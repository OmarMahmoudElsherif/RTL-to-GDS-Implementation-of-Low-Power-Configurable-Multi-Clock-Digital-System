
module fifo_rd #(
	parameter	DATA_WIDTH = 8,
	parameter   PTR_WIDTH = 4
	) (
	input	wire							r_clk,
	input	wire							r_rstn,
	input	wire							r_inc,
	input	wire		[PTR_WIDTH-1:0]		sync_wr_ptr,
	output	wire							r_empty,
	output  wire		[PTR_WIDTH-2:0]     r_addr,
	output  reg			[PTR_WIDTH-1:0]     gray_rd_ptr
	);


// read pointer
reg			[PTR_WIDTH-1:0]     r_ptr;

//incrementing read pointer
always @(posedge r_clk or negedge r_rstn) begin
	if (!r_rstn) begin
		r_ptr 		<=		'b0;
	end
	else if (r_inc	&	!r_empty) begin
		r_ptr 		<=	r_ptr 	+	'b1;
	end
end

// assigning read address
assign 	r_addr 	=	r_ptr[PTR_WIDTH-2:0] ;

//assigning empty flag
assign r_empty = (gray_rd_ptr == sync_wr_ptr);



//converting read pointer to Gray encoded 
always @(*) begin
	//if (!r_rstn) begin
	//	gray_rd_ptr		<=		'b0;
	//end
	//else begin
		case(r_ptr)
		'b0000	:	gray_rd_ptr		=	'b0000;
		'b0001	:	gray_rd_ptr		=	'b0001;
		'b0010	:	gray_rd_ptr		=	'b0011;
		'b0011	:	gray_rd_ptr		=	'b0010;
		'b0100	:	gray_rd_ptr		=	'b0110;
		'b0101	:	gray_rd_ptr		=	'b0111;
		'b0110	:	gray_rd_ptr		=	'b0101;
		'b0111	:	gray_rd_ptr		=	'b0100;
		'b1000	:	gray_rd_ptr		=	'b1100;
		'b1001	:	gray_rd_ptr		=	'b1101;
		'b1010	:	gray_rd_ptr		=	'b1111;
		'b1011	:	gray_rd_ptr		=	'b1110;
		'b1100	:	gray_rd_ptr		=	'b1010;
		'b1101	:	gray_rd_ptr		=	'b1011;
		'b1110	:	gray_rd_ptr		=	'b1001;
		'b1111	:	gray_rd_ptr		=	'b1000;
		endcase


	//end
end




endmodule