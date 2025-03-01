class my_seqr extends uvm_sequencer#(seq_item);

`uvm_component_utils(my_seqr)

function new(string name = "my_seqr",uvm_component parent = null);
  super.new(name,parent);
endfunction

endclass
