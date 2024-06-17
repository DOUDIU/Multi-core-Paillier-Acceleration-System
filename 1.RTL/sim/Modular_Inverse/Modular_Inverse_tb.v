`timescale 1ns / 1ps

module Modular_Inverse_tb();

reg		clk		=	0	;
reg		rst_n	= 	0	;
always #5 clk = ~clk; 
initial #20 rst_n = 1;
/*
reg		[255:0]		a;
reg		[255:0]		p;
reg					valid_in;

wire	[255:0]		R;
wire				valid_out;
wire				busy;


Modular_Inverse #(
		.Data_Width 	(256)
)Modular_Inverse_inst(
	 	.clk			(clk		)
	,	.rst_n			(rst_n		)
	,	.a				(a			)
	,	.p				(p			)
	,	.valid_in		(valid_in	)
	,	.R				(R			)
	,	.valid_out		(valid_out	)
	,	.busy			()
);


initial begin
	a = 256'h0;
	p = 256'h0;
	valid_in = 0;
	#100;
	valid_in = 1;
	a = 256'h123456;
	p = 256'hefee431;
	#10
	valid_in = 0;
	wait(valid_out);
	$display("R = %h",R);
	$stop;
end
*/

localparam K = 128;
localparam N = 32;
wire [K*N-1:0] a_reg;
wire [K*N-1:0] p_reg;
assign a_reg = 4096'h39979947f84591c7011dc06e677dc75ce460fd29a14d022555732743a714c8cf18ff8ebe1a8b01aabd6d421cf63ee8f0870f09badc9224f9fed2af198c5da91847bb617d0e28a369453604f44580667d19c6cbf1365dc89c74126ac7c4ff6f974fdb853bf92e50975dd7c5e6e3bed5c2c20b11011a8f308c56d193bf1461326716180d26596840499b727663b9271e7ad17020b0202ffeb0f83d610245b396e63ea93b568be6ad20dcf85bd66411987b9c99a9756a6b21c03e7d16d9807cf9b1f63208f216144c08c5c571343d1d05032239a444b890d96abed9f0cbacfbbfab6f2f28f1460f6ed4e906b303d12bf4f1ec40d1a7d4a572dfa8b09a0fa5730ff88981780bb3f309afc99fab51bba5b1e5c768809c880bda44efa7cfbb03ac9d317cd6211d142fd3eb964d872d3a8f833a19a0c0b825bdf7972a22e3133a538a063430cfef88eb7aa8f028d88a7272678ccb0deff5bd7ae373a62ffa5789c874dac229ecda874772927346cf18c197bae55c93c16eeacbea4acc52a6abd20e95f0aa41adb389c6468400741f2a27fbee12e8de39d80f67fa81e252caa8d46903016e3202345b9abeab552d7f912d346ce1603e209010af32ef06b3286e86daeb8ced3dfc0a45097f952aade6a537c61f26a2e1c47658ce092e9b6c29a02604523b931dd247099e3123c04a84ebad9f2f569be1df94c3fe93f1c92358cd60233349;
assign p_reg = 4096'h92d20837163355491353a40bfbed6afffb000939ca99e2dcb7e96c94d9e6ff1b54db47d62fa87283db4ef47e8119e2cb0d126f44ef110cd64d6493014fbee11fce25ad01515ed88bef11f595cc5b107aed44c3aecf42318a0e9dc2431934703c219abc2ee926037fbd46e2b2465b19b3110e3ccdbdfbe0daadefe22a725ef38bc2371fdc5e9cfb439ea6ac84b3e424e71cc3a263dc8cb4642042d01abe4e54416d821fae3e588950e16d5bdc76fc0629b4829eabad9ad1535fc322dc0ad791ca8a353157ab771cc0eafb621a07b0ce0998a65541754ffeedb756ff3ca3b606dea2b63fa2483a5dda07c17496f556f441e4c09fbb079cbbb8279c01fca24b56bf32e9902603d670439cee8a4f9730281ca7e736783300f69b64cce28fb565b99599758f8c8e5d58ce03af202cfe8d88092884f15b5a76578db8bf6a32cf7e2d78a758c60de9e6cf037bd2a6c7d22c670b8b384722fef18a9870588c1368f3c1f82caa709eff78cfdb2a3594bce3977875c0c30e464a5fc136225c7e206ba599b14ec856a9a230bca081331c969774eb112295c0670d4cb20723ceaa02e0ff4879a508052dad14c59f1787572686d68c51eb3ce8f505e141803ec18bc77c4986a7ea1dd24c13c7bb976496361ad38078e2daaf39f049a489793e2b46643b3eb3f168a3ad29eb4accb4ca422e7dd70e809f4ad5ed15d295f6765773bb5d851b3e81;
reg [K*N-1:0] result_reg;
integer i;


reg					mi_start	=	0;
reg		[K-1:0]		a			=	0;
reg		[K-1:0]		p			=	0;
reg					valid_in	=	0;

wire	[K-1:0]		r;
wire				valid_out;

modular_inverse_optimize #(
		.K			(K			)
	,	.N			(N			)
)modular_inverse_optimize_inst(
		.clk		(clk		)
	,	.rst_n		(rst_n		)
	,	.mi_start	(mi_start	)
	,	.a			(a			)
	,	.p			(p			)
	,	.valid_in	(valid_in	)
	,	.r			(r			)
	,	.valid_out	(valid_out	)
);


initial begin
	@(posedge rst_n);
	for(i= 0; i < 10; i = i + 1) begin
		@(posedge clk);
	end
	mi_start = 1;
	@(posedge clk);
	mi_start = 0;
	for(i = 0; i < N; i = i + 1) begin
		@(posedge clk);
		valid_in = 1;
		a = a_reg[K*i+:K];
		p = p_reg[K*i+:K];
	end
	@(posedge clk);
	valid_in = 0;
	wait(valid_out);
	for(i = 0; i < N; i = i + 1) begin
		@(posedge clk);
		result_reg[K*i+:K] = r;
	end
	$display("result_reg = %h",result_reg);
	$stop;
end









endmodule
