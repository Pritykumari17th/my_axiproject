`include "axi_agent.sv"
`include "axi_scoreboard.sv"
`include "axi_coverage.sv"

class my_env extends uvm_env;
  my_agent agnt;
  my_scoreboard sb;
  coverage cov;
`uvm_component_utils(my_env)

function new(string name = "my_env", uvm_component parent = null);
 super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
 super.build_phase(phase);
 
 agnt = my_agent :: type_id :: create("agnt",this);
 sb = my_scoreboard :: type_id :: create("sb",this);
cov = coverage :: type_id :: create("cov",this);
endfunction

function void connect_phase(uvm_phase phase);
 super.connect_phase(phase);

//TLM connection 
agnt.mon.mon_wr2sb.connect(sb.mon_wr2sb);
agnt.mon.mon_rd2sb.connect(sb.mon_rd2sb);

agnt.mon.mon_wr2sb.connect(cov.analysis_export);
agnt.mon.mon_rd2sb.connect(cov.analysis_export);
endfunction

endclass

