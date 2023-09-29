
module CLKDIV_MUX #(parameter	RATIO_WIDTH	= 8)
(
	input		wire	[5:0]					Prescale,
	output		reg		[RATIO_WIDTH-1:0]		OUT_Div_Ratio
);



always@(*) begin
	case(Prescale)
	'd32 	: 	OUT_Div_Ratio = 'd1;
	'd16 	: 	OUT_Div_Ratio = 'd2;
	'd8 	: 	OUT_Div_Ratio = 'd4;
	'd4 	:  	OUT_Div_Ratio = 'd8;
	default : 	OUT_Div_Ratio = 'd1;

	endcase
end



endmodule