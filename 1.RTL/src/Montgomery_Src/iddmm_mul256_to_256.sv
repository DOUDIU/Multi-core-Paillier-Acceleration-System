/*
    X = x10x9x8x7x6x5x4x3x2x1x0
    Y = y7y6y5y4y3y2yy15y14y13y12y11y10y9y8y7y6y5y4y3y2y1y01y0
    X*Y = (x10x9x8x7x6x5x4x3x2x1x0) * (y15y14y13y12y11y10y9y8y7y6y5y4y3y2y1y0)
        = ((x10 << 240) + (x9 << 216) + (x8 << 192) + (x7 << 168) + (x6 << 144) + (x5 << 120) + (x4 << 96) + (x3 << 72) + (x2 << 48) + (x1 << 24) + x0)
            * ((y15 << 240) + (y14 << 224) + (y13 << 208) + (y12 << 192) + (y11 << 176) + (y10 << 160) + (y9 << 144) + (y8 << 128) + (y7 << 112) + (y6 << 96) + (y5 << 80) + (y4 << 64) + (y3 << 48) + (y2 << 32) + (y1 << 16) + y0)
        =  (
            (x10y15) << 480
        +   (x10y14) << 464
        +   (x10y13) << 448
        +   (x10y12) << 432
        +   (x10y11) << 416
        +   (x10y10) << 400
        +   (x10y9 ) << 384
        +   (x10y8 ) << 368
        +   (x10y7 ) << 352
        +   (x10y6 ) << 336
        +   (x10y5 ) << 320
        +   (x10y4 ) << 304
        +   (x10y3 ) << 288
        +   (x10y2 ) << 272
        +   (x10y1 ) << 256
        +   (x10y0 ) << 240

        +   (x9y15) << 456
        +   (x9y14) << 440
        +   (x9y13) << 424
        +   (x9y12) << 408
        +   (x9y11) << 392
        +   (x9y10) << 376
        +   (x9y9 ) << 360
        +   (x9y8 ) << 344
        +   (x9y7 ) << 328
        +   (x9y6 ) << 312
        +   (x9y5 ) << 296
        +   (x9y4 ) << 280
        +   (x9y3 ) << 264
        +   (x9y2 ) << 248
        +   (x9y1 ) << 232
        +   (x9y0 ) << 216

        +   (x8y15) << 432
        +   (x8y14) << 416
        +   (x8y13) << 400
        +   (x8y12) << 384
        +   (x8y11) << 368
        +   (x8y10) << 352
        +   (x8y9 ) << 336
        +   (x8y8 ) << 320
        +   (x8y7 ) << 304
        +   (x8y6 ) << 288
        +   (x8y5 ) << 272
        +   (x8y4 ) << 256
        +   (x8y3 ) << 240
        +   (x8y2 ) << 224
        +   (x8y1 ) << 208
        +   (x8y0 ) << 192

        +   (x7y15) << 408
        +   (x7y14) << 392
        +   (x7y13) << 376
        +   (x7y12) << 360
        +   (x7y11) << 344
        +   (x7y10) << 328
        +   (x7y9 ) << 312
        +   (x7y8 ) << 296
        +   (x7y7 ) << 280
        +   (x7y6 ) << 264
        +   (x7y5 ) << 248
        +   (x7y4 ) << 232
        +   (x7y3 ) << 216
        +   (x7y2 ) << 200
        +   (x7y1 ) << 184
        +   (x7y0 ) << 168

        +   (x6y15) << 384
        +   (x6y14) << 368
        +   (x6y13) << 352
        +   (x6y12) << 336
        +   (x6y11) << 320
        +   (x6y10) << 304
        +   (x6y9 ) << 288
        +   (x6y8 ) << 272
        +   (x6y7 ) << 256
        +   (x6y6 ) << 240
        +   (x6y5 ) << 224
        +   (x6y4 ) << 208
        +   (x6y3 ) << 192
        +   (x6y2 ) << 176
        +   (x6y1 ) << 160
        +   (x6y0 ) << 144

        +   (x5y15) << 360
        +   (x5y14) << 344
        +   (x5y13) << 328
        +   (x5y12) << 312
        +   (x5y11) << 296
        +   (x5y10) << 280
        +   (x5y9 ) << 264
        +   (x5y8 ) << 248
        +   (x5y7 ) << 232
        +   (x5y6 ) << 216
        +   (x5y5 ) << 200
        +   (x5y4 ) << 184
        +   (x5y3 ) << 168
        +   (x5y2 ) << 152
        +   (x5y1 ) << 136
        +   (x5y0 ) << 120

        +   (x4y15) << 336
        +   (x4y14) << 320
        +   (x4y13) << 304
        +   (x4y12) << 288
        +   (x4y11) << 272
        +   (x4y10) << 256
        +   (x4y9 ) << 240
        +   (x4y8 ) << 224
        +   (x4y7 ) << 208
        +   (x4y6 ) << 192
        +   (x4y5 ) << 176
        +   (x4y4 ) << 160
        +   (x4y3 ) << 144
        +   (x4y2 ) << 128
        +   (x4y1 ) << 112
        +   (x4y0 ) << 96

        +   (x3y15) << 312
        +   (x3y14) << 296
        +   (x3y13) << 280
        +   (x3y12) << 264
        +   (x3y11) << 248
        +   (x3y10) << 232
        +   (x3y9 ) << 216
        +   (x3y8 ) << 200
        +   (x3y7 ) << 184
        +   (x3y6 ) << 168
        +   (x3y5 ) << 152
        +   (x3y4 ) << 136
        +   (x3y3 ) << 120
        +   (x3y2 ) << 104
        +   (x3y1 ) << 88
        +   (x3y0 ) << 72

        +   (x2y15) << 288
        +   (x2y14) << 272
        +   (x2y13) << 256
        +   (x2y12) << 240
        +   (x2y11) << 224
        +   (x2y10) << 208
        +   (x2y9 ) << 192
        +   (x2y8 ) << 176
        +   (x2y7 ) << 160
        +   (x2y6 ) << 144
        +   (x2y5 ) << 128
        +   (x2y4 ) << 112
        +   (x2y3 ) << 96
        +   (x2y2 ) << 80
        +   (x2y1 ) << 64
        +   (x2y0 ) << 48

        +   (x1y15) << 264
        +   (x1y14) << 248
        +   (x1y13) << 232
        +   (x1y12) << 216
        +   (x1y11) << 200
        +   (x1y10) << 184
        +   (x1y9 ) << 168
        +   (x1y8 ) << 152
        +   (x1y7 ) << 136
        +   (x1y6 ) << 120
        +   (x1y5 ) << 104
        +   (x1y4 ) << 88
        +   (x1y3 ) << 72
        +   (x1y2 ) << 56
        +   (x1y1 ) << 40
        +   (x1y0 ) << 24

        +   (x0y15) << 240
        +   (x0y14) << 224
        +   (x0y13) << 208
        +   (x0y12) << 192
        +   (x0y11) << 176
        +   (x0y10) << 160
        +   (x0y9 ) << 144
        +   (x0y8 ) << 128
        +   (x0y7 ) << 112
        +   (x0y6 ) << 96
        +   (x0y5 ) << 80
        +   (x0y4 ) << 64
        +   (x0y3 ) << 48
        +   (x0y2 ) << 32
        +   (x0y1 ) << 16
        +   (x0y0 )
    )
*/
module iddmm_mul_256_to_256(
        input                           clk
    ,   input                           rst_n

    ,   input           [255    :0]     x
    ,   input           [255    :0]     y
    ,   output  reg     [255    :0]     result
);
wire [23:0]x10 = x[240   +:16];
wire [23:0]x9  = x[216   +:24];
wire [23:0]x8  = x[192   +:24];
wire [23:0]x7  = x[168   +:24];
wire [23:0]x6  = x[144   +:24];
wire [23:0]x5  = x[120   +:24];
wire [23:0]x4  = x[ 96   +:24];
wire [23:0]x3  = x[ 72   +:24];
wire [23:0]x2  = x[ 48   +:24];
wire [23:0]x1  = x[ 24   +:24];
wire [23:0]x0  = x[  0   +:24];

