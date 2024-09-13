module mm_iddmm_top_tb();

localparam K       = 128 ;
localparam N       = 32  ;

reg     clk = 0;
reg     rst_n = 0;

always #2 clk = ~clk;
initial #100 rst_n = 1;

reg [K*N-1:0]   big_x                 [0:2] = {
    4096'hc1df0542cbba9f6aed3aeeb7401bb37903c58d9d5f21d65ad1b98dcdea604d1c93002beae5e3ba36e68c53947334535de07fa62dae8dab29a705764d6361d337bb8f8b2eb7544d4d712448daab680c1a23e1a1ba6f85f82c796d8ac217525ec6351e343ccab4d1081fa4b3cd63a8ad43d70848b8fc6c47672bc104c8e0c70a7ed425406b85000155592afd87614ce8fb8b69e1a113a78b1d62fc60d72fbb16b0577f67c5068d4d3a149920a9574965fecb6c2cc3243acc4673fc5610f2fcb59ffe99b9a19e5cbe58c395a594a0c0b53320271837ed95054f858a97e561b3145391ab16dcbbe5e58da8e7dec86babca61e844a72f26bf3f52d87bd7a4f58113f32a6b621a0430,4096'h7bef7c6eda6e77a55a48181b6dc2c846a1fed629e9e42f04384d8d2e3569994322b68bf4f6be669cf77ab0d94d4df80b90deb3e5e75c91df0b569497302ade9168ee9bc08f9683a55a02beb3e308e87fab724c36903e0fe0ea5b1cc2f42ca152bb8b3f582714c0cc3361270ed6d85cf5643934cec8daa07311533264611b005e7c71a42ddc0f6f81d53f4b0b8ebb76746a9f7ec5271bb609efd0692ec64fc66046ec9205cea2b06254d50f6ba210c2f14186cbe473989c8b78489a9eb96b2b48f633db1a05676b46e077fe0858a2089f3c6592e187ad25e6b03733d077440d3e1c655d763a50b46d19b832f556fc9514edbfef471b241eeb713603d0a27d20bf,4096'hadd717b1ab12562fffd6d77cd1f242427b95babfca8ed8cff9b057f47fef2611801768f823b788ce3e267deabcb29008a69486f13f03c9239573143168d00392e297c2702d17fc5e3df30b38abcfcf91df4e25e49bd7177bf7b7ba2536a9413acf80ca4988f06b429862dff990c9ed97fb6377679722ee2c60a3155c4414f1b40e5554f4d487ead9c317bc772cdc51d110f65bb40181759591d0b7757c53941c1c196a0ee8f546b66196de5b1f62f2bd021a9d3ed45054774dabc20ec5f9d7018e5a49aa8fd71b68287489867e0858cb983eed3e59d3d9e481425decf52f22d22e11af93b342ba2e1f9c05841a6a81d7c42d8bb057b6d8160a104c2acb0044d8e48dc73cd4507d6d1fc8e2fadeef038c9d6d58c976e604771b8150331ce38d1fb805834e7dcdb2bf041493527b1febad46eb4992a2d95eddbef54aa8087ce26809f8c779efd2b5b575aa6ca36f0474e12c785c7ae0ef9d154d41f977ccb1dbd6e71a6f1792a0f807fc9c1ec2ee66cf59d16be496f4708505b869bef8bb54161f2d76c1a5b3a033d13871413fece81a35d22a60422e0d1f0f61a93c178e22dcc1c13c725c1f65bb1162e6fc651cfba3167f1b51f43a7cca91e17b3820ecf06f26aaa7fd6b6d2fb06460b8e6297abd6e0163d76cb489cca1d3d82b618c1e4a3f8d3ca811bad9ac03aacb469d863d4041a0ef296a7a2931bdf4020272f1ed71a52
};

