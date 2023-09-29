
module fifo_mem #(
	parameter	DATA_WIDTH = 8,
	parameter	FIFO_DEPTH = 8,
	parameter   PTR_WIDTH = 4
	)

	(
	input	wire							w_clk,
	input	wire							w_rstn,
	input	wire							w_inc,
	input	wire							w_full,
	input   wire			[PTR_WIDTH-2:0]     w_addr,         
   	input   wire			[PTR_WIDTH-2:0]     r_addr,             
    	input   wire			[DATA_WIDTH-1:0]    w_data,             
    	output  wire		[DATA_WIDTH-1:0]    r_data              
	);

reg [FIFO_DEPTH-1:0] i ;

//FIFO Memory
reg [DATA_WIDTH-1:0] FIFO_MEM [FIFO_DEPTH-1:0] ;

//writing data
always @(posedge w_clk or negedge w_rstn) begin
	if (!w_rstn) begin
		// reset
		for(i=0;i<FIFO_DEPTH;i=i+1) begin
			FIFO_MEM[i]		<=		'b0;
		end
	end
	else if (w_inc	&	!w_full) begin
		FIFO_MEM[w_addr]	<=		w_data;
	end
end


//reading data
assign 	r_data 		=	FIFO_MEM[r_addr] ;


endmodule