wire [15:0]y15 = y[240   +:16];
wire [15:0]y14 = y[224   +:16];
wire [15:0]y13 = y[208   +:16];
wire [15:0]y12 = y[192   +:16];
wire [15:0]y11 = y[176   +:16];
wire [15:0]y10 = y[160   +:16];
wire [15:0]y9  = y[144   +:16];
wire [15:0]y8  = y[128   +:16];
wire [15:0]y7  = y[112   +:16];
wire [15:0]y6  = y[ 96   +:16];
wire [15:0]y5  = y[ 80   +:16];
wire [15:0]y4  = y[ 64   +:16];
wire [15:0]y3  = y[ 48   +:16];
wire [15:0]y2  = y[ 32   +:16];
wire [15:0]y1  = y[ 16   +:16];
wire [15:0]y0  = y[  0   +:16];

reg[39:0]  x10y0;
reg[39:0]  x9y2,  x9y1,  x9y0;
reg[39:0]  x8y3,  x8y2,  x8y1,  x8y0;
reg[39:0]  x7y5,  x7y4,  x7y3,  x7y2,  x7y1,  x7y0;
reg[39:0]  x6y6,  x6y5,  x6y4,  x6y3,  x6y2,  x6y1,  x6y0;
reg[39:0]  x5y8,  x5y7,  x5y6,  x5y5,  x5y4,  x5y3,  x5y2,  x5y1,  x5y0;
reg[39:0]  x4y9,  x4y8,  x4y7,  x4y6,  x4y5,  x4y4,  x4y3,  x4y2,  x4y1,  x4y0;
reg[39:0]  x3y11,  x3y10,  x3y9,  x3y8,  x3y7,  x3y6,  x3y5,  x3y4,  x3y3,  x3y2,  x3y1,  x3y0;
reg[39:0]  x2y12,  x2y11,  x2y10,  x2y9,  x2y8,  x2y7,  x2y6,  x2y5,  x2y4,  x2y3,  x2y2,  x2y1,  x2y0;
reg[39:0]  x1y14,  x1y13,  x1y12,  x1y11,  x1y10,  x1y9,  x1y8,  x1y7,  x1y6,  x1y5,  x1y4,  x1y3,  x1y2,  x1y1,  x1y0;
reg[39:0]  x0y15,  x0y14,  x0y13,  x0y12,  x0y11,  x0y10,  x0y9,  x0y8,  x0y7,  x0y6,  x0y5,  x0y4,  x0y3,  x0y2,  x0y1,  x0y0;

