
module parity #(
	parameter DATA_WIDTH = 8  // default value 
)
	(
	input		wire							CLK,
	input		wire							RST,
	input		wire							PAR_TYP,
	input   	wire                 			parity_enable,
	input		wire							DATA_Valid,
	input		wire	[DATA_WIDTH-1:0]		P_DATA,
	output		reg								par_bit
	);


reg  [DATA_WIDTH-1:0]    DATA_V ;

//isolate input 
always @ (posedge CLK or negedge RST)
 begin
  if(!RST)
   begin
    DATA_V <= 'b0 ;
   end
  else if(DATA_Valid)
   begin
    DATA_V <= P_DATA ;
   end 
 end
 
// PAR_TYP : 0 -> Odd parity,  1 -> Even parity
always @ (posedge CLK or negedge RST)
 begin
  if(!RST)
   begin
    par_bit <= 'b0 ;
   end
  else
   begin
    if (parity_enable)
	 begin
	  case(PAR_TYP)
	  1'b0 : begin                 
	          par_bit <= ^DATA_V  ;     // Even Parity
	         end
	  1'b1 : begin
	          par_bit <= ~^DATA_V ;     // Odd Parity
	         end		
	  endcase       	 
	 end
   end
 end 


endmodule