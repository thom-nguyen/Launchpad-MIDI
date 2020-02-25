module WaveAdder (input[15:0] playing,

input[5:0] wave0,
input[5:0] wave1,
input[5:0] wave2,
input[5:0] wave3,
input[5:0] wave4,
input[5:0] wave5,
input[5:0] wave6,
input[5:0] wave7,
input[5:0] wave8,
input[5:0] wave9,
input[5:0] wave10,
input[5:0] wave11,
input[5:0] wave12,
input[5:0] wave13,
input[5:0] wave14,
input[5:0] wave15,

output[5:0] newWave);
	
	//wire[16:0] sum;
	
	wire [8:0] sum;
	
	assign sum = wave0 + wave1 + wave2 + wave3 + wave4 + wave5 + wave6 + wave7 + wave8 + wave9 + wave10 + wave11 + wave12 + wave13 + wave14 + wave15;
	
	//reg[1:0] numWaves;
	
	reg [4:0] numWaves;
	
	
	integer i;
	
	/*
	i bound to 15
	*/
	always @(*)	begin
		numWaves = 5'b0;
		for (i = 0; i < 16; i = i + 1) begin
			numWaves = numWaves + playing[i];
		end
	end
	
	//wire[16:0] quotient;
	//wire[2:0] remain;
	
	wire[8:0] quotient;
	wire[4:0] remain;
	
	
	//CHANGE
	Divider waveDivider(.denom(numWaves), .numer(sum), .quotient(quotient), .remain(remain));
	//Divide2Waves waveDivider(.denom(numWaves), .numer(sum), .quotient(quotient), .remain(remain));
	
	assign newWave = quotient[5:0];
	
	
endmodule
	

	
			
	