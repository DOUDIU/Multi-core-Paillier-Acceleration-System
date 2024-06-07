module paillier_top#(
        parameter K       = 128
    ,   parameter N       = 32
)(
        input                   clk
    ,   input                   rst_n   

    ,   input       [2:0]       task_cmd
    ,   input                   task_req

    ,   input       [K-1:0]     enc_g_data
    ,   input                   enc_g_valid
    ,   input       [K-1:0]     enc_m_data
    ,   input                   enc_m_valid
    ,   input       [K-1:0]     enc_r_data
    ,   input                   enc_r_valid
    ,   input       [K-1:0]     enc_n_data
    ,   input                   enc_n_valid

    ,   input       [K-1:0]     dec_c_data
    ,   input                   dec_c_valid
    ,   input       [K-1:0]     dec_lambda_data
    ,   input                   dec_lambda_valid
    ,   input       [K-1:0]     dec_n_data
    ,   input                   dec_n_valid

    ,   input       [K-1:0]     homo_add_c1
    ,   input                   homo_add_c1_valid
    ,   input       [K-1:0]     homo_add_c2
    ,   input                   homo_add_c2_valid

    ,   input       [K-1:0]     scalar_mul_c1
    ,   input                   scalar_mul_c1_valid
    ,   input       [K-1:0]     scalar_mul_const
    ,   input                   scalar_mul_const_valid

    ,   output  reg [K-1:0]     enc_out_data
    ,   output  reg             enc_out_valid
);

reg                     me_start_0      ;
reg     [K-1    : 0]    me_x_0          ;
reg                     me_x_valid_0    ;
reg     [K-1    : 0]    me_y_0          ;
reg                     me_y_valid_0    ;
wire    [K-1    : 0]    me_result_0     ;
wire                    me_valid_0      ;

reg                     me_start_1      ;
reg     [K-1    : 0]    me_x_1          ;
reg                     me_x_valid_1    ;
reg     [K-1    : 0]    me_y_1          ;
reg                     me_y_valid_1    ;
wire    [K-1    : 0]    me_result_1     ;
wire                    me_valid_1      ;

reg     [K-1            : 0]    me_result_0_storage     [N-1:0] ;
reg     [K-1            : 0]    me_result_1_storage     [N-1:0] ;
reg     [$clog2(N)-1    : 0]    me_result_0_cnt         =   0;
reg     [$clog2(N)-1    : 0]    me_result_1_cnt         =   0;


reg                             mm_start_0              ;
reg     [$clog2(N)-1    : 0]    mm_addr                 ;
reg     [$clog2(N)-1    : 0]    mm_addr_d1              ;
reg     [K-1            : 0]    mm_x_0                  ;
reg     [K-1            : 0]    mm_y_0                  ;
reg                             mm_x_valid_0            ;
reg                             mm_y_valid_0            ;
wire    [K-1            : 0]    mm_result_0             ;
wire                            mm_valid_0              ;

reg     [$clog2(N)-1    : 0]    mm_result_0_cnt         =   0;


localparam  STA_IDLE                = 0,
            STA_ENCRYPTION_ME       = 1,
            STA_ENCRYPTION_MM       = 2,
            STA_DECRYPTION_ME       = 3,
            STA_DECRYPTION_L        = 4,
            STA_DECRYPTION_MM       = 5,
            STA_HOMOMORPHIC_ADD     = 6,
            STA_SCALAR_MUL          = 7,
            STA_END                 = 8;

reg         [3:0]        state_now;
reg         [3:0]        state_next;


always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        state_now <= STA_IDLE;
    end
    else begin
        state_now <= state_next;
    end
end