// pipe 0
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        x10y0  <= 0;

        x9y2   <= 0;
        x9y1   <= 0;
        x9y0   <= 0;

        x8y3   <= 0;
        x8y2   <= 0;
        x8y1   <= 0;
        x8y0   <= 0;

        x7y5   <= 0;
        x7y4   <= 0;
        x7y3   <= 0;
        x7y2   <= 0;
        x7y1   <= 0;
        x7y0   <= 0;

        x6y6   <= 0;
        x6y5   <= 0;
        x6y4   <= 0;
        x6y3   <= 0;
        x6y2   <= 0;
        x6y1   <= 0;
        x6y0   <= 0;

        x5y8   <= 0;
        x5y7   <= 0;
        x5y6   <= 0;
        x5y5   <= 0;
        x5y4   <= 0;
        x5y3   <= 0;
        x5y2   <= 0;
        x5y1   <= 0;
        x5y0   <= 0;

        x4y9   <= 0;
        x4y8   <= 0;
        x4y7   <= 0;
        x4y6   <= 0;
        x4y5   <= 0;
        x4y4   <= 0;
        x4y3   <= 0;
        x4y2   <= 0;
        x4y1   <= 0;
        x4y0   <= 0;

        x3y11  <= 0;
        x3y10  <= 0;
        x3y9   <= 0;
        x3y8   <= 0;
        x3y7   <= 0;
        x3y6   <= 0;
        x3y5   <= 0;
        x3y4   <= 0;
        x3y3   <= 0;
        x3y2   <= 0;
        x3y1   <= 0;
        x3y0   <= 0;

        x2y12  <= 0;
        x2y11  <= 0;
        x2y10  <= 0;
        x2y9   <= 0;
        x2y8   <= 0;
        x2y7   <= 0;
        x2y6   <= 0;
        x2y5   <= 0;
        x2y4   <= 0;
        x2y3   <= 0;
        x2y2   <= 0;
        x2y1   <= 0;
        x2y0   <= 0;

        x1y14  <= 0;
        x1y13  <= 0;
        x1y12  <= 0;
        x1y11  <= 0;
        x1y10  <= 0;
        x1y9   <= 0;
        x1y8   <= 0;
        x1y7   <= 0;
        x1y6   <= 0;
        x1y5   <= 0;
        x1y4   <= 0;
        x1y3   <= 0;
        x1y2   <= 0;
        x1y1   <= 0;
        x1y0   <= 0;

        x0y15  <= 0;
        x0y14  <= 0;
        x0y13  <= 0;
        x0y12  <= 0;
        x0y11  <= 0;
        x0y10  <= 0;
        x0y9   <= 0;
        x0y8   <= 0;
        x0y7   <= 0;
        x0y6   <= 0;
        x0y5   <= 0;
        x0y4   <= 0;
        x0y3   <= 0;
        x0y2   <= 0;
        x0y1   <= 0;
        x0y0   <= 0;
    end
    else begin
        x10y0  <= x10 * y0 ;

        x9y2   <= x9  * y2 ;
        x9y1   <= x9  * y1 ;
        x9y0   <= x9  * y0 ;

        x8y3   <= x8  * y3 ;
        x8y2   <= x8  * y2 ;
        x8y1   <= x8  * y1 ;
        x8y0   <= x8  * y0 ;

        x7y5   <= x7  * y5 ;
        x7y4   <= x7  * y4 ;
        x7y3   <= x7  * y3 ;
        x7y2   <= x7  * y2 ;
        x7y1   <= x7  * y1 ;
        x7y0   <= x7  * y0 ;

        x6y6   <= x6  * y6 ;
        x6y5   <= x6  * y5 ;
        x6y4   <= x6  * y4 ;
        x6y3   <= x6  * y3 ;
        x6y2   <= x6  * y2 ;
        x6y1   <= x6  * y1 ;
        x6y0   <= x6  * y0 ;

        x5y8   <= x5  * y8 ;
        x5y7   <= x5  * y7 ;
        x5y6   <= x5  * y6 ;
        x5y5   <= x5  * y5 ;
        x5y4   <= x5  * y4 ;
        x5y3   <= x5  * y3 ;
        x5y2   <= x5  * y2 ;
        x5y1   <= x5  * y1 ;
        x5y0   <= x5  * y0 ;

        x4y9   <= x4  * y9 ;
        x4y8   <= x4  * y8 ;
        x4y7   <= x4  * y7 ;
        x4y6   <= x4  * y6 ;
        x4y5   <= x4  * y5 ;
        x4y4   <= x4  * y4 ;
        x4y3   <= x4  * y3 ;
        x4y2   <= x4  * y2 ;
        x4y1   <= x4  * y1 ;
        x4y0   <= x4  * y0 ;

        x3y11  <= x3  * y11;
        x3y10  <= x3  * y10;
        x3y9   <= x3  * y9 ;
        x3y8   <= x3  * y8 ;
        x3y7   <= x3  * y7 ;
        x3y6   <= x3  * y6 ;
        x3y5   <= x3  * y5 ;
        x3y4   <= x3  * y4 ;
        x3y3   <= x3  * y3 ;
        x3y2   <= x3  * y2 ;
        x3y1   <= x3  * y1 ;
        x3y0   <= x3  * y0 ;

        x2y12  <= x2  * y12;
        x2y11  <= x2  * y11;
        x2y10  <= x2  * y10;
        x2y9   <= x2  * y9 ;
        x2y8   <= x2  * y8 ;
        x2y7   <= x2  * y7 ;
        x2y6   <= x2  * y6 ;
        x2y5   <= x2  * y5 ;
        x2y4   <= x2  * y4 ;
        x2y3   <= x2  * y3 ;
        x2y2   <= x2  * y2 ;
        x2y1   <= x2  * y1 ;
        x2y0   <= x2  * y0 ;

        x1y14  <= x1  * y14;
        x1y13  <= x1  * y13;
        x1y12  <= x1  * y12;
        x1y11  <= x1  * y11;
        x1y10  <= x1  * y10;
        x1y9   <= x1  * y9 ;
        x1y8   <= x1  * y8 ;
        x1y7   <= x1  * y7 ;
        x1y6   <= x1  * y6 ;
        x1y5   <= x1  * y5 ;
        x1y4   <= x1  * y4 ;
        x1y3   <= x1  * y3 ;
        x1y2   <= x1  * y2 ;
        x1y1   <= x1  * y1 ;
        x1y0   <= x1  * y0 ;

        x0y15  <= x0  * y15;
        x0y14  <= x0  * y14;
        x0y13  <= x0  * y13;
        x0y12  <= x0  * y12;
        x0y11  <= x0  * y11;
        x0y10  <= x0  * y10;
        x0y9   <= x0  * y9 ;
        x0y8   <= x0  * y8 ;
        x0y7   <= x0  * y7 ;
        x0y6   <= x0  * y6 ;
        x0y5   <= x0  * y5 ;
        x0y4   <= x0  * y4 ;
        x0y3   <= x0  * y3 ;
        x0y2   <= x0  * y2 ;
        x0y1   <= x0  * y1 ;
        x0y0   <= x0  * y0 ;
    end
