// Conservative screen-space bounds, with an FP32 error allowance.
// All edge arithmetic and all coverage comparisons remain unchanged.
// For the guarded finite range, S bounds rounded edge components and R
// bounds all vertex/pixel coordinates. The allowance uses
//     |area_fp| > 256*u*S*S*R / margin, u=2^-24.
// Outside that range, or when margin would reach 256, scan the viewport.
module hw2_bbox(
    input [7:0] width,height,
    input [31:0] ax,ay,bx,by,cx,cy,
    input [7:0] dxab_exp,dyab_exp,dxbc_exp,dybc_exp,dxca_exp,dyca_exp,area_exp,
    output reg [8:0] xmin,xend,ymin,yend,
    output reg fallback,
    output reg [8:0] margin
);
    function automatic fp_lt;
        input [31:0] a,b;
        begin
            if(a[30:0]==0&&b[30:0]==0) fp_lt=0;
            else if(a[31]!=b[31]) fp_lt=a[31];
            else if(a[31]) fp_lt=a[30:0]>b[30:0];
            else fp_lt=a[30:0]<b[30:0];
        end
    endfunction
    function automatic [8:0] floor_clip;
        input [31:0] value;
        reg [23:0] significand,shifted;
        begin
            significand={1'b1,value[22:0]};
            shifted=significand>>(32'd150-{24'b0,value[30:23]});
            if(value[31]||value[30:23]<127) floor_clip=9'd0;
            else if(value[30:23]>=135) floor_clip=9'd256;
            else floor_clip=shifted[8:0];
        end
    endfunction
    function automatic [8:0] ceil_clip;
        input [31:0] value;
        reg [23:0] significand,low_mask,shifted;
        reg [8:0] whole;
        integer shift;
        begin
            significand={1'b1,value[22:0]};
            low_mask=0; whole=0; shift=0;
            if(value[31]||value[30:0]==0) ceil_clip=0;
            else if(value[30:23]<127) ceil_clip=1;
            else if(value[30:23]>=135) ceil_clip=256;
            else begin
                shift=32'd150-{24'b0,value[30:23]};
                shifted=significand>>shift;
                whole=shifted[8:0];
                low_mask=(24'd1<<shift)-24'd1;
                ceil_clip=whole+((significand&low_mask)!=0);
            end
        end
    endfunction
    function automatic [7:0] max_exp;
        input [7:0] a,b;
        begin
            if(b>a) max_exp=b;
            else max_exp=a;
        end
    endfunction
    function automatic [8:0] clamp_coord;
        input signed [31:0] value;
        input [7:0] limit;
        begin
            if(value<32'sd0) clamp_coord=9'd0;
            else if(value>$signed({24'b0,limit})) clamp_coord={1'b0,limit};
            else clamp_coord=value[8:0];
        end
    endfunction
    wire [31:0] xlo_ab=fp_lt(ax,bx)?ax:bx;
    wire [31:0] xhi_ab=fp_lt(ax,bx)?bx:ax;
    wire [31:0] ylo_ab=fp_lt(ay,by)?ay:by;
    wire [31:0] yhi_ab=fp_lt(ay,by)?by:ay;
    wire [31:0] xlo=fp_lt(xlo_ab,cx)?xlo_ab:cx;
    wire [31:0] xhi=fp_lt(xhi_ab,cx)?cx:xhi_ab;
    wire [31:0] ylo=fp_lt(ylo_ab,cy)?ylo_ab:cy;
    wire [31:0] yhi=fp_lt(yhi_ab,cy)?cy:yhi_ab;
    wire [7:0] edge_exp=max_exp(max_exp(max_exp(max_exp(max_exp(
        dxab_exp,dyab_exp),dxbc_exp),dybc_exp),dxca_exp),dyca_exp);
    wire [7:0] coord_exp=max_exp(max_exp(max_exp(max_exp(max_exp(max_exp(
        8'd134,ax[30:23]),ay[30:23]),bx[30:23]),by[30:23]),cx[30:23]),cy[30:23]);
    wire valid_range=(coord_exp<8'd143)&&(edge_exp>=8'd95)&&(edge_exp<=8'd143)&&
                     (area_exp!=8'd0)&&(area_exp!=8'd255);
    wire signed [31:0] pad_shift=32'sd2*$signed({24'b0,edge_exp})+
        $signed({24'b0,coord_exp})-$signed({24'b0,area_exp})-32'sd266;
    always @* begin
        fallback=!valid_range||(pad_shift>=32'sd8);
        margin=(pad_shift<=32'sd0)?9'd1:
               ((pad_shift<32'sd8)?(9'd1<<pad_shift):9'd256);
    end
    wire signed [31:0] low_x=$signed({23'b0,floor_clip(xlo)})-$signed({23'b0,margin});
    wire signed [31:0] high_x=$signed({23'b0,ceil_clip(xhi)})+$signed({23'b0,margin});
    wire signed [31:0] low_y=$signed({23'b0,floor_clip(ylo)})-$signed({23'b0,margin});
    wire signed [31:0] high_y=$signed({23'b0,ceil_clip(yhi)})+$signed({23'b0,margin});
    always @* begin
        if(!fallback) begin
            xmin=clamp_coord(low_x,width); xend=clamp_coord(high_x,width);
            ymin=clamp_coord(low_y,height); yend=clamp_coord(high_y,height);
        end else begin
            xmin=9'd0; xend={1'b0,width};
            ymin=9'd0; yend={1'b0,height};
        end
    end
endmodule
