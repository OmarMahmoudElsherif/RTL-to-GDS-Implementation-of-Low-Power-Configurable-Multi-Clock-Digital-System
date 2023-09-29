
module SYS_CTRL #(
	parameter DATA_WIDTH = 8,
	parameter ADDR_WIDTH = 4
	)
(
	///////////////////////// INPUTS //////////////////////////
	input		wire							CLK,
	input		wire							RST,
	input		wire							ALU_OUT_VLD,
	input		wire	[2*DATA_WIDTH-1:0]		ALU_OUT,
	input		wire	[DATA_WIDTH-1:0]		RX_P_DATA,
	input		wire							RX_D_VLD,
	input		wire	[DATA_WIDTH-1:0]		RdData,
	input		wire							RdData_Valid,
	input		wire							FIFO_FULL,
	///////////////////////// OUTPUTS //////////////////////////
	output		reg								ALU_EN,
	output		reg		[3:0]					ALU_FUN,
	output		reg								CLK_EN,
	output		reg		[ADDR_WIDTH-1:0]		Address,
	output		reg								WrEN,
	output		reg								RdEN,
	output		reg		[DATA_WIDTH-1:0]		WrData,
	output		reg		[DATA_WIDTH-1:0]		WR_DATA,
	output		reg								WR_INC,
	output		reg								clk_div_en
);


///////////////////////////////////////////////////
//////////////////// Commands /////////////////////
///////////////////////////////////////////////////

localparam	[7:0]	RF_Wr_CMD 			=	'hAA,
					RF_Rd_CMD 			=	'hBB,
					ALU_OPER_W_OP_CMD 	=	'hCC,
					ALU_OPER_W_NOP_CMD 	=	'hDD;



///////////////////////////////////////////////////
/////////////////// FSM States ////////////////////
///////////////////////////////////////////////////

localparam	[3:0]	IDLE				=	'b0000,
					RF_Wr_CMD_F1		=	'b0001,
					RF_Wr_CMD_F2		=	'b0010,
					RF_Wr_OP			=	'b0011,
					RF_Rd_CMD_F1		=	'b0100,
					RF_Rd_OP			=	'b0101,
					ALU_OPER_CMD_F1		=	'b0110,
					ALU_OPER_CMD_F2		=	'b0111,
					ALU_OPER_CMD_F3		=	'b1000,
					ALU_OP				=	'b1001,
					ALU_OPER_NOP_F1		=	'b1010,
					FIFO_Wr				=	'b1011,
					FIFO_ALU_F0 		=	'b1100,
					FIFO_ALU_F1         =   'b1101;




reg		[3:0]		current_state,
						next_state;


///////////////////////////////////////////////////
/////////// Internal Storage Elements /////////////
///////////////////////////////////////////////////

//reg		[DATA_WIDTH-1:0] 	OP_A,
//							OP_B;

reg		[2*DATA_WIDTH-1:0]	ALU_OUT_reg;







// Next State Logic
always@(posedge CLK or negedge RST ) begin
	if(!RST) begin
		current_state	<=	IDLE;
	end
	else begin
		current_state	<=	next_state;
	end
end



// FSM	Logic
always @(*) begin
	
