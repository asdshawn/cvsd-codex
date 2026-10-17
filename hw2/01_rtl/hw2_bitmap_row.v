
// A row is both the storage and the lint hierarchy boundary. Each read and
// update terminal covers at most 256 pixels, while all rows commit together.
module hw2_bitmap_row #(parameter PIXEL_LANES=40)(
    input clk,rstn,start,processing,fault,
    input [7:0] row_id,
    input [PIXEL_LANES-1:0] hits,
    input [16:0] lane_y,step_size,
    input [8:0] first_length,row_width,yend,xmin,
    input [255:0] first_update,full_mask,
    input [7:0] read_column,
    output reg [255:0] bits,
    output read_bit
);
    wire [31:0] row_number={24'b0,row_id};
    wire [31:0] distance=row_number-lane_y;
    wire [31:0] offset=first_length+(distance-32'd1)*row_width;
    localparam HIT_WORK_WIDTH=(PIXEL_LANES<256)?256:PIXEL_LANES;
    wire [HIT_WORK_WIDTH-1:0] padded_hits={{(HIT_WORK_WIDTH-PIXEL_LANES){1'b0}},hits};
    wire [HIT_WORK_WIDTH-1:0] shifted_hits=padded_hits>>offset;
    wire [255:0] row_hits=shifted_hits[255:0];
    wire active_row=(row_number>{15'b0,lane_y})&&(row_number<{23'b0,yend})&&(offset<{15'b0,step_size});
    wire [255:0] update=(row_number=={15'b0,lane_y})?first_update:
        (active_row?((row_hits&full_mask)<<xmin):256'b0);
    assign read_bit=bits[read_column];
    always @(posedge clk or negedge rstn) begin
        if(!rstn) bits<=256'b0;
        else if(start) bits<=256'b0;
        else if(processing&&!fault&&(|update)) bits<=bits|update;
    end
endmodule
