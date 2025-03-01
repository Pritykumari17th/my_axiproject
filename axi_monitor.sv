class my_monitor extends uvm_monitor;

virtual axi_intf vif;
seq_item wr_req,rd_req;
`uvm_component_utils(my_monitor)

uvm_analysis_port#(seq_item) mon_wr2sb;
uvm_analysis_port#(seq_item) mon_rd2sb;

function new(string name = "my_monitor", uvm_component parent = null);
super.new(name,parent);
mon_wr2sb = new("mon_wr2sb",this);
mon_rd2sb = new("mon_rd2sb",this);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
if(uvm_config_db#(virtual axi_intf):: get(this,"","vif",vif))
$fatal("MONITOR INTERFACE","Failed to get Interface");
endfunction

task run_phase(uvm_phase phase);
wr_req = seq_item :: type_id :: create("wr_req");
rd_req = seq_item :: type_id :: create("rd_req");

forever fork
wr_transfer();
rd_transfer();
`uvm_info("MONITOR","Packet Recieved",UVM_LOW);
join
endtask

task wr_transfer();
@(vif.mon_cb);

//write address channel
wait(vif.AWVALID && vif.AWREADY)
wr_req.AWID = vif.AWID;
wr_req.AWADDR = vif.AWADDR;
wr_req.AWLEN = vif.AWLEN;
wr_req.AWSIZE = vif.AWSIZE;
wr_req.AWBURST = vif.AWBURST;
wr_req.AWVALID = vif.AWVALID;
wr_req.AWREADY = vif.AWREADY;
wr_req.WDATA = new[wr_req.AWLEN +1];
wr_req.WSTRB = new[wr_req.AWLEN +1];

//write data channel
@(vif.mon_cb);
wr_req.WID = vif.WID;
foreach(wr_req.WDATA[i]) begin
wait(vif.WVALID && vif.WREADY)
wr_req.WDATA[i] = vif.WDATA;
wr_req.WSTRB[i] = vif.WSTRB;
wr_req.WLAST = vif.WLAST;
@(vif.mon_cb);
end
//write response channel

wait(vif.BVALID && vif.BREADY == 1)
wr_req.BID = vif.BID;
wr_req.BRESP = vif.BRESP;

@(vif.mon_cb);
wr_req.wr_rd = 1;
mon_wr2sb.write(wr_req);

endtask


task rd_transfer();
@(vif.mon_cb);
//read address channel
wait(vif.ARVALID && vif.ARREADY)
rd_req.ARID = vif.ARID;
rd_req.ARADDR = vif.ARADDR;
rd_req.ARLEN = vif.ARLEN;
rd_req.ARSIZE = vif.ARSIZE;
rd_req.ARBURST = vif.ARBURST;
rd_req.RDATA = new[rd_req.ARLEN+1];
rd_req.RRESP = new[rd_req.ARLEN+1];

@(vif.mon_cb);

//read data channel
@(vif.mon_cb);
rd_req.RID = vif.RID;
foreach(rd_req.RDATA[i])begin
wait(vif.RVALID && vif.RREADY)
rd_req.RDATA[i] = vif.RDATA;
rd_req.RRESP[i] = vif.RRESP;
rd_req.RLAST = vif.RLAST;
@(vif.mon_cb);
end
rd_req.wr_rd = 0;
mon_rd2sb.write(rd_req);

endtask

endclass