end

// pipe 1
reg [511:0] sum_s1_0;
reg [511:0] sum_s1_1;
reg [511:0] sum_s1_2;
reg [511:0] sum_s1_3;
reg [511:0] sum_s1_4;
reg [511:0] sum_s1_5;
reg [511:0] sum_s1_6;
reg [511:0] sum_s1_7;
reg [511:0] sum_s1_8;
reg [511:0] sum_s1_9;
reg [511:0] sum_s1_10;
reg [511:0] sum_s1_11;
reg [511:0] sum_s1_12;
reg [511:0] sum_s1_13;
reg [511:0] sum_s1_14;
reg [511:0] sum_s1_15;
reg [511:0] sum_s1_16;
reg [511:0] sum_s1_17;
reg [511:0] sum_s1_18;
reg [511:0] sum_s1_19;
reg [511:0] sum_s1_20;
reg [511:0] sum_s1_21;
reg [511:0] sum_s1_22;
reg [511:0] sum_s1_23;
reg [511:0] sum_s1_24;
reg [511:0] sum_s1_25;
reg [511:0] sum_s1_26;
reg [511:0] sum_s1_27;
reg [511:0] sum_s1_28;
reg [511:0] sum_s1_29;
reg [511:0] sum_s1_30;
reg [511:0] sum_s1_31;
reg [511:0] sum_s1_32;
reg [511:0] sum_s1_33;
reg [511:0] sum_s1_34;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        sum_s1_0    <=  0;
        sum_s1_1    <=  0;
        sum_s1_2    <=  0;
        sum_s1_3    <=  0;
        sum_s1_4    <=  0;
        sum_s1_5    <=  0;
        sum_s1_6    <=  0;
        sum_s1_7    <=  0;
        sum_s1_8    <=  0;
        sum_s1_9    <=  0;
        sum_s1_10   <=  0;
        sum_s1_11   <=  0;
        sum_s1_12   <=  0;
        sum_s1_13   <=  0;
        sum_s1_14   <=  0;
        sum_s1_15   <=  0;
        sum_s1_16   <=  0;
        sum_s1_17   <=  0;
        sum_s1_18   <=  0;
    end
    else begin
        sum_s1_0    <= x0y0 + (x0y1 << 16) + ((x1y0 + (x0y2 << 8)) << 24); // << 0
        sum_s1_1    <= x1y1 + ((x0y3 + x2y0) << 8) + ((x1y2 + ((x0y4 + x2y1) << 8)) << 16);// << 40
        sum_s1_2    <= (x1y3 + x3y0) + ((x2y2 + x0y5) << 8) + ((x1y4 + x3y1) << 16);// << 72
        sum_s1_3    <= (x0y6 + x2y3 + x4y0) + ((x1y5 + x3y2) << 8);// << 96
        sum_s1_4    <= (x0y7 + x2y4 + x4y1) + ((x1y6 + x3y3 + x5y0) << 8);// << 112
        sum_s1_5    <= (x0y8 + x2y5 + x4y2) + ((x1y7 + x3y4 + x5y1) << 8);// << 128
        sum_s1_6    <= x0y9 + x2y6 + x4y3 + x6y0;// << 144
        sum_s1_7    <= x1y8 + x3y5 + x5y2;// << 152
        sum_s1_8    <= x0y10 + x2y7 + x4y4 + x6y1 + ((x1y9 + x3y6) << 8);// << 160
        sum_s1_9    <= x5y3 + x7y0 + ((x0y11 + x2y8 + x4y5 + x6y2) << 8);// << 168
        sum_s1_10   <= x1y10 + x3y7 + x5y4 + x7y1;// << 184
        sum_s1_11   <= x0y12 + x2y9 + x4y6 + x6y3 + x8y0;// << 192
        sum_s1_12   <= x1y11 + x3y8 + x5y5 + x7y2;// << 200
        sum_s1_13   <= x0y13 + x2y10 + x4y7 + x6y4 + x8y1;// << 208
        sum_s1_14   <= x1y12 + x3y9 + x5y6 + x7y3 + x9y0;// << 216
        sum_s1_15   <= x2y11 + x0y14 + x4y8 + x6y5 + x8y2;// << 224
        sum_s1_16   <= x1y13 + x3y10 + x5y7 + x7y4 + x9y1;// << 232
        sum_s1_17   <= x0y15 + x2y12 + x4y9 + x6y6 + x8y3 + x10y0;// << 240
        sum_s1_18   <= x1y14 + x3y11 + x5y8 + x7y5 + x9y2;// << 248
    end
