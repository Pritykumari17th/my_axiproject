`include "axi_sequencer.sv"
`include "axi_driver.sv"
`include "axi_monitor.sv"

class my_agent extends uvm_agent;
  my_seqr seqr;
  my_driver driv;
  my_monitor mon;

`uvm_component_utils(my_agent)

function new(string name = "my_agent", uvm_component parent = null);
 super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
 super.build_phase(phase);

if(get_is_active == UVM_ACTIVE)begin
driv = my_driver :: type_id :: create("driv",this);
seqr = my_seqr :: type_id :: create("seqr",this);
end

mon = my_monitor :: type_id :: create("mon",this);
endfunction

function void connect_phase(uvm_phase phase);
super.connect_phase(phase);

if(get_is_active == UVM_ACTIVE)
driv.seq_item_port.connect(seqr.seq_item_export);
endfunction

endclass
