
module ASYNC_FIFO #(
	parameter	DATA_WIDTH = 8,
	parameter	FIFO_DEPTH = 8,
	parameter   PTR_WIDTH = 4
	)	(
	input	wire							w_clk,
	input	wire							r_clk,
	input	wire							w_rstn,
	input	wire							r_rstn,

	input	wire							w_inc,
	input	wire							r_inc,
	
	output	wire							full,
	output	wire							empty,

	input   wire			[DATA_WIDTH-1:0]    		wr_data,             
    	output  wire			[DATA_WIDTH-1:0]    		rd_data     
	);


//////////////////////////////////////////
/////////// Internal Signals /////////////
/////////////////////////////////////////
wire		[PTR_WIDTH-2:0]     w_addr;         
wire		[PTR_WIDTH-2:0]     r_addr;            

wire		[PTR_WIDTH-1:0]		rd_ptr,sync_rd_ptr;
wire		[PTR_WIDTH-1:0]		wr_ptr,sync_wr_ptr;


//////////////////////////////////////////
////////// DUT Instantiations ////////////
/////////////////////////////////////////


fifo_mem #(
	.DATA_WIDTH(DATA_WIDTH),
	.FIFO_DEPTH(FIFO_DEPTH),
	.PTR_WIDTH(PTR_WIDTH)
	)
	fifo_mem_DUT
(
	.w_clk(w_clk),
	.w_rstn(w_rstn),
	.w_inc(w_inc),
	.w_full(full),
	.w_addr(w_addr),         
    .r_addr(r_addr),             
    .w_data(wr_data),             
    .r_data(rd_data)              
);



fifo_wr #(
	.DATA_WIDTH(DATA_WIDTH),
	.PTR_WIDTH(PTR_WIDTH)
	)
	fifo_wr_DUT
	(
	.w_clk(w_clk),
	.w_rstn(w_rstn),
	.w_inc(w_inc),
	.sync_rd_ptr(sync_rd_ptr),
	.w_full(full),
	.w_addr(w_addr),
	.gray_wr_ptr(wr_ptr)
	);



fifo_rd #(
	.DATA_WIDTH(DATA_WIDTH),
	.PTR_WIDTH(PTR_WIDTH)
	)
	fifo_rd_DUT
	(
	.r_clk(r_clk),
	.r_rstn(r_rstn),
	.r_inc(r_inc),
	.sync_wr_ptr(sync_wr_ptr),
	.r_empty(empty),
	.r_addr(r_addr),
	.gray_rd_ptr(rd_ptr)
	);





//2 FF synchronization for wr_ptr
BIT_SYNC #(
	.BUS_WIDTH(PTR_WIDTH),
	.NUM_STAGES(2)
	)
	WRITE_BIT_SYNC
	(
	.ASYNC(wr_ptr),
	.CLK(r_clk),
	.RST(r_rstn),
	.SYNC(sync_wr_ptr)
	);


//2 FF synchronization for rd_ptr
BIT_SYNC #(
	.BUS_WIDTH(PTR_WIDTH),
	.NUM_STAGES(2)
	)
	READ_BIT_SYNC
	(
	.ASYNC(rd_ptr),
	.CLK(w_clk),
	.RST(w_rstn),
	.SYNC(sync_rd_ptr)
	);





endmodule