end

// pipe 2
reg [511 :0]  sum_s2_0;
reg [511 :0]  sum_s2_1;
reg [511 :0]  sum_s2_2;
reg [511 :0]  sum_s2_3;
reg [511 :0]  sum_s2_4;
reg [511 :0]  sum_s2_5;
reg [511 :0]  sum_s2_6;
reg [511 :0]  sum_s2_7;
reg [511 :0]  sum_s2_8;
reg [511 :0]  sum_s2_9;
reg [511 :0]  sum_s2_10;
reg [511 :0]  sum_s2_11;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        sum_s2_0    <=  0;
        sum_s2_1    <=  0;
        sum_s2_2    <=  0;
        sum_s2_3    <=  0;
        sum_s2_4    <=  0;
        sum_s2_5    <=  0;
        sum_s2_6    <=  0;
        sum_s2_7    <=  0;
        sum_s2_8    <=  0;
        sum_s2_9    <=  0;
        sum_s2_10   <=  0;
        sum_s2_11   <=  0;
    end
    else begin
        sum_s2_0    <=  sum_s1_0 + (sum_s1_1 << 40) + (sum_s1_2 << 72) + (sum_s1_3 << 96);// << 0
        sum_s2_1    <=  sum_s1_4 + (sum_s1_5 << 16) + (sum_s1_6 << 32) + (sum_s1_7 << 40);// << 112
        sum_s2_2    <=  sum_s1_8 + (sum_s1_9 << 8) + (sum_s1_10 << 24) + (sum_s1_11 << 32);// << 160
        sum_s2_3    <=  sum_s1_12 + (sum_s1_13 << 8) + (sum_s1_14 << 16) + (sum_s1_15 << 24);// << 200
        sum_s2_4    <=  sum_s1_16 + (sum_s1_17 << 8) + (sum_s1_18 << 16);// << 232
    end
