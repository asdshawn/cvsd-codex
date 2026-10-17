// Q densely packed pixel centers per cycle inside conservative bounds.
// Setup and the first chunk commit on the grant edge, as in the baseline.
module hw2_raster_worker #(parameter PIXEL_LANES=64)(
    input clk,rstn,start,run_enable,fire,
    input [7:0] width,height,
    input [15:0] triangle_id,
    input [31:0] ax,ay,bx,by,cx,cy,
    output available,complete,fault,
    output [15:0] complete_id,
    output [255:0] bitmap_row0,
    output [255:0] bitmap_row1,
    output [255:0] bitmap_row2,
    output [255:0] bitmap_row3,
    output [255:0] bitmap_row4,
    output [255:0] bitmap_row5,
    output [255:0] bitmap_row6,
    output [255:0] bitmap_row7,
    output [255:0] bitmap_row8,
    output [255:0] bitmap_row9,
    output [255:0] bitmap_row10,
    output [255:0] bitmap_row11,
    output [255:0] bitmap_row12,
    output [255:0] bitmap_row13,
    output [255:0] bitmap_row14,
    output [255:0] bitmap_row15,
    output [255:0] bitmap_row16,
    output [255:0] bitmap_row17,
    output [255:0] bitmap_row18,
    output [255:0] bitmap_row19,
    output [255:0] bitmap_row20,
    output [255:0] bitmap_row21,
    output [255:0] bitmap_row22,
    output [255:0] bitmap_row23,
    output [255:0] bitmap_row24,
    output [255:0] bitmap_row25,
    output [255:0] bitmap_row26,
    output [255:0] bitmap_row27,
    output [255:0] bitmap_row28,
    output [255:0] bitmap_row29,
    output [255:0] bitmap_row30,
    output [255:0] bitmap_row31,
    output [255:0] bitmap_row32,
    output [255:0] bitmap_row33,
    output [255:0] bitmap_row34,
    output [255:0] bitmap_row35,
    output [255:0] bitmap_row36,
    output [255:0] bitmap_row37,
    output [255:0] bitmap_row38,
    output [255:0] bitmap_row39,
    output [255:0] bitmap_row40,
    output [255:0] bitmap_row41,
    output [255:0] bitmap_row42,
    output [255:0] bitmap_row43,
    output [255:0] bitmap_row44,
    output [255:0] bitmap_row45,
    output [255:0] bitmap_row46,
    output [255:0] bitmap_row47,
    output [255:0] bitmap_row48,
    output [255:0] bitmap_row49,
    output [255:0] bitmap_row50,
    output [255:0] bitmap_row51,
    output [255:0] bitmap_row52,
    output [255:0] bitmap_row53,
    output [255:0] bitmap_row54,
    output [255:0] bitmap_row55,
    output [255:0] bitmap_row56,
    output [255:0] bitmap_row57,
    output [255:0] bitmap_row58,
    output [255:0] bitmap_row59,
    output [255:0] bitmap_row60,
    output [255:0] bitmap_row61,
    output [255:0] bitmap_row62,
    output [255:0] bitmap_row63,
    output [255:0] bitmap_row64,
    output [255:0] bitmap_row65,
    output [255:0] bitmap_row66,
    output [255:0] bitmap_row67,
    output [255:0] bitmap_row68,
    output [255:0] bitmap_row69,
    output [255:0] bitmap_row70,
    output [255:0] bitmap_row71,
    output [255:0] bitmap_row72,
    output [255:0] bitmap_row73,
    output [255:0] bitmap_row74,
    output [255:0] bitmap_row75,
    output [255:0] bitmap_row76,
    output [255:0] bitmap_row77,
    output [255:0] bitmap_row78,
    output [255:0] bitmap_row79,
    output [255:0] bitmap_row80,
    output [255:0] bitmap_row81,
    output [255:0] bitmap_row82,
    output [255:0] bitmap_row83,
    output [255:0] bitmap_row84,
    output [255:0] bitmap_row85,
    output [255:0] bitmap_row86,
    output [255:0] bitmap_row87,
    output [255:0] bitmap_row88,
    output [255:0] bitmap_row89,
    output [255:0] bitmap_row90,
    output [255:0] bitmap_row91,
    output [255:0] bitmap_row92,
    output [255:0] bitmap_row93,
    output [255:0] bitmap_row94,
    output [255:0] bitmap_row95,
    output [255:0] bitmap_row96,
    output [255:0] bitmap_row97,
    output [255:0] bitmap_row98,
    output [255:0] bitmap_row99,
    output [255:0] bitmap_row100,
    output [255:0] bitmap_row101,
    output [255:0] bitmap_row102,
    output [255:0] bitmap_row103,
    output [255:0] bitmap_row104,
    output [255:0] bitmap_row105,
    output [255:0] bitmap_row106,
    output [255:0] bitmap_row107,
    output [255:0] bitmap_row108,
    output [255:0] bitmap_row109,
    output [255:0] bitmap_row110,
    output [255:0] bitmap_row111,
    output [255:0] bitmap_row112,
    output [255:0] bitmap_row113,
    output [255:0] bitmap_row114,
    output [255:0] bitmap_row115,
    output [255:0] bitmap_row116,
    output [255:0] bitmap_row117,
    output [255:0] bitmap_row118,
    output [255:0] bitmap_row119,
    output [255:0] bitmap_row120,
    output [255:0] bitmap_row121,
    output [255:0] bitmap_row122,
    output [255:0] bitmap_row123,
    output [255:0] bitmap_row124,
    output [255:0] bitmap_row125,
    output [255:0] bitmap_row126,
    output [255:0] bitmap_row127,
    output [255:0] bitmap_row128,
    output [255:0] bitmap_row129,
    output [255:0] bitmap_row130,
    output [255:0] bitmap_row131,
    output [255:0] bitmap_row132,
    output [255:0] bitmap_row133,
    output [255:0] bitmap_row134,
    output [255:0] bitmap_row135,
    output [255:0] bitmap_row136,
    output [255:0] bitmap_row137,
    output [255:0] bitmap_row138,
    output [255:0] bitmap_row139,
    output [255:0] bitmap_row140,
    output [255:0] bitmap_row141,
    output [255:0] bitmap_row142,
    output [255:0] bitmap_row143,
    output [255:0] bitmap_row144,
    output [255:0] bitmap_row145,
    output [255:0] bitmap_row146,
    output [255:0] bitmap_row147,
    output [255:0] bitmap_row148,
    output [255:0] bitmap_row149,
    output [255:0] bitmap_row150,
    output [255:0] bitmap_row151,
    output [255:0] bitmap_row152,
    output [255:0] bitmap_row153,
    output [255:0] bitmap_row154,
    output [255:0] bitmap_row155,
    output [255:0] bitmap_row156,
    output [255:0] bitmap_row157,
    output [255:0] bitmap_row158,
    output [255:0] bitmap_row159,
    output [255:0] bitmap_row160,
    output [255:0] bitmap_row161,
    output [255:0] bitmap_row162,
    output [255:0] bitmap_row163,
    output [255:0] bitmap_row164,
    output [255:0] bitmap_row165,
    output [255:0] bitmap_row166,
    output [255:0] bitmap_row167,
    output [255:0] bitmap_row168,
    output [255:0] bitmap_row169,
    output [255:0] bitmap_row170,
    output [255:0] bitmap_row171,
    output [255:0] bitmap_row172,
    output [255:0] bitmap_row173,
    output [255:0] bitmap_row174,
    output [255:0] bitmap_row175,
    output [255:0] bitmap_row176,
    output [255:0] bitmap_row177,
    output [255:0] bitmap_row178,
    output [255:0] bitmap_row179,
    output [255:0] bitmap_row180,
    output [255:0] bitmap_row181,
    output [255:0] bitmap_row182,
    output [255:0] bitmap_row183,
    output [255:0] bitmap_row184,
    output [255:0] bitmap_row185,
    output [255:0] bitmap_row186,
    output [255:0] bitmap_row187,
    output [255:0] bitmap_row188,
    output [255:0] bitmap_row189,
    output [255:0] bitmap_row190,
    output [255:0] bitmap_row191,
    output [255:0] bitmap_row192,
    output [255:0] bitmap_row193,
    output [255:0] bitmap_row194,
    output [255:0] bitmap_row195,
    output [255:0] bitmap_row196,
    output [255:0] bitmap_row197,
    output [255:0] bitmap_row198,
    output [255:0] bitmap_row199,
    output [255:0] bitmap_row200,
    output [255:0] bitmap_row201,
    output [255:0] bitmap_row202,
    output [255:0] bitmap_row203,
    output [255:0] bitmap_row204,
    output [255:0] bitmap_row205,
    output [255:0] bitmap_row206,
    output [255:0] bitmap_row207,
    output [255:0] bitmap_row208,
    output [255:0] bitmap_row209,
    output [255:0] bitmap_row210,
    output [255:0] bitmap_row211,
    output [255:0] bitmap_row212,
    output [255:0] bitmap_row213,
    output [255:0] bitmap_row214,
    output [255:0] bitmap_row215,
    output [255:0] bitmap_row216,
    output [255:0] bitmap_row217,
    output [255:0] bitmap_row218,
    output [255:0] bitmap_row219,
    output [255:0] bitmap_row220,
    output [255:0] bitmap_row221,
    output [255:0] bitmap_row222,
    output [255:0] bitmap_row223,
    output [255:0] bitmap_row224,
    output [255:0] bitmap_row225,
    output [255:0] bitmap_row226,
    output [255:0] bitmap_row227,
    output [255:0] bitmap_row228,
    output [255:0] bitmap_row229,
    output [255:0] bitmap_row230,
    output [255:0] bitmap_row231,
    output [255:0] bitmap_row232,
    output [255:0] bitmap_row233,
    output [255:0] bitmap_row234,
    output [255:0] bitmap_row235,
    output [255:0] bitmap_row236,
    output [255:0] bitmap_row237,
    output [255:0] bitmap_row238,
    output [255:0] bitmap_row239,
    output [255:0] bitmap_row240,
    output [255:0] bitmap_row241,
    output [255:0] bitmap_row242,
    output [255:0] bitmap_row243,
    output [255:0] bitmap_row244,
    output [255:0] bitmap_row245,
    output [255:0] bitmap_row246,
    output [255:0] bitmap_row247,
    output [255:0] bitmap_row248,
    output [255:0] bitmap_row249,
    output [255:0] bitmap_row250,
    output [255:0] bitmap_row251,
    output [255:0] bitmap_row252,
    output [255:0] bitmap_row253,
    output [255:0] bitmap_row254,
    output [255:0] bitmap_row255,
    output bitmap0_next,
    output [7:0] fp_status
);
    localparam IDLE=1'b0,ACTIVE=1'b1;
    reg state,next_state;
    reg [16:0] pixel_base,saved_total;
    reg [15:0] saved_id;
    reg [31:0] sax,say,sbx,sby,scx,scy;
    reg [31:0] sdxab,sdyab,sdxbc,sdybc,sdxca,sdyca;
    reg spos,sneg,saved_exception;
    reg [8:0] saved_xmin,saved_xend,saved_yend,cursor_x;
    reg [16:0] cursor_y;

    wire [31:0] dxab,dyab,dxbc,dybc,dxca,dyca,area;
    wire zero,positive,negative,setup_fault;
    wire [7:0] setup_status;
    hw2_triangle_setup setup(.ax(fire?ax:32'b0),.ay(fire?ay:32'b0),
        .bx(fire?bx:32'b0),.by(fire?by:32'b0),.cx(fire?cx:32'b0),.cy(fire?cy:32'b0),
        .dxab(dxab),.dyab(dyab),.dxbc(dxbc),.dybc(dybc),.dxca(dxca),.dyca(dyca),
        .area(area),.area_zero(zero),.area_positive(positive),.area_negative(negative),
        .fault(setup_fault),.status(setup_status));
    wire [8:0] box_xmin,box_xend,box_ymin,box_yend;
    wire lint_unused_box_fallback;
    wire [8:0] lint_unused_box_margin;
    `ifdef HW2_SIM_DIAGNOSTICS
    wire box_fallback=lint_unused_box_fallback;
    wire [8:0] box_margin=lint_unused_box_margin;
    `endif
    hw2_bbox bounds(.width(width),.height(height),
        .ax(fire?ax:32'b0),.ay(fire?ay:32'b0),.bx(fire?bx:32'b0),.by(fire?by:32'b0),
        .cx(fire?cx:32'b0),.cy(fire?cy:32'b0),
        .dxab_exp(dxab[30:23]),.dyab_exp(dyab[30:23]),.dxbc_exp(dxbc[30:23]),.dybc_exp(dybc[30:23]),.dxca_exp(dxca[30:23]),.dyca_exp(dyca[30:23]),.area_exp(area[30:23]),
        .xmin(box_xmin),.xend(box_xend),.ymin(box_ymin),.yend(box_yend),
        .fallback(lint_unused_box_fallback),.margin(lint_unused_box_margin));
    // Viewport coordinates are 0..256; lengths fit nine bits and area fits
    // seventeen. Form full-width results before selecting the stored widths.
    wire [9:0] lint_unused_box_dx={1'b0,box_xend}-{1'b0,box_xmin};
    wire [9:0] lint_unused_box_dy={1'b0,box_yend}-{1'b0,box_ymin};
    wire [8:0] box_width=(box_xend>box_xmin)?lint_unused_box_dx[8:0]:9'd0;
    wire [8:0] box_height=(box_yend>box_ymin)?lint_unused_box_dy[8:0]:9'd0;
    wire [17:0] lint_unused_box_product=box_width*box_height;
    wire [16:0] box_total=lint_unused_box_product[16:0];
    wire processing=run_enable&&(fire||(state==ACTIVE));
    wire [16:0] base=fire?17'd0:pixel_base;
    wire [16:0] total=fire?box_total:saved_total;
    wire [8:0] xmin=fire?box_xmin:saved_xmin;
    wire [8:0] xend=fire?box_xend:saved_xend;
    wire [8:0] yend=fire?box_yend:saved_yend;
    wire pos=fire?positive:spos;
    wire neg=fire?negative:sneg;
    // Finite coordinates below 2^16 cannot overflow an edge operation.
    // Re-testing a previously blue pixel is then harmless. Very large inputs
    // retain the baseline covered-pixel fault suppression through one read port.
    wire input_exception=ax[30:23]>=143||ay[30:23]>=143||bx[30:23]>=143||
                         by[30:23]>=143||cx[30:23]>=143||cy[30:23]>=143;
    wire exceptional=fire?input_exception:saved_exception;
    wire [16:0] step_size=exceptional?17'd1:PIXEL_LANES;
    // The cursor advances only before the final chunk, so it remains < total.
    wire [17:0] lint_unused_pixel_next={1'b0,pixel_base}+{1'b0,step_size};
    wire last_chunk=({1'b0,base}+{1'b0,step_size}>={1'b0,total});
    wire [PIXEL_LANES-1:0] hits,lane_faults,zero_hits;
    wire [7:0] lane_status[0:PIXEL_LANES-1];
    wire [8:0] lane_x[0:PIXEL_LANES];
    wire [16:0] lane_y[0:PIXEL_LANES];
    wire [15:0] lane_address[0:PIXEL_LANES-1];
    assign lane_x[0]=fire?box_xmin:cursor_x;
    assign lane_y[0]=fire?{8'b0,box_ymin}:cursor_y;
    wire [255:0] covered_by_row;
    wire covered_exception=covered_by_row[lane_address[0][15:8]];
    wire [7:0] status_chain[0:PIXEL_LANES];
    assign status_chain[0]=(fire?setup_status:8'b0);
    genvar sk;
    generate for(sk=0;sk<PIXEL_LANES;sk=sk+1) begin: status_fold
        assign status_chain[sk+1]=status_chain[sk]|lane_status[sk];
    end endgenerate
    assign fp_status=processing?status_chain[PIXEL_LANES]:8'b0;
    assign available=(state==IDLE);
    assign fault=run_enable&&((fire&&setup_fault)||(|lane_faults));
    assign complete=processing&&!fault&&((fire&&zero)||last_chunk);
    assign complete_id=fire?triangle_id:saved_id;
    assign bitmap0_next=bitmap_row0[0]||(processing&&(|zero_hits)&&!fault);
    genvar l;
    generate for(l=0;l<PIXEL_LANES;l=l+1) begin: lane
        wire wrap=({1'b0,lane_x[l]}+10'd1>={1'b0,xend});
        assign lane_x[l+1]=wrap?xmin:lane_x[l]+9'd1;
        assign lane_y[l+1]=lane_y[l]+(wrap?17'd1:17'd0);
        assign lane_address[l]={lane_y[l][7:0],lane_x[l][7:0]};
        wire lane_inside=({1'b0,base}+l<{1'b0,total})&&
                         lane_x[l]<xend&&lane_y[l]<{8'b0,yend};
        wire enable=processing&&lane_inside&&(pos||neg)&&
                    (!exceptional||((l==0)&&!covered_exception));
        // Compute only products used by this active pixel. The subtraction,
        // multiplication, and edge-comparison rounding boundaries are unchanged.
        hw2_active_pixel_lane pixel_test(.enable(enable),.area_positive(pos),.area_negative(neg),
            .x(lane_x[l][7:0]),.y(lane_y[l][7:0]),
            .ax(fire?ax:sax),.ay(fire?ay:say),.bx(fire?bx:sbx),.by(fire?by:sby),
            .cx(fire?cx:scx),.cy(fire?cy:scy),
            .dxab(fire?dxab:sdxab),.dyab(fire?dyab:sdyab),
            .dxbc(fire?dxbc:sdxbc),.dybc(fire?dybc:sdybc),
            .dxca(fire?dxca:sdxca),.dyca(fire?dyca:sdyca),
            .hit(hits[l]),.fault(lane_faults[l]),.status(lane_status[l]));
        assign zero_hits[l]=hits[l]&&(lane_address[l]==0);
    end endgenerate
    always @(posedge clk or negedge rstn) begin
        if(!rstn) state<=IDLE;
        else if(start) state<=IDLE;
        else state<=next_state;
    end
    always @* begin
        next_state=state;
        if(!run_enable||fault) next_state=IDLE;
        else if(state==IDLE) begin
            if(fire&&!zero&&!last_chunk) next_state=ACTIVE;
        end else if(last_chunk) next_state=IDLE;
    end
    wire [9:0] lint_unused_first_length={1'b0,xend}-{1'b0,lane_x[0]};
    wire [9:0] lint_unused_row_width={1'b0,xend}-{1'b0,xmin};
    wire [8:0] first_length=lint_unused_first_length[8:0];
    wire [8:0] row_width=lint_unused_row_width[8:0];
    wire [255:0] first_mask=(256'd1<<first_length)-256'd1;
    wire [255:0] full_mask=(256'd1<<row_width)-256'd1;
    localparam HIT_WORK_WIDTH=(PIXEL_LANES<256)?256:PIXEL_LANES;
    wire [HIT_WORK_WIDTH-1:0] padded_hits={{(HIT_WORK_WIDTH-PIXEL_LANES){1'b0}},hits};
    wire [255:0] first_hits=padded_hits[255:0];
    wire [255:0] first_update=(first_hits&first_mask)<<lane_x[0];
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage0(
        .row_id(8'd0),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row0),.read_bit(covered_by_row[0]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage1(
        .row_id(8'd1),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row1),.read_bit(covered_by_row[1]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage2(
        .row_id(8'd2),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row2),.read_bit(covered_by_row[2]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage3(
        .row_id(8'd3),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row3),.read_bit(covered_by_row[3]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage4(
        .row_id(8'd4),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row4),.read_bit(covered_by_row[4]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage5(
        .row_id(8'd5),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row5),.read_bit(covered_by_row[5]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage6(
        .row_id(8'd6),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row6),.read_bit(covered_by_row[6]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage7(
        .row_id(8'd7),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row7),.read_bit(covered_by_row[7]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage8(
        .row_id(8'd8),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row8),.read_bit(covered_by_row[8]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage9(
        .row_id(8'd9),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row9),.read_bit(covered_by_row[9]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage10(
        .row_id(8'd10),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row10),.read_bit(covered_by_row[10]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage11(
        .row_id(8'd11),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row11),.read_bit(covered_by_row[11]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage12(
        .row_id(8'd12),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row12),.read_bit(covered_by_row[12]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage13(
        .row_id(8'd13),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row13),.read_bit(covered_by_row[13]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage14(
        .row_id(8'd14),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row14),.read_bit(covered_by_row[14]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage15(
        .row_id(8'd15),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row15),.read_bit(covered_by_row[15]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage16(
        .row_id(8'd16),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row16),.read_bit(covered_by_row[16]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage17(
        .row_id(8'd17),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row17),.read_bit(covered_by_row[17]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage18(
        .row_id(8'd18),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row18),.read_bit(covered_by_row[18]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage19(
        .row_id(8'd19),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row19),.read_bit(covered_by_row[19]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage20(
        .row_id(8'd20),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row20),.read_bit(covered_by_row[20]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage21(
        .row_id(8'd21),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row21),.read_bit(covered_by_row[21]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage22(
        .row_id(8'd22),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row22),.read_bit(covered_by_row[22]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage23(
        .row_id(8'd23),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row23),.read_bit(covered_by_row[23]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage24(
        .row_id(8'd24),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row24),.read_bit(covered_by_row[24]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage25(
        .row_id(8'd25),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row25),.read_bit(covered_by_row[25]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage26(
        .row_id(8'd26),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row26),.read_bit(covered_by_row[26]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage27(
        .row_id(8'd27),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row27),.read_bit(covered_by_row[27]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage28(
        .row_id(8'd28),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row28),.read_bit(covered_by_row[28]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage29(
        .row_id(8'd29),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row29),.read_bit(covered_by_row[29]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage30(
        .row_id(8'd30),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row30),.read_bit(covered_by_row[30]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage31(
        .row_id(8'd31),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row31),.read_bit(covered_by_row[31]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage32(
        .row_id(8'd32),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row32),.read_bit(covered_by_row[32]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage33(
        .row_id(8'd33),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row33),.read_bit(covered_by_row[33]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage34(
        .row_id(8'd34),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row34),.read_bit(covered_by_row[34]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage35(
        .row_id(8'd35),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row35),.read_bit(covered_by_row[35]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage36(
        .row_id(8'd36),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row36),.read_bit(covered_by_row[36]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage37(
        .row_id(8'd37),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row37),.read_bit(covered_by_row[37]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage38(
        .row_id(8'd38),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row38),.read_bit(covered_by_row[38]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage39(
        .row_id(8'd39),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row39),.read_bit(covered_by_row[39]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage40(
        .row_id(8'd40),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row40),.read_bit(covered_by_row[40]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage41(
        .row_id(8'd41),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row41),.read_bit(covered_by_row[41]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage42(
        .row_id(8'd42),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row42),.read_bit(covered_by_row[42]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage43(
        .row_id(8'd43),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row43),.read_bit(covered_by_row[43]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage44(
        .row_id(8'd44),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row44),.read_bit(covered_by_row[44]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage45(
        .row_id(8'd45),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row45),.read_bit(covered_by_row[45]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage46(
        .row_id(8'd46),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row46),.read_bit(covered_by_row[46]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage47(
        .row_id(8'd47),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row47),.read_bit(covered_by_row[47]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage48(
        .row_id(8'd48),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row48),.read_bit(covered_by_row[48]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage49(
        .row_id(8'd49),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row49),.read_bit(covered_by_row[49]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage50(
        .row_id(8'd50),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row50),.read_bit(covered_by_row[50]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage51(
        .row_id(8'd51),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row51),.read_bit(covered_by_row[51]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage52(
        .row_id(8'd52),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row52),.read_bit(covered_by_row[52]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage53(
        .row_id(8'd53),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row53),.read_bit(covered_by_row[53]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage54(
        .row_id(8'd54),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row54),.read_bit(covered_by_row[54]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage55(
        .row_id(8'd55),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row55),.read_bit(covered_by_row[55]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage56(
        .row_id(8'd56),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row56),.read_bit(covered_by_row[56]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage57(
        .row_id(8'd57),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row57),.read_bit(covered_by_row[57]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage58(
        .row_id(8'd58),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row58),.read_bit(covered_by_row[58]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage59(
        .row_id(8'd59),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row59),.read_bit(covered_by_row[59]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage60(
        .row_id(8'd60),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row60),.read_bit(covered_by_row[60]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage61(
        .row_id(8'd61),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row61),.read_bit(covered_by_row[61]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage62(
        .row_id(8'd62),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row62),.read_bit(covered_by_row[62]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage63(
        .row_id(8'd63),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row63),.read_bit(covered_by_row[63]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage64(
        .row_id(8'd64),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row64),.read_bit(covered_by_row[64]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage65(
        .row_id(8'd65),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row65),.read_bit(covered_by_row[65]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage66(
        .row_id(8'd66),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row66),.read_bit(covered_by_row[66]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage67(
        .row_id(8'd67),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row67),.read_bit(covered_by_row[67]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage68(
        .row_id(8'd68),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row68),.read_bit(covered_by_row[68]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage69(
        .row_id(8'd69),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row69),.read_bit(covered_by_row[69]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage70(
        .row_id(8'd70),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row70),.read_bit(covered_by_row[70]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage71(
        .row_id(8'd71),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row71),.read_bit(covered_by_row[71]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage72(
        .row_id(8'd72),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row72),.read_bit(covered_by_row[72]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage73(
        .row_id(8'd73),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row73),.read_bit(covered_by_row[73]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage74(
        .row_id(8'd74),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row74),.read_bit(covered_by_row[74]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage75(
        .row_id(8'd75),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row75),.read_bit(covered_by_row[75]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage76(
        .row_id(8'd76),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row76),.read_bit(covered_by_row[76]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage77(
        .row_id(8'd77),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row77),.read_bit(covered_by_row[77]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage78(
        .row_id(8'd78),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row78),.read_bit(covered_by_row[78]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage79(
        .row_id(8'd79),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row79),.read_bit(covered_by_row[79]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage80(
        .row_id(8'd80),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row80),.read_bit(covered_by_row[80]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage81(
        .row_id(8'd81),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row81),.read_bit(covered_by_row[81]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage82(
        .row_id(8'd82),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row82),.read_bit(covered_by_row[82]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage83(
        .row_id(8'd83),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row83),.read_bit(covered_by_row[83]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage84(
        .row_id(8'd84),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row84),.read_bit(covered_by_row[84]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage85(
        .row_id(8'd85),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row85),.read_bit(covered_by_row[85]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage86(
        .row_id(8'd86),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row86),.read_bit(covered_by_row[86]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage87(
        .row_id(8'd87),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row87),.read_bit(covered_by_row[87]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage88(
        .row_id(8'd88),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row88),.read_bit(covered_by_row[88]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage89(
        .row_id(8'd89),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row89),.read_bit(covered_by_row[89]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage90(
        .row_id(8'd90),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row90),.read_bit(covered_by_row[90]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage91(
        .row_id(8'd91),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row91),.read_bit(covered_by_row[91]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage92(
        .row_id(8'd92),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row92),.read_bit(covered_by_row[92]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage93(
        .row_id(8'd93),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row93),.read_bit(covered_by_row[93]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage94(
        .row_id(8'd94),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row94),.read_bit(covered_by_row[94]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage95(
        .row_id(8'd95),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row95),.read_bit(covered_by_row[95]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage96(
        .row_id(8'd96),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row96),.read_bit(covered_by_row[96]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage97(
        .row_id(8'd97),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row97),.read_bit(covered_by_row[97]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage98(
        .row_id(8'd98),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row98),.read_bit(covered_by_row[98]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage99(
        .row_id(8'd99),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row99),.read_bit(covered_by_row[99]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage100(
        .row_id(8'd100),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row100),.read_bit(covered_by_row[100]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage101(
        .row_id(8'd101),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row101),.read_bit(covered_by_row[101]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage102(
        .row_id(8'd102),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row102),.read_bit(covered_by_row[102]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage103(
        .row_id(8'd103),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row103),.read_bit(covered_by_row[103]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage104(
        .row_id(8'd104),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row104),.read_bit(covered_by_row[104]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage105(
        .row_id(8'd105),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row105),.read_bit(covered_by_row[105]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage106(
        .row_id(8'd106),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row106),.read_bit(covered_by_row[106]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage107(
        .row_id(8'd107),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row107),.read_bit(covered_by_row[107]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage108(
        .row_id(8'd108),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row108),.read_bit(covered_by_row[108]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage109(
        .row_id(8'd109),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row109),.read_bit(covered_by_row[109]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage110(
        .row_id(8'd110),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row110),.read_bit(covered_by_row[110]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage111(
        .row_id(8'd111),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row111),.read_bit(covered_by_row[111]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage112(
        .row_id(8'd112),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row112),.read_bit(covered_by_row[112]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage113(
        .row_id(8'd113),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row113),.read_bit(covered_by_row[113]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage114(
        .row_id(8'd114),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row114),.read_bit(covered_by_row[114]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage115(
        .row_id(8'd115),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row115),.read_bit(covered_by_row[115]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage116(
        .row_id(8'd116),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row116),.read_bit(covered_by_row[116]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage117(
        .row_id(8'd117),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row117),.read_bit(covered_by_row[117]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage118(
        .row_id(8'd118),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row118),.read_bit(covered_by_row[118]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage119(
        .row_id(8'd119),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row119),.read_bit(covered_by_row[119]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage120(
        .row_id(8'd120),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row120),.read_bit(covered_by_row[120]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage121(
        .row_id(8'd121),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row121),.read_bit(covered_by_row[121]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage122(
        .row_id(8'd122),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row122),.read_bit(covered_by_row[122]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage123(
        .row_id(8'd123),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row123),.read_bit(covered_by_row[123]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage124(
        .row_id(8'd124),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row124),.read_bit(covered_by_row[124]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage125(
        .row_id(8'd125),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row125),.read_bit(covered_by_row[125]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage126(
        .row_id(8'd126),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row126),.read_bit(covered_by_row[126]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage127(
        .row_id(8'd127),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row127),.read_bit(covered_by_row[127]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage128(
        .row_id(8'd128),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row128),.read_bit(covered_by_row[128]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage129(
        .row_id(8'd129),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row129),.read_bit(covered_by_row[129]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage130(
        .row_id(8'd130),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row130),.read_bit(covered_by_row[130]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage131(
        .row_id(8'd131),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row131),.read_bit(covered_by_row[131]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage132(
        .row_id(8'd132),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row132),.read_bit(covered_by_row[132]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage133(
        .row_id(8'd133),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row133),.read_bit(covered_by_row[133]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage134(
        .row_id(8'd134),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row134),.read_bit(covered_by_row[134]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage135(
        .row_id(8'd135),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row135),.read_bit(covered_by_row[135]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage136(
        .row_id(8'd136),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row136),.read_bit(covered_by_row[136]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage137(
        .row_id(8'd137),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row137),.read_bit(covered_by_row[137]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage138(
        .row_id(8'd138),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row138),.read_bit(covered_by_row[138]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage139(
        .row_id(8'd139),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row139),.read_bit(covered_by_row[139]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage140(
        .row_id(8'd140),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row140),.read_bit(covered_by_row[140]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage141(
        .row_id(8'd141),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row141),.read_bit(covered_by_row[141]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage142(
        .row_id(8'd142),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row142),.read_bit(covered_by_row[142]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage143(
        .row_id(8'd143),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row143),.read_bit(covered_by_row[143]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage144(
        .row_id(8'd144),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row144),.read_bit(covered_by_row[144]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage145(
        .row_id(8'd145),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row145),.read_bit(covered_by_row[145]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage146(
        .row_id(8'd146),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row146),.read_bit(covered_by_row[146]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage147(
        .row_id(8'd147),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row147),.read_bit(covered_by_row[147]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage148(
        .row_id(8'd148),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row148),.read_bit(covered_by_row[148]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage149(
        .row_id(8'd149),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row149),.read_bit(covered_by_row[149]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage150(
        .row_id(8'd150),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row150),.read_bit(covered_by_row[150]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage151(
        .row_id(8'd151),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row151),.read_bit(covered_by_row[151]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage152(
        .row_id(8'd152),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row152),.read_bit(covered_by_row[152]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage153(
        .row_id(8'd153),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row153),.read_bit(covered_by_row[153]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage154(
        .row_id(8'd154),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row154),.read_bit(covered_by_row[154]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage155(
        .row_id(8'd155),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row155),.read_bit(covered_by_row[155]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage156(
        .row_id(8'd156),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row156),.read_bit(covered_by_row[156]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage157(
        .row_id(8'd157),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row157),.read_bit(covered_by_row[157]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage158(
        .row_id(8'd158),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row158),.read_bit(covered_by_row[158]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage159(
        .row_id(8'd159),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row159),.read_bit(covered_by_row[159]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage160(
        .row_id(8'd160),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row160),.read_bit(covered_by_row[160]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage161(
        .row_id(8'd161),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row161),.read_bit(covered_by_row[161]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage162(
        .row_id(8'd162),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row162),.read_bit(covered_by_row[162]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage163(
        .row_id(8'd163),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row163),.read_bit(covered_by_row[163]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage164(
        .row_id(8'd164),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row164),.read_bit(covered_by_row[164]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage165(
        .row_id(8'd165),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row165),.read_bit(covered_by_row[165]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage166(
        .row_id(8'd166),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row166),.read_bit(covered_by_row[166]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage167(
        .row_id(8'd167),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row167),.read_bit(covered_by_row[167]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage168(
        .row_id(8'd168),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row168),.read_bit(covered_by_row[168]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage169(
        .row_id(8'd169),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row169),.read_bit(covered_by_row[169]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage170(
        .row_id(8'd170),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row170),.read_bit(covered_by_row[170]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage171(
        .row_id(8'd171),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row171),.read_bit(covered_by_row[171]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage172(
        .row_id(8'd172),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row172),.read_bit(covered_by_row[172]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage173(
        .row_id(8'd173),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row173),.read_bit(covered_by_row[173]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage174(
        .row_id(8'd174),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row174),.read_bit(covered_by_row[174]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage175(
        .row_id(8'd175),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row175),.read_bit(covered_by_row[175]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage176(
        .row_id(8'd176),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row176),.read_bit(covered_by_row[176]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage177(
        .row_id(8'd177),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row177),.read_bit(covered_by_row[177]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage178(
        .row_id(8'd178),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row178),.read_bit(covered_by_row[178]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage179(
        .row_id(8'd179),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row179),.read_bit(covered_by_row[179]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage180(
        .row_id(8'd180),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row180),.read_bit(covered_by_row[180]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage181(
        .row_id(8'd181),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row181),.read_bit(covered_by_row[181]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage182(
        .row_id(8'd182),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row182),.read_bit(covered_by_row[182]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage183(
        .row_id(8'd183),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row183),.read_bit(covered_by_row[183]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage184(
        .row_id(8'd184),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row184),.read_bit(covered_by_row[184]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage185(
        .row_id(8'd185),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row185),.read_bit(covered_by_row[185]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage186(
        .row_id(8'd186),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row186),.read_bit(covered_by_row[186]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage187(
        .row_id(8'd187),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row187),.read_bit(covered_by_row[187]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage188(
        .row_id(8'd188),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row188),.read_bit(covered_by_row[188]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage189(
        .row_id(8'd189),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row189),.read_bit(covered_by_row[189]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage190(
        .row_id(8'd190),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row190),.read_bit(covered_by_row[190]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage191(
        .row_id(8'd191),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row191),.read_bit(covered_by_row[191]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage192(
        .row_id(8'd192),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row192),.read_bit(covered_by_row[192]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage193(
        .row_id(8'd193),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row193),.read_bit(covered_by_row[193]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage194(
        .row_id(8'd194),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row194),.read_bit(covered_by_row[194]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage195(
        .row_id(8'd195),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row195),.read_bit(covered_by_row[195]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage196(
        .row_id(8'd196),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row196),.read_bit(covered_by_row[196]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage197(
        .row_id(8'd197),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row197),.read_bit(covered_by_row[197]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage198(
        .row_id(8'd198),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row198),.read_bit(covered_by_row[198]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage199(
        .row_id(8'd199),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row199),.read_bit(covered_by_row[199]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage200(
        .row_id(8'd200),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row200),.read_bit(covered_by_row[200]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage201(
        .row_id(8'd201),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row201),.read_bit(covered_by_row[201]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage202(
        .row_id(8'd202),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row202),.read_bit(covered_by_row[202]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage203(
        .row_id(8'd203),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row203),.read_bit(covered_by_row[203]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage204(
        .row_id(8'd204),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row204),.read_bit(covered_by_row[204]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage205(
        .row_id(8'd205),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row205),.read_bit(covered_by_row[205]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage206(
        .row_id(8'd206),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row206),.read_bit(covered_by_row[206]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage207(
        .row_id(8'd207),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row207),.read_bit(covered_by_row[207]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage208(
        .row_id(8'd208),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row208),.read_bit(covered_by_row[208]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage209(
        .row_id(8'd209),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row209),.read_bit(covered_by_row[209]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage210(
        .row_id(8'd210),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row210),.read_bit(covered_by_row[210]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage211(
        .row_id(8'd211),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row211),.read_bit(covered_by_row[211]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage212(
        .row_id(8'd212),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row212),.read_bit(covered_by_row[212]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage213(
        .row_id(8'd213),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row213),.read_bit(covered_by_row[213]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage214(
        .row_id(8'd214),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row214),.read_bit(covered_by_row[214]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage215(
        .row_id(8'd215),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row215),.read_bit(covered_by_row[215]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage216(
        .row_id(8'd216),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row216),.read_bit(covered_by_row[216]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage217(
        .row_id(8'd217),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row217),.read_bit(covered_by_row[217]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage218(
        .row_id(8'd218),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row218),.read_bit(covered_by_row[218]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage219(
        .row_id(8'd219),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row219),.read_bit(covered_by_row[219]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage220(
        .row_id(8'd220),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row220),.read_bit(covered_by_row[220]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage221(
        .row_id(8'd221),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row221),.read_bit(covered_by_row[221]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage222(
        .row_id(8'd222),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row222),.read_bit(covered_by_row[222]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage223(
        .row_id(8'd223),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row223),.read_bit(covered_by_row[223]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage224(
        .row_id(8'd224),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row224),.read_bit(covered_by_row[224]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage225(
        .row_id(8'd225),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row225),.read_bit(covered_by_row[225]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage226(
        .row_id(8'd226),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row226),.read_bit(covered_by_row[226]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage227(
        .row_id(8'd227),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row227),.read_bit(covered_by_row[227]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage228(
        .row_id(8'd228),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row228),.read_bit(covered_by_row[228]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage229(
        .row_id(8'd229),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row229),.read_bit(covered_by_row[229]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage230(
        .row_id(8'd230),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row230),.read_bit(covered_by_row[230]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage231(
        .row_id(8'd231),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row231),.read_bit(covered_by_row[231]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage232(
        .row_id(8'd232),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row232),.read_bit(covered_by_row[232]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage233(
        .row_id(8'd233),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row233),.read_bit(covered_by_row[233]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage234(
        .row_id(8'd234),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row234),.read_bit(covered_by_row[234]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage235(
        .row_id(8'd235),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row235),.read_bit(covered_by_row[235]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage236(
        .row_id(8'd236),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row236),.read_bit(covered_by_row[236]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage237(
        .row_id(8'd237),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row237),.read_bit(covered_by_row[237]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage238(
        .row_id(8'd238),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row238),.read_bit(covered_by_row[238]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage239(
        .row_id(8'd239),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row239),.read_bit(covered_by_row[239]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage240(
        .row_id(8'd240),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row240),.read_bit(covered_by_row[240]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage241(
        .row_id(8'd241),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row241),.read_bit(covered_by_row[241]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage242(
        .row_id(8'd242),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row242),.read_bit(covered_by_row[242]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage243(
        .row_id(8'd243),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row243),.read_bit(covered_by_row[243]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage244(
        .row_id(8'd244),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row244),.read_bit(covered_by_row[244]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage245(
        .row_id(8'd245),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row245),.read_bit(covered_by_row[245]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage246(
        .row_id(8'd246),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row246),.read_bit(covered_by_row[246]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage247(
        .row_id(8'd247),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row247),.read_bit(covered_by_row[247]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage248(
        .row_id(8'd248),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row248),.read_bit(covered_by_row[248]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage249(
        .row_id(8'd249),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row249),.read_bit(covered_by_row[249]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage250(
        .row_id(8'd250),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row250),.read_bit(covered_by_row[250]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage251(
        .row_id(8'd251),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row251),.read_bit(covered_by_row[251]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage252(
        .row_id(8'd252),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row252),.read_bit(covered_by_row[252]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage253(
        .row_id(8'd253),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row253),.read_bit(covered_by_row[253]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage254(
        .row_id(8'd254),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row254),.read_bit(covered_by_row[254]));
    hw2_bitmap_row #(.PIXEL_LANES(PIXEL_LANES)) bitmap_row_storage255(
        .row_id(8'd255),
        .clk(clk),.rstn(rstn),.start(start),.processing(processing),.fault(fault),
        .hits(hits),.lane_y(lane_y[0]),.first_length(first_length),.row_width(row_width),
        .yend(yend),.step_size(step_size),.first_update(first_update),.full_mask(full_mask),
        .xmin(xmin),.read_column(lane_address[0][7:0]),
        .bits(bitmap_row255),.read_bit(covered_by_row[255]));
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            sax<=32'd0; say<=32'd0; sbx<=32'd0; sby<=32'd0; scx<=32'd0; scy<=32'd0;
            sdxab<=32'd0; sdyab<=32'd0; sdxbc<=32'd0; sdybc<=32'd0; sdxca<=32'd0; sdyca<=32'd0;
            pixel_base<=0; saved_total<=0; saved_id<=0; saved_exception<=0;
            spos<=0; sneg<=0; saved_xmin<=0; saved_xend<=0; saved_yend<=0;
            cursor_x<=0; cursor_y<=0;
        end else if(start) begin
            pixel_base<=0; saved_total<=0; saved_id<=0; saved_exception<=0;
            spos<=0; sneg<=0; saved_xmin<=0; saved_xend<=0; saved_yend<=0;
            cursor_x<=0; cursor_y<=0;
        end else if(processing&&!fault) begin
            if(fire) begin
                saved_id<=triangle_id;
                sax<=ax; say<=ay; sbx<=bx; sby<=by; scx<=cx; scy<=cy;
                sdxab<=dxab; sdyab<=dyab; sdxbc<=dxbc; sdybc<=dybc;
                sdxca<=dxca; sdyca<=dyca;
                spos<=positive; sneg<=negative;
                saved_xmin<=box_xmin; saved_xend<=box_xend; saved_yend<=box_yend;
                saved_total<=box_total; pixel_base<=step_size;
                saved_exception<=input_exception;
            end else if(!last_chunk) pixel_base<=lint_unused_pixel_next[16:0];
            cursor_x<=exceptional?lane_x[1]:lane_x[PIXEL_LANES];
            cursor_y<=exceptional?lane_y[1]:lane_y[PIXEL_LANES];
        end
    end
    `ifdef HW2_SIM_DIAGNOSTICS
    initial if(PIXEL_LANES<1||PIXEL_LANES>65536) $fatal(1,"Invalid PIXEL_LANES");
    `endif
endmodule
