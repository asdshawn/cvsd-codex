
module hw2_fp_edge(input [31:0] ax,ay,dx,dy,px,py,
                   output [31:0] edge_value, output [7:0] status);
    wire [31:0] rx,ry,p0,p1;
    wire [7:0] s0,s1,s2,s3,s4;
    hw2_fp_sub sx(.a(px),.b(ax),.z(rx),.status(s0));
    hw2_fp_sub sy(.a(py),.b(ay),.z(ry),.status(s1));
    hw2_fp_mul m0(.a(dx),.b(ry),.z(p0),.status(s2));
    hw2_fp_mul m1(.a(dy),.b(rx),.z(p1),.status(s3));
    hw2_fp_sub se(.a(p0),.b(p1),.z(edge_value),.status(s4));
    assign status=s0|s1|s2|s3|s4;
endmodule
