////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design 
// 
////////////////////////////////////////////////////////////////////////////////
module FIFO(FIFO_int.DUT FIFOint);
 
localparam max_fifo_addr = $clog2(FIFOint.FIFO_DEPTH);

reg [FIFOint.FIFO_WIDTH-1:0] mem [FIFOint.FIFO_DEPTH-1:0];

reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
reg [max_fifo_addr:0] count;

always @(posedge FIFOint.clk or negedge FIFOint.rst_n) begin
	if (!FIFOint.rst_n) begin
		wr_ptr <= 0;
		FIFOint.overflow <= 0;
		FIFOint.wr_ack <= 0;
	end
	else if (FIFOint.wr_en && count < FIFOint.FIFO_DEPTH) begin
		mem[wr_ptr] <= FIFOint.data_in;
		FIFOint.wr_ack <= 1;
		wr_ptr <= wr_ptr + 1;
		FIFOint.overflow <= 0;
	end
	else begin 
		FIFOint.wr_ack <= 0; 
		if (FIFOint.full & FIFOint.wr_en)
			FIFOint.overflow <= 1;
		else
			FIFOint.overflow <= 0;
	end
end

always @(posedge FIFOint.clk or negedge FIFOint.rst_n) begin
	if (!FIFOint.rst_n) begin
		rd_ptr <= 0;
		FIFOint.underflow <= 0;
	end
	else if (FIFOint.rd_en && count != 0) begin
		FIFOint.data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1;
		FIFOint.underflow <= 0;
	end else begin
            if (FIFOint.empty && FIFOint.rd_en) begin
                FIFOint.underflow <= 1;
            end else begin
                FIFOint.underflow <= 0;
            end
        end
end

always @(posedge FIFOint.clk or negedge FIFOint.rst_n) begin
	if (!FIFOint.rst_n) begin
		count <= 0;
	end
	else begin
		if (FIFOint.wr_en && FIFOint.rd_en && !FIFOint.full && !FIFOint.empty) 
                count <= count; 
            else if	(FIFOint.wr_en && !FIFOint.full)
	    		count = count + 1;
	    	else if (FIFOint.rd_en && !FIFOint.empty)
	    		count = count - 1;
	end
end

assign FIFOint.full = (count == FIFOint.FIFO_DEPTH)? 1 : 0;
assign FIFOint.empty = (count == 0)? 1 : 0;
assign FIFOint.almostfull = (count == FIFOint.FIFO_DEPTH-1)? 1 : 0; 
assign FIFOint.almostempty = (count == 1)? 1 : 0;

endmodule