module ClkDiv #(
	parameter	RATIO_WIDTH	= 8
	)(

	input	wire						I_ref_clk,	//Reference Frequency
	input	wire						I_rst_n,	//Active Low Asynchronous Reset
	input	wire						I_clk_en,	//Clock Divider Block Enable 
	input	wire	[RATIO_WIDTH-1:0]	I_div_ratio, //The divided ratio (integer value)
	output	wire						o_div_clk
	);

reg		[RATIO_WIDTH-2:0]	Counter;
reg							toggle_low_flg;
wire	[RATIO_WIDTH-2:0]	Half;
wire						Even_flg;
reg							div_by_1_or_0;		
reg 						div_clk;


always@(posedge I_ref_clk, negedge I_rst_n)	begin
	if(!I_rst_n)	begin
		div_clk			<=	'b0;
		Counter			<=	'b1;
		toggle_low_flg	<=	'b0;
		div_by_1_or_0	<=	'b0;
	end
	else if(I_clk_en && ( I_div_ratio != 'b0) && ( I_div_ratio != 'b1))	 begin

		div_by_1_or_0	<=	'b0;

		if(Even_flg	&&	Counter == Half) begin    // if division ratio is even
			div_clk		<=	~div_clk;
			Counter		<=	'b1;
		end	
		else if(!Even_flg && Counter==Half)
			if(toggle_low_flg) begin
				div_clk			<=	~div_clk;
				Counter			<=	'b0;
				toggle_low_flg	<=	'b0;
			end
			else begin
				div_clk			<=	~div_clk;
				Counter			<=	'b1;
				toggle_low_flg	<=	'b1;
			end

		else begin
			// increment counter
			Counter	<=	Counter	+	'b1;
			
		end


	end
	else begin    // if enable = 0,or divide by 1 or 0, then clk_out =clk_in
			div_by_1_or_0	<=	'b1;
	end
	

end


assign Half	= I_div_ratio>>1;
assign Even_flg = ~(I_div_ratio[0]);
assign o_div_clk = (I_clk_en && !div_by_1_or_0) ? div_clk : I_ref_clk ;

endmodule