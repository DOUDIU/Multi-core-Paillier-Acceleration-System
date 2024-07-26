`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/13 12:45:13
// Design Name: 
// Module Name: me_iddmm_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

//function:result = x^^y mod m

module me_iddmm_top#(
        parameter MULT_METHOD   = "TRADITION"   // "COMMON"    :use * ,MULT_LATENCY arbitrarily
                                                // "TRADITION" :MULT_LATENCY=9                
                                                // "VEDIC8"    :VEDIC MULT, MULT_LATENCY=8 
    ,   parameter ADD1_METHOD   = "3-2_PIPE1"   // "COMMON"    :use + ,ADD1_LATENCY arbitrarily
                                                // "3-2_PIPE2" :classic pipeline adder,stage 2,ADD1_LATENCY=2
                                                // "3-2_PIPE1" :classic pipeline adder,stage 1,ADD1_LATENCY=1
                                                // 
    ,   parameter ADD2_METHOD   = "3-2_DELAY2"  // "COMMON"    :use + ,adder2 has no delay,32*(32+2)=1088 clock
                                                // "3-2_DELAY2":use + ,adder2 has 1  delay,32*(32+2)*2=2176 clock
                                                // 
    ,   parameter K             = 128
    ,   parameter N             = 32
)(
        input                   clk         
    ,   input                   rst_n       

    ,   input                   me_start

    ,   input       [K-1:0]     me_x
    ,   input                   me_x_valid

    ,   input       [K-1:0]     me_y
    ,   input                   me_y_valid

    ,   output      [K-1:0]     me_result   
    ,   output                  me_valid
);
localparam ADDR_W   =   $clog2(N);
`define Modelsim_Sim

wire    [K-1    : 0]    me_m1                       ;
reg     [K-1    : 0]    yy                          ;

assign  me_m1       =   128'hb885007f9c90c3f3beb79b92378fe7f;//m1=(-1*(mod_inv(m,2**K)))%2**K

reg     [4              : 0]    state_now;
reg     [4              : 0]    state_now_d1;
reg     [4              : 0]    state_next;
localparam  IDLE                        =   0,
            STA_WR_ROU_XX               =   1,
            STA_STORE_RESULT2           =   2,
            STA_LOOP_STEP1              =   3,
            STA_LOOP_STEP2              =   4,
            STA_LOOP_STORE_THEN_JUMP    =   5,
            STA_LOOP_STORE2             =   6,
            STA_FINAL_MM                =   7,
            STA_STORE_RESULT            =   8;

reg     [$clog2(K*N)    : 0]    loop_counter            ; 
reg                             result_valid            ;
reg     [K-1            : 0]    result_out              ; 
reg     [ADDR_W         : 0]    wr_x_cnt                ;

wire    [2              : 0]    wr_ena                  ;
reg                             wr_ena_x                ;
reg                             wr_ena_y                ;
reg                             wr_ena_m                ;
reg     [ADDR_W-1       : 0]    wr_addr                 ;
reg     [ADDR_W-1       : 0]    wr_addr_d1          = 0 ;
reg     [K-1            : 0]    wr_x                    ;
reg     [K-1            : 0]    wr_x_reg                ;
reg     [K-1            : 0]    wr_y                    ;
reg     [K-1            : 0]    wr_y_reg                ;
wire    [K-1            : 0]    wr_m                    ;

reg                             task_req                ;
wire                            task_end                ;
wire                            task_grant              ;
reg                             task_grant_d1           ;
wire    [K-1            : 0]    task_res                ;

wire    [K-1            : 0]    ram_rou_rd_data         ;

wire                            ram_result2_wr_en       ;
wire    [K-1            : 0]    ram_result2_rd_data     ;

wire                            ram_result_wr_en        ;
wire    [ADDR_W-1       : 0]    ram_result_wr_addr      ;
wire    [K-1            : 0]    ram_result_wr_data      ;
wire    [K-1            : 0]    ram_result_rd_data      ;

wire    [ADDR_W-1       : 0]    ram_result_backup_rd_addr     ;
wire    [K-1            : 0]    ram_result_backup_rd_data     ;


