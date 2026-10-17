
module hw2_priority_row(input [255:0] bits,output present,output [7:0] column);
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
    assign present=|bits;
    assign column=first_set(bits);
endmodule
