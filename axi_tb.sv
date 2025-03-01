`include "uvm_macros.svh"
import uvm_pkg :: *;

`include "axi_interface.sv"
`include "axi_test.sv"

module tb;
bit clk;
bit rstn;

axi_intf vif(clk,resetn);

always #5 clk = ~clk;

//dut instiation

axi_slave dut(.axi_clk_i(vif.clk),
              .axi_rstn_i(vif.rstn),
              .axi_awid_i(vif.AWID),
              .axi_awaddr_i(vif.AWADDR),
              .axi_awlen_i(vif.AWLEN),
              .axi_awsize_i(vif.AWSIZE),
              .axi_awburst_i(vif.AWBURST),
              .axi_awlock_i(vif.AWLOCK),
              .axi_awcache_i(vif.AWCACHE),
              .axi_awprot_i(vif.AWPROT),
              .axi_awvalid_i(vif.AWVALID),
              .axi_awready_o(vif.AWREADY),

              .axi_arid_i(vif.ARID),
              .axi_araddr_i(vif.ARADDR),
              .axi_arlen_i(vif.ARLEN),
              .axi_arsize_i(vif.ARSIZE),
              .axi_arburst_i(vif.ARBURST),
              .axi_arlock_i(vif.ARLOCK),
              .axi_arcache_i(vif.ARCACHE),
              .axi_arprot_i(vif.ARPROT),
              .axi_arvalid_i(vif.ARVALID),
              .axi_arready_o(vif.ARREADY),

              .axi_wid_i(vif.WID),
              .axi_wdata_i(vif.WDATA),
              .axi_wstrb_i(vif.WSTRB),
              .axi_wlast_i(vif.WLAST),
              .axi_wvalid_i(vif.WVALID),
              .axi_wready_o(vif.WREADY),

              .axi_rid_o(vif.RID),
              .axi_rdata_o(vif.RDATA),
              .axi_rresp_o(vif.RRESP),
              .axi_rlast_o(vif.RLAST),
              .axi_rvalid_o(vif.RVALID),
              .axi_rready_i(vif.RREADY),

              .axi_bid_o(vif.BID),
              .axi_bresp_o(vif.BRESP),
              .axi_bvalid_o(vif.BVALID),
              .axi_bready_i(vif.BREADY));


  initial begin
    rstn = 0;
    #10 rstn = 1;
  end

initial uvm_config_db#(virtual axi_intf) :: set(uvm_root::get(),"*","vif",vif);

initial begin

run_test("my_test");

//10000;
$finish;
end
endmodule
