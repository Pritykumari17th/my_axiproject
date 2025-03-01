class my_scoreboard extends uvm_scoreboard;
`uvm_component_utils(my_scoreboard)
`uvm_analysis_imp_decl(_wr)
`uvm_analysis_imp_decl(_rd)

uvm_analysis_imp_wr#(seq_item,my_scoreboard) mon_wr2sb;
uvm_analysis_imp_rd#(seq_item,my_scoreboard) mon_rd2sb;

bit [31:0] mem[int];

bit [31:0]addr[$];
bit [31:0]temp_addr;
bit [31:0]wrap_boundry;
bit [31:0]limiting_addr;


bit [31:0] rd_addr[$];
bit [31:0] rd_temp_addr;
bit [31:0] rd_wrap_boundary;
bit [31:0] rd_limiting_addr;

function new(string name = "my_scoreboard",uvm_component parent = null);
super.new(name,parent);
mon_wr2sb = new("mon_wr2sb",this);
mon_rd2sb = new("mon_rd2sb",this);
endfunction

function void write_wr(seq_item req);
if(req.AWVALID && req.AWREADY) begin
addr.push_back(req.AWADDR);
wrap_boundry = int'(req.AWADDR/((2**req.AWSIZE) * (req.AWLEN+1)))*((2**req.AWSIZE) * (req.AWLEN+1));
limiting_addr = wrap_boundry + ((2**req.AWSIZE) * (req.AWLEN+1));
end

for(int i = 0; i<= req.AWLEN;i++)begin
if(req.WVALID && req.WREADY)begin
temp_addr = pop_front(addr);
mem[temp_addr] = req.WDATA[i];
end

if(req.AWBURST == 2'b00)begin
addr.push_back(temp_addr);
end

if(req.AWBURST == 2'b01)begin
addr.push_back(temp_addr + 2**req.AWSIZE);
end

if(req.AWBURST == 2'b10)begin
if((temp_addr + 2**req.AWSIZE) < limiting_addr)
addr.push_back(temp_addr+ 2**req.AWSIZE);
else
addr.push_back(wrap_boundry);
end
end
endfunction

function void write_rd(seq_item req);

if(req.ARVALID && req.ARREADY)begin
rd_addr.push_back(addr);
rd_wrap_boundary = int'(req.AWADDR / ((2 ** req.ARSIZE) * (req.ARLEN + 1))) * ((2 ** req.ARSIZE) * (req.ARLEN + 1));
			rd_limiting_addr = rd_wrap_boundary + ((2 ** req.ARSIZE) * (req.ARLEN + 1));
end
for(int i =0; i<= req.ARLEN;i++)begin
rd_temp_addr = rd_addr.pop_front;
if (!mem.exists (rd_temp_addr))begin
uvm_warning("SCOREBOARD","MEMORY NOT WRITTEN YET");
end
else begin
if(req.RDATA[i]==mem[rd_temp_addr])begin
`uvm_info ("SCOREBOARD","READ PASSED",UVM_LOW);
end
else begin
`uvm_error("SCOREBOARD","READ FAILED");		
end		
end
end

if(req.ARBURST == 2'b00) begin 
rd_addr.push_back(rd_temp_addr);
end

if(req.ARBURST == 2'b01) begin 
rd_addr.push_back(rd_temp_addr + 2 ** req.AWSIZE);
end 

if(req.ARBURST == 2'b10) begin 
if((rd_temp_addr + 2 ** req.ARSIZE) < rd_limiting_addr )
rd_addr.push_back(rd_temp_addr + 2 ** req.ARSIZE);
else
rd_addr.push_back(rd_wrap_boundary);
 
end
endfunction
endclass
