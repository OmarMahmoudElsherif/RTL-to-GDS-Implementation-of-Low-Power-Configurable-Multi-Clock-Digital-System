
module RST_SYNC #(
	parameter		NUM_STAGES = 2 	//default value
	)
	(
	input		wire		CLK,
	input		wire		RST,
	output		wire		SYNC_RST
	);


// Synchronization FlipFlops
reg	[NUM_STAGES-1:0]	Sync_FFs;



always @(posedge CLK or negedge RST) begin
	if (!RST) begin
		Sync_FFs		<=		'b0;		
	end
	else  begin
		Sync_FFs		<=		{	Sync_FFs[NUM_STAGES-2:0], 1'b1	};	
	end
		
end

assign 	SYNC_RST	=	Sync_FFs[NUM_STAGES-1];




endmodule