always@(*) begin
    state_next = STA_IDLE;
    case(state_now)
        STA_IDLE: begin
            if(task_req) begin
                case(task_cmd)
                    3'b000:     state_next = STA_ENCRYPTION_ME;
                    3'b001:     state_next = STA_DECRYPTION_ME;
                    3'b010:     state_next = STA_HOMOMORPHIC_ADD;
                    3'b011:     state_next = STA_SCALAR_MUL;
                    default:    state_next = STA_IDLE;
                endcase
            end
        end
        STA_ENCRYPTION_ME: begin
            if((me_result_0_cnt == N - 1) && (me_result_1_cnt == N - 1)) begin
                state_next  =   STA_ENCRYPTION_MM;
            end
            else begin
                state_next  =   STA_ENCRYPTION_ME;
            end
        end
        STA_ENCRYPTION_MM: begin
            if(mm_result_0_cnt == N - 1) begin
                state_next  =   STA_IDLE;
            end
            else begin
                state_next  =   STA_ENCRYPTION_MM;
            end
        end
        STA_DECRYPTION_ME: begin
            if(me_result_0_cnt == N - 1) begin
                state_next  =   STA_DECRYPTION_L;
            end
        end
        STA_DECRYPTION_L: begin

        end
        STA_HOMOMORPHIC_ADD: begin
            if(mm_result_0_cnt == N - 1) begin
                state_next  =   STA_IDLE;
            end
            else begin
                state_next  =   STA_HOMOMORPHIC_ADD;
            end
        end
        STA_SCALAR_MUL: begin
            if(me_result_0_cnt == N - 1) begin
                state_next  =   STA_IDLE;
            end
            else begin
                state_next  =   STA_SCALAR_MUL;
            end
        end
        default: begin
            state_next = STA_IDLE;
        end
    endcase
end

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        me_start_0          <=  0;
        me_x_0              <=  0;
        me_x_valid_0        <=  0;
        me_y_0              <=  0;
        me_y_valid_0        <=  0;
        me_start_1          <=  0;
        me_x_1              <=  0;
        me_x_valid_1        <=  0;
        me_y_1              <=  0;
        me_y_valid_1        <=  0;
        me_result_0_cnt     <=  0;
        me_result_1_cnt     <=  0;

        mm_addr             <=  0;
        mm_addr_d1          <=  0;
        mm_x_0              <=  0;
        mm_y_0              <=  0;
        mm_x_valid_0        <=  0;
        mm_y_valid_0        <=  0;
        mm_start_0          <=  0;

        enc_out_data        <=  0;
        enc_out_valid       <=  0;
    end
    else begin
        mm_addr_d1          <=  mm_addr; 
        case(state_now)
            STA_IDLE: begin
                me_result_0_cnt         <=      0;
                me_result_1_cnt         <=      0;
                enc_out_data            <=      0;
                enc_out_valid           <=      0;
                mm_addr                 <=      0;
                if(state_next == STA_ENCRYPTION_ME) begin
                    me_start_0              <=      1;
                    me_start_1              <=      1;
                end
                if((state_next == STA_SCALAR_MUL) | (state_next == STA_DECRYPTION_ME)) begin
                    me_start_0              <=      1;
                end
                if(state_next   ==  STA_HOMOMORPHIC_ADD) begin
                    mm_start_0      <=  1;
                end
            end
            STA_ENCRYPTION_ME: begin
                me_start_0          <=      0;
                me_start_1          <=      0;
                me_x_0              <=      enc_g_data;
                me_x_valid_0        <=      enc_g_valid;
                me_y_0              <=      enc_m_data;
                me_y_valid_0        <=      enc_m_valid;
                me_x_1              <=      enc_r_data;
                me_x_valid_1        <=      enc_r_valid;
                me_y_1              <=      enc_n_data;
                me_y_valid_1        <=      enc_n_valid;
                if(me_valid_0) begin
                    me_result_0_storage[me_result_0_cnt]    <=      me_result_0;
                    me_result_0_cnt                         <=      (me_result_0_cnt < N-1) ? (me_result_0_cnt + 1) : me_result_0_cnt;
                end
                if(me_valid_1) begin
                    me_result_1_storage[me_result_1_cnt]    <=      me_result_1;
                    me_result_1_cnt                         <=      (me_result_1_cnt < N-1) ? (me_result_1_cnt + 1) : me_result_1_cnt;
                end
                if(state_next   ==  STA_ENCRYPTION_MM) begin
                    mm_start_0      <=  1;
                end
            end
            STA_ENCRYPTION_MM: begin
                mm_start_0      <=  0;
                mm_addr         <=  mm_addr < N - 1 ? mm_addr + 1 : mm_addr;
                if(mm_addr_d1 < N - 1) begin
                    mm_x_0              <=  me_result_0_storage[mm_addr];
                    mm_y_0              <=  me_result_1_storage[mm_addr];
                    mm_x_valid_0        <=  1;
                    mm_y_valid_0        <=  1;
                end
                else begin
                    mm_x_valid_0        <=  0;
                    mm_y_valid_0        <=  0;
                end
                if(mm_valid_0) begin
                    mm_result_0_cnt     <=  mm_result_0_cnt + 1;
                end
                enc_out_data        <=  mm_result_0;
                enc_out_valid       <=  mm_valid_0;
            end
            STA_DECRYPTION_ME: begin
                me_start_0          <=      0;
                me_x_0              <=      dec_c_data;
                me_x_valid_0        <=      dec_c_valid;
                me_y_0              <=      dec_lambda_data;
                me_y_valid_0        <=      dec_lambda_valid;
                if(me_valid_0) begin
                    me_result_0_storage[me_result_0_cnt]    <=      me_result_0;
                    me_result_0_cnt                         <=      (me_result_0_cnt < N-1) ? (me_result_0_cnt + 1) : me_result_0_cnt;
                end
            end
            STA_HOMOMORPHIC_ADD: begin
                mm_start_0          <=  0;
                mm_x_0              <=  homo_add_c1;
                mm_y_0              <=  homo_add_c2;
                mm_x_valid_0        <=  homo_add_c1_valid;
                mm_y_valid_0        <=  homo_add_c2_valid;
                if(mm_valid_0) begin
                    mm_result_0_cnt     <=  mm_result_0_cnt + 1;
                end
                enc_out_data        <=  mm_result_0;
                enc_out_valid       <=  mm_valid_0;
            end
            STA_SCALAR_MUL: begin
                me_start_0          <=      0;
                me_x_0              <=      scalar_mul_c1;
                me_x_valid_0        <=      scalar_mul_c1_valid;
                me_y_0              <=      scalar_mul_const;
                me_y_valid_0        <=      scalar_mul_const_valid;
                if(me_valid_0) begin
                    me_result_0_cnt                         <=      (me_result_0_cnt < N-1) ? (me_result_0_cnt + 1) : me_result_0_cnt;
                end
                enc_out_data        <=  me_valid_0;
                enc_out_valid       <=  me_result_0;
            end
            default: begin
            end
        endcase
    end
