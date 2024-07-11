module paillier_axi_top#(
        // Users to add parameters here
        parameter BLOCK_COUNT = 4
	,	parameter K = 128

		// Base address of targeted slave
	,   parameter  C_M_TARGET_SLAVE_BASE_ADDR	= 32'h10000000
		// Burst Length. Supports 1, 2, 4, 8, 16, 32, 64, 128, 256 burst lengths
	,   parameter integer C_M_AXI_BURST_LEN	= 16
		// Thread ID Width
	,   parameter integer C_M_AXI_ID_WIDTH	= 1
		// Width of Address Bus
	,   parameter integer C_M_AXI_ADDR_WIDTH	= 32
		// Width of Data Bus
	,   parameter integer C_M_AXI_DATA_WIDTH	= 128
		// Width of User Write Address Bus
	,   parameter integer C_M_AXI_AWUSER_WIDTH	= 0
		// Width of User Read Address Bus
	,   parameter integer C_M_AXI_ARUSER_WIDTH	= 0
		// Width of User Write Data Bus
	,   parameter integer C_M_AXI_WUSER_WIDTH	= 0
		// Width of User Read Data Bus
	,   parameter integer C_M_AXI_RUSER_WIDTH	= 0
		// Width of User Response Bus
	,   parameter integer C_M_AXI_BUSER_WIDTH	= 0

		// Width of S_AXI data bus
	,   parameter integer C_S_AXI_DATA_WIDTH	= 32
		// Width of S_AXI address bus
	,	parameter integer C_S_AXI_ADDR_WIDTH	= 4
)(
//----------------------------------------------------
// AXI-LITE slave port
    // Global Clock Signal
        input wire  S_AXI_ACLK
    // Global Reset Signal. This Signal is Active LOW
    ,   input wire  S_AXI_ARESETN
    // Write address (issued by master, acceped by Slave)
    ,   input wire [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_AWADDR
    // Write channel Protection type. This signal indicates the
        // privilege and security level of the transaction, and whether
        // the transaction is a data access or an instruction access.
    ,   input wire [2 : 0] S_AXI_AWPROT
    // Write address valid. This signal indicates that the master signaling
        // valid write address and control information.
    ,   input wire  S_AXI_AWVALID
    // Write address ready. This signal indicates that the slave is ready
        // to accept an address and associated control signals.
    ,   output wire  S_AXI_AWREADY
    // Write data (issued by master, acceped by Slave) 
    ,   input wire [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_WDATA
    // Write strobes. This signal indicates which byte lanes hold
        // valid data. There is one write strobe bit for each eight
        // bits of the write data bus.    
    ,   input wire [(C_S_AXI_DATA_WIDTH/8)-1 : 0] S_AXI_WSTRB
    // Write valid. This signal indicates that valid write
        // data and strobes are available.
    ,   input wire  S_AXI_WVALID
    // Write ready. This signal indicates that the slave
        // can accept the write data.
    ,   output wire  S_AXI_WREADY
    // Write response. This signal indicates the status
        // of the write transaction.
    ,   output wire [1 : 0] S_AXI_BRESP
    // Write response valid. This signal indicates that the channel
        // is signaling a valid write response.
    ,   output wire  S_AXI_BVALID
    // Response ready. This signal indicates that the master
        // can accept a write response.
    ,   input wire  S_AXI_BREADY
    // Read address (issued by master, acceped by Slave)
    ,   input wire [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_ARADDR
    // Protection type. This signal indicates the privilege
        // and security level of the transaction, and whether the
        // transaction is a data access or an instruction access.
    ,   input wire [2 : 0] S_AXI_ARPROT
    // Read address valid. This signal indicates that the channel
        // is signaling valid read address and control information.
    ,   input wire  S_AXI_ARVALID
    // Read address ready. This signal indicates that the slave is
        // ready to accept an address and associated control signals.
    ,   output wire  S_AXI_ARREADY
    // Read data (issued by slave)
    ,   output wire [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_RDATA
    // Read response. This signal indicates the status of the
        // read transfer.
    ,   output wire [1 : 0] S_AXI_RRESP
    // Read valid. This signal indicates that the channel is
        // signaling the required read data.
    ,   output wire  S_AXI_RVALID
    // Read ready. This signal indicates that the master can
        // accept the read data and response information.
    ,   input wire  S_AXI_RREADY

//----------------------------------------------------
// AXI-FULL master port
    // Global Clock Signal.
    ,   input wire  M_AXI_ACLK
    // Global Reset Singal. This Signal is Active Low
    ,   input wire  M_AXI_ARESETN

    //----------------Write Address Channel----------------//
    // Master Interface Write Address ID
    ,   output wire [C_M_AXI_ID_WIDTH-1 : 0] M_AXI_AWID
    // Master Interface Write Address
    ,   output wire [C_M_AXI_ADDR_WIDTH-1 : 0] M_AXI_AWADDR
    // Burst length. The burst length gives the exact number of transfers in a burst
    ,   output wire [7 : 0] M_AXI_AWLEN
    // Burst size. This signal indicates the size of each transfer in the burst
    ,   output wire [2 : 0] M_AXI_AWSIZE
    // Burst type. The burst type and the size information, 
    // determine how the address for each transfer within the burst is calculated.
    ,   output wire [1 : 0] M_AXI_AWBURST
    // Lock type. Provides additional information about the
    // atomic characteristics of the transfer.
    ,   output wire  M_AXI_AWLOCK
    // Memory type. This signal indicates how transactions
    // are required to progress through a system.
    ,   output wire [3 : 0] M_AXI_AWCACHE
    // Protection type. This signal indicates the privilege
    // and security level of the transaction, and whether
    // the transaction is a data access or an instruction access.
    ,   output wire [2 : 0] M_AXI_AWPROT
    // Quality of Service, QoS identifier sent for each write transaction.
    ,   output wire [3 : 0] M_AXI_AWQOS
    // Optional User-defined signal in the write address channel.
    ,   output wire [C_M_AXI_AWUSER_WIDTH-1 : 0] M_AXI_AWUSER
    // Write address valid. This signal indicates that
    // the channel is signaling valid write address and control information.
    ,   output wire  M_AXI_AWVALID
    // Write address ready. This signal indicates that
    // the slave is ready to accept an address and associated control signals
    ,   input wire  M_AXI_AWREADY

    //----------------Write Data Channel----------------//
    // Master Interface Write Data.
    ,   output wire [C_M_AXI_DATA_WIDTH-1 : 0] M_AXI_WDATA
    // Write strobes. This signal indicates which byte
    // lanes hold valid data. There is one write strobe
    // bit for each eight bits of the write data bus.
    ,   output wire [C_M_AXI_DATA_WIDTH/8-1 : 0] M_AXI_WSTRB
    // Write last. This signal indicates the last transfer in a write burst.
    ,   output wire  M_AXI_WLAST
    // Optional User-defined signal in the write data channel.
    ,   output wire [C_M_AXI_WUSER_WIDTH-1 : 0] M_AXI_WUSER
    // Write valid. This signal indicates that valid write
    // data and strobes are available
    ,   output wire  M_AXI_WVALID
    // Write ready. This signal indicates that the slave
    // can accept the write data.
    ,   input wire  M_AXI_WREADY

    //----------------Write Response Channel----------------//
    // Master Interface Write Response.
    ,   input wire [C_M_AXI_ID_WIDTH-1 : 0] M_AXI_BID
    // Write response. This signal indicates the status of the write transaction.
    ,   input wire [1 : 0] M_AXI_BRESP
    // Optional User-defined signal in the write response channel
    ,   input wire [C_M_AXI_BUSER_WIDTH-1 : 0] M_AXI_BUSER
    // Write response valid. This signal indicates that the
    // channel is signaling a valid write response.
    ,   input wire  M_AXI_BVALID
    // Response ready. This signal indicates that the master
    // can accept a write response.
    ,   output wire  M_AXI_BREADY

    //----------------Read Address Channel----------------//
    // Master Interface Read Address.
    ,   output wire [C_M_AXI_ID_WIDTH-1 : 0] M_AXI_ARID
    // Read address. This signal indicates the initial
    // address of a read burst transaction.
    ,   output wire [C_M_AXI_ADDR_WIDTH-1 : 0] M_AXI_ARADDR
    // Burst length. The burst length gives the exact number of transfers in a burst
    ,   output wire [7 : 0] M_AXI_ARLEN
    // Burst size. This signal indicates the size of each transfer in the burst
    ,   output wire [2 : 0] M_AXI_ARSIZE
    // Burst type. The burst type and the size information, 
    // determine how the address for each transfer within the burst is calculated.
    ,   output wire [1 : 0] M_AXI_ARBURST
    // Lock type. Provides additional information about the
    // atomic characteristics of the transfer.
    ,   output wire  M_AXI_ARLOCK
    // Memory type. This signal indicates how transactions
    // are required to progress through a system.
    ,   output wire [3 : 0] M_AXI_ARCACHE
    // Protection type. This signal indicates the privilege
    // and security level of the transaction, and whether
    // the transaction is a data access or an instruction access.
    ,   output wire [2 : 0] M_AXI_ARPROT
    // Quality of Service, QoS identifier sent for each read transaction
    ,   output wire [3 : 0] M_AXI_ARQOS
    // Optional User-defined signal in the read address channel.
    ,   output wire [C_M_AXI_ARUSER_WIDTH-1 : 0] M_AXI_ARUSER
    // Write address valid. This signal indicates that
    // the channel is signaling valid read address and control information
    ,   output wire  M_AXI_ARVALID
    // Read address ready. This signal indicates that
    // the slave is ready to accept an address and associated control signals
    ,   input wire  M_AXI_ARREADY

    //----------------Read Data Channel----------------//
    // Read ID tag. This signal is the identification tag
    // for the read data group of signals generated by the slave.
    ,   input wire [C_M_AXI_ID_WIDTH-1 : 0] M_AXI_RID
    // Master Read Data
    ,   input wire [C_M_AXI_DATA_WIDTH-1 : 0] M_AXI_RDATA
    // Read response. This signal indicates the status of the read transfer
    ,   input wire [1 : 0] M_AXI_RRESP
    // Read last. This signal indicates the last transfer in a read burst
    ,   input wire  M_AXI_RLAST
    // Optional User-defined signal in the read address channel.
    ,   input wire [C_M_AXI_RUSER_WIDTH-1 : 0] M_AXI_RUSER
    // Read valid. This signal indicates that the channel
    // is signaling the required read data.
    ,   input wire  M_AXI_RVALID
    // Read ready. This signal indicates that the master can
    // accept the read data and response information.
    ,   output wire  M_AXI_RREADY
);
    genvar o;

//----------------------------------------------------
// wire definition
    wire    		                    paillier_start      ;
    wire    [1:0]	                    paillier_mode       ;
    wire    			                paillier_finished   ;

    wire    [2  :0]                     task_cmd                [0 : BLOCK_COUNT - 1]   ;
    wire                                task_req                [0 : BLOCK_COUNT - 1]   ;
    wire                                task_end                [0 : BLOCK_COUNT - 1]   ;
    wire    [K-1:0]                     enc_g_data              [0 : BLOCK_COUNT - 1]   ;
    wire                                enc_g_valid             [0 : BLOCK_COUNT - 1]   ;
    wire    [K-1:0]                     enc_m_data              [0 : BLOCK_COUNT - 1]   ;
    wire                                enc_m_valid             [0 : BLOCK_COUNT - 1]   ;
    wire    [K-1:0]                     enc_r_data              [0 : BLOCK_COUNT - 1]   ;
    wire                                enc_r_valid             [0 : BLOCK_COUNT - 1]   ;
    wire    [K-1:0]                     enc_n_data              [0 : BLOCK_COUNT - 1]   ;
    wire                                enc_n_valid             [0 : BLOCK_COUNT - 1]   ;
    wire    [K-1:0]                     dec_c_data              [0 : BLOCK_COUNT - 1]   ;
    wire                                dec_c_valid             [0 : BLOCK_COUNT - 1]   ;
    wire    [K-1:0]                     dec_lambda_data         [0 : BLOCK_COUNT - 1]   ;
    wire                                dec_lambda_valid        [0 : BLOCK_COUNT - 1]   ;
    wire    [K-1:0]                     dec_n_data              [0 : BLOCK_COUNT - 1]   ;
    wire                                dec_n_valid             [0 : BLOCK_COUNT - 1]   ;
    wire    [K-1:0]                     homo_add_c1             [0 : BLOCK_COUNT - 1]   ;
    wire                                homo_add_c1_valid       [0 : BLOCK_COUNT - 1]   ;
    wire    [K-1:0]                     homo_add_c2             [0 : BLOCK_COUNT - 1]   ;
    wire                                homo_add_c2_valid       [0 : BLOCK_COUNT - 1]   ;
    wire    [K-1:0]                     scalar_mul_c1           [0 : BLOCK_COUNT - 1]   ;
    wire                                scalar_mul_c1_valid     [0 : BLOCK_COUNT - 1]   ;
    wire    [K-1:0]                     scalar_mul_const        [0 : BLOCK_COUNT - 1]   ;
    wire                                scalar_mul_const_valid  [0 : BLOCK_COUNT - 1]   ;
    wire    [K-1:0]                     enc_out_data            [0 : BLOCK_COUNT - 1]   ;
    wire                                enc_out_valid           [0 : BLOCK_COUNT - 1]   ;

//---------------------------------------------------
// FORWARD FIFO STORAGE
// fifo #(
//         .FDW                ()
//     ,   .FAW                ()
// )u_forwardfifo(
//         .rst                (~S_AXIS_ARESETN    )
//     ,   .clr                (1'b0               )
//     ,   .clk                (S_AXIS_ACLK        )
//     ,   .wr_rdy             (fwr_rdy            )
//     ,   .wr_vld             (fwr_vld            )
//     ,   .wr_din             (fwr_dat            )
//     ,   .rd_rdy             (frd_rdy            )
//     ,   .rd_vld             (frd_vld            )
//     ,   .rd_dout            (frd_din            )
//     ,   .empty              (frd_empty          )
//     ,   .full               (fwr_full           )
//     ,   .fullN              ()
//     ,   .emptyN             ()
//     ,   .rd_cnt             (frd_cnt            )
//     ,   .wr_cnt             (fwr_cnt            )
// );


//---------------------------------------------------
// FIFO TO AXI FULL
axi_full_core #(
    //----------------------------------------------------
    // FIFO parameters
	 	.BLOCK_COUNT                    (BLOCK_COUNT                )
	,	.K                              (K                          )

    //----------------------------------------------------
    // AXI-FULL parameters
	,   .C_M_TARGET_SLAVE_BASE_ADDR	    (C_M_TARGET_SLAVE_BASE_ADDR )   
	,   .C_M_AXI_BURST_LEN	            (C_M_AXI_BURST_LEN	        )   
	,   .C_M_AXI_ID_WIDTH	            (C_M_AXI_ID_WIDTH	        )   
	,   .C_M_AXI_ADDR_WIDTH	            (C_M_AXI_ADDR_WIDTH	        )   
	,   .C_M_AXI_DATA_WIDTH	            (C_M_AXI_DATA_WIDTH	        )   
	,   .C_M_AXI_AWUSER_WIDTH	        (C_M_AXI_AWUSER_WIDTH	    )   
	,   .C_M_AXI_ARUSER_WIDTH	        (C_M_AXI_ARUSER_WIDTH	    )   
	,   .C_M_AXI_WUSER_WIDTH	        (C_M_AXI_WUSER_WIDTH	    )   
	,   .C_M_AXI_RUSER_WIDTH	        (C_M_AXI_RUSER_WIDTH	    )   
	,   .C_M_AXI_BUSER_WIDTH	        (C_M_AXI_BUSER_WIDTH	    )   
)u_axi_full_core(
//----------------------------------------------------
// paillier control interface
        .paillier_start     (paillier_start     )
    ,   .paillier_mode      (paillier_mode      )
    ,   .paillier_finished  (paillier_finished  )

//----------------------------------------------------
// AXI-FULL master port
    ,   .INIT_AXI_TXN       (INIT_AXI_TXN       )
    ,   .TXN_DONE           (TXN_DONE           )
    ,   .ERROR              ()
    ,   .M_AXI_ACLK         (M_AXI_ACLK         )
    ,   .M_AXI_ARESETN      (M_AXI_ARESETN      )

    //----------------Write Address Channel----------------//
    ,   .M_AXI_AWID         (M_AXI_AWID         )
    ,   .M_AXI_AWADDR       (M_AXI_AWADDR       )
    ,   .M_AXI_AWLEN        (M_AXI_AWLEN        )
    ,   .M_AXI_AWSIZE       (M_AXI_AWSIZE       )
    ,   .M_AXI_AWBURST      (M_AXI_AWBURST      )
    ,   .M_AXI_AWLOCK       (M_AXI_AWLOCK       )
    ,   .M_AXI_AWCACHE      (M_AXI_AWCACHE      )
    ,   .M_AXI_AWPROT       (M_AXI_AWPROT       )
    ,   .M_AXI_AWQOS        (M_AXI_AWQOS        )
    ,   .M_AXI_AWUSER       (M_AXI_AWUSER       )
    ,   .M_AXI_AWVALID      (M_AXI_AWVALID      )
    ,   .M_AXI_AWREADY      (M_AXI_AWREADY      )

    //----------------Write Data Channel----------------//
    ,   .M_AXI_WDATA        (M_AXI_WDATA        )
    ,   .M_AXI_WSTRB        (M_AXI_WSTRB        )
    ,   .M_AXI_WLAST        (M_AXI_WLAST        )
    ,   .M_AXI_WUSER        (M_AXI_WUSER        )
    ,   .M_AXI_WVALID       (M_AXI_WVALID       )
    ,   .M_AXI_WREADY       (M_AXI_WREADY       )

    //----------------Write Response Channel----------------//
    ,   .M_AXI_BID          (M_AXI_BID          )
    ,   .M_AXI_BRESP        (M_AXI_BRESP        )
    ,   .M_AXI_BUSER        (M_AXI_BUSER        )
    ,   .M_AXI_BVALID       (M_AXI_BVALID       )
    ,   .M_AXI_BREADY       (M_AXI_BREADY       )

    //----------------Read Address Channel----------------//
    ,   .M_AXI_ARID         (M_AXI_ARID         )
    ,   .M_AXI_ARADDR       (M_AXI_ARADDR       )
    ,   .M_AXI_ARLEN        (M_AXI_ARLEN        )
    ,   .M_AXI_ARSIZE       (M_AXI_ARSIZE       )
    ,   .M_AXI_ARBURST      (M_AXI_ARBURST      )
    ,   .M_AXI_ARLOCK       (M_AXI_ARLOCK       )
    ,   .M_AXI_ARCACHE      (M_AXI_ARCACHE      )
    ,   .M_AXI_ARPROT       (M_AXI_ARPROT       )
    ,   .M_AXI_ARQOS        (M_AXI_ARQOS        )
    ,   .M_AXI_ARUSER       (M_AXI_ARUSER       )
    ,   .M_AXI_ARVALID      (M_AXI_ARVALID      )
    ,   .M_AXI_ARREADY      (M_AXI_ARREADY      )

    //----------------Read Data Channel----------------//
    ,   .M_AXI_RID          (M_AXI_RID          )
    ,   .M_AXI_RDATA        (M_AXI_RDATA        )
    ,   .M_AXI_RRESP        (M_AXI_RRESP        )
    ,   .M_AXI_RLAST        (M_AXI_RLAST        )
    ,   .M_AXI_RUSER        (M_AXI_RUSER        )
    ,   .M_AXI_RVALID       (M_AXI_RVALID       )
    ,   .M_AXI_RREADY       (M_AXI_RREADY       )
);


saxi_lite_core #(
    // Width of S_AXI data bus
        .C_S_AXI_DATA_WIDTH	    ( C_S_AXI_DATA_WIDTH    )
    // Width of S_AXI address bus
    ,   .C_S_AXI_ADDR_WIDTH	    ( C_S_AXI_ADDR_WIDTH    )
)u_saxi_lite_core(
    // Users to add ports here
        .paillier_start         (paillier_start         )
    ,   .paillier_mode          (paillier_mode          )
    ,   .paillier_finished      (paillier_finished      )

    // User ports ends
    // Do not modify the ports beyond this line
    ,   .S_AXI_ACLK             (S_AXI_ACLK             )
    ,   .S_AXI_ARESETN          (S_AXI_ARESETN          )
    ,   .S_AXI_AWADDR           (S_AXI_AWADDR           )
    ,   .S_AXI_AWPROT           (S_AXI_AWPROT           )
    ,   .S_AXI_AWVALID          (S_AXI_AWVALID          )
    ,   .S_AXI_AWREADY          (S_AXI_AWREADY          )
    ,   .S_AXI_WDATA            (S_AXI_WDATA            )
    ,   .S_AXI_WSTRB            (S_AXI_WSTRB            )
    ,   .S_AXI_WVALID           (S_AXI_WVALID           )
    ,   .S_AXI_WREADY           (S_AXI_WREADY           )
    ,   .S_AXI_BRESP            (S_AXI_BRESP            )
    ,   .S_AXI_BVALID           (S_AXI_BVALID           )
    ,   .S_AXI_BREADY           (S_AXI_BREADY           )
    ,   .S_AXI_ARADDR           (S_AXI_ARADDR           )
    ,   .S_AXI_ARPROT           (S_AXI_ARPROT           )
    ,   .S_AXI_ARVALID          (S_AXI_ARVALID          )
    ,   .S_AXI_ARREADY          (S_AXI_ARREADY          )
    ,   .S_AXI_RDATA            (S_AXI_RDATA            )
    ,   .S_AXI_RRESP            (S_AXI_RRESP            )
    ,   .S_AXI_RVALID           (S_AXI_RVALID           )
    ,   .S_AXI_RREADY           (S_AXI_RREADY           )
);

generate 
    for(o = 0; o < BLOCK_COUNT; o = o + 1) begin
            paillier_top paillier_top_inst(
                .clk                        (M_AXI_ACLK                 )
            ,   .rst_n                      (M_AXI_ARESETN              )

            ,   .task_cmd                   (task_cmd               [o] )
            ,   .task_req                   (task_req               [o] )
            ,   .task_end                   (task_end               [o] ) 

            ,   .enc_g_data                 (enc_g_data             [o] )
            ,   .enc_g_valid                (enc_g_valid            [o] )
            ,   .enc_m_data                 (enc_m_data             [o] )
            ,   .enc_m_valid                (enc_m_valid            [o] )
            ,   .enc_r_data                 (enc_r_data             [o] )
            ,   .enc_r_valid                (enc_r_valid            [o] )
            ,   .enc_n_data                 (enc_n_data             [o] )
            ,   .enc_n_valid                (enc_n_valid            [o] )

            ,   .dec_c_data                 (dec_c_data             [o] )
            ,   .dec_c_valid                (dec_c_valid            [o] )
            ,   .dec_lambda_data            (dec_lambda_data        [o] )
            ,   .dec_lambda_valid           (dec_lambda_valid       [o] )
            ,   .dec_n_data                 (dec_n_data             [o] )
            ,   .dec_n_valid                (dec_n_valid            [o] )

            ,   .homo_add_c1                (homo_add_c1            [o] )
            ,   .homo_add_c1_valid          (homo_add_c1_valid      [o] )
            ,   .homo_add_c2                (homo_add_c2            [o] )
            ,   .homo_add_c2_valid          (homo_add_c2_valid      [o] )

            ,   .scalar_mul_c1              (scalar_mul_c1          [o] )
            ,   .scalar_mul_c1_valid        (scalar_mul_c1_valid    [o] ) 
            ,   .scalar_mul_const           (scalar_mul_const       [o] )
            ,   .scalar_mul_const_valid     (scalar_mul_const_valid [o] ) 

            ,   .enc_out_data               (enc_out_data           [o] )
            ,   .enc_out_valid              (enc_out_valid          [o] )
        );
    end
endgenerate



endmodule