ALU_EN 			=	'b0;
//ALU_FUN 		=	'b0;
CLK_EN 			=	'b0;
//Address 		=	'b0;
WrEN 			=	'b0;
RdEN 			=	'b0;
//WrData 			=	'b0;
WR_DATA 		=	'b0;
WR_INC			=	'b0;
clk_div_en		=	'b1;
next_state		=	IDLE;


	case(current_state)

	IDLE	:	begin
		if(RX_D_VLD) begin	// Frame 0 came
			case(RX_P_DATA)
			RF_Wr_CMD 				:	next_state	=	RF_Wr_CMD_F1;
			RF_Rd_CMD 				:	next_state	=	RF_Rd_CMD_F1;
			ALU_OPER_W_OP_CMD 		:	next_state	=	ALU_OPER_CMD_F1;
			ALU_OPER_W_NOP_CMD 		:	next_state	=	ALU_OPER_NOP_F1;

			default					:	next_state	=	IDLE;

			endcase
		end

		else begin
			next_state	=	IDLE;
		end

	end


	RF_Wr_CMD_F1	:	begin
		
		if(RX_D_VLD) begin  // Frame 1 came
			next_state	=	RF_Wr_CMD_F2;
		end

		else begin
			next_state	=	RF_Wr_CMD_F1;
		end
	end

	RF_Wr_CMD_F2	:	begin
		
		if(RX_D_VLD) begin  // Frame 2 came
			next_state	=	RF_Wr_OP;
		end

		else begin
			next_state	=	RF_Wr_CMD_F2;
		end
	end

	RF_Wr_OP		:	begin   //doing write operation in RegFile

		WrEN 			=	'b1;
		next_state		=	IDLE;  // RegFile Write Command Completed
	end


	RF_Rd_CMD_F1	:	begin
		if(RX_D_VLD) begin  // Frame 1 came
			next_state	=	RF_Rd_OP;
		end

		else begin
			next_state	=	RF_Rd_CMD_F1;
		end
	end

	RF_Rd_OP		:	begin   //doing read operation in RegFile

		RdEN 				=	'b1;
		if(RdData_Valid) begin // reading data from RegFile
			next_state		=	FIFO_Wr;  
		end
		else begin
			next_state		=	RF_Rd_OP;
		end

	end


	FIFO_Wr 		:	begin
		
		if(!FIFO_FULL) begin
			WR_INC		=	'b1;
			WR_DATA 	=	WrData;
			next_state	=	IDLE;   // RegFile Read Command Completed
		end
		else begin
			next_state 	=	FIFO_Wr; 	
		end
	end


	ALU_OPER_CMD_F1	:	begin
		if(RX_D_VLD) begin  // Frame 1 came
			next_state	=	ALU_OPER_CMD_F2;
		end

		else begin
			next_state	=	ALU_OPER_CMD_F1;
		end

	end

	ALU_OPER_CMD_F2	:	begin
		if(RX_D_VLD) begin  // Frame 2 came
			next_state	=	ALU_OPER_CMD_F3;
			WrEN 		=	'b1;  // write OPA in REG[0] 

		end

		else begin
			next_state	=	ALU_OPER_CMD_F2;
		end

	end


	ALU_OPER_CMD_F3	:	begin
		if(RX_D_VLD) begin  // Frame 3 came
			next_state	=	ALU_OP;
			WrEN 		=	'b1;  // write OPB in REG[1] 
		end

		else begin
			next_state	=	ALU_OPER_CMD_F3;
		end

	end

	ALU_OP 		:	begin
		CLK_EN 		=	'b1;
		ALU_EN 		=	'b1;
		if(ALU_OUT_VLD) begin   // output of alu = 16 bits ,so we need to take 2 frames
			next_state = FIFO_ALU_F0;
		end
		else begin
			next_state = ALU_OP;
		end
	end	

	FIFO_ALU_F0 	:	begin
		CLK_EN 		=	'b1;
		if(!FIFO_FULL) begin
			WR_INC		=	'b1;
			WR_DATA 	=	ALU_OUT_reg[DATA_WIDTH-1:0];
			next_state	=	FIFO_ALU_F1;   
		end
		else begin
			next_state 	=	FIFO_ALU_F0; 	
		end
	end

	FIFO_ALU_F1 	:	begin
		if(!FIFO_FULL) begin
			WR_INC		=	'b1;
			WR_DATA 	=	ALU_OUT_reg[2*DATA_WIDTH-1:DATA_WIDTH];
			next_state	=	IDLE;   // ALU_OPerations Commands Completed
		end
		else begin
			next_state 	=	FIFO_ALU_F1; 	
		end
	end

	ALU_OPER_NOP_F1	:	begin
		if(RX_D_VLD) begin  // Frame 1 came
			next_state	=	ALU_OP; 
		end

		else begin
			next_state	=	ALU_OPER_NOP_F1;
		end
	end

	




	default	:	begin
		ALU_EN 			=	'b0;
		//ALU_FUN 		=	'b0;
		CLK_EN 			=	'b0;
		//Address 		=	'b0;
		WrEN 			=	'b0;
		RdEN 			=	'b0;
		//WrData 			=	'b0;
		WR_DATA 		=	'b0;
		WR_INC			=	'b0;
		clk_div_en		=	'b1;
		next_state		=	IDLE;
	end

	endcase
end


///////////////////////////////////////////////////
//////////////// Storage Elements /////////////////
///////////////////////////////////////////////////

always@(posedge CLK or negedge RST) begin
	if(!RST) begin
		WrData 			<=	'b0;
		Address 		<=	'b0;
		//OP_A			<=	'b0;
		//OP_B			<=	'b0;
		ALU_FUN 		<=	'b0;
		ALU_OUT_reg 	<=	'b0;
	end
	else begin
		if((current_state==RF_Wr_CMD_F1 || current_state == RF_Rd_CMD_F1) && RX_D_VLD) begin
			Address		<=	RX_P_DATA;
		end
		else if(current_state==RF_Wr_CMD_F2 && RX_D_VLD) begin
			WrData		<=	RX_P_DATA;
		end
		else if(current_state==RF_Rd_OP && RdData_Valid) begin
			WrData		<=	RdData;   // stores data read from RF to send it to FIFO
		end
		else if(current_state==ALU_OPER_CMD_F1 && RX_D_VLD) begin
			WrData		<=	RX_P_DATA;
			Address		<=	'b0;		// REG[0]   
		end
		else if(current_state==ALU_OPER_CMD_F2 && RX_D_VLD) begin
			WrData		<=	RX_P_DATA;
			Address		<=	'b1;		// REG[1]   
		end
		else if( (current_state==ALU_OPER_CMD_F3 || current_state==ALU_OPER_NOP_F1) && RX_D_VLD) begin
			ALU_FUN 	<=	RX_P_DATA;   
		end
		else if(current_state==ALU_OP && ALU_OUT_VLD) begin
			ALU_OUT_reg <=	ALU_OUT;   
		end
	end

end


endmodule