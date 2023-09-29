
module fifo_wr #(
	parameter	DATA_WIDTH = 8,
	parameter   PTR_WIDTH = 4
	) (
	input	wire							w_clk,
	input	wire							w_rstn,
	input	wire							w_inc,
	input	wire		[PTR_WIDTH-1:0]		sync_rd_ptr,
	output	wire							w_full,
	output  wire		[PTR_WIDTH-2:0]     w_addr,
	output  reg			[PTR_WIDTH-1:0]     gray_wr_ptr
	);


// write pointer
reg			[PTR_WIDTH-1:0]     w_ptr;

//incrementing write pointer
always @(posedge w_clk or negedge w_rstn) begin
	if (!w_rstn) begin
		w_ptr 		<=		'b0;
	end
	else if (w_inc	&	!w_full) begin
		w_ptr 		<=	w_ptr 	+	'b1;
	end
end

// assigning write address
assign 	w_addr 	=	w_ptr[PTR_WIDTH-2:0] ;

//assigning full flag
assign w_full = (gray_wr_ptr[PTR_WIDTH-1] != sync_rd_ptr[PTR_WIDTH-1]) && (gray_wr_ptr[PTR_WIDTH-2] != sync_rd_ptr[PTR_WIDTH-2]) && (gray_wr_ptr[PTR_WIDTH-3:0] == sync_rd_ptr[PTR_WIDTH-3:0]);



//converting write pointer to Gray encoded 
always @(*) begin
	//if (!w_rstn) begin
	//	gray_wr_ptr		<=		'b0;
	//end
	//else begin
		case(w_ptr)
		'b0000	:	gray_wr_ptr		=	'b0000;
		'b0001	:	gray_wr_ptr		=	'b0001;
		'b0010	:	gray_wr_ptr		=	'b0011;
		'b0011	:	gray_wr_ptr		=	'b0010;
		'b0100	:	gray_wr_ptr		=	'b0110;
		'b0101	:	gray_wr_ptr		=	'b0111;
		'b0110	:	gray_wr_ptr		=	'b0101;
		'b0111	:	gray_wr_ptr		=	'b0100;
		'b1000	:	gray_wr_ptr		=	'b1100;
		'b1001	:	gray_wr_ptr		=	'b1101;
		'b1010	:	gray_wr_ptr		=	'b1111;
		'b1011	:	gray_wr_ptr		=	'b1110;
		'b1100	:	gray_wr_ptr		=	'b1010;
		'b1101	:	gray_wr_ptr		=	'b1011;
		'b1110	:	gray_wr_ptr		=	'b1001;
		'b1111	:	gray_wr_ptr		=	'b1000;
		endcase


	//end
end




endmodule