reg                             ram_y_wr_en             ;
reg     [ADDR_W-1       : 0]    ram_y_wr_addr           ;
reg     [K-1            : 0]    ram_y_wr_data           ;
reg     [ADDR_W-1       : 0]    ram_y_rd_addr           ;
wire    [K-1            : 0]    ram_y_rd_data           ;

assign ram_result2_wr_en    =   (state_now == STA_STORE_RESULT2) & task_grant;

assign ram_result_wr_en     =   (((state_now == STA_LOOP_STORE_THEN_JUMP) | (state_now == STA_LOOP_STORE2)) & task_req & task_grant) | ((state_now_d1 == STA_STORE_RESULT) & task_grant_d1);
assign ram_result_wr_addr   =   (state_now_d1 == STA_STORE_RESULT) ? wr_addr_d1 : wr_addr;
assign ram_result_wr_data   =   (state_now_d1 == STA_STORE_RESULT) ? ram_result_backup_rd_data : task_res;

always@(*) begin
    case(state_now)
        STA_LOOP_STEP1: begin
            wr_x_reg    = ram_result_rd_data;
        end
        STA_LOOP_STEP2: begin
            wr_x_reg    = ram_result_rd_data;
        end
        STA_FINAL_MM: begin
            wr_x_reg    = ram_result_rd_data;
        end
        default: begin
            wr_x_reg    = wr_x;
        end
    endcase
end
always@(*) begin
    case(state_now)
        STA_WR_ROU_XX: begin
            wr_y_reg    = ram_rou_rd_data;
        end
        STA_LOOP_STEP1: begin
            wr_y_reg    = ram_result_rd_data;
        end
        STA_LOOP_STEP2: begin
            wr_y_reg    = ram_result2_rd_data;
        end
        STA_FINAL_MM: begin
            wr_y_reg    = wr_addr_d1 == 0 ? 1 : 0;
        end
        default: begin
            wr_y_reg    = wr_y;
        end
    endcase
end

dual_port_ram#(
    `ifndef Modelsim_Sim
        .filename       ("../../../../../1.RTL/data/ram_me_m.txt")
    `else
        .filename       ("..\\1.RTL\\data\\ram_me_m.txt")
    `endif
    ,   .RAM_WIDTH      (K                  )
    ,   .ADDR_LINE      ($clog2(N)          )
)ram_me_m(
        .clk            (clk                )
    ,   .wr_en          (0                  )
    ,   .wr_addr        ()
    ,   .wr_data        ()
    ,   .rd_en          (1                  )
    ,   .rd_addr        (wr_addr            )
    ,   .rd_data        (wr_m               )
);

dual_port_ram#(
    `ifndef Modelsim_Sim
        .filename       ("../../../../../1.RTL/data/ram_me_rou.txt")
    `else
        .filename       ("..\\1.RTL\\data\\ram_me_rou.txt")
    `endif
    ,   .RAM_WIDTH      (K                  )
    ,   .ADDR_LINE      ($clog2(N)          )
)ram_me_rou(
        .clk            (clk                )
    ,   .wr_en          (0                  )
    ,   .wr_addr        ()
    ,   .wr_data        ()
    ,   .rd_en          (1                  )
    ,   .rd_addr        (wr_addr            )
    ,   .rd_data        (ram_rou_rd_data    )
);

dual_port_ram#(
        .filename       ("none")
    ,   .RAM_WIDTH      (K                  )
    ,   .ADDR_LINE      ($clog2(N)          )
)ram_result2(
        .clk            (clk                )
    ,   .wr_en          (ram_result2_wr_en  )
    ,   .wr_addr        (wr_addr            )
    ,   .wr_data        (task_res           )
    ,   .rd_en          (1                  )
    ,   .rd_addr        (wr_addr            )
    ,   .rd_data        (ram_result2_rd_data)
);