end

// pipe 3
reg [511 :0]  sum_s3_0;
reg [511 :0]  sum_s3_1;
reg [511 :0]  sum_s3_2;
reg [511 :0]  sum_s3_3;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        sum_s3_0    <=  0;
        sum_s3_1    <=  0;
        sum_s3_2    <=  0;
        sum_s3_3    <=  0;
    end
    else begin
        sum_s3_0    <=  sum_s2_0 + (sum_s2_1 << 112);// << 0
        sum_s3_1    <=  sum_s2_2 + (sum_s2_3 << 40) + (sum_s2_4 << 72);// << 160
    end
end

// pipe 4
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        result      <=  0;
    end
    else begin
        result      <=  sum_s3_0 + (sum_s3_1 << 160);
    end
end


endmodule
/*
    X = x10x9x8x7x6x5x4x3x2x1x0
    Y = y7y6y5y4y3y2yy15y14y13y12y11y10y9y8y7y6y5y4y3y2y1y01y0
    X*Y = (x10x9x8x7x6x5x4x3x2x1x0) * (y15y14y13y12y11y10y9y8y7y6y5y4y3y2y1y0)
        = ((x10 << 240) + (x9 << 216) + (x8 << 192) + (x7 << 168) + (x6 << 144) + (x5 << 120) + (x4 << 96) + (x3 << 72) + (x2 << 48) + (x1 << 24) + x0)
            * ((y15 << 240) + (y14 << 224) + (y13 << 208) + (y12 << 192) + (y11 << 176) + (y10 << 160) + (y9 << 144) + (y8 << 128) + (y7 << 112) + (y6 << 96) + (y5 << 80) + (y4 << 64) + (y3 << 48) + (y2 << 32) + (y1 << 16) + y0)
        =  (
            (x10y15) << 480
        +   (x10y14) << 464
        +   (x10y13) << 448
        +   (x10y12) << 432
        +   (x10y11) << 416
        +   (x10y10) << 400
        +   (x10y9 ) << 384
        +   (x10y8 ) << 368
        +   (x10y7 ) << 352
        +   (x10y6 ) << 336
        +   (x10y5 ) << 320
        +   (x10y4 ) << 304
        +   (x10y3 ) << 288
        +   (x10y2 ) << 272
        +   (x10y1 ) << 256
        +   (x10y0 ) << 240

        +   (x9y15) << 456
        +   (x9y14) << 440
        +   (x9y13) << 424
        +   (x9y12) << 408
        +   (x9y11) << 392
        +   (x9y10) << 376
        +   (x9y9 ) << 360
        +   (x9y8 ) << 344
        +   (x9y7 ) << 328
        +   (x9y6 ) << 312
        +   (x9y5 ) << 296
        +   (x9y4 ) << 280
        +   (x9y3 ) << 264
        +   (x9y2 ) << 248
        +   (x9y1 ) << 232
        +   (x9y0 ) << 216

        +   (x8y15) << 432
        +   (x8y14) << 416
        +   (x8y13) << 400
        +   (x8y12) << 384
        +   (x8y11) << 368
        +   (x8y10) << 352
        +   (x8y9 ) << 336
        +   (x8y8 ) << 320
        +   (x8y7 ) << 304
        +   (x8y6 ) << 288
        +   (x8y5 ) << 272
        +   (x8y4 ) << 256
        +   (x8y3 ) << 240
        +   (x8y2 ) << 224
        +   (x8y1 ) << 208
        +   (x8y0 ) << 192

        +   (x7y15) << 408
        +   (x7y14) << 392
        +   (x7y13) << 376
        +   (x7y12) << 360
        +   (x7y11) << 344
        +   (x7y10) << 328
        +   (x7y9 ) << 312
        +   (x7y8 ) << 296
        +   (x7y7 ) << 280
        +   (x7y6 ) << 264
        +   (x7y5 ) << 248
        +   (x7y4 ) << 232
        +   (x7y3 ) << 216
        +   (x7y2 ) << 200
        +   (x7y1 ) << 184
        +   (x7y0 ) << 168

        +   (x6y15) << 384
        +   (x6y14) << 368
        +   (x6y13) << 352
        +   (x6y12) << 336
        +   (x6y11) << 320
        +   (x6y10) << 304
        +   (x6y9 ) << 288
        +   (x6y8 ) << 272
        +   (x6y7 ) << 256
        +   (x6y6 ) << 240
        +   (x6y5 ) << 224
        +   (x6y4 ) << 208
        +   (x6y3 ) << 192
        +   (x6y2 ) << 176
        +   (x6y1 ) << 160
        +   (x6y0 ) << 144

        +   (x5y15) << 360
        +   (x5y14) << 344
        +   (x5y13) << 328
        +   (x5y12) << 312
        +   (x5y11) << 296
        +   (x5y10) << 280
        +   (x5y9 ) << 264
        +   (x5y8 ) << 248
        +   (x5y7 ) << 232
        +   (x5y6 ) << 216
        +   (x5y5 ) << 200
        +   (x5y4 ) << 184
        +   (x5y3 ) << 168
        +   (x5y2 ) << 152
        +   (x5y1 ) << 136
        +   (x5y0 ) << 120

        +   (x4y15) << 336
        +   (x4y14) << 320
        +   (x4y13) << 304
        +   (x4y12) << 288
        +   (x4y11) << 272
        +   (x4y10) << 256
        +   (x4y9 ) << 240
        +   (x4y8 ) << 224
        +   (x4y7 ) << 208
        +   (x4y6 ) << 192
        +   (x4y5 ) << 176
        +   (x4y4 ) << 160
        +   (x4y3 ) << 144
        +   (x4y2 ) << 128
        +   (x4y1 ) << 112
        +   (x4y0 ) << 96

        +   (x3y15) << 312
        +   (x3y14) << 296
        +   (x3y13) << 280
        +   (x3y12) << 264
        +   (x3y11) << 248
        +   (x3y10) << 232
        +   (x3y9 ) << 216
        +   (x3y8 ) << 200
        +   (x3y7 ) << 184
        +   (x3y6 ) << 168
        +   (x3y5 ) << 152
        +   (x3y4 ) << 136
        +   (x3y3 ) << 120
        +   (x3y2 ) << 104
        +   (x3y1 ) << 88
        +   (x3y0 ) << 72

        +   (x2y15) << 288
        +   (x2y14) << 272
        +   (x2y13) << 256
        +   (x2y12) << 240
        +   (x2y11) << 224
        +   (x2y10) << 208
        +   (x2y9 ) << 192
        +   (x2y8 ) << 176
        +   (x2y7 ) << 160
        +   (x2y6 ) << 144
        +   (x2y5 ) << 128
        +   (x2y4 ) << 112
        +   (x2y3 ) << 96
        +   (x2y2 ) << 80
        +   (x2y1 ) << 64
        +   (x2y0 ) << 48

        +   (x1y15) << 264
        +   (x1y14) << 248
        +   (x1y13) << 232
        +   (x1y12) << 216
        +   (x1y11) << 200
        +   (x1y10) << 184
        +   (x1y9 ) << 168
        +   (x1y8 ) << 152
        +   (x1y7 ) << 136
        +   (x1y6 ) << 120
        +   (x1y5 ) << 104
        +   (x1y4 ) << 88
        +   (x1y3 ) << 72
        +   (x1y2 ) << 56
        +   (x1y1 ) << 40
        +   (x1y0 ) << 24

        +   (x0y15) << 240
        +   (x0y14) << 224
        +   (x0y13) << 208
        +   (x0y12) << 192
        +   (x0y11) << 176
        +   (x0y10) << 160
        +   (x0y9 ) << 144
        +   (x0y8 ) << 128
        +   (x0y7 ) << 112
        +   (x0y6 ) << 96
        +   (x0y5 ) << 80
        +   (x0y4 ) << 64
        +   (x0y3 ) << 48
        +   (x0y2 ) << 32
        +   (x0y1 ) << 16
        +   (x0y0 )
    )
*/
/*
    X = x10x9x8x7x6x5x4x3x2x1x0
    Y = y7y6y5y4y3y2yy15y14y13y12y11y10y9y8y7y6y5y4y3y2y1y01y0
    X*Y = (x10x9x8x7x6x5x4x3x2x1x0) * (y15y14y13y12y11y10y9y8y7y6y5y4y3y2y1y0)
        = ((x10 << 240) + (x9 << 216) + (x8 << 192) + (x7 << 168) + (x6 << 144) + (x5 << 120) + (x4 << 96) + (x3 << 72) + (x2 << 48) + (x1 << 24) + x0)
            * ((y15 << 240) + (y14 << 224) + (y13 << 208) + (y12 << 192) + (y11 << 176) + (y10 << 160) + (y9 << 144) + (y8 << 128) + (y7 << 112) + (y6 << 96) + (y5 << 80) + (y4 << 64) + (y3 << 48) + (y2 << 32) + (y1 << 16) + y0)
        =  (
            (x10y15) << 480
        +   (x10y14) << 464
        +   (x9y15 ) << 456
        +   (x10y13) << 448
        +   (x9y14 ) << 440
        +   (x10y12) << 432
        +   (x8y15 ) << 432
        +   (x9y13 ) << 424
        +   (x8y14 + x10y11) << 416
        +   (x7y15 + x9y12) << 408
        +   (x8y13 + x10y10) << 400
        +   (x7y14 + x9y11) << 392
        +   (x6y15 + x8y12 + x10y9) << 384
        +   (x7y13 + x9y10) << 376
        +   (x6y14 + x8y11 + x10y8) << 368
        +   (x5y15 + x7y12 + x9y9) << 360
        +   (x6y13 + x8y10 + x10y7) << 352
        +   (x5y14 + x7y11 + x9y8) << 344
        +   (x4y15 + x6y12 + x8y9 + x10y6) << 336
        +   (x5y13 + x7y10 + x9y7) << 328
        +   (x4y14 + x6y11 + x8y8 + x10y5) << 320
        +   (x3y15 + x5y12 + x7y9 + x9y6) << 312
        +   (x4y13 + x6y10 + x8y7 + x10y4) << 304
        +   (x3y14 + x5y11 + x7y8 + x9y5) << 296
        +   (x2y15 + x4y12 + x6y9 + x8y6 + x10y3) << 288
        +   (x3y13 + x5y10 + x7y7 + x9y4) << 280
        +   (x2y14 + x4y11 + x6y8 + x8y5 + x10y2) << 272
        +   (x1y15 + x3y12 + x5y9 + x7y6 + x9y3) << 264
        +   (x2y13 + x4y10 + x6y7 + x8y4 + x10y1) << 256
        +   (x1y14 + x3y11 + x5y8 + x7y5 + x9y2) << 248
        +   (x0y15 + x2y12 + x4y9 + x6y6 + x8y3 + x10y0) << 240
        +   (x1y13 + x3y10 + x5y7 + x7y4 + x9y1) << 232
        +   (x2y11 + x0y14 + x4y8 + x6y5 + x8y2) << 224
        +   (x1y12 + x3y9 + x5y6 + x7y3 + x9y0) << 216
        +   (x0y13 + x2y10 + x4y7 + x6y4 + x8y1) << 208
        +   (x1y11 + x3y8 + x5y5 + x7y2) << 200
        +   (x0y12 + x2y9 + x4y6 + x6y3 + x8y0) << 192
        +   (x1y10 + x3y7 + x5y4 + x7y1) << 184
        +   (x0y11 + x2y8 + x4y5 + x6y2) << 176
        +   (x1y9 + x3y6 + x5y3 + x7y0) << 168
        +   (x0y10 + x2y7 + x4y4 + x6y1) << 160
        +   (x1y8 + x3y5 + x5y2) << 152
        +   (x0y9 + x2y6 + x4y3 + x6y0) << 144
        +   (x1y7 + x3y4 + x5y1) << 136
        +   (x0y8 + x2y5 + x4y2) << 128
        +   (x1y6 + x3y3 + x5y0) << 120
        +   (x0y7 + x2y4 + x4y1) << 112
        +   (x1y5 + x3y2) << 104
        +   (x0y6 + x2y3 + x4y0) << 96
        +   (x1y4 + x3y1) << 88
        +   (x2y2 + x0y5) << 80
        +   (x1y3 + x3y0) << 72
        +   (x0y4 + x2y1) << 64
        +   (x1y2) << 56
        +   (x0y3 + x2y0) << 48
        +   (x1y1) << 40
        +   (x0y2) << 32
        +   (x1y0) << 24
        +   (x0y1) << 16
        +   (x0y0)
    )
*/