end







me_iddmm_top #(
        .K              (K              )
    ,   .N              (N              )
)me_4096_inst_0(
        .clk            (clk            )
    ,   .rst_n          (rst_n          )
    ,   .me_start       (me_start_0     )
    ,   .me_x           (me_x_0         )
    ,   .me_x_valid     (me_x_valid_0   )
    ,   .me_y           (me_y_0         )
    ,   .me_y_valid     (me_y_valid_0   )
    ,   .me_result      (me_result_0    )
    ,   .me_valid       (me_valid_0     )
);

me_iddmm_top #(
        .K              (K              )
    ,   .N              (N              )
)me_4096_inst_1(
        .clk            (clk            )
    ,   .rst_n          (rst_n          )
    ,   .me_start       (me_start_1     )
    ,   .me_x           (me_x_1         )
    ,   .me_x_valid     (me_x_valid_1   )
    ,   .me_y           (me_y_1         )
    ,   .me_y_valid     (me_y_valid_1   )
    ,   .me_result      (me_result_1    )
    ,   .me_valid       (me_valid_1     )
);

mm_iddmm_top #(
        .K              (K              )
    ,   .N              (N              )
)mm_iddmm_top_4096_inst_0(
        .clk            (clk            )
    ,   .rst_n          (rst_n          )
    ,   .mm_start       (mm_start_0     )
    ,   .mm_x           (mm_x_0         )
    ,   .mm_x_valid     (mm_x_valid_0   )
    ,   .mm_y           (mm_y_0         )
    ,   .mm_y_valid     (mm_y_valid_0   )
    ,   .mm_result      (mm_result_0    )
    ,   .mm_valid       (mm_valid_0     )
);

endmodule