reg [K*N-1:0]   big_y                 [0:2] = {
    4096'h6ba000aae20213f722fc5470729ad8c24582b0a2770f4d03cacace6d643e651b3693808cdb14d627e66041a01d0b880b6ef860f128dc00763a17e8ba2ab82d8ab74abf1f8fefb8084c79fea078d240f9494e015693644635d3666a738e44cd1fb2d2bba34fa9229c630c1214fd0da66429175f7c0b25e19ff5d8c30a95c3ff70bffcbbffe9f71a5184eb10d8db7ea06a0b7a3bed231377d8e2635da172fe2f9ee2976a8661384cd36092502be1117958dd2252d84ecb53d63ab1d04be31f760212af374c8ca98d1a7e7ff29c24b7a9c25b3ed35c3c2be6e625033ae984a61426af0239b50b0ae849384e14120366b6e6233bc679d74362ca5c0ac2278762821bf4e67587acfb1f5386615fa7c2670cc010f322cf6731fd4120f7bf5c1fa33186c9e14c325bd9ef9439c15aa06101167d29fd728f42a66b04eea3db148ada8b23e680706b56d39c1724af0bf491075de4f6c18592054345a7ffe93b14d10e6532512dc88a4b43c51b8dd43dd80a31232e33882a7f3c0ae1364e2cd2bbe99113be5a98ca21cc10e3aaff2f53ff8f1e7125df9f31683fca3fd08474702171f46f7278edc0cc248a2d3d5d3a82515bb2c5d6b16880499bf455a41291e1a88e373fb6bcde50818f640570928e34371de7aa86df6e792c98fe8002807e016f6e27b47e127a6877402aaf23dde9b00b1520551678990e9d17cae6f8b0a8208391db5780,4096'hc8fa4d3f1579f2835d860978c22712b07072c23b499b6f2cdbe724bd831e21ea4f9178eceede09ed4889f17c206d201095549e59aa3df84ad851b880ecc97904399d7cae69b0d762f6276e1e66cbc5b6490ec1e76391f41b36e84d4600dd63d17b9431521e828c5c485ad1f39534ede35b681988102ff6c65c3f8ffe40f73fb18e27c929806a8eafd9232f16de429b849714ab662761d00a5a5d762bc34bfe382f682192794746d0f05d01c6b8d0aa3b497a69a08d510d21e25f30c0490e61ae8d504a8bc1324c016eadbcf82fd07c7429e0dbf233c58e6810a01dd18acb8241d6a644ef3e3d82937f292eb570acb1fa051299ebbfec549aaf7fd05cc118918,4096'h972ddb8e4e7f3ddbfb4604f81c3783c996afe91945422513c0f1a3d4aeed4235d1eb5c38e662762c603c497b7716bc74a94103e4324092e7b195cb9e3fef244db27b83ba756aa43e80ebfcd1de53c99b4f1aa25ca7caec6f3dca7592f57376a3effc0ef27d2cbc507d7697bac66fcbde187ba9010aa2eeb6bbea126f00a4eebd6fd96e90bc980ac3ad20ae08c50280e2addf13a6eec05bb4deff5cca0d7907dbd5599b340e375050cf56607fdc2c0d041de39782222609d757297852a6f836c59f9f38b8b1a96c59288d44d43ba6067316fa8022f0271552fb092cf2381fc760cac62ea034b726ee096b3a6b857b51096eb835f24341eab0c0af2d9d97e75c1c
};

