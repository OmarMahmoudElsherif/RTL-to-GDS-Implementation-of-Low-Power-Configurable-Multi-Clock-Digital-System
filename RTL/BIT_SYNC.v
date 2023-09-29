
module BIT_SYNC #(
	parameter	BUS_WIDTH	=	1, 	//default value
	parameter	NUM_STAGES 	= 	2	//default value
	)

	(
	input	wire		[BUS_WIDTH-1:0]		ASYNC,
	input	wire							CLK,
	input	wire							RST,
	output	reg			[BUS_WIDTH-1:0]		SYNC
	
	);


// Synchronization FlipFlops
reg	[NUM_STAGES-1:0]	Sync_FFs	[BUS_WIDTH-1:0];

//iterator
integer i;


always @(posedge CLK or negedge RST) begin
	if (!RST) begin
		
		for(i=0;i<BUS_WIDTH;i=i+1) begin
			Sync_FFs[i]		<=		'b0;
		end
		
	end
	else  begin

		for(i=0;i<BUS_WIDTH;i=i+1) begin
			Sync_FFs[i]		<=		{	Sync_FFs[i][NUM_STAGES-2:0], ASYNC[i]	};	
		end
		
	end
end

//Assiging output
always @(*)
 begin
  for (i=0; i<BUS_WIDTH; i=i+1)
    SYNC[i] = Sync_FFs[i][NUM_STAGES-1] ; 
 end 





endmodule