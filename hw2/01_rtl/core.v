`ifndef HW2_BUILD_STAGE
`define HW2_BUILD_STAGE 4
`endif
`ifndef HW2_PIXEL_LANES
`define HW2_PIXEL_LANES 40
`endif
`ifndef HW2_RASTER_GROUPS
`define HW2_RASTER_GROUPS 1
`endif

module core #(
    parameter BUILD_STAGE=`HW2_BUILD_STAGE,
    parameter PIXEL_LANES=`HW2_PIXEL_LANES,
    parameter RASTER_GROUPS=`HW2_RASTER_GROUPS,
    parameter MAX_VERTICES=65536,
    parameter MAX_TRIANGLES=65536
)(
    input clk,rstn,
    input [7:0] width,height,
    input [15:0] nvertex,ntriangle,
    input [31:0] matrix,
    input valid,
    output reg finish,
    output reg [19:0] addrv,
    output reg wev,
    output reg [31:0] wdatav,
    input [31:0] rdatav,
    output reg [19:0] addri,
    output reg wei,
    output reg [31:0] wdatai,
    input [31:0] rdatai,
    output reg [19:0] addrf,
    output reg wef,
    output reg [31:0] wdataf,
    // Frame is cleared by the environment; the streaming writer is write-only.
    input [31:0] rdataf
);
    localparam [2:0] IDLE=0,RUN=1,WRITE=2,DRAIN=3,DONE=4,FAULT=5;
    localparam [31:0] COVERED=32'h000080ff,UNCOVERED=32'hffffffff;
    reg [2:0] state,next_state;
    reg valid_d;
    wire start=(state==IDLE&&valid)||(state==DONE&&valid&&!valid_d);
    reg [7:0] cfg_width,cfg_height;
    reg [15:0] cfg_nv,cfg_nt;

    reg [31:0] matrix_words[0:31];
    reg [5:0] m_count;
    wire matrix_ready=(m_count==32);
    wire matrix_done_next=matrix_ready||(state==RUN&&valid&&m_count==31);
    wire [511:0] mv_flat,mp_flat;
    genvar m;
    generate for(m=0;m<16;m=m+1) begin: matrices
        assign mv_flat[32*m+:32]=matrix_words[m];
        assign mp_flat[32*m+:32]=matrix_words[m+16];
    end endgenerate

    // Reads begin on the first valid edge. A bounded XYZ queue absorbs the
    // matrix-input window and any valid gaps without pre-valid memory access.
    // Reserve a queue slot on the first word request, including in-flight words.
    localparam [17:0] RAW_QUEUE_DEPTH=18'd16;
    reg [95:0] raw_vertices[0:15];
    reg [31:0] v_xword,v_yword;
    reg [16:0] raw_v_count;
    reg [17:0] v_word_ptr,i_word_ptr;
    reg v_tag0_valid,v_tag1_valid,i_tag0_valid,i_tag1_valid;
    reg [17:0] v_tag0_addr,v_tag1_addr,i_tag0_addr,i_tag1_addr;
    reg [16:0] v_cache_count,i_packet_count;
    wire [17:0] v_total={2'b0,cfg_nv}*18'd3;
    wire [17:0] i_total={2'b0,cfg_nt}*18'd3;
    wire [17:0] raw_reserved=(v_word_ptr+18'd2)/18'd3-{1'b0,v_cache_count};
    wire v_z_response=v_tag1_valid&&(v_tag1_addr%3==2);
    wire v_commit=state==RUN&&matrix_ready&&v_cache_count<raw_v_count;
    wire [15:0] v_commit_id=v_cache_count[15:0];
    wire [95:0] raw_vertex=raw_vertices[v_cache_count[3:0]];
    wire [31:0] transform_x=raw_vertex[31:0],transform_y=raw_vertex[63:32];
    wire [31:0] transform_z=raw_vertex[95:64];
    wire v_issue=state==RUN&&v_word_ptr<v_total&&
                 ((v_word_ptr%3!=0)||raw_reserved<RAW_QUEUE_DEPTH);
    wire i_issue=state==RUN&&i_word_ptr<i_total;
    wire index_range_fault=state==RUN&&i_tag1_valid&&rdatai>={16'b0,cfg_nv};
    wire i_packet_commit=state==RUN&&i_tag1_valid&&(i_tag1_addr%3==2)&&!index_range_fault;
    wire [15:0] i_commit_id=i_tag1_addr/3;
    reg [31:0] i_word0,i_word1;
    // Preserve diagnostic cache names in RTL simulation.
    `ifdef HW2_SIM_DIAGNOSTICS
    reg [31:0] vertex_x[0:MAX_VERTICES-1],vertex_y[0:MAX_VERTICES-1];
    reg [31:0] index_i[0:MAX_TRIANGLES-1],index_j[0:MAX_TRIANGLES-1],index_k[0:MAX_TRIANGLES-1];
    `endif
    wire [31:0] converted_x,converted_y;
    wire vertex_fault,lint_unused_vertex_w_zero;
    wire [7:0] vertex_status;
    wire [16*3*RASTER_GROUPS-1:0] vertex_read_addr;
    wire [64*3*RASTER_GROUPS-1:0] vertex_read_data;
    wire [16*RASTER_GROUPS-1:0] index_read_addr;
    wire [48*RASTER_GROUPS-1:0] index_read_data;
    wire [3*RASTER_GROUPS-1:0] vertex_read_valid;
    wire [RASTER_GROUPS-1:0] index_read_valid;
    wire vertex_write=(BUILD_STAGE>=2)&&!start&&(state==RUN)&&v_commit&&!vertex_fault;
    wire index_write=(BUILD_STAGE>=2)&&!start&&(state==RUN)&&i_packet_commit;
    hw2_banked_cache #(.WIDTH(64),.WORDS(MAX_VERTICES),.READ_PORTS(3*RASTER_GROUPS)) vertex_cache(
        .clk(clk),.rstn(rstn),.write_enable(vertex_write),.write_addr(v_commit_id),
        .write_data({converted_y,converted_x}),.read_valid(vertex_read_valid),
        .read_addr(vertex_read_addr),.read_data(vertex_read_data));
    hw2_banked_cache #(.WIDTH(48),.WORDS(MAX_TRIANGLES),.READ_PORTS(RASTER_GROUPS)) index_cache(
        .clk(clk),.rstn(rstn),.write_enable(index_write),.write_addr(i_commit_id),
        // Every input word retains the original 32-bit range check before commit.
        .write_data({rdatai[15:0],i_word1[15:0],i_word0[15:0]}),.read_valid(index_read_valid),
        .read_addr(index_read_addr),.read_data(index_read_data));
    `ifdef HW2_SIM_DIAGNOSTICS
    wire [MAX_TRIANGLES-1:0] tri_present,tri_issued;
    `endif
    // Diagnostic scoreboards are retained for the simulation testbenches.
    `ifdef HW2_SIM_DIAGNOSTICS
    reg [MAX_VERTICES-1:0] vertex_ready;
    reg [MAX_TRIANGLES-1:0] tri_done;
    `endif
    reg [16:0] dispatched_count,completed_count;
    reg [16:0] frame_issue_count,frame_accept_count;

    generate if(BUILD_STAGE>=3) begin: arithmetic
        wire [31:0] width_fp,height_fp;
        wire [7:0] lint_unused_width_status,lint_unused_height_status;
        DW_fp_i2flt #(23,8,8,0) width_convert(.a(cfg_width),.rnd(3'b000),.z(width_fp),.status(lint_unused_width_status));
        DW_fp_i2flt #(23,8,8,0) height_convert(.a(cfg_height),.rnd(3'b000),.z(height_fp),.status(lint_unused_height_status));
        hw2_vertex_transform vertex(.enable(v_commit),.mv(mv_flat),.mp(mp_flat),
            .x(transform_x),.y(transform_y),.z(transform_z),.width_fp(width_fp),.height_fp(height_fp),
            .screen_x(converted_x),.screen_y(converted_y),.fault(vertex_fault),
            .w_zero(lint_unused_vertex_w_zero),.status(vertex_status));
    end else begin: transfer_only
        assign converted_x=transform_x;
        assign converted_y=transform_y;
        assign vertex_fault=1'b0;
        assign lint_unused_vertex_w_zero=1'b0;
        assign vertex_status=8'b0;
    end endgenerate

    wire [RASTER_GROUPS-1:0] group_fire;
    wire [15:0] group_triangle[0:RASTER_GROUPS-1];
    wire [31:0] group_ax[0:RASTER_GROUPS-1],group_ay[0:RASTER_GROUPS-1];
    wire [31:0] group_bx[0:RASTER_GROUPS-1],group_by[0:RASTER_GROUPS-1];
    wire [31:0] group_cx[0:RASTER_GROUPS-1],group_cy[0:RASTER_GROUPS-1];
    wire [RASTER_GROUPS-1:0] group_available,group_complete,group_fault,group_bitmap0_next;
    wire [15:0] lint_unused_group_complete_id[0:RASTER_GROUPS-1];
    wire [7:0] group_status[0:RASTER_GROUPS-1];
    wire [65535:0] group_bitmap[0:RASTER_GROUPS-1];
    genvar g;
    generate for(g=0;g<RASTER_GROUPS;g=g+1) begin: workers
        if(BUILD_STAGE==4) begin: enabled
            hw2_raster_worker #(.PIXEL_LANES(PIXEL_LANES)) raster(
                .clk(clk),.rstn(rstn),.start(start),.run_enable(state==RUN),
                .fire(group_fire[g]),.width(cfg_width),.height(cfg_height),
                .triangle_id(group_triangle[g]),.ax(group_ax[g]),.ay(group_ay[g]),
                .bx(group_bx[g]),.by(group_by[g]),.cx(group_cx[g]),.cy(group_cy[g]),
                .available(group_available[g]),.complete(group_complete[g]),
                .complete_id(lint_unused_group_complete_id[g]),.fault(group_fault[g]),
                .bitmap_row0(group_bitmap[g][0+:256]),
                .bitmap_row1(group_bitmap[g][256+:256]),
                .bitmap_row2(group_bitmap[g][512+:256]),
                .bitmap_row3(group_bitmap[g][768+:256]),
                .bitmap_row4(group_bitmap[g][1024+:256]),
                .bitmap_row5(group_bitmap[g][1280+:256]),
                .bitmap_row6(group_bitmap[g][1536+:256]),
                .bitmap_row7(group_bitmap[g][1792+:256]),
                .bitmap_row8(group_bitmap[g][2048+:256]),
                .bitmap_row9(group_bitmap[g][2304+:256]),
                .bitmap_row10(group_bitmap[g][2560+:256]),
                .bitmap_row11(group_bitmap[g][2816+:256]),
                .bitmap_row12(group_bitmap[g][3072+:256]),
                .bitmap_row13(group_bitmap[g][3328+:256]),
                .bitmap_row14(group_bitmap[g][3584+:256]),
                .bitmap_row15(group_bitmap[g][3840+:256]),
                .bitmap_row16(group_bitmap[g][4096+:256]),
                .bitmap_row17(group_bitmap[g][4352+:256]),
                .bitmap_row18(group_bitmap[g][4608+:256]),
                .bitmap_row19(group_bitmap[g][4864+:256]),
                .bitmap_row20(group_bitmap[g][5120+:256]),
                .bitmap_row21(group_bitmap[g][5376+:256]),
                .bitmap_row22(group_bitmap[g][5632+:256]),
                .bitmap_row23(group_bitmap[g][5888+:256]),
                .bitmap_row24(group_bitmap[g][6144+:256]),
                .bitmap_row25(group_bitmap[g][6400+:256]),
                .bitmap_row26(group_bitmap[g][6656+:256]),
                .bitmap_row27(group_bitmap[g][6912+:256]),
                .bitmap_row28(group_bitmap[g][7168+:256]),
                .bitmap_row29(group_bitmap[g][7424+:256]),
                .bitmap_row30(group_bitmap[g][7680+:256]),
                .bitmap_row31(group_bitmap[g][7936+:256]),
                .bitmap_row32(group_bitmap[g][8192+:256]),
                .bitmap_row33(group_bitmap[g][8448+:256]),
                .bitmap_row34(group_bitmap[g][8704+:256]),
                .bitmap_row35(group_bitmap[g][8960+:256]),
                .bitmap_row36(group_bitmap[g][9216+:256]),
                .bitmap_row37(group_bitmap[g][9472+:256]),
                .bitmap_row38(group_bitmap[g][9728+:256]),
                .bitmap_row39(group_bitmap[g][9984+:256]),
                .bitmap_row40(group_bitmap[g][10240+:256]),
                .bitmap_row41(group_bitmap[g][10496+:256]),
                .bitmap_row42(group_bitmap[g][10752+:256]),
                .bitmap_row43(group_bitmap[g][11008+:256]),
                .bitmap_row44(group_bitmap[g][11264+:256]),
                .bitmap_row45(group_bitmap[g][11520+:256]),
                .bitmap_row46(group_bitmap[g][11776+:256]),
                .bitmap_row47(group_bitmap[g][12032+:256]),
                .bitmap_row48(group_bitmap[g][12288+:256]),
                .bitmap_row49(group_bitmap[g][12544+:256]),
                .bitmap_row50(group_bitmap[g][12800+:256]),
                .bitmap_row51(group_bitmap[g][13056+:256]),
                .bitmap_row52(group_bitmap[g][13312+:256]),
                .bitmap_row53(group_bitmap[g][13568+:256]),
                .bitmap_row54(group_bitmap[g][13824+:256]),
                .bitmap_row55(group_bitmap[g][14080+:256]),
                .bitmap_row56(group_bitmap[g][14336+:256]),
                .bitmap_row57(group_bitmap[g][14592+:256]),
                .bitmap_row58(group_bitmap[g][14848+:256]),
                .bitmap_row59(group_bitmap[g][15104+:256]),
                .bitmap_row60(group_bitmap[g][15360+:256]),
                .bitmap_row61(group_bitmap[g][15616+:256]),
                .bitmap_row62(group_bitmap[g][15872+:256]),
                .bitmap_row63(group_bitmap[g][16128+:256]),
                .bitmap_row64(group_bitmap[g][16384+:256]),
                .bitmap_row65(group_bitmap[g][16640+:256]),
                .bitmap_row66(group_bitmap[g][16896+:256]),
                .bitmap_row67(group_bitmap[g][17152+:256]),
                .bitmap_row68(group_bitmap[g][17408+:256]),
                .bitmap_row69(group_bitmap[g][17664+:256]),
                .bitmap_row70(group_bitmap[g][17920+:256]),
                .bitmap_row71(group_bitmap[g][18176+:256]),
                .bitmap_row72(group_bitmap[g][18432+:256]),
                .bitmap_row73(group_bitmap[g][18688+:256]),
                .bitmap_row74(group_bitmap[g][18944+:256]),
                .bitmap_row75(group_bitmap[g][19200+:256]),
                .bitmap_row76(group_bitmap[g][19456+:256]),
                .bitmap_row77(group_bitmap[g][19712+:256]),
                .bitmap_row78(group_bitmap[g][19968+:256]),
                .bitmap_row79(group_bitmap[g][20224+:256]),
                .bitmap_row80(group_bitmap[g][20480+:256]),
                .bitmap_row81(group_bitmap[g][20736+:256]),
                .bitmap_row82(group_bitmap[g][20992+:256]),
                .bitmap_row83(group_bitmap[g][21248+:256]),
                .bitmap_row84(group_bitmap[g][21504+:256]),
                .bitmap_row85(group_bitmap[g][21760+:256]),
                .bitmap_row86(group_bitmap[g][22016+:256]),
                .bitmap_row87(group_bitmap[g][22272+:256]),
                .bitmap_row88(group_bitmap[g][22528+:256]),
                .bitmap_row89(group_bitmap[g][22784+:256]),
                .bitmap_row90(group_bitmap[g][23040+:256]),
                .bitmap_row91(group_bitmap[g][23296+:256]),
                .bitmap_row92(group_bitmap[g][23552+:256]),
                .bitmap_row93(group_bitmap[g][23808+:256]),
                .bitmap_row94(group_bitmap[g][24064+:256]),
                .bitmap_row95(group_bitmap[g][24320+:256]),
                .bitmap_row96(group_bitmap[g][24576+:256]),
                .bitmap_row97(group_bitmap[g][24832+:256]),
                .bitmap_row98(group_bitmap[g][25088+:256]),
                .bitmap_row99(group_bitmap[g][25344+:256]),
                .bitmap_row100(group_bitmap[g][25600+:256]),
                .bitmap_row101(group_bitmap[g][25856+:256]),
                .bitmap_row102(group_bitmap[g][26112+:256]),
                .bitmap_row103(group_bitmap[g][26368+:256]),
                .bitmap_row104(group_bitmap[g][26624+:256]),
                .bitmap_row105(group_bitmap[g][26880+:256]),
                .bitmap_row106(group_bitmap[g][27136+:256]),
                .bitmap_row107(group_bitmap[g][27392+:256]),
                .bitmap_row108(group_bitmap[g][27648+:256]),
                .bitmap_row109(group_bitmap[g][27904+:256]),
                .bitmap_row110(group_bitmap[g][28160+:256]),
                .bitmap_row111(group_bitmap[g][28416+:256]),
                .bitmap_row112(group_bitmap[g][28672+:256]),
                .bitmap_row113(group_bitmap[g][28928+:256]),
                .bitmap_row114(group_bitmap[g][29184+:256]),
                .bitmap_row115(group_bitmap[g][29440+:256]),
                .bitmap_row116(group_bitmap[g][29696+:256]),
                .bitmap_row117(group_bitmap[g][29952+:256]),
                .bitmap_row118(group_bitmap[g][30208+:256]),
                .bitmap_row119(group_bitmap[g][30464+:256]),
                .bitmap_row120(group_bitmap[g][30720+:256]),
                .bitmap_row121(group_bitmap[g][30976+:256]),
                .bitmap_row122(group_bitmap[g][31232+:256]),
                .bitmap_row123(group_bitmap[g][31488+:256]),
                .bitmap_row124(group_bitmap[g][31744+:256]),
                .bitmap_row125(group_bitmap[g][32000+:256]),
                .bitmap_row126(group_bitmap[g][32256+:256]),
                .bitmap_row127(group_bitmap[g][32512+:256]),
                .bitmap_row128(group_bitmap[g][32768+:256]),
                .bitmap_row129(group_bitmap[g][33024+:256]),
                .bitmap_row130(group_bitmap[g][33280+:256]),
                .bitmap_row131(group_bitmap[g][33536+:256]),
                .bitmap_row132(group_bitmap[g][33792+:256]),
                .bitmap_row133(group_bitmap[g][34048+:256]),
                .bitmap_row134(group_bitmap[g][34304+:256]),
                .bitmap_row135(group_bitmap[g][34560+:256]),
                .bitmap_row136(group_bitmap[g][34816+:256]),
                .bitmap_row137(group_bitmap[g][35072+:256]),
                .bitmap_row138(group_bitmap[g][35328+:256]),
                .bitmap_row139(group_bitmap[g][35584+:256]),
                .bitmap_row140(group_bitmap[g][35840+:256]),
                .bitmap_row141(group_bitmap[g][36096+:256]),
                .bitmap_row142(group_bitmap[g][36352+:256]),
                .bitmap_row143(group_bitmap[g][36608+:256]),
                .bitmap_row144(group_bitmap[g][36864+:256]),
                .bitmap_row145(group_bitmap[g][37120+:256]),
                .bitmap_row146(group_bitmap[g][37376+:256]),
                .bitmap_row147(group_bitmap[g][37632+:256]),
                .bitmap_row148(group_bitmap[g][37888+:256]),
                .bitmap_row149(group_bitmap[g][38144+:256]),
                .bitmap_row150(group_bitmap[g][38400+:256]),
                .bitmap_row151(group_bitmap[g][38656+:256]),
                .bitmap_row152(group_bitmap[g][38912+:256]),
                .bitmap_row153(group_bitmap[g][39168+:256]),
                .bitmap_row154(group_bitmap[g][39424+:256]),
                .bitmap_row155(group_bitmap[g][39680+:256]),
                .bitmap_row156(group_bitmap[g][39936+:256]),
                .bitmap_row157(group_bitmap[g][40192+:256]),
                .bitmap_row158(group_bitmap[g][40448+:256]),
                .bitmap_row159(group_bitmap[g][40704+:256]),
                .bitmap_row160(group_bitmap[g][40960+:256]),
                .bitmap_row161(group_bitmap[g][41216+:256]),
                .bitmap_row162(group_bitmap[g][41472+:256]),
                .bitmap_row163(group_bitmap[g][41728+:256]),
                .bitmap_row164(group_bitmap[g][41984+:256]),
                .bitmap_row165(group_bitmap[g][42240+:256]),
                .bitmap_row166(group_bitmap[g][42496+:256]),
                .bitmap_row167(group_bitmap[g][42752+:256]),
                .bitmap_row168(group_bitmap[g][43008+:256]),
                .bitmap_row169(group_bitmap[g][43264+:256]),
                .bitmap_row170(group_bitmap[g][43520+:256]),
                .bitmap_row171(group_bitmap[g][43776+:256]),
                .bitmap_row172(group_bitmap[g][44032+:256]),
                .bitmap_row173(group_bitmap[g][44288+:256]),
                .bitmap_row174(group_bitmap[g][44544+:256]),
                .bitmap_row175(group_bitmap[g][44800+:256]),
                .bitmap_row176(group_bitmap[g][45056+:256]),
                .bitmap_row177(group_bitmap[g][45312+:256]),
                .bitmap_row178(group_bitmap[g][45568+:256]),
                .bitmap_row179(group_bitmap[g][45824+:256]),
                .bitmap_row180(group_bitmap[g][46080+:256]),
                .bitmap_row181(group_bitmap[g][46336+:256]),
                .bitmap_row182(group_bitmap[g][46592+:256]),
                .bitmap_row183(group_bitmap[g][46848+:256]),
                .bitmap_row184(group_bitmap[g][47104+:256]),
                .bitmap_row185(group_bitmap[g][47360+:256]),
                .bitmap_row186(group_bitmap[g][47616+:256]),
                .bitmap_row187(group_bitmap[g][47872+:256]),
                .bitmap_row188(group_bitmap[g][48128+:256]),
                .bitmap_row189(group_bitmap[g][48384+:256]),
                .bitmap_row190(group_bitmap[g][48640+:256]),
                .bitmap_row191(group_bitmap[g][48896+:256]),
                .bitmap_row192(group_bitmap[g][49152+:256]),
                .bitmap_row193(group_bitmap[g][49408+:256]),
                .bitmap_row194(group_bitmap[g][49664+:256]),
                .bitmap_row195(group_bitmap[g][49920+:256]),
                .bitmap_row196(group_bitmap[g][50176+:256]),
                .bitmap_row197(group_bitmap[g][50432+:256]),
                .bitmap_row198(group_bitmap[g][50688+:256]),
                .bitmap_row199(group_bitmap[g][50944+:256]),
                .bitmap_row200(group_bitmap[g][51200+:256]),
                .bitmap_row201(group_bitmap[g][51456+:256]),
                .bitmap_row202(group_bitmap[g][51712+:256]),
                .bitmap_row203(group_bitmap[g][51968+:256]),
                .bitmap_row204(group_bitmap[g][52224+:256]),
                .bitmap_row205(group_bitmap[g][52480+:256]),
                .bitmap_row206(group_bitmap[g][52736+:256]),
                .bitmap_row207(group_bitmap[g][52992+:256]),
                .bitmap_row208(group_bitmap[g][53248+:256]),
                .bitmap_row209(group_bitmap[g][53504+:256]),
                .bitmap_row210(group_bitmap[g][53760+:256]),
                .bitmap_row211(group_bitmap[g][54016+:256]),
                .bitmap_row212(group_bitmap[g][54272+:256]),
                .bitmap_row213(group_bitmap[g][54528+:256]),
                .bitmap_row214(group_bitmap[g][54784+:256]),
                .bitmap_row215(group_bitmap[g][55040+:256]),
                .bitmap_row216(group_bitmap[g][55296+:256]),
                .bitmap_row217(group_bitmap[g][55552+:256]),
                .bitmap_row218(group_bitmap[g][55808+:256]),
                .bitmap_row219(group_bitmap[g][56064+:256]),
                .bitmap_row220(group_bitmap[g][56320+:256]),
                .bitmap_row221(group_bitmap[g][56576+:256]),
                .bitmap_row222(group_bitmap[g][56832+:256]),
                .bitmap_row223(group_bitmap[g][57088+:256]),
                .bitmap_row224(group_bitmap[g][57344+:256]),
                .bitmap_row225(group_bitmap[g][57600+:256]),
                .bitmap_row226(group_bitmap[g][57856+:256]),
                .bitmap_row227(group_bitmap[g][58112+:256]),
                .bitmap_row228(group_bitmap[g][58368+:256]),
                .bitmap_row229(group_bitmap[g][58624+:256]),
                .bitmap_row230(group_bitmap[g][58880+:256]),
                .bitmap_row231(group_bitmap[g][59136+:256]),
                .bitmap_row232(group_bitmap[g][59392+:256]),
                .bitmap_row233(group_bitmap[g][59648+:256]),
                .bitmap_row234(group_bitmap[g][59904+:256]),
                .bitmap_row235(group_bitmap[g][60160+:256]),
                .bitmap_row236(group_bitmap[g][60416+:256]),
                .bitmap_row237(group_bitmap[g][60672+:256]),
                .bitmap_row238(group_bitmap[g][60928+:256]),
                .bitmap_row239(group_bitmap[g][61184+:256]),
                .bitmap_row240(group_bitmap[g][61440+:256]),
                .bitmap_row241(group_bitmap[g][61696+:256]),
                .bitmap_row242(group_bitmap[g][61952+:256]),
                .bitmap_row243(group_bitmap[g][62208+:256]),
                .bitmap_row244(group_bitmap[g][62464+:256]),
                .bitmap_row245(group_bitmap[g][62720+:256]),
                .bitmap_row246(group_bitmap[g][62976+:256]),
                .bitmap_row247(group_bitmap[g][63232+:256]),
                .bitmap_row248(group_bitmap[g][63488+:256]),
                .bitmap_row249(group_bitmap[g][63744+:256]),
                .bitmap_row250(group_bitmap[g][64000+:256]),
                .bitmap_row251(group_bitmap[g][64256+:256]),
                .bitmap_row252(group_bitmap[g][64512+:256]),
                .bitmap_row253(group_bitmap[g][64768+:256]),
                .bitmap_row254(group_bitmap[g][65024+:256]),
                .bitmap_row255(group_bitmap[g][65280+:256]),
                .bitmap0_next(group_bitmap0_next[g]),
                .fp_status(group_status[g]));
        end else begin: disabled
            assign group_available[g]=1'b0;
            assign group_complete[g]=1'b0;
            assign lint_unused_group_complete_id[g]=16'b0;
            assign group_fault[g]=1'b0;
            assign group_bitmap[g]=65536'b0;
            assign group_bitmap0_next[g]=1'b0;
            assign group_status[g]=8'b0;
        end
    end endgenerate

    // BUILD_STAGE=4 assumes the environment clears Frame to white before start.
    // Static row reductions preserve each worker's accumulated bitmap and expose
    // new covered pixels while the raster workers continue running.
    wire [65535:0] covered_bitmap;
    wire pending_blue;
    wire [15:0] next_blue_address;
    wire send_blue;
    genvar row,wg;
    generate if(BUILD_STAGE==4) begin: streaming_output
        for(row=0;row<256;row=row+1) begin: rows
            wire [255:0] merged[0:RASTER_GROUPS];
            assign merged[0]=256'b0;
            for(wg=0;wg<RASTER_GROUPS;wg=wg+1) begin: groups
                assign merged[wg+1]=merged[wg]|group_bitmap[wg][256*row+:256];
            end
            assign covered_bitmap[256*row+:256]=merged[RASTER_GROUPS];
        end
        hw2_frame_writer writer(.clk(clk),.rstn(rstn),.start(start),
            .covered_row0(covered_bitmap[0+:256]),
            .covered_row1(covered_bitmap[256+:256]),
            .covered_row2(covered_bitmap[512+:256]),
            .covered_row3(covered_bitmap[768+:256]),
            .covered_row4(covered_bitmap[1024+:256]),
            .covered_row5(covered_bitmap[1280+:256]),
            .covered_row6(covered_bitmap[1536+:256]),
            .covered_row7(covered_bitmap[1792+:256]),
            .covered_row8(covered_bitmap[2048+:256]),
            .covered_row9(covered_bitmap[2304+:256]),
            .covered_row10(covered_bitmap[2560+:256]),
            .covered_row11(covered_bitmap[2816+:256]),
            .covered_row12(covered_bitmap[3072+:256]),
            .covered_row13(covered_bitmap[3328+:256]),
            .covered_row14(covered_bitmap[3584+:256]),
            .covered_row15(covered_bitmap[3840+:256]),
            .covered_row16(covered_bitmap[4096+:256]),
            .covered_row17(covered_bitmap[4352+:256]),
            .covered_row18(covered_bitmap[4608+:256]),
            .covered_row19(covered_bitmap[4864+:256]),
            .covered_row20(covered_bitmap[5120+:256]),
            .covered_row21(covered_bitmap[5376+:256]),
            .covered_row22(covered_bitmap[5632+:256]),
            .covered_row23(covered_bitmap[5888+:256]),
            .covered_row24(covered_bitmap[6144+:256]),
            .covered_row25(covered_bitmap[6400+:256]),
            .covered_row26(covered_bitmap[6656+:256]),
            .covered_row27(covered_bitmap[6912+:256]),
            .covered_row28(covered_bitmap[7168+:256]),
            .covered_row29(covered_bitmap[7424+:256]),
            .covered_row30(covered_bitmap[7680+:256]),
            .covered_row31(covered_bitmap[7936+:256]),
            .covered_row32(covered_bitmap[8192+:256]),
            .covered_row33(covered_bitmap[8448+:256]),
            .covered_row34(covered_bitmap[8704+:256]),
            .covered_row35(covered_bitmap[8960+:256]),
            .covered_row36(covered_bitmap[9216+:256]),
            .covered_row37(covered_bitmap[9472+:256]),
            .covered_row38(covered_bitmap[9728+:256]),
            .covered_row39(covered_bitmap[9984+:256]),
            .covered_row40(covered_bitmap[10240+:256]),
            .covered_row41(covered_bitmap[10496+:256]),
            .covered_row42(covered_bitmap[10752+:256]),
            .covered_row43(covered_bitmap[11008+:256]),
            .covered_row44(covered_bitmap[11264+:256]),
            .covered_row45(covered_bitmap[11520+:256]),
            .covered_row46(covered_bitmap[11776+:256]),
            .covered_row47(covered_bitmap[12032+:256]),
            .covered_row48(covered_bitmap[12288+:256]),
            .covered_row49(covered_bitmap[12544+:256]),
            .covered_row50(covered_bitmap[12800+:256]),
            .covered_row51(covered_bitmap[13056+:256]),
            .covered_row52(covered_bitmap[13312+:256]),
            .covered_row53(covered_bitmap[13568+:256]),
            .covered_row54(covered_bitmap[13824+:256]),
            .covered_row55(covered_bitmap[14080+:256]),
            .covered_row56(covered_bitmap[14336+:256]),
            .covered_row57(covered_bitmap[14592+:256]),
            .covered_row58(covered_bitmap[14848+:256]),
            .covered_row59(covered_bitmap[15104+:256]),
            .covered_row60(covered_bitmap[15360+:256]),
            .covered_row61(covered_bitmap[15616+:256]),
            .covered_row62(covered_bitmap[15872+:256]),
            .covered_row63(covered_bitmap[16128+:256]),
            .covered_row64(covered_bitmap[16384+:256]),
            .covered_row65(covered_bitmap[16640+:256]),
            .covered_row66(covered_bitmap[16896+:256]),
            .covered_row67(covered_bitmap[17152+:256]),
            .covered_row68(covered_bitmap[17408+:256]),
            .covered_row69(covered_bitmap[17664+:256]),
            .covered_row70(covered_bitmap[17920+:256]),
            .covered_row71(covered_bitmap[18176+:256]),
            .covered_row72(covered_bitmap[18432+:256]),
            .covered_row73(covered_bitmap[18688+:256]),
            .covered_row74(covered_bitmap[18944+:256]),
            .covered_row75(covered_bitmap[19200+:256]),
            .covered_row76(covered_bitmap[19456+:256]),
            .covered_row77(covered_bitmap[19712+:256]),
            .covered_row78(covered_bitmap[19968+:256]),
            .covered_row79(covered_bitmap[20224+:256]),
            .covered_row80(covered_bitmap[20480+:256]),
            .covered_row81(covered_bitmap[20736+:256]),
            .covered_row82(covered_bitmap[20992+:256]),
            .covered_row83(covered_bitmap[21248+:256]),
            .covered_row84(covered_bitmap[21504+:256]),
            .covered_row85(covered_bitmap[21760+:256]),
            .covered_row86(covered_bitmap[22016+:256]),
            .covered_row87(covered_bitmap[22272+:256]),
            .covered_row88(covered_bitmap[22528+:256]),
            .covered_row89(covered_bitmap[22784+:256]),
            .covered_row90(covered_bitmap[23040+:256]),
            .covered_row91(covered_bitmap[23296+:256]),
            .covered_row92(covered_bitmap[23552+:256]),
            .covered_row93(covered_bitmap[23808+:256]),
            .covered_row94(covered_bitmap[24064+:256]),
            .covered_row95(covered_bitmap[24320+:256]),
            .covered_row96(covered_bitmap[24576+:256]),
            .covered_row97(covered_bitmap[24832+:256]),
            .covered_row98(covered_bitmap[25088+:256]),
            .covered_row99(covered_bitmap[25344+:256]),
            .covered_row100(covered_bitmap[25600+:256]),
            .covered_row101(covered_bitmap[25856+:256]),
            .covered_row102(covered_bitmap[26112+:256]),
            .covered_row103(covered_bitmap[26368+:256]),
            .covered_row104(covered_bitmap[26624+:256]),
            .covered_row105(covered_bitmap[26880+:256]),
            .covered_row106(covered_bitmap[27136+:256]),
            .covered_row107(covered_bitmap[27392+:256]),
            .covered_row108(covered_bitmap[27648+:256]),
            .covered_row109(covered_bitmap[27904+:256]),
            .covered_row110(covered_bitmap[28160+:256]),
            .covered_row111(covered_bitmap[28416+:256]),
            .covered_row112(covered_bitmap[28672+:256]),
            .covered_row113(covered_bitmap[28928+:256]),
            .covered_row114(covered_bitmap[29184+:256]),
            .covered_row115(covered_bitmap[29440+:256]),
            .covered_row116(covered_bitmap[29696+:256]),
            .covered_row117(covered_bitmap[29952+:256]),
            .covered_row118(covered_bitmap[30208+:256]),
            .covered_row119(covered_bitmap[30464+:256]),
            .covered_row120(covered_bitmap[30720+:256]),
            .covered_row121(covered_bitmap[30976+:256]),
            .covered_row122(covered_bitmap[31232+:256]),
            .covered_row123(covered_bitmap[31488+:256]),
            .covered_row124(covered_bitmap[31744+:256]),
            .covered_row125(covered_bitmap[32000+:256]),
            .covered_row126(covered_bitmap[32256+:256]),
            .covered_row127(covered_bitmap[32512+:256]),
            .covered_row128(covered_bitmap[32768+:256]),
            .covered_row129(covered_bitmap[33024+:256]),
            .covered_row130(covered_bitmap[33280+:256]),
            .covered_row131(covered_bitmap[33536+:256]),
            .covered_row132(covered_bitmap[33792+:256]),
            .covered_row133(covered_bitmap[34048+:256]),
            .covered_row134(covered_bitmap[34304+:256]),
            .covered_row135(covered_bitmap[34560+:256]),
            .covered_row136(covered_bitmap[34816+:256]),
            .covered_row137(covered_bitmap[35072+:256]),
            .covered_row138(covered_bitmap[35328+:256]),
            .covered_row139(covered_bitmap[35584+:256]),
            .covered_row140(covered_bitmap[35840+:256]),
            .covered_row141(covered_bitmap[36096+:256]),
            .covered_row142(covered_bitmap[36352+:256]),
            .covered_row143(covered_bitmap[36608+:256]),
            .covered_row144(covered_bitmap[36864+:256]),
            .covered_row145(covered_bitmap[37120+:256]),
            .covered_row146(covered_bitmap[37376+:256]),
            .covered_row147(covered_bitmap[37632+:256]),
            .covered_row148(covered_bitmap[37888+:256]),
            .covered_row149(covered_bitmap[38144+:256]),
            .covered_row150(covered_bitmap[38400+:256]),
            .covered_row151(covered_bitmap[38656+:256]),
            .covered_row152(covered_bitmap[38912+:256]),
            .covered_row153(covered_bitmap[39168+:256]),
            .covered_row154(covered_bitmap[39424+:256]),
            .covered_row155(covered_bitmap[39680+:256]),
            .covered_row156(covered_bitmap[39936+:256]),
            .covered_row157(covered_bitmap[40192+:256]),
            .covered_row158(covered_bitmap[40448+:256]),
            .covered_row159(covered_bitmap[40704+:256]),
            .covered_row160(covered_bitmap[40960+:256]),
            .covered_row161(covered_bitmap[41216+:256]),
            .covered_row162(covered_bitmap[41472+:256]),
            .covered_row163(covered_bitmap[41728+:256]),
            .covered_row164(covered_bitmap[41984+:256]),
            .covered_row165(covered_bitmap[42240+:256]),
            .covered_row166(covered_bitmap[42496+:256]),
            .covered_row167(covered_bitmap[42752+:256]),
            .covered_row168(covered_bitmap[43008+:256]),
            .covered_row169(covered_bitmap[43264+:256]),
            .covered_row170(covered_bitmap[43520+:256]),
            .covered_row171(covered_bitmap[43776+:256]),
            .covered_row172(covered_bitmap[44032+:256]),
            .covered_row173(covered_bitmap[44288+:256]),
            .covered_row174(covered_bitmap[44544+:256]),
            .covered_row175(covered_bitmap[44800+:256]),
            .covered_row176(covered_bitmap[45056+:256]),
            .covered_row177(covered_bitmap[45312+:256]),
            .covered_row178(covered_bitmap[45568+:256]),
            .covered_row179(covered_bitmap[45824+:256]),
            .covered_row180(covered_bitmap[46080+:256]),
            .covered_row181(covered_bitmap[46336+:256]),
            .covered_row182(covered_bitmap[46592+:256]),
            .covered_row183(covered_bitmap[46848+:256]),
            .covered_row184(covered_bitmap[47104+:256]),
            .covered_row185(covered_bitmap[47360+:256]),
            .covered_row186(covered_bitmap[47616+:256]),
            .covered_row187(covered_bitmap[47872+:256]),
            .covered_row188(covered_bitmap[48128+:256]),
            .covered_row189(covered_bitmap[48384+:256]),
            .covered_row190(covered_bitmap[48640+:256]),
            .covered_row191(covered_bitmap[48896+:256]),
            .covered_row192(covered_bitmap[49152+:256]),
            .covered_row193(covered_bitmap[49408+:256]),
            .covered_row194(covered_bitmap[49664+:256]),
            .covered_row195(covered_bitmap[49920+:256]),
            .covered_row196(covered_bitmap[50176+:256]),
            .covered_row197(covered_bitmap[50432+:256]),
            .covered_row198(covered_bitmap[50688+:256]),
            .covered_row199(covered_bitmap[50944+:256]),
            .covered_row200(covered_bitmap[51200+:256]),
            .covered_row201(covered_bitmap[51456+:256]),
            .covered_row202(covered_bitmap[51712+:256]),
            .covered_row203(covered_bitmap[51968+:256]),
            .covered_row204(covered_bitmap[52224+:256]),
            .covered_row205(covered_bitmap[52480+:256]),
            .covered_row206(covered_bitmap[52736+:256]),
            .covered_row207(covered_bitmap[52992+:256]),
            .covered_row208(covered_bitmap[53248+:256]),
            .covered_row209(covered_bitmap[53504+:256]),
            .covered_row210(covered_bitmap[53760+:256]),
            .covered_row211(covered_bitmap[54016+:256]),
            .covered_row212(covered_bitmap[54272+:256]),
            .covered_row213(covered_bitmap[54528+:256]),
            .covered_row214(covered_bitmap[54784+:256]),
            .covered_row215(covered_bitmap[55040+:256]),
            .covered_row216(covered_bitmap[55296+:256]),
            .covered_row217(covered_bitmap[55552+:256]),
            .covered_row218(covered_bitmap[55808+:256]),
            .covered_row219(covered_bitmap[56064+:256]),
            .covered_row220(covered_bitmap[56320+:256]),
            .covered_row221(covered_bitmap[56576+:256]),
            .covered_row222(covered_bitmap[56832+:256]),
            .covered_row223(covered_bitmap[57088+:256]),
            .covered_row224(covered_bitmap[57344+:256]),
            .covered_row225(covered_bitmap[57600+:256]),
            .covered_row226(covered_bitmap[57856+:256]),
            .covered_row227(covered_bitmap[58112+:256]),
            .covered_row228(covered_bitmap[58368+:256]),
            .covered_row229(covered_bitmap[58624+:256]),
            .covered_row230(covered_bitmap[58880+:256]),
            .covered_row231(covered_bitmap[59136+:256]),
            .covered_row232(covered_bitmap[59392+:256]),
            .covered_row233(covered_bitmap[59648+:256]),
            .covered_row234(covered_bitmap[59904+:256]),
            .covered_row235(covered_bitmap[60160+:256]),
            .covered_row236(covered_bitmap[60416+:256]),
            .covered_row237(covered_bitmap[60672+:256]),
            .covered_row238(covered_bitmap[60928+:256]),
            .covered_row239(covered_bitmap[61184+:256]),
            .covered_row240(covered_bitmap[61440+:256]),
            .covered_row241(covered_bitmap[61696+:256]),
            .covered_row242(covered_bitmap[61952+:256]),
            .covered_row243(covered_bitmap[62208+:256]),
            .covered_row244(covered_bitmap[62464+:256]),
            .covered_row245(covered_bitmap[62720+:256]),
            .covered_row246(covered_bitmap[62976+:256]),
            .covered_row247(covered_bitmap[63232+:256]),
            .covered_row248(covered_bitmap[63488+:256]),
            .covered_row249(covered_bitmap[63744+:256]),
            .covered_row250(covered_bitmap[64000+:256]),
            .covered_row251(covered_bitmap[64256+:256]),
            .covered_row252(covered_bitmap[64512+:256]),
            .covered_row253(covered_bitmap[64768+:256]),
            .covered_row254(covered_bitmap[65024+:256]),
            .covered_row255(covered_bitmap[65280+:256]),
            .take(send_blue),
            .pending(pending_blue),.address(next_blue_address));
    end else begin: legacy_output
        assign covered_bitmap=65536'b0;
        assign pending_blue=1'b0;
        assign next_blue_address=16'b0;
    end endgenerate

    // Vertex and index responses commit as ascending, gap-free prefixes.
    // Each triangle needs max(i,j,k)+1 committed vertices. This is equivalent
    // to the three vertex_ready tests, while avoiding random bitmap read ports.
    wire [15:0] index_max_ij=(i_word0[15:0]>i_word1[15:0])?i_word0[15:0]:i_word1[15:0];
    wire [15:0] index_max=(index_max_ij>rdatai[15:0])?index_max_ij:rdatai[15:0];
    wire [MAX_TRIANGLES-1:0] eligible;
    function automatic [7:0] first_set;
        input [255:0] value;
        reg [255:0] rest;
        reg [7:0] result;
        begin
            rest=value; result=8'd0;
            if(!(|rest[127:0])) begin rest=rest>>128; result=result+8'd128; end
            if(!(|rest[63:0])) begin rest=rest>>64; result=result+8'd64; end
            if(!(|rest[31:0])) begin rest=rest>>32; result=result+8'd32; end
            if(!(|rest[15:0])) begin rest=rest>>16; result=result+8'd16; end
            if(!(|rest[7:0])) begin rest=rest>>8; result=result+8'd8; end
            if(!(|rest[3:0])) begin rest=rest>>4; result=result+8'd4; end
            if(!(|rest[1:0])) begin rest=rest>>2; result=result+8'd2; end
            if(!rest[0]) result=result+8'd1;
            first_set=result;
        end
    endfunction
    localparam READY_BANKS=(MAX_TRIANGLES+255)/256;
    genvar bank;
    wire [16*RASTER_GROUPS-1:0] group_triangle_flat;
    generate for(bank=0;bank<READY_BANKS;bank=bank+1) begin: ready_banks
        localparam WORDS=((MAX_TRIANGLES-256*bank)<256)?(MAX_TRIANGLES-256*bank):256;
        localparam [7:0] BANK=bank;
        hw2_dispatch_bank #(.WORDS(WORDS),.GROUPS(RASTER_GROUPS)) storage(
            .bank_id(BANK),
            .clk(clk),.rstn(rstn),.start(start),.running(state==RUN),.enabled(BUILD_STAGE==4),
            .commit(i_packet_commit),.commit_id(i_commit_id),.index_max(index_max),
            .vertex_count(v_cache_count),.fire(group_fire),.triangle_ids(group_triangle_flat),
            .eligible(eligible[256*bank+:WORDS]));
        `ifdef HW2_SIM_DIAGNOSTICS
        assign tri_present[256*bank+:WORDS]=storage.present;
        assign tri_issued[256*bank+:WORDS]=storage.issued;
        `endif
    end endgenerate
    generate for(genvar gt=0;gt<RASTER_GROUPS;gt=gt+1) begin: triangle_bus
        assign group_triangle_flat[16*gt+:16]=group_triangle[gt];
    end endgenerate

    wire [RASTER_GROUPS-1:0] choice_valid;
    wire [15:0] choice_id[0:RASTER_GROUPS-1];
    localparam GROUP_INDEX_BITS=(RASTER_GROUPS>1)?$clog2(RASTER_GROUPS):1;
    wire [GROUP_INDEX_BITS-1:0] free_rank[0:RASTER_GROUPS-1];
    wire [16:0] grants[0:RASTER_GROUPS],completions[0:RASTER_GROUPS];
    wire [7:0] status_chain[0:RASTER_GROUPS];
    wire [RASTER_GROUPS:0] bitmap_bit_chain,bitmap0_chain;
    assign free_rank[0]={GROUP_INDEX_BITS{1'b0}};
    assign grants[0]=17'd0;
    assign completions[0]=17'd0;
    assign status_chain[0]=8'd0;
    assign bitmap_bit_chain[0]=1'b0;
    assign bitmap0_chain[0]=1'b0;
    genvar dg;
    generate for(dg=0;dg<RASTER_GROUPS;dg=dg+1) begin: dispatch
        wire [255:0] present_rows;
        wire [7:0] first_columns[0:255];
        wire [7:0] first_row=first_set(present_rows);
        for(genvar cr=0;cr<256;cr=cr+1) begin: priority_rows
            if(cr<READY_BANKS) begin: used
                localparam WORDS=((MAX_TRIANGLES-256*cr)<256)?(MAX_TRIANGLES-256*cr):256;
                localparam [7:0] ROW_ID=cr;
                wire [255:0] remaining[0:dg];
                assign remaining[0]={{(256-WORDS){1'b0}},eligible[256*cr+:WORDS]};
                for(genvar prior=0;prior<dg;prior=prior+1) begin: earlier_choices
                    assign remaining[prior+1]=remaining[prior]&
                        ~((choice_id[prior][15:8]==ROW_ID)?(256'd1<<choice_id[prior][7:0]):256'd0);
                end
                hw2_priority_row priority_encoder(.bits(remaining[dg]),
                    .present(present_rows[cr]),.column(first_columns[cr]));
            end else begin: empty
                assign present_rows[cr]=1'b0;
                assign first_columns[cr]=8'd255;
            end
        end
        assign choice_valid[dg]=|present_rows;
        assign choice_id[dg]=choice_valid[dg]?{first_row,first_columns[first_row]}:16'd0;
        if(dg+1<RASTER_GROUPS) begin: next_rank
            assign free_rank[dg+1]=free_rank[dg]+{{(GROUP_INDEX_BITS-1){1'b0}},group_available[dg]};
        end
        wire [15:0] selected_id=choice_id[free_rank[dg]];
        assign index_read_addr[16*dg+:16]=selected_id;
        // Prefix counters reset at each frame; stale/unwritten payload is masked.
        assign index_read_valid[dg]=!start&&(state==RUN)&&
                                    ({1'b0,selected_id}<i_packet_count);
        wire [31:0] cached_i={16'b0,index_read_data[48*dg+:16]};
        wire [31:0] cached_j={16'b0,index_read_data[48*dg+16+:16]};
        wire [31:0] cached_k={16'b0,index_read_data[48*dg+32+:16]};
        wire valid_indices=(cached_i<{16'b0,cfg_nv})&&(cached_j<{16'b0,cfg_nv})&&
                           (cached_k<{16'b0,cfg_nv});
        assign group_fire[dg]=group_available[dg]&&choice_valid[free_rank[dg]]&&valid_indices;
        assign group_triangle[dg]=group_fire[dg]?selected_id:16'd0;
        wire [15:0] vi=cached_i[15:0];
        assign vertex_read_addr[16*(3*dg+0)+:16]=vi;
        assign vertex_read_valid[3*dg+0]=!start&&(state==RUN)&&
                                             ({1'b0,vi}<v_cache_count);
        wire [15:0] vj=cached_j[15:0];
        assign vertex_read_addr[16*(3*dg+1)+:16]=vj;
        assign vertex_read_valid[3*dg+1]=!start&&(state==RUN)&&
                                             ({1'b0,vj}<v_cache_count);
        wire [15:0] vk=cached_k[15:0];
        assign vertex_read_addr[16*(3*dg+2)+:16]=vk;
        assign vertex_read_valid[3*dg+2]=!start&&(state==RUN)&&
                                             ({1'b0,vk}<v_cache_count);
        assign group_ax[dg]=group_fire[dg]?vertex_read_data[192*dg+0+:32]:32'd0;
        assign group_ay[dg]=group_fire[dg]?vertex_read_data[192*dg+32+:32]:32'd0;
        assign group_bx[dg]=group_fire[dg]?vertex_read_data[192*dg+64+:32]:32'd0;
        assign group_by[dg]=group_fire[dg]?vertex_read_data[192*dg+96+:32]:32'd0;
        assign group_cx[dg]=group_fire[dg]?vertex_read_data[192*dg+128+:32]:32'd0;
        assign group_cy[dg]=group_fire[dg]?vertex_read_data[192*dg+160+:32]:32'd0;
        assign grants[dg+1]=grants[dg]+(group_fire[dg]?17'd1:17'd0);
        assign completions[dg+1]=completions[dg]+(group_complete[dg]?17'd1:17'd0);
        assign status_chain[dg+1]=status_chain[dg]|group_status[dg];
        if(BUILD_STAGE==4) begin: streaming_bitmap_bit
            assign bitmap_bit_chain[dg+1]=bitmap_bit_chain[dg];
        end else begin: legacy_bitmap_bit
            assign bitmap_bit_chain[dg+1]=bitmap_bit_chain[dg]|
                group_bitmap[dg][frame_issue_count[15:0]];
        end
        assign bitmap0_chain[dg+1]=bitmap0_chain[dg]|group_bitmap0_next[dg];
    end endgenerate
    wire [16:0] grant_count=grants[RASTER_GROUPS];
    // At most cfg_nt (65535) triangles are dispatched. Keep the arithmetic
    // carry explicit; the stored count and its existing interface stay 17 bits.
    wire [17:0] lint_unused_dispatched_next={1'b0,dispatched_count}+{1'b0,grant_count};
    wire [16:0] complete_count=completions[RASTER_GROUPS];
    wire [7:0] group_status_or=status_chain[RASTER_GROUPS];
    wire final_bitmap_bit=bitmap_bit_chain[RASTER_GROUPS];
    wire final_bitmap0_next=bitmap0_chain[RASTER_GROUPS];

    reg [7:0] fp_status;
    wire fault_event=index_range_fault||(v_commit&&vertex_fault)||(|group_fault);
    assign send_blue=(BUILD_STAGE==4)&&(state==RUN||state==WRITE)&&
                     !start&&!fault_event&&pending_blue;
    wire [16:0] vertex_count_next=v_cache_count+((v_commit&&!vertex_fault)?17'd1:17'd0);
    wire [16:0] index_count_next=i_packet_count+(i_packet_commit?17'd1:17'd0);
    wire [17:0] completed_next={1'b0,completed_count}+{1'b0,complete_count};
    wire v_tags_empty_next=!v_tag0_valid&&(!v_tag1_valid||v_z_response);
    wire i_tags_empty_next=!i_tag0_valid&&(!i_tag1_valid||i_packet_commit);
    wire all_done_next=matrix_done_next&&vertex_count_next=={1'b0,cfg_nv}&&
        index_count_next=={1'b0,cfg_nt}&&v_tags_empty_next&&i_tags_empty_next&&
        (BUILD_STAGE<4||completed_next=={2'b0,cfg_nt})&&!fault_event;
    wire [16:0] frame_accept_next=frame_accept_count+(wef?17'd1:17'd0);

    // First FSM block: state register.
    always @(posedge clk or negedge rstn) begin
        if(!rstn) state<=IDLE;
        else state<=next_state;
    end
    // Second FSM block: complete next-state logic.
    always @* begin
        next_state=state;
        case(state)
            IDLE: if(valid) next_state=RUN;
            RUN: if(fault_event) next_state=FAULT;
                 else if(all_done_next) next_state=WRITE;
            WRITE: if(BUILD_STAGE==4) begin
                       if(!pending_blue) next_state=DRAIN;
                   end else if(frame_issue_count==17'd65535) next_state=DRAIN;
            DRAIN: if(BUILD_STAGE==4) begin
                       if(frame_accept_next==frame_issue_count) next_state=DONE;
                   end else if(frame_accept_next==17'd65536) next_state=DONE;
            DONE: if(valid&&!valid_d) next_state=RUN;
            FAULT: next_state=FAULT;
            default: next_state=IDLE;
        endcase
    end
    // Third FSM block: registered ports, data storage, and scoreboards.
    integer reset_matrix,reset_raw;
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            valid_d<=0;
            addrv<=0; wev<=0; wdatav<=0;
            addri<=0; wei<=0; wdatai<=0;
            cfg_width<=0; cfg_height<=0; cfg_nv<=0; cfg_nt<=0;
            m_count<=0;
            for(reset_matrix=0;reset_matrix<32;reset_matrix=reset_matrix+1)
                matrix_words[reset_matrix]<=32'd0;
            v_word_ptr<=0; i_word_ptr<=0;
            v_tag0_addr<=0; v_tag1_addr<=0; i_tag0_addr<=0; i_tag1_addr<=0;
            v_xword<=0; v_yword<=0; raw_v_count<=0;
            for(reset_raw=0;reset_raw<16;reset_raw=reset_raw+1)
                raw_vertices[reset_raw]<=96'd0;
            i_word0<=0; i_word1<=0;
            v_cache_count<=0; i_packet_count<=0;
            dispatched_count<=0; completed_count<=0;

            fp_status<=0;
        end else begin
            valid_d<=valid;
            wev<=0; wei<=0; wdatav<=0; wdatai<=0;
            v_tag1_addr<=v_tag0_addr;
            i_tag1_addr<=i_tag0_addr;
            if(start) begin
                cfg_width<=width; cfg_height<=height; cfg_nv<=nvertex; cfg_nt<=ntriangle;
                m_count<=1;
                if(BUILD_STAGE>=2) matrix_words[0]<=matrix;
                v_word_ptr<=(nvertex!=0)?18'd1:18'd0;
                i_word_ptr<=(ntriangle!=0)?18'd1:18'd0;
                v_tag0_addr<=0;
                i_tag0_addr<=0;
                addrv<=0; addri<=0;
                raw_v_count<=0;
                v_cache_count<=0; i_packet_count<=0;
                dispatched_count<=0; completed_count<=0;

                fp_status<=0;
            end else if(state==RUN) begin
                if(valid&&m_count<32) begin
                    if(BUILD_STAGE>=2) matrix_words[m_count[4:0]]<=matrix;
                    m_count<=m_count+1'b1;
                end
                if(v_issue) begin
                    addrv<={2'b0,v_word_ptr};
                    v_tag0_addr<=v_word_ptr;
                    v_word_ptr<=v_word_ptr+1'b1;
                end
                if(i_issue) begin
                    addri<={2'b0,i_word_ptr};
                    i_tag0_addr<=i_word_ptr;
                    i_word_ptr<=i_word_ptr+1'b1;
                end
                if(v_tag1_valid) begin
                    case(v_tag1_addr%3)
                        0: v_xword<=rdatav;
                        1: v_yword<=rdatav;
                        2: begin
                            raw_vertices[raw_v_count[3:0]]<={rdatav,v_yword,v_xword};
                            raw_v_count<=raw_v_count+17'd1;
                        end
                    endcase
                end
                if(v_commit&&!vertex_fault) begin
    `ifdef HW2_SIM_DIAGNOSTICS
                    if(BUILD_STAGE>=2) begin
                        vertex_x[v_commit_id]<=converted_x;
                        vertex_y[v_commit_id]<=converted_y;
                    end
    `endif
                    v_cache_count<=vertex_count_next;
                    fp_status<=fp_status|vertex_status|group_status_or;
                end else fp_status<=fp_status|group_status_or;
                if(i_tag1_valid) begin
                    case(i_tag1_addr%3)
                        0: i_word0<=rdatai;
                        1: i_word1<=rdatai;
                        2: if(!index_range_fault) begin
    `ifdef HW2_SIM_DIAGNOSTICS
                            if(BUILD_STAGE>=2) begin
                                index_i[i_commit_id]<=i_word0;
                                index_j[i_commit_id]<=i_word1;
                                index_k[i_commit_id]<=rdatai;
                            end
    `endif
                            i_packet_count<=index_count_next;
                        end
                    endcase
                end
                dispatched_count<=lint_unused_dispatched_next[16:0];
                completed_count<=completed_next[16:0];
            end
        end
    end

    wire legacy_first=(state==RUN)&&all_done_next&&!fault_event&&(BUILD_STAGE<4);
    wire legacy_write=(state==WRITE)&&(BUILD_STAGE<4);
    wire finish_condition=(state==DRAIN)&&((BUILD_STAGE==4)?
        (frame_accept_next==frame_issue_count):(frame_accept_next==17'd65536));
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            v_tag0_valid<=1'b0; v_tag1_valid<=1'b0;
            i_tag0_valid<=1'b0; i_tag1_valid<=1'b0;
            addrf<=20'd0; wef<=1'b0; wdataf<=UNCOVERED;
            frame_issue_count<=17'd0; frame_accept_count<=17'd0;
            finish<=1'b0;
        end else begin
            v_tag0_valid<=start?(nvertex!=0):v_issue;
            i_tag0_valid<=start?(ntriangle!=0):i_issue;
            v_tag1_valid<=!start&&v_tag0_valid;
            i_tag1_valid<=!start&&i_tag0_valid;
            if(start) frame_accept_count<=17'd0;
            else if(wef) frame_accept_count<=frame_accept_next;
            if(start) frame_issue_count<=17'd0;
            else if(send_blue||legacy_write) frame_issue_count<=frame_issue_count+17'd1;
            else if(legacy_first) frame_issue_count<=17'd1;
            if(start) finish<=1'b0;
            else if(finish_condition) finish<=1'b1;
            if(start) wef<=1'b0;
            else wef<=send_blue||legacy_first||legacy_write;
            if(send_blue) begin
                addrf<={4'b0,next_blue_address}; wdataf<=COVERED;
            end else if(legacy_first) begin
                addrf<=20'd0;
                wdataf<=(BUILD_STAGE==2)?UNCOVERED:(final_bitmap0_next?COVERED:UNCOVERED);
            end else if(legacy_write) begin
                addrf<={4'b0,frame_issue_count[15:0]};
                wdataf<=(BUILD_STAGE==2)?(frame_issue_count[0]?COVERED:UNCOVERED):
                    (final_bitmap_bit?COVERED:UNCOVERED);
            end
        end
    end

    // Simulation diagnostics are not part of the functional hardware interface.
    `ifdef HW2_SIM_DIAGNOSTICS
    wire vertex_w_zero=lint_unused_vertex_w_zero;
    wire [15:0] group_complete_id[0:RASTER_GROUPS-1];
    genvar diagnostic_group;
    generate for(diagnostic_group=0;diagnostic_group<RASTER_GROUPS;diagnostic_group=diagnostic_group+1) begin: diagnostic_ids
        assign group_complete_id[diagnostic_group]=lint_unused_group_complete_id[diagnostic_group];
    end endgenerate
    reg fault_valid;
    reg [3:0] fault_code;
    reg [15:0] fault_vertex_id,fault_triangle_id;
    reg [31:0] last_xyz_x,last_xyz_y,last_xyz_z;
    reg [16:0] first_unissued;
    integer debug_group,debug_prefix;
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            fault_valid<=0; fault_code<=0; fault_vertex_id<=0; fault_triangle_id<=0;
            last_xyz_x<=0; last_xyz_y<=0; last_xyz_z<=0; first_unissued<=0;
            vertex_ready<={MAX_VERTICES{1'b0}};
            tri_done<={MAX_TRIANGLES{1'b0}};
        end else if(start) begin
            fault_valid<=0; fault_code<=0; first_unissued<=0;
            vertex_ready<={MAX_VERTICES{1'b0}};
            tri_done<={MAX_TRIANGLES{1'b0}};
        end else if(state==RUN) begin
            if(v_commit&&!vertex_fault) begin
                vertex_ready[v_commit_id]<=1;
                last_xyz_x<=transform_x; last_xyz_y<=transform_y; last_xyz_z<=transform_z;
            end
            for(debug_group=0;debug_group<RASTER_GROUPS;debug_group=debug_group+1)
                if(group_complete[debug_group]) tri_done[lint_unused_group_complete_id[debug_group]]<=1;
            for(debug_prefix=first_unissued;debug_prefix<cfg_nt&&debug_prefix<MAX_TRIANGLES&&tri_issued[debug_prefix];debug_prefix=debug_prefix+1)
                first_unissued<=debug_prefix+1;
            if(fault_event) begin
                fault_valid<=1;
                if(index_range_fault) begin fault_code<=1; fault_triangle_id<=i_tag1_addr/3; end
                else if(v_commit&&vertex_fault) begin fault_code<=lint_unused_vertex_w_zero?2:3; fault_vertex_id<=v_commit_id; end
                else begin
                    fault_code<=4;
                    for(debug_group=0;debug_group<RASTER_GROUPS;debug_group=debug_group+1)
                        if(group_fault[debug_group]) fault_triangle_id<=lint_unused_group_complete_id[debug_group];
                end
            end
        end
    end
    `endif
    `ifdef HW2_SIM_DIAGNOSTICS
    initial begin
        if(BUILD_STAGE<1||BUILD_STAGE>4||MAX_VERTICES<1||MAX_VERTICES>65536||
           MAX_TRIANGLES<1||MAX_TRIANGLES>65536||RASTER_GROUPS<1)
            $fatal(1,"Invalid core configuration");
    end
    always @(posedge clk) if(rstn&&start) begin
        if(nvertex>MAX_VERTICES||ntriangle>MAX_TRIANGLES)
            $fatal(1,"Input counts exceed elaborated cache capacity");
    end
    `endif

    `ifdef HW2_SIM_DIAGNOSTICS
`ifdef HW2_ASSERT_DISPATCH_BOUND
    always @(posedge clk) if(rstn&&state==RUN) begin
        if(i_packet_count>{1'b0,cfg_nt})
            $fatal(1,"DISPATCH_PREFIX count exceeds configured count");
        if(i_packet_commit&&{1'b0,i_commit_id}!=i_packet_count)
            $fatal(1,"DISPATCH_PREFIX commit ID is not the next prefix ID");
    end
`endif
    `endif
endmodule