dual_port_ram#(
    `ifndef Modelsim_Sim
        .filename       ("../../../../../1.RTL/data/ram_me_result.txt")
    `else
        .filename       ("..\\1.RTL\\data\\ram_me_result.txt")
    `endif
    ,   .RAM_WIDTH      (K                      )
    ,   .ADDR_LINE      ($clog2(N)              )
)ram_result(
        .clk            (clk                    )
    ,   .wr_en          (ram_result_wr_en       )
    ,   .wr_addr        (ram_result_wr_addr     )
    ,   .wr_data        (ram_result_wr_data     )
    ,   .rd_en          (1                      )
    ,   .rd_addr        (wr_addr                )
    ,   .rd_data        (ram_result_rd_data     )
);

dual_port_ram#(
    `ifndef Modelsim_Sim
        .filename       ("../../../../../1.RTL/data/ram_me_result_backup.txt")
    `else
        .filename       ("..\\1.RTL\\data\\ram_me_result_backup.txt")
    `endif
    ,   .RAM_WIDTH      (K                      )
    ,   .ADDR_LINE      ($clog2(N)              )
)ram_result_backup(
        .clk            (clk                    )
    ,   .wr_en          (0                      )
    ,   .wr_addr        ()
    ,   .wr_data        ()
    ,   .rd_en          (1                      )
    ,   .rd_addr        (wr_addr                )
    ,   .rd_data        (ram_result_backup_rd_data)
);

dual_port_ram#(
        .filename       ("none")
    ,   .RAM_WIDTH      (K                  )
    ,   .ADDR_LINE      ($clog2(N)          )
)ram_y(
        .clk            (clk                )
    ,   .wr_en          (ram_y_wr_en        )
    ,   .wr_addr        (ram_y_wr_addr      )
    ,   .wr_data        (ram_y_wr_data      )
    ,   .rd_en          (1                  )
    ,   .rd_addr        (ram_y_rd_addr      )
    ,   .rd_data        (ram_y_rd_data      )
);

//---------------------------------------------------------------------
//---------------------------------------------------------------------
//algorithm achievement:
//---------------------------------------------------------------------
//---------------------------------------------------------------------
// rou = fastExpMod(2,2*nbit,p)
// result = mont_r2mm(rou,1,p,nbit)

//step0
// result2 = mont_r2mm(xx,rou,p,nbit) 

//step1
// for(i) in range(nbit-1,-1,-1):
//     result = mont_r2mm(result,result,p,nbit)
//     if((yy>>i)&1==1):
//         result = mont_r2mm(result,result2,p,nbit)

//step2
// result = mont_r2mm(result,1,p,nbit)
//---------------------------------------------------------------------
//---------------------------------------------------------------------

always@(posedge clk or negedge rst_n) begin
    if(!rst_n | me_start)begin
        ram_y_wr_en         <=  0;
        ram_y_wr_addr       <=  0-1;
        ram_y_wr_data       <=  0;
    end
    else if(me_y_valid) begin
        ram_y_wr_en         <=  1;
        ram_y_wr_addr       <=  ram_y_wr_addr + 1;
        ram_y_wr_data       <=  me_y;
    end
end

always@(posedge clk)begin
    wr_addr_d1 <= wr_addr;
    task_grant_d1 <= task_grant;
    state_now_d1 <= state_now;
end

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        state_now   <=  IDLE;
    end
    else begin
        state_now   <=  state_next;
    end
end

