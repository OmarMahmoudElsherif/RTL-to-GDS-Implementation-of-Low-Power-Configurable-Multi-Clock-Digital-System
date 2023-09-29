
module	PULSE_GEN (
	input			wire					CLK,
	input			wire					RST,
	input			wire					LVL_SIG,
	output			wire					PULSE_SIG
	);

//Pulse generator FlipFlop
reg						Pulse_Gen_FF;						


// Sequential
always @(posedge CLK or negedge RST) begin
	if (!RST) begin
		Pulse_Gen_FF	<=		'b0;
	end
	else  begin
		//Pulse Generator
		Pulse_Gen_FF	<=		LVL_SIG;
	end
end



//Generated Pulse
assign 	PULSE_SIG	=	(~Pulse_Gen_FF) & LVL_SIG;




endmodule