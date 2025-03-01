
class seq_item extends uvm_sequence_item;

bit wr_rd;
// Write Address
  bit [3:0]AWID;
  rand bit [31:0]AWADDR;
  rand bit [7:0]AWLEN;
  rand bit [2:0]AWSIZE;
  rand bit [1:0]AWBURST;

  bit [1:0]AWLOCK;
  bit [3:0]AWCACHE;
  bit [2:0]AWPROT;
  bit AWVALID;
  bit AWREADY;

  //Read Address
  bit [3:0]ARID;
  rand bit [31:0]ARADDR;
  rand bit [3:0]ARLEN;
  rand bit [2:0]ARSIZE;
  rand bit [1:0]ARBURST;

  bit [1:0]ARLOCK;
  bit [3:0]ARCACHE;
  bit [2:0]ARPROT;
  bit ARVALID;
  bit ARREADY;

//write Data
  bit [3:0]WID;
  rand bit [31:0]WDATA[];

  bit [3:0]WSTRB[];
  bit WLAST;
  bit WVALID;
  bit WREADY;

  //Read Data
  bit [3:0]RID;
  bit [31:0]RDATA[];
  bit [1:0]RRESP[];
  bit RLAST;
  bit RVALID;
  bit RREADY;

  
  //Write Response
  bit [3:0]BID;
  bit [1:0]BRESP;
  bit BVALID;
  bit BREADY;

`uvm_object_utils(seq_item)

function new(string name = "seq_item");
super.new(name);
endfunction


constraint burst_type{  soft AWBURST == 2'b01;
				soft ARBURST == 2'b10;}

	constraint burst_size{  AWSIZE inside {[0:3]};
				ARSIZE inside {[0:3]};}

	constraint burst_len {  AWBURST == 0 -> AWLEN inside {[0:15]};
				ARBURST == 0 -> ARLEN inside {[0:15]};
				AWBURST == 2 -> AWLEN inside {1,3,7,15};
				ARBURST == 2 -> ARLEN inside {1,3,7,15};
				solve AWBURST before AWLEN;
				solve ARBURST before ARLEN;}

	constraint algnd_addr{  AWADDR % 2**AWSIZE == 0;
				ARADDR % 2**ARSIZE == 0;
				solve AWSIZE before AWADDR;
				solve ARSIZE before ARADDR;}
	
	constraint DATA_size {  WDATA.size == AWLEN + 1;
				WSTRB.size == AWLEN + 1;}

	constraint wrt_strb  {  if(AWBURST==2'b01)
				foreach(WSTRB[i,j])
					if(i==0){
					if(j >= AWADDR%8 && j < (AWADDR%8 + 2** AWSIZE))
						WSTRB[i][j]==1;
					else
						WSTRB[i][j]==0;}
					else {
						
					}
				solve AWADDR before WSTRB;}

	constraint cache     {  AWCACHE[1] == 0 -> (AWCACHE[2] == 0) && (AWCACHE[3] == 0);
				ARCACHE[1] == 0 -> (ARCACHE[2] == 0) && (ARCACHE[3] == 0);}




/*constraint c_LEN{
	solve AWBURST before AWLEN;
	solve ARBURST before ARLEN;
	if(AWBURST==2)
		AWLEN inside {1,3,7,15};
	if(ARBURST == 2)
		ARLEN inside {1,3,7,15};
	solve AWLEN before WDATA;
	solve ARLEN before RDATA;}

constraint size{
	AWSIZE inside {0,1,2};
	ARSIZE <= 2;
	solve AWSIZE before WDATA;
	solve ARSIZE before RDATA;}


constraint wr_strb  {  if(AWBURST==2'b01)
				foreach(WSTRB[i,j])
					if(i==0){
					if(j >= AWADDR%8 && j < (AWADDR%8 + 2** AWSIZE))
						WSTRB[i][j]==1;
					else
						WSTRB[i][j]==0;}
					else {
						
					}
				solve AWADDR before WSTRB;}*/

endclass
