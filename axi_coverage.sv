class coverage extends uvm_subscriber #(seq_item);
	`uvm_component_utils(coverage)

	bit [ 31 :0] AWADDR;
	bit [3:0] AWLEN;
	bit [2:0] AWSIZE;
	bit [1:0] AWBURST;

   	bit [ 31 :0] WDATA[];
   	bit [ 7 : 0] WSTRB[];

   	bit [1:0] BRESP;

	bit [ 31 :0] ARADDR;
	bit [3:0] ARLEN;
	bit [2:0] ARSIZE;
	bit [1:0] ARBURST;

   	bit [31 :0] RDATA[];
   	bit [ 1: 0] RRESP[];
	
	covergroup cg_wr();
		 coverpoint AWADDR { bins A_WR1 [16] = {[ 0		 : (((2**32)/64)*16)-1]};
						bins A_WR2 [16] = {[((2**32)/64)*16   : (((2**32)/64)*32)-1]};
						bins A_WR3 [16] = {[((2**32)/64)*32   : (((2**32)/64)*48)-1]};
						bins A_WR4 [16] = {[((2**32)/64)*48   : $ ]};}

		 coverpoint WDATA  { bins D_WR1 [16] = {[ 0		 : (((2**32)/64)*16)-1]};
						bins D_WR2 [16] = {[((2**32)/64)*16   : (((2**32)/64)*32)-1]};
						bins D_WR3 [16] = {[((2**32)/64)*32   : (((2**32)/64)*48)-1]};
						bins D_WR4 [16] = {[((2**32)/64)*48   : $ ]};}
						
		 coverpoint AWLEN  { bins burst_ln_fx_wr[16] = {[0 :15]};
						bins burst_ln_rem  [16] = {[16: $]};}

		 coverpoint AWSIZE { bins burst_size [8] = {[0 : 7]};}
		
		 coverpoint AWBURST{ bins burst_fixed = {0};
						bins burst_incr  = {1};
						bins burst_wrap  = {2};
						illegal_bins burst_invld = {3};}

		 coverpoint BRESP { bins OKAY = {0};
						bins EXOKAY  = {1};
						bins SLV_ERR  = {2};
						bins DEC_ERR = {3};}

		 cross AWADDR,WDATA,BRESP;		
	endgroup

	covergroup cg_rd();

		 coverpoint ARADDR { bins A_RD1 [16] = {[0		 : (((2**32)/64)*16)-1]};
						bins A_RD2 [16] = {[((2**32)/64)*16   : (((2**32)/64)*32)-1]};
						bins A_RD3 [16] = {[((2**32)/64)*32   : (((2**32)/64)*48)-1]};
						bins A_RD4 [16] = {[((2**32)/64)*48   : $ ]};}

		 coverpoint RDATA  { bins D_RD1 [16] = {[0		 : (((2**32)/64)*16)-1]};
						bins D_RD2 [16] = {[((2**32)/64)*16   : (((2**32)/64)*32)-1]};
						bins D_RD3 [16] = {[((2**32)/64)*32   : (((2**32)/64)*48)-1]};
						bins D_RD4 [16] = {[((2**32)/64)*48   : $ ]};
}
						
	
		 coverpoint ARLEN  { bins burst_ln_fx_wr[16] = {[0 :15]};
						bins burst_ln_rem  [16] = {[16: $]};}

		 coverpoint ARSIZE { bins burst_size [8] = {[0 : 7]};}

		 coverpoint ARBURST{ bins burst_fixed = {0};
						bins burst_incr  = {1};
						bins burst_wrap  = {2};
						illegal_bins burst_invld = {3};}

		RRESPcp    : coverpoint RRESP  { bins OKAY = {0};
						bins EXOKAY  = {1};
						bins SLV_ERR  = {2};
						bins DEC_ERR = {3};}

		RD_ADDRxDATAxRESP : cross ARADDR,RDATA,RRESP;
	endgroup


	function void write(seq_item t);
		if(t.wr_rd) begin
			AWADDR = t.AWADDR;
			AWLEN = t.AWLEN;
			AWSIZE = t.AWSIZE;
			AWBURST = t.AWBURST;
			WDATA = t.WDATA;
			WSTRB = t.WSTRB;
			BRESP = t.BRESP;
			cg_wr.sample;
		end
		else begin
			ARADDR = t.ARADDR;
			ARLEN = t.ARLEN;
			ARSIZE = t.ARSIZE;
			ARBURST = t.ARBURST;
			RDATA = t.RDATA;
			RRESP = t.RRESP;
			cg_rd.sample;
		end
	endfunction

	function new(string name = "coverage", uvm_component parent = null);
		super.new(name,parent);
		cg_wr = new();
		cg_rd = new();
	endfunction
endclass

