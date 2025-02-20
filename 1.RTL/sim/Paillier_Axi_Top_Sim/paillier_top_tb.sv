`timescale 1ns / 1ps
module paillier_top_tb();

parameter K       = 128 ;
parameter N       = 32  ;

reg     clk = 0;
reg     rst_n = 0;

always #2 clk = ~clk;
initial #100 rst_n = 1;

wire    [K-1    :   0]      PAILLIER_N                              [N-1:0] ;
wire    [K-1    :   0]      PAILLIER_N_SQUARE                       [N-1:0] ;
wire    [K-1    :   0]      PAILLIER_M                              [N-1:0] ;
wire    [K-1    :   0]      PAILLIER_C                              [N-1:0] ;
wire    [K-1    :   0]      PAILLIER_R                              [N-1:0] ;

wire    [K-1    :   0]      PAILLIER_ENC_A                          [N-1:0] ;
wire    [K-1    :   0]      PAILLIER_ENC_B                          [N-1:0] ;

wire    [K-1    :   0]      PAILLIER_CONST_SCALAR                   [N-1:0] ;

reg     [K*N-1  :   0]      PAILLIER_ENC_RESULT                             ;
reg     [K*N-1  :   0]      PAILLIER_DEC_RESULT                             ;
wire    [K*N-1  :   0]      PAILLIER_ENC_RESULT_CONFIRM                     ;
wire    [K*N-1  :   0]      PAILLIER_DEC_RESULT_CONFIRM                     ;
wire    [K*N-1  :   0]      PAILLIER_HOMOMORPHIC_ADD_RESULT_CONFIRM         ;
wire    [K*N-1  :   0]      PAILLIER_POSTIVE_SCALAR_MUL_RESULT_CONFIRM      ;

reg     [1      :   0]      task_cmd                                        ;
reg                         task_req                                        ;

reg     [K-1    :   0]      enc_m_data                                      ;
reg                         enc_m_valid                                     ;
reg     [K-1    :   0]      enc_r_data                                      ;
reg                         enc_r_valid                                     ;

reg     [K-1    :   0]      dec_c_data                                      ;
reg                         dec_c_valid                                     ;

reg     [K-1    :   0]      homo_add_c1                                     ;
reg                         homo_add_c1_valid                               ;
reg     [K-1    :   0]      homo_add_c2                                     ;
reg                         homo_add_c2_valid                               ;

reg     [K-1    :   0]      scalar_mul_c1                                   ;
reg                         scalar_mul_c1_valid                             ;
reg     [K-1    :   0]      scalar_mul_const                                ;
reg                         scalar_mul_const_valid                          ;

wire    [K-1    :   0]      enc_out_data                                    ;
wire                        enc_out_valid                                   ;

assign  PAILLIER_N          =       {
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'hc1df05419c6057e26ebad2d3abd7123c,
    128'hdd612c4cf0c09d1881f83b3ea46ad2f1,
    128'h239e21d0a3a778cfbfa9f4f46a0f355c,
    128'h3c57d0305706482133aa5b0aa7d96179,
    128'h8442d0c0a2d7fd48359690c361c66fa0,
    128'hdc7131e9dcf83e11cab3812b22861546,
    128'ha5be250c5ab7d671d5e6129b0ef708e1,
    128'h5d2d0ed5bde948bf5c4339c0d7e45b9,
    128'hc3ac4ef3c50af15fbd37492f126c5a51,
    128'h8af725228255ab1b6ecab2f668149e3f,
    128'hf74e3cd371e7fadf3edb24476ca0632f,
    128'ha53d0af0840ed39b736a5f08339a21e3,
    128'h5a53aa612f73dabd6864bf2dc85b296b,
    128'h4e2a2bddcdabdae21b8c938d1c95d327,
    128'h8213cc126746497a511d8d29aea5ac13,
    128'hd2c5de79b62fb1a1a8e12114c110a8bf
};
assign  PAILLIER_N_SQUARE   =       {
    128'h92d20837163355491353a40bfbed6aff,
    128'hfb000939ca99e2dcb7e96c94d9e6ff1b,
    128'h54db47d62fa87283db4ef47e8119e2cb,
    128'hd126f44ef110cd64d6493014fbee11f,
    128'hce25ad01515ed88bef11f595cc5b107a,
    128'hed44c3aecf42318a0e9dc2431934703c,
    128'h219abc2ee926037fbd46e2b2465b19b3,
    128'h110e3ccdbdfbe0daadefe22a725ef38b,
    128'hc2371fdc5e9cfb439ea6ac84b3e424e7,
    128'h1cc3a263dc8cb4642042d01abe4e5441,
    128'h6d821fae3e588950e16d5bdc76fc0629,
    128'hb4829eabad9ad1535fc322dc0ad791ca,
    128'h8a353157ab771cc0eafb621a07b0ce09,
    128'h98a65541754ffeedb756ff3ca3b606de,
    128'ha2b63fa2483a5dda07c17496f556f441,
    128'he4c09fbb079cbbb8279c01fca24b56bf,
    128'h32e9902603d670439cee8a4f9730281c,
    128'ha7e736783300f69b64cce28fb565b995,
    128'h99758f8c8e5d58ce03af202cfe8d8809,
    128'h2884f15b5a76578db8bf6a32cf7e2d78,
    128'ha758c60de9e6cf037bd2a6c7d22c670b,
    128'h8b384722fef18a9870588c1368f3c1f8,
    128'h2caa709eff78cfdb2a3594bce3977875,
    128'hc0c30e464a5fc136225c7e206ba599b1,
    128'h4ec856a9a230bca081331c969774eb11,
    128'h2295c0670d4cb20723ceaa02e0ff4879,
    128'ha508052dad14c59f1787572686d68c51,
    128'heb3ce8f505e141803ec18bc77c4986a7,
    128'hea1dd24c13c7bb976496361ad38078e2,
    128'hdaaf39f049a489793e2b46643b3eb3f1,
    128'h68a3ad29eb4accb4ca422e7dd70e809f,
    128'h4ad5ed15d295f6765773bb5d851b3e81
};
assign  PAILLIER_M          =       {
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h1000000019091
};
assign  PAILLIER_C          =       {
    128'h2d46fce2a9a239735393f40689a3de6c,
    128'h2a7d72710510a6e96e1c05f70b07c020,
    128'ha6d3722b3bc964e7e380fb7c6a5f5105,
    128'hf4dd8de256af6bf7397ca64b2beb57f4,
    128'hc766ca4e0a9dbcdb7bf02f238e6274a3,
    128'h6477a9f69f7e4696187b755e7280039d,
    128'h906e3f53a3f724a1c6c4d7566cce7bde,
    128'h3e36e2651e9cbcf90aac31bf7342a57c,
    128'h65766defb6c504e928df700aaad37004,
    128'h90a942d8589a87bd8a592b8b50b2ed94,
    128'h7bc2268448f80073d1590746f897fd89,
    128'hf47d4c20c24a11d112ed6408ecc6168c,
    128'h18e5f4dc586d61fc440b3742de816e2b,
    128'h3e7f28e338849fd6b5a56f57751ec4f0,
    128'had24eecf286b5e1ee037bbb0b35f735d,
    128'h18dfa24fab9a2083b50f329fc9b06382,
    128'h80d06001753efaf62521c9cfe8488ad9,
    128'h1dcb932843789273609e88aef2a941df,
    128'h49a5b56c9cec3f40ee7eda1678490db6,
    128'h99ee8087c1fbd877aefde8b54d034f3,
    128'hb044fc897670b453871db2ea47efb8d6,
    128'h2be1592d34ce44351a9e0e0f065ac5cd,
    128'hc4cf44af5542941bf4d96b9bf2b31e37,
    128'hcafdf5373b8c11a7d3907c8fff7e7d2c,
    128'hed30a3ef89305acc7e1beb513b3cdb21,
    128'h2f243109555b6b4be5a548063c0c88a8,
    128'h66786e25e26da72bc94331b6506d17f7,
    128'h7a7266c7303bf1596fd4603cbbaae24e,
    128'h6c150a8e9ffe4bc1c4ea66d3c60ce01c,
    128'h13b0d6d27b5e99a57e7d28c7fdd1db1a,
    128'hf26e7771fd0425a0a4e6cdfd11c2f7db,
    128'hc82c5c674fe9b19f3b7edac8e9fd6f16
};
assign  PAILLIER_R          =       {
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h100000000000007b
};
assign PAILLIER_ENC_A = {
    128'h39979947f84591c7011dc06e677dc75c,
    128'he460fd29a14d022555732743a714c8cf,
    128'h18ff8ebe1a8b01aabd6d421cf63ee8f0,
    128'h870f09badc9224f9fed2af198c5da918,
    128'h47bb617d0e28a369453604f44580667d,
    128'h19c6cbf1365dc89c74126ac7c4ff6f97,
    128'h4fdb853bf92e50975dd7c5e6e3bed5c2,
    128'hc20b11011a8f308c56d193bf14613267,
    128'h16180d26596840499b727663b9271e7a,
    128'hd17020b0202ffeb0f83d610245b396e6,
    128'h3ea93b568be6ad20dcf85bd66411987b,
    128'h9c99a9756a6b21c03e7d16d9807cf9b1,
    128'hf63208f216144c08c5c571343d1d0503,
    128'h2239a444b890d96abed9f0cbacfbbfab,
    128'h6f2f28f1460f6ed4e906b303d12bf4f1,
    128'hec40d1a7d4a572dfa8b09a0fa5730ff8,
    128'h8981780bb3f309afc99fab51bba5b1e5,
    128'hc768809c880bda44efa7cfbb03ac9d31,
    128'h7cd6211d142fd3eb964d872d3a8f833a,
    128'h19a0c0b825bdf7972a22e3133a538a06,
    128'h3430cfef88eb7aa8f028d88a7272678c,
    128'hcb0deff5bd7ae373a62ffa5789c874da,
    128'hc229ecda874772927346cf18c197bae5,
    128'h5c93c16eeacbea4acc52a6abd20e95f0,
    128'haa41adb389c6468400741f2a27fbee12,
    128'he8de39d80f67fa81e252caa8d4690301,
    128'h6e3202345b9abeab552d7f912d346ce1,
    128'h603e209010af32ef06b3286e86daeb8c,
    128'hed3dfc0a45097f952aade6a537c61f26,
    128'ha2e1c47658ce092e9b6c29a02604523b,
    128'h931dd247099e3123c04a84ebad9f2f56,
    128'h9be1df94c3fe93f1c92358cd60233349
};

assign PAILLIER_ENC_B = {
    128'h64f90d8e6ecb2d62deca8aa83e132fce,
    128'h583823bfd16e55b0c7335d8ba6398e7d,
    128'h559a4ac4b35fd8bc985bb3703ab5ea1b,
    128'had795aefc5a057e7dd37900f9283d61c,
    128'h75127caee7d47c8c13d594dd56cbee41,
    128'hd274d10a98c9ed0d7e603467aedd0f3b,
    128'h413d51e15a0a94922605298eda51b8a8,
    128'h79dad4406baf4ef76e73088c8e8b83ae,
    128'hcf7a81a3fa725d8876213b5776feb6b1,
    128'h2eaf531ffb4e6dfcfba83f87692d5b1c,
    128'h850e6b0d8fdf30aece1483c68fc5c53f,
    128'h62aec5f82d885487f1b68a54c5c63b22,
    128'h92bc7adbcf5247baf181812e2f8ce377,
    128'h5c8ae175260352d76b6ebae0ec667de,
    128'h7d40c8e50140535699bac4ec6eaac688,
    128'h8332091d8dd200b67555139fb8705510,
    128'h568b340ebf2f96aff91c5e02fab4dea9,
    128'hc8bfe6161660f462f351553058a6da4a,
    128'hbee15e8e0a8a4b4ab140a3ed4a41b653,
    128'he5ad5398299d01a30bad0b5009e48b2e,
    128'h46a38f6b74dc4f4528c196e13b1671f,
    128'ha15de410802a4fc351b3c622af26277a,
    128'hb90219294836997e6417672b4dd9deb5,
    128'hc2514bc694a127bbb048162697d554e4,
    128'hdac30b29f0d0c8430c72c7a5a27513a2,
    128'h153f2f791af169fd1d864ff736d07268,
    128'h2e895215e8055e598e0cc3a2efd47fbb,
    128'h2ae5ef6530b49d1d5b16e73f5ce869e,
    128'h8ca3da69b12247bb2c0e01087de91485,
    128'h3e2f049ca12371659c29b88331a80cfa,
    128'hd36c3d3a9857c9bcb15e9b0b27bacde4,
    128'h77b1427f2ef134808cf012f11e8ff81
};

assign PAILLIER_CONST_SCALAR = {
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h0,
    128'h555
};

assign PAILLIER_ENC_RESULT_CONFIRM = 
    4096'h39979947f84591c7011dc06e677dc75ce460fd29a14d022555732743a714c8cf18ff8ebe1a8b01aabd6d421cf63ee8f0870f09badc9224f9fed2af198c5da91847bb617d0e28a369453604f44580667d19c6cbf1365dc89c74126ac7c4ff6f974fdb853bf92e50975dd7c5e6e3bed5c2c20b11011a8f308c56d193bf1461326716180d26596840499b727663b9271e7ad17020b0202ffeb0f83d610245b396e63ea93b568be6ad20dcf85bd66411987b9c99a9756a6b21c03e7d16d9807cf9b1f63208f216144c08c5c571343d1d05032239a444b890d96abed9f0cbacfbbfab6f2f28f1460f6ed4e906b303d12bf4f1ec40d1a7d4a572dfa8b09a0fa5730ff88981780bb3f309afc99fab51bba5b1e5c768809c880bda44efa7cfbb03ac9d317cd6211d142fd3eb964d872d3a8f833a19a0c0b825bdf7972a22e3133a538a063430cfef88eb7aa8f028d88a7272678ccb0deff5bd7ae373a62ffa5789c874dac229ecda874772927346cf18c197bae55c93c16eeacbea4acc52a6abd20e95f0aa41adb389c6468400741f2a27fbee12e8de39d80f67fa81e252caa8d46903016e3202345b9abeab552d7f912d346ce1603e209010af32ef06b3286e86daeb8ced3dfc0a45097f952aade6a537c61f26a2e1c47658ce092e9b6c29a02604523b931dd247099e3123c04a84ebad9f2f569be1df94c3fe93f1c92358cd60233349;

assign PAILLIER_HOMOMORPHIC_ADD_RESULT_CONFIRM = 
    4096'h4904062748e78c906669047c13914eb04625950470038694b7fc33475a802b8b7a65a9f4bcf333d40e2420785b2c5c3c3426344ffebf6488915353dfd8049c030db3bb8badd183d9c0cf1d296170a253228835e300219476f3b01ea75c7b906d24e022e395595618b6a21c09faa9f5760b412a73d964d219c9ab6cb1f2da344188efa0af11d5ddf4f3523458512a6727342784e6528995c41875dda793ef9411a23584d91cc53cb48fb2e41860a5b5d8358fa498f99af8ad57ffc06c018f814c2908592ecea97d5231e0065509f0411dc873623a4d861a47c62acbd3b6dc166fb2b03396a06916f27afbf197950268cdb8ee1e5c3344d22ddd29ceef63454abeef57ea6fc334da4d69cc6e43b41610807a86dbb035f4055ebe093dc5b9d2d4c92e6657a2b15c565b5074f5d42559e9c45e388659b1c265c9b715008461d5af8323f46794f60a6865a404d33d5f348a1a579964340b5f416db76e1fc55f437dfb96bec716aac9b934d1ba20522224716a0eb0383422f7c91bb152e0b36abc5e0d74863676eb29ea7a756154eaf9d066f7cdb0f2c28e21347e882fcda64de8c03a1e32dbb9d24400fb0e3cd4f774ad08d1e77c6b49c2c7d46ee67e608297d00dd51ad15ed6f0ec0575858a88c910f7201e7c88961a4282a6c2878bd0fdf6dd2a2d2183b1066904de6d076b3a0734e3be197b91ac435ceee6e8276b839ac551278c;

assign PAILLIER_POSTIVE_SCALAR_MUL_RESULT_CONFIRM = 
    4096'h8ae38ca70b6322b2b552b35e545efa4c9b4e82c402598dd8a8e7c47d2f87da6e43e68d9cf70ba51cd82bb8c71f3d7cf012e6c107c10174658aee26b50af8a44021c9a21b8090d3252d36af98b56622d220a29eb9afd9edb9e8a0cf58d29eaea148094e85c3ddc54561f4758503b32efa4253f7d8c418598f4609515315d1216ee34b8833608707b7afe6bf7e209200857f7baa06dcec92de158db58b738840f42ea573c75c949fccf675a4c5e92512ba84363446ad240406c90c458e141d975f6807027ad4269b4b8cef188a9e150f9d3b8e9681146e96db313eb896814490ad95a95918ac63ef3a95c11b51945d2827fe1db44c19cde01d17f6a3ccf29bef7bb5125c044ac23aef94fc8f636a3e5703728331103e31d119b709b460bd651945a0aa7a62407886ac970751fffa6edfaff3a3c9fc3d50f1bfc942f80ba898f1e23f8409bfbc72f2ea866774236b7528d5de76524a584ef74ea20c072461d260eacc3e73ed548e29f154c9bce54eddb13e70db47601a291a4238c3e3b04901ae6e98cbdfc047197d37a6ce7018493698e81a98e3364ed3e73117687e64984531dc7d048682b9cf46129f1da43d51fb82f1e497639fcbc6d1ff901f796145ace2d44e1dc59cc0f66cc222d333d1fa7213f342db41e599e4998cceb5f64126761a18aee1c876e93062a6feb965cd915739409fdbd55130d07a8658cee1fb0156c3f8;

assign PAILLIER_DEC_RESULT_CONFIRM = 4096'h1000000019091;

initial begin
    // paillier_encrypt_task;
     paillier_decrypt_task;
//     paillier_homomorphic_addition_task;
    // paillier_postive_scalar_multiplication_task;
end

paillier_top #(
        .K                          (K                          )
    ,   .N                          (N                          )
)paillier_top_inst(
        .clk                        (clk                        )
    ,   .rst_n                      (rst_n                      )

    ,   .task_cmd                   (task_cmd                   )
    ,   .task_req                   (task_req                   )

    ,   .enc_m_data                 (enc_m_data                 )
    ,   .enc_m_valid                (enc_m_valid                )
    ,   .enc_r_data                 (enc_r_data                 )
    ,   .enc_r_valid                (enc_r_valid                )

    ,   .dec_c_data                 (dec_c_data                 )
    ,   .dec_c_valid                (dec_c_valid                )

    ,   .homo_add_c1                (homo_add_c1                )
    ,   .homo_add_c1_valid          (homo_add_c1_valid          )
    ,   .homo_add_c2                (homo_add_c2                )
    ,   .homo_add_c2_valid          (homo_add_c2_valid          )

    ,   .scalar_mul_c1              (scalar_mul_c1              )
    ,   .scalar_mul_c1_valid        (scalar_mul_c1_valid        )
    ,   .scalar_mul_const           (scalar_mul_const           )
    ,   .scalar_mul_const_valid     (scalar_mul_const_valid     )

    ,   .enc_out_data               (enc_out_data               )
    ,   .enc_out_valid              (enc_out_valid              )
);

task paillier_encrypt_task;
    task_cmd    <=  2'b00;
    task_req    <=  0;
    enc_m_data  <=  0;
    enc_r_data  <=  0;
    enc_m_valid <=  0;
    enc_r_valid <=  0;

    @(posedge rst_n);
    #40
    @(posedge clk);
    task_req    <=  1;
    task_cmd    <=  2'b00;
    @(posedge clk);
    task_req    <=  0;
    task_cmd    <=  0;
    for(integer i = 0; i < 32; i = i + 1) begin
        @(posedge clk);
        enc_m_data  <=  PAILLIER_M[i];
        enc_r_data  <=  PAILLIER_R[i];
        enc_m_valid <=  1;
        enc_r_valid <=  1;
    end
    @(posedge clk);
    enc_m_valid <=  0;
    enc_r_valid <=  0;
    wait(enc_out_valid);
    PAILLIER_ENC_RESULT      = {PAILLIER_ENC_RESULT[(K*N-K-1):0],enc_out_data};
    for (integer i = 0; i <= N-1; i = i + 1) begin
        @(posedge clk)
        PAILLIER_ENC_RESULT      = {enc_out_data,PAILLIER_ENC_RESULT[(K*N-1):K]};
    end
    $display("paillier encrypt result: \n0x%x",PAILLIER_ENC_RESULT);
    #100;
    assert(PAILLIER_ENC_RESULT ==  PAILLIER_ENC_RESULT_CONFIRM)
        $display("paillier encrypt result is correct!");
    else
        $display("paillier encrypt result is wrong!");
    $stop;
endtask

task paillier_decrypt_task;
    task_cmd    <=  2'b00;
    task_req    <=  0;
    dec_c_data  <=  0;
    dec_c_valid <=  0;

    @(posedge rst_n);
    #40
    @(posedge clk);
    task_req    <=  1;
    task_cmd    <=  2'b01;
    @(posedge clk);
    task_req    <=  0;
    task_cmd    <=  0;
    for(integer i = 0; i < 32; i = i + 1) begin
        @(posedge clk);
        dec_c_data  <=  PAILLIER_C[i];
        dec_c_valid <=  1;
    end
    @(posedge clk);
    dec_c_data  <=  0;
    dec_c_valid <=  0;
    wait(enc_out_valid);
    PAILLIER_DEC_RESULT      = {PAILLIER_DEC_RESULT[(K*N-K-1):0],enc_out_data};
    for (integer i = 0; i <= N-1; i = i + 1) begin
        @(posedge clk)
        PAILLIER_DEC_RESULT      = {enc_out_data,PAILLIER_DEC_RESULT[(K*N-1):K]};
    end
    $display("paillier decrypt result: \n0x%x",PAILLIER_DEC_RESULT);
    #100;
    assert(PAILLIER_DEC_RESULT ==  PAILLIER_DEC_RESULT_CONFIRM)
        $display("paillier decrypt result is correct!");
    else
        $display("paillier decrypt result is wrong!");
    $stop;
endtask

task paillier_homomorphic_addition_task;
    task_cmd            <=  3'b000;
    task_req            <=  0;
    homo_add_c1         <=  0;
    homo_add_c1_valid   <=  0;
    homo_add_c2         <=  0;
    homo_add_c2_valid   <=  0;

    @(posedge rst_n);
    #40
    @(posedge clk);
    task_req    <=  1;
    task_cmd    <=  2'b10;
    @(posedge clk);
    task_req    <=  0;
    task_cmd    <=  0;
    for(integer i = 0; i < 32; i = i + 1) begin
        @(posedge clk);
        homo_add_c1        <=  PAILLIER_ENC_A[i];
        homo_add_c2        <=  PAILLIER_ENC_B[i];
        homo_add_c1_valid  <=  1;
        homo_add_c2_valid  <=  1;
    end
    @(posedge clk);
    homo_add_c1_valid  <=  0;
    homo_add_c2_valid  <=  0;
    wait(enc_out_valid);
    PAILLIER_ENC_RESULT      = {PAILLIER_ENC_RESULT[(K*N-K-1):0],enc_out_data};
    for (integer i = 0; i <= N-1; i = i + 1) begin
        @(posedge clk)
        PAILLIER_ENC_RESULT      = {enc_out_data,PAILLIER_ENC_RESULT[(K*N-1):K]};
    end
    $display("paillier homomorphic addition result: \n0x%x",PAILLIER_ENC_RESULT);
    #100;
    assert(PAILLIER_ENC_RESULT ==  PAILLIER_HOMOMORPHIC_ADD_RESULT_CONFIRM)
        $display("paillier homomorphic addition result is correct!");
    else
        $display("paillier homomorphic addition result is wrong!");
    $stop;
endtask

task paillier_postive_scalar_multiplication_task;
    task_cmd                <=  3'b000;
    task_req                <=  0;
    scalar_mul_c1           <=  0;
    scalar_mul_c1_valid     <=  0;
    scalar_mul_const        <=  0;
    scalar_mul_const_valid  <=  0;

    @(posedge rst_n);
    #40
    @(posedge clk);
    task_req    <=  1;
    task_cmd    <=  2'b11;
    @(posedge clk);
    task_req    <=  0;
    task_cmd    <=  0;
    for(integer i = 0; i < 32; i = i + 1) begin
        @(posedge clk);
            scalar_mul_c1           <=  PAILLIER_ENC_A[i];
            scalar_mul_const        <=  PAILLIER_CONST_SCALAR[i];
            scalar_mul_c1_valid     <=  1;
            scalar_mul_const_valid  <=  1;
    end
    @(posedge clk);
    scalar_mul_c1_valid     <=  0;
    scalar_mul_const_valid  <=  0;
    wait(enc_out_valid);
    PAILLIER_ENC_RESULT      = {PAILLIER_ENC_RESULT[(K*N-K-1):0],enc_out_data};
    for (integer i = 0; i <= N-1; i = i + 1) begin
        @(posedge clk)
        PAILLIER_ENC_RESULT      = {enc_out_data,PAILLIER_ENC_RESULT[(K*N-1):K]};
    end
    $display("paillier postive multiplication result: \n0x%x",PAILLIER_ENC_RESULT);
    #100;
    assert(PAILLIER_ENC_RESULT ==  PAILLIER_POSTIVE_SCALAR_MUL_RESULT_CONFIRM)
        $display("paillier postive multiplication result is correct!");
    else
        $display("paillier postive multiplication result is wrong!");
    $stop;
endtask

endmodule