reg [K*N-1:0]   result_confirm          [0:2] = {
    4096'h39979947f84591c7011dc06e677dc75ce460fd29a14d022555732743a714c8cf18ff8ebe1a8b01aabd6d421cf63ee8f0870f09badc9224f9fed2af198c5da91847bb617d0e28a369453604f44580667d19c6cbf1365dc89c74126ac7c4ff6f974fdb853bf92e50975dd7c5e6e3bed5c2c20b11011a8f308c56d193bf1461326716180d26596840499b727663b9271e7ad17020b0202ffeb0f83d610245b396e63ea93b568be6ad20dcf85bd66411987b9c99a9756a6b21c03e7d16d9807cf9b1f63208f216144c08c5c571343d1d05032239a444b890d96abed9f0cbacfbbfab6f2f28f1460f6ed4e906b303d12bf4f1ec40d1a7d4a572dfa8b09a0fa5730ff88981780bb3f309afc99fab51bba5b1e5c768809c880bda44efa7cfbb03ac9d317cd6211d142fd3eb964d872d3a8f833a19a0c0b825bdf7972a22e3133a538a063430cfef88eb7aa8f028d88a7272678ccb0deff5bd7ae373a62ffa5789c874dac229ecda874772927346cf18c197bae55c93c16eeacbea4acc52a6abd20e95f0aa41adb389c6468400741f2a27fbee12e8de39d80f67fa81e252caa8d46903016e3202345b9abeab552d7f912d346ce1603e209010af32ef06b3286e86daeb8ced3dfc0a45097f952aade6a537c61f26a2e1c47658ce092e9b6c29a02604523b931dd247099e3123c04a84ebad9f2f569be1df94c3fe93f1c92358cd60233349,4096'hfc41e2cf2eaaff122c86b7458d7d2b7b6cfdc6447b117f0c1086678a1ab6d608d0ac4c0cad54ef54e379d14d498edf9cc342f59920593bd39016840315eefc5ea53c13306f9b469f83e3496289bb8447d89aa49f839a2d27309a86d7f8ef0181cf06caba268e222b028ff1fb7ca62767f61394ae57b2b8f55538cf46f7768a8cee60444d05d66791e7beaf53abfd36acde336c68811ef23ad5b48e9990ce7de7e67c11a0814f3541769c883fe51f0ae7f16cd82844efd72c0b0c0a7c66eb9121a67b22abd2bcfdc80a77ca9f8379641216439544a56d5a83fadcc26521ecc947435e23fb27ed7de84fe55fb70413f5ea8177668f387c2dc7c1bd42bedcdfe15,4096'he58cc0d30f3f6b6586dfe0603902e02be958c89f7cca008c062ded844f83e10a7fbb6549d0852982c64683d8e6ac46ce3c4e7e93515e1d95e7d725088b5b04b2c7673716a02c531e71a7b0ec05b597039ede0d3570df698f44f4237a838a022c9ee14a8d37d6a49c7065758db335aaf8bb20adcd7341c4939810cf66acd689501ecda79d54326163a752237c9f083652b5b19c26b64a6ab9d955fe981320894eb5a060298619e70aac2bc645fd95f35944cba9c79067ef533dd6c2fdfff49a734d223b31d9d4811618ccac795c6070f46355135dc9040cbae829d613c9a388459bd6ff9acbf768f4d24a9244a1411e91861897357365120b13496053bd1382e
};

reg     [1      :   0]     mm_type      ;
reg                        mm_start     ;
reg     [K-1    :   0]     mm_x         ;
reg                        mm_x_valid   ;
reg     [K-1    :   0]     mm_y         ;
reg                        mm_y_valid   ;
wire    [K-1    :   0]     mm_result    ;
wire                       mm_valid     ;
reg     [K*N-1  :   0]     MM_RESULT    ;



initial begin
    mm_start        <=  0;
    mm_x            <=  0;
    mm_y            <=  0;
    mm_x_valid      <=  0;
    mm_y_valid      <=  0;
    @(posedge rst_n);
    @(posedge clk);
    for(integer i = 0; i < 3; i = i + 1) begin
        single_request(i);
    end
    $stop;
end

mm_iddmm_top#(
        .K              (K              )
    ,   .N              (N              )
)mm_iddmm_top_inst(
        .clk            (clk            )
    ,   .rst_n          (rst_n          )
    ,   .mm_type        (mm_type        )
    ,   .mm_start       (mm_start       )
    ,   .mm_x           (mm_x           )
    ,   .mm_x_valid     (mm_x_valid     )
    ,   .mm_y           (mm_y           )
    ,   .mm_y_valid     (mm_y_valid     )
    ,   .mm_result      (mm_result      )
    ,   .mm_valid       (mm_valid       )
);

task single_request(input num);
    @(posedge clk);
    mm_start    <=  1;
    mm_type     <=  num;
    @(posedge clk);
    mm_start    <=  0;
    for(integer i = 0; i < 32; i = i + 1) begin
        @(posedge clk);
        mm_x        <=  big_x[num][i*K+:K];
        mm_y        <=  big_y[num][i*K+:K];
        mm_x_valid  <=  1;
        mm_y_valid  <=  1;
    end
    @(posedge clk);
    mm_x_valid  <=  0;
    mm_y_valid  <=  0;
    wait(mm_valid);
    MM_RESULT      = {MM_RESULT[(K*N-K-1):0],mm_result};
    for (integer i = 0; i <= N-1; i = i + 1) begin
        @(posedge clk)
        MM_RESULT      = {mm_result,MM_RESULT[(K*N-1):K]};
    end
    $display("MM_RESULT: \n0x%x",MM_RESULT);
    @(posedge clk);
    assert(MM_RESULT ==  result_confirm[num])
        $display("result is correct!");
    else
        $display("result is wrong!");
endtask



endmodule