always@(*) begin
    if(!rst_n)begin
        state_next  =  IDLE;
    end
    else begin
        case (state_now)
            IDLE: begin
                if(me_start) begin
                    state_next  =   STA_WR_ROU_XX;
                end
                else begin
                    state_next  =   IDLE;
                end
            end
            STA_WR_ROU_XX: begin
                if(wr_x_cnt == N) begin
                    state_next  =   STA_STORE_RESULT2;
                end
                else begin
                    state_next  =   STA_WR_ROU_XX;
                end
            end
            STA_STORE_RESULT2: begin
                if(task_end) begin
                    state_next  =   STA_LOOP_STEP1;
                end
                else begin
                    state_next  =   STA_STORE_RESULT2;
                end
            end
            STA_LOOP_STEP1: begin
                if((wr_addr_d1 == N-1)&(wr_ena_x | wr_ena_y)) begin
                    state_next  =   STA_LOOP_STORE_THEN_JUMP;
                end
                else begin
                    state_next  =   STA_LOOP_STEP1;
                end
            end
            STA_LOOP_STEP2: begin
                if((wr_addr_d1 == N-1)&(wr_ena_x | wr_ena_y)) begin
                    state_next  =   STA_LOOP_STORE2;
                end
                else begin
                    state_next  =   STA_LOOP_STEP2;
                end
            end
            STA_LOOP_STORE_THEN_JUMP: begin
                if(task_end) begin
                    state_next  =   yy[K-1] ? STA_LOOP_STEP2 : ((loop_counter == (K*N-1)) ? STA_FINAL_MM : STA_LOOP_STEP1);
                end
                else begin
                    state_next  =   STA_LOOP_STORE_THEN_JUMP;
                end
            end
            STA_LOOP_STORE2: begin
                if(task_end) begin
                    state_next  =   (loop_counter == (K*N)) ? STA_FINAL_MM : STA_LOOP_STEP1;
                end
                else begin
                    state_next  =   STA_LOOP_STORE2;
                end
            end
            STA_FINAL_MM: begin
                if((wr_addr_d1 == N-1)&(wr_ena_x | wr_ena_y)) begin
                    state_next  =   STA_STORE_RESULT;
                end
                else begin
                    state_next  =   STA_FINAL_MM;
                end
            end
            STA_STORE_RESULT: begin
                state_next  <=  task_end ? IDLE : STA_STORE_RESULT;
            end
            default: begin
                state_next  =  IDLE;
            end
        endcase
    end
end

always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        task_req            <=  0;
        wr_addr             <=  0;

        wr_x                <=  0;
        wr_y                <=  0;
        wr_ena_x            <=  0;
        wr_ena_y            <=  0;
        wr_ena_m            <=  0;

        ram_y_rd_addr       <=  0-1;
        yy                  <=  0;

        loop_counter        <=  0;
        result_valid        <=  0;
        result_out          <=  0;
        wr_x_cnt            <=  0;

    end
    else begin
        case (state_now)
            IDLE:begin
                task_req          <=  0;
                loop_counter      <=  0;
                result_valid      <=  0;
                result_out        <=  0;

                wr_x              <=  0;
                wr_y              <=  0;
                wr_ena_x          <=  0;
                wr_ena_y          <=  0;
                wr_ena_m          <=  0;

                wr_addr           <=  0;
                wr_x_cnt          <=  0;

                ram_y_rd_addr     <=  0-1;
            end
            //write xx & rou
            STA_WR_ROU_XX:begin
                if(me_x_valid)begin
                    wr_x_cnt            <=  wr_x_cnt + 1;
                    wr_addr             <=  wr_addr + 1;
                    wr_ena_x            <=  1;
                    wr_x                <=  me_x;
                    wr_ena_y            <=  1;
                    wr_ena_m            <=  1;
                end 
                else begin
                    wr_ena_x            <=  0;
                    wr_ena_y            <=  0;
                    wr_ena_m            <=  0;
                end
                if(wr_x_cnt == N)begin
                    wr_x_cnt            <=  0;
                    task_req            <=  1;
                    wr_addr             <=  0;
                end
            end
            //store result2
            STA_STORE_RESULT2:begin
                if(task_end)begin
                    task_req            <=  0;
                    
                    ram_y_rd_addr       <=  ram_y_rd_addr - 1;//inverted read address
                    yy                  <=  ram_y_rd_data;
                end
                
                if(task_grant)begin
                    wr_addr             <=  wr_addr + 1;
                end
            end
            //result = mont_r2mm(result,result,p,nbit)
            STA_LOOP_STEP1:begin
                if((wr_addr_d1 == N-1)&(wr_ena_x | wr_ena_y))begin
                    task_req          <=  1;
                    wr_addr           <=  0;
                    wr_ena_x          <=  0;
                    wr_ena_y          <=  0;
                end
                else begin
                    wr_addr           <=  wr_addr + 1;
                    wr_ena_x          <=  1;
                    wr_ena_y          <=  1;
                end
            end
            //result = mont_r2mm(result,result2,p,nbit)
            STA_LOOP_STEP2:begin
                if((wr_addr_d1 == N-1)&(wr_ena_x | wr_ena_y))begin
                    task_req          <=  1;
                    wr_addr           <=  0;
                    wr_ena_x          <=  0;
                    wr_ena_y          <=  0;
                end
                else begin
                    wr_addr           <=  wr_addr + 1;
                    wr_ena_x          <=  1;
                    wr_ena_y          <=  1;
                end
            end
            //store result of STA_LOOP_STEP1 and decide whether to skip STA_LOOP_STEP2
            STA_LOOP_STORE_THEN_JUMP:begin
                if(task_end)begin
                    task_req          <=  0;
                    loop_counter      <=  loop_counter == (K*N) ? loop_counter : loop_counter + 1;

                    if(loop_counter[($clog2(K)-1):0] == K-1)begin//loop_counter+1 % 128 == 0
                        ram_y_rd_addr       <=  ram_y_rd_addr - 1;//inverted read address
                        yy                  <=  ram_y_rd_data;
                    end
                    else begin
                        yy                  <=  yy << 1;
                    end
                end

                if(task_req & task_grant)begin
                    wr_addr           <=  wr_addr + 1;
                end
            end
            //store result of STA_LOOP_STEP2 and decide whether to jump to STA_FINAL_MM
            STA_LOOP_STORE2:begin
                if(task_end)begin
                    task_req          <=  0;
                end
                if(task_req & task_grant)begin
                    wr_addr           <=  wr_addr + 1;
                end
            end
            //result = mont_r2mm(result,1,p,nbit)
            STA_FINAL_MM:begin
                if((wr_addr_d1 == N-1)&(wr_ena_x | wr_ena_y))begin
                    task_req          <=  1;
                    wr_addr           <=  0;
                    wr_ena_x          <=  0;
                    wr_ena_y          <=  0;
                end
                else begin
                    wr_addr           <=  wr_addr + 1;
                    wr_ena_x          <=  1;
                    wr_ena_y          <=  1;
                end
            end
            //get final result
            STA_STORE_RESULT:begin
                if(task_end)begin
                    task_req          <=  0;
                end

                if(task_req & task_grant)begin
                    wr_addr           <=  wr_addr + 1;
                    result_out        <=  task_res;
                    result_valid      <=  1;  
                end
                else begin
                    result_out        <=  0;
                    result_valid      <=  0;
                end
            end
            //default state
            default:begin
            end
        endcase
    end
