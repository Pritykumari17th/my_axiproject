class my_driver extends uvm_driver#(seq_item);
virtual axi_intf vif;

`uvm_component_utils(my_driver)

function new(string name = "my_driver",uvm_component parent = null);
super.new(name);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);

if(!uvm_config_db#(virtual axi_intf)::get(this,"","vif",vif))begin
$fatal("DRIVER INTERFACE","Failed to get Interface");
end
endfunction

task run_phase(uvm_phase phase);
reset();  
@(vif.driv_cb);
forever fork
@(vif.driv_cb);
seq_item_port.get_next_item();
begin
wr_addr(req);
wr_data(req);
end
wr_res(req);
begin
rd_addr(req);
rd_data(req);
end
seq_item_port.item_done();
join
endtask
 
task reset();
@(vif.driv_cb);
vif.AWVALID <= 0;
vif.ARVALID <= 0;
vif.WVALID <= 0;
@(vif.driv_cb);
vif.rstn<= 1;
endtask

task wr_addr(seq_item req);
@(vif.driv_cb);
vif.AWID <= req.AWID;
vif.AWADDR <= req.AWADDR;
vif.AWLEN <= req.AWLEN;
vif.AWSIZE <= req.AWSIZE;
vif.AWBURST <= req.AWBURST;
vif.AWLOCK <= req.AWLOCK;
vif.AWCACHE <= req.AWCACHE;
vif.AWPROT <= req.AWPROT;
vif.AWVALID <= 1;

wait(vif.AWREADY==1)

req.AWREADY <= vif.AWREADY;
@(vif.driv_cb);
vif.AWVALID <= 0;
endtask


task wr_data(seq_item req);
@(vif.driv_cb);
  vif.WID <= req.WID;
  
for(int i = 0; i<= req.AWLEN;i++)begin
//@(vif.driv_cb);
vif.WDATA <= req.WDATA[i];
vif.WSTRB <= req.WSTRB[i];
vif.WVALID <= 1;

if(i == req.AWLEN)
vif.WLAST <= 1;

 wait(vif.WREADY==1)
@(vif.driv_cb);
vif.WVALID <= 0;
end
vif.WLAST <= 0;
endtask

task wr_res(seq_item req);
@(vif.driv_cb);
  
  vif.BREADY <= 1;
wait(vif.BVALID==1)
  req.BID <= vif.BID;
  req.BRESP <= vif.BRESP;
  req.BVALID <= vif.BVALID;
  @(vif.driv_cb);
  vif.BREADY <= 0;
endtask


task rd_addr(seq_item req);
@(vif.driv_cb);
  vif.ARID <= req.ARID;
  vif.ARADDR <= req.ARADDR;
  vif.ARLEN <= req.ARLEN;
  vif.ARSIZE <= req.ARSIZE;
  vif.ARBURST <= req.ARBURST;
  vif.ARLOCK <= req.ARLOCK;
  vif.ARCACHE <= req.ARCACHE;
  vif.ARPROT <= req.ARPROT;
  vif.ARVALID <= 1;
  wait(vif.ARREADY==1)
  req.ARREADY <= vif.ARREADY;
  @(vif.driv_cb);
  vif.ARVALID <= 0;
endtask


task rd_data(seq_item req);
@(vif.driv_cb);
  vif.RREADY <= 1;
  
  wait(vif.RVALID ==1)
  req.RID <= vif.RID;
  req.RDATA <= vif.RDATA;
  req.RRESP <= vif.RRESP;
  req.RLAST <= vif.RLAST;
  
  req.RVALID <= vif.RVALID;
  @(vif.driv_cb);
  vif.RREADY <= 0;
endtask

endclass
