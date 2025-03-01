
interface axi_intf(input bit clk,bit rstn);

// Write Address
  logic [3:0]AWID;
  logic [31:0]AWADDR;
  logic [3:0]AWLEN;
  logic [2:0]AWSIZE;
  logic [1:0]AWBURST;
  logic [1:0]AWLOCK;
  logic [3:0]AWCACHE;
  logic [2:0]AWPROT;
  logic AWVALID;
  logic AWREADY;
  
  //Read Address
  logic [3:0]ARID;
  logic [31:0]ARADDR;
  logic [3:0]ARLEN;
  logic [2:0]ARSIZE;
  logic [1:0]ARBURST;
  logic [1:0]ARLOCK;
  logic [3:0]ARCACHE;
  logic [2:0]ARPROT;
  logic ARVALID;
  logic ARREADY;
  
  //write Data
  logic [3:0]WID;
  logic [31:0]WDATA;
  logic [3:0]WSTRB;
  logic WLAST;
  logic WVALID;
  logic WREADY;
  
  //Read Data
  logic [3:0]RID;
  logic [31:0]RDATA;
  logic [3:0]RRESP;
  logic RLAST;
  logic RVALID;
  logic RREADY;
  
  //Write Response
  logic [3:0]BID;
  logic [1:0]BRESP;
  logic BVALID;
  logic BREADY;
  
  
clocking driv_cb@(posedge clk);

//Write Address
output AWID;
output AWADDR;
output AWLEN;
output AWSIZE;
output AWBURST;
output AWLOCK;
output AWCACHE;
output AWPROT;
output AWVALID;

input AWREADY;

 //write Data
  output WID;
  output WDATA;
  output WSTRB;
  output WLAST;
  output WVALID;

  input WREADY;

 //Read Address

  output ARID;
  output ARADDR;
  output ARLEN;
  output ARSIZE;
  output ARBURST;
  output ARLOCK;
  output ARCACHE;
  output ARPROT;
  output ARVALID;

  input ARREADY;

    //Read Data
  output RID;
  output RDATA;
  output RRESP;
  output RLAST;
  output RVALID;

  input RREADY;

  //Write Response
  input BID;
  input BRESP;
  input BVALID;

  output BREADY;

endclocking 

clocking mon_cb@(posedge clk);
//Write Address
input AWID;
input AWADDR;
input AWLEN;
input AWSIZE;
input AWBURST;
input AWLOCK;
input AWCACHE;
input AWPROT;
input AWVALID;
input AWREADY;

 //write Data
  input WID;
  input WDATA;
  input WSTRB;
  input WLAST;
  input WVALID;
  input WREADY;

 //Read Address

  input ARID;
  input ARADDR;
  input ARLEN;
  input ARSIZE;
  input ARBURST;
  input ARLOCK;
  input ARCACHE;
  input ARPROT;
  input ARVALID;
  input ARREADY;

    //Read Data
  input RID;
  input RDATA;
  input RRESP;
  input RLAST;
  input RVALID;
  input RREADY;

  //Write Response
  input BID;
  input BRESP;
  input BVALID;
  input BREADY;
endclocking

modport driv_m(clocking driv_cb, input rstn);

modport mon_m(clocking mon_cb, input rstn);

endinterface