end


mmp_iddmm_sp #(
        .MULT_METHOD    (MULT_METHOD    )   // "COMMON"    :use * ,MULT_LATENCY arbitrarily
                                            // "TRADITION" :MULT_LATENCY=9                
                                            // "VEDIC8"  :VEDIC MULT, MULT_LATENCY=8 
    ,   .ADD1_METHOD    (ADD1_METHOD    )   // "COMMON"    :use + ,ADD1_LATENCY arbitrarily
                                            // "3-2_PIPE2" :classic pipeline adder,state 2,ADD1_LATENCY=2
                                            // "3-2_PIPE1" :classic pipeline adder,state 1,ADD1_LATENCY=1
                                            // 
    ,   .ADD2_METHOD    (ADD2_METHOD    )   // "COMMON"    :use + ,adder2 has no delay,32*(32+2)=1088 clock
                                            // "3-2_DELAY2":use + ,adder2 has 1  delay,32*(32+2)*2=2176 clock
                                            // 
    ,   .K              (K              )   // K bits in every group
    ,   .N              (N              )   // Number of groups
)u_mmp_iddmm_sp(
        .clk            (clk            )
    ,   .rst_n          (rst_n          )

    ,   .wr_ena         (wr_ena         )
    ,   .wr_addr        (wr_addr_d1     )
    ,   .wr_x           (wr_x_reg       )   //low words first
    ,   .wr_y           (wr_y_reg       )   //low words first
    ,   .wr_m           (wr_m           )   //low words first
    ,   .wr_m1          (me_m1          )

    ,   .task_req       (task_req       )
    ,   .task_end       (task_end       )
    ,   .task_grant     (task_grant     )
    ,   .task_res       (task_res       )    
);



assign wr_ena       = {wr_ena_m,wr_ena_y,wr_ena_x};
assign me_result    = result_out;
assign me_valid     = result_valid;



endmodule
