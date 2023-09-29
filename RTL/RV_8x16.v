
module RV_8x16 #(
	parameter DATA_WIDTH = 8, //default value
	parameter ADDR_WIDTH = 4, //default value
	parameter RV_DEPTH 	 = 8 //default value
)	(
	input 		wire						CLK,
	input 		wire						RST,
	input 		wire						WrEn,
	input 		wire						RdEn,
	input 		wire	[ADDR_WIDTH-1:0]	Address,
	input 		wire	[DATA_WIDTH-1:0] 	WrData,
	output 		reg 	[DATA_WIDTH-1:0] 	RdData,
	output 		reg 					 	RdData_Valid,
	output		wire	[DATA_WIDTH-1:0]	REG0,
	output		wire	[DATA_WIDTH-1:0]	REG1,
	output		wire	[DATA_WIDTH-1:0]	REG2,
	output		wire	[DATA_WIDTH-1:0]	REG3
);

// 8x16 Register File
reg [DATA_WIDTH-1:0] RegisterFile [RV_DEPTH-1:0];


//sequential always
always@(posedge CLK,negedge RST) begin
	if(!RST) begin
		RegisterFile[0] <= 'b0;
		RegisterFile[1] <= 'b0;
		RegisterFile[2] <= 'b1000_0001;		// UART Config, default Prescale = REG2[7:2] =32, REG2[0] = Parity Enable , default =1, REG2[1] = Parity Type, default =0
		RegisterFile[3] <= 'b0010_0000;				// Div Ratio, default = 32
		RegisterFile[4] <= 'b0;
		RegisterFile[5] <= 'b0;
		RegisterFile[6] <= 'b0;
		RegisterFile[7] <= 'b0;

		RdData_Valid	<=	'b0;
		RdData 			<=	'b0;
	end
	else begin
		if(!WrEn  &&  RdEn )	begin	//Read operation
			RdData 			<= 		RegisterFile[Address];
			RdData_Valid	<=		'b1;
		end
		else if (WrEn && !RdEn )  begin	// Write operation
			RegisterFile[Address] 	<= 		WrData;	
			RdData_Valid			<=		'b0;
		end
		else begin
			RdData_Valid			<=		'b0;
		end
	end
end


// Assigning First 3 Registers 
assign 		REG0	=	RegisterFile[0] ;
assign 		REG1	=	RegisterFile[1] ;
assign 		REG2	=	RegisterFile[2] ;
assign 		REG3	=	RegisterFile[3] ;




endmodule