// Each leaf owns one bitmap row; no 65536-bit memory or mux terminal.
module hw2_frame_row(
    input clk,rstn,start,
    input [255:0] covered,
    input take,
    input [7:0] column,
    output pending,
    output [7:0] first_column
);
    reg [255:0] sent;
    wire [255:0] bits=covered&~sent;
    function automatic [7:0] first_set;
        input [255:0] bits;
        reg [255:0] remaining;
        reg [7:0] position;
        begin
            remaining=bits; position=8'd0;
            if(!(|remaining[127:0])) begin remaining=remaining>>128; position=position+8'd128; end
            if(!(|remaining[63:0])) begin remaining=remaining>>64; position=position+8'd64; end
            if(!(|remaining[31:0])) begin remaining=remaining>>32; position=position+8'd32; end
            if(!(|remaining[15:0])) begin remaining=remaining>>16; position=position+8'd16; end
            if(!(|remaining[7:0])) begin remaining=remaining>>8; position=position+8'd8; end
            if(!(|remaining[3:0])) begin remaining=remaining>>4; position=position+8'd4; end
            if(!(|remaining[1:0])) begin remaining=remaining>>2; position=position+8'd2; end
            if(!remaining[0]) position=position+8'd1;
            first_set=position;
        end
    endfunction
    assign pending=|bits;
    assign first_column=first_set(bits);
    always @(posedge clk or negedge rstn) begin
        if(!rstn) sent<=256'b0;
        else if(start) sent<=256'b0;
        else if(take) sent[column]<=1'b1;
    end
endmodule
