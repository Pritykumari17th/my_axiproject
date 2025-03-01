`include "axi_seq_item.sv"
`include "axi_seq.sv"
`include "axi_env.sv"


class my_test extends uvm_test;
my_env env;
my_seq my_sq;

`uvm_component_utils(my_test)

function new(string name = "my_test", uvm_component parent = null);
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);

env = my_env :: type_id :: create("env",this);
endfunction

task run_phase(uvm_phase phase);
super.run_phase(phase);
my_sq = my_seq :: type_id :: create("my_sq");
phase.raise_objection(this,"objection is raised");
my_sq.start(env.agnt.seqr);
phase.drop_objection(this,"objection is dropped");
endtask
endclass
