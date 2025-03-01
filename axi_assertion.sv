module assertion;

bit m,n;

initial begin
	if(AWVALID & AWREADY)
		m=1;
	if(WVALID & WREADY)
		n=1;
end

//HANDSHAKING

	property p_a;
		@(posedge clk) $rose(AWVALID) |-> ##[0:5] AWREADY;
	endproperty

	property p_a1;
		@(posedge clk) $rose(WVALID) |->  ##[0:5] WREADY;
	endproperty

	property p_a2;
		@(posedge clk) $rose(ARVALID) |-> ##[0:5] ARREADY;
	endproperty

	property p_a3;
		@(posedge ACLK) $rose(RVALID)  |-> ##[0:5] RREADY; 
	endproperty

	property p_a4;
		@(posedge ACLK) $rose(BVALID)  |-> ##[0:5] BREADY; 
	endproperty


// SOURCE MUST KEEP ITS INFORMATION STABLE UNTIL TRANSFER OCCURS & ONCE VALID IS ASSERTED IT MUST STAY ASSERTED UNTIL THE HANDSHAKE OCCURS

	property p_b2;
		@(posedge ACLK) $rose(AWVALID) |-> ($stable( AWID & AWADDR & AWLEN & AWSIZE & AWBURST & AWVALID ) until AWREADY);
	endproperty

	property p_b1;
		@(posedge ACLK) $rose(ARVALID) |-> $stable( ARID & ARADDR & ARLEN & ARSIZE & ARBURST & ARVALID ) until ARREADY;
	endproperty

	property p_b2;
		@(posedge ACLK) $rose(WVALID) |-> $stable( WID & WDATA & WSTRB & WVALID ) until WREADY;
	endproperty

	property p_b3;
		@(posedge ACLK) $rose(RVALID) |-> $stable( RID & RDATA & RRESP & RVALID ) until WREADY;
	endproperty

	property p_b4;
		@(posedge ACLK) $rose(BVALID) |-> $stable( BID & BRESP & BVALID ) until BREADY;
	endproperty

// READ DATA MUST ALWAYS FOLLOW THE ADDRESS & THE SLAVE MUST WAIT FOR BOTH ARVALID & ARREADY TO BE ASSERTED BEFORE ASSERTING RVALID 
	property p_c;
		@(posedge ACLK) !( RVALID ) until (ARVALID && ARREADY) 
	endproperty

// THE SLAVE MUST WAIT FOR ALL OF AWVALID & AWREADY & WVALID & WREADY TO BE ASSERTED & ALSO WAIT FOR WLAST BEFORE ASSERTING BVALID 	

	sequence sq1;
		@(posedge clk ) (AWVALID & AWREADY) |-> m;
	endsequence

	sequence sq2;
		@(posedge clk ) (WVALID & WREADY) |-> n;
	endsequence

	property p_d;
		@(posedge ACLK) (sq1 & sq2)|-> ##[0:$] WLAST;
	endproperty

	property p_d1;
		@(posedge ACLK) !(BRESP) until WLAST;
	endproperty


	property p_e;
		@(posedge ACLK) $rose(WLAST) |-> ##[0:$]( WVALID & WREADY ) |=> $fell(WLAST);
	endproperty

	property p_e1;
		@(posedge ACLK) $rose(RLAST) |-> ##[0:$]( RVALID & RREADY ) |=> $fell(RLAST);
	endproperty

// RESET
	property preset;
		@(posedge ACLK) !(ARESETn) |->  ( !ARVALID & !AWVALID & !WVALID & !RVALID & !BVALID )
	endproperty

// EARLIEST POINT AFTER RESET ARVALID,AWVALID AND WVALID CAN BE ASSERTED IS AFTER ONE RISING CLOCK EDGE
	property p_f;
		@(posedge ACLK) ((!ARVALID & !AWVALID & !WVALID) until ARESETn ) ##[1:$] ( ARVALID | AWVALID | WVALID )
	endproperty


	// CACHE[2:3] CANNOT BE HIGH WHEN CAACHE[1] IS LOW
	property p_g;
		@(posedge ACLK) !AWCACHE[1] |-> !AWCACHE[2] & !AWCACHE[3] 
	endproperty

	property p_g1;
		@(posedge ACLK) !ARCACHE[1] |-> !ARCACHE[2] & !ARCACHE[3] 
	endproperty

	
endmodule


	

	
