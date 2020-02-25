module newSim(	
	//inputs
	//numSounds
	KEY,
	SW,
	
	//GPIO
	//GPIO_1,
	CLOCK_50
	
	//AUD_ADCDAT,
	
	// Bidirectionals
	//AUD_BCLK,
	//AUD_ADCLRCK,
	//AUD_DACLRCK,

	//FPGA_I2C_SDAT,

	// Outputs
	//AUD_XCK,
	//AUD_DACDAT,

	//FPGA_I2C_SCLK
);

//PARAMETERS FOR AUDIO CONTROLLER

//input				AUD_ADCDAT;
// Bidirectionals
//inout				AUD_BCLK;
//inout				AUD_ADCLRCK;
//inout				AUD_DACLRCK;
//inout				FPGA_I2C_SDAT;
// Outputs
//output				AUD_XCK;
//output				AUD_DACDAT;
//output				FPGA_I2C_SCLK;


//PARAMETERS FOR LAUNCHPAD IO

//input [35:0] GPIO_1;
input [3:0] KEY;
input [9:0] SW;
input CLOCK_50;


//MODULE: RATEDIVIDER (1)
//MAKES CLOCK (clock44) TO DETERMINE RATE AT WHICH SOUNDS WILL BE PARSED AT

//OUTPUT AT 44.100 kHz
wire [27:0] rate44, rate025;
assign rate44 = 28'b0000000000000000000000000001;	// 44.100 kHz => 1 132
assign rate025 = 28'b0000000000000000000000000100;	// 0.25 seconds

wire clock44, clock025;

RateDivider rd0 ( .reset(~KEY[0]), .rate(rate44), .clk(CLOCK_50), .out(clock44) );
RateDivider rd1 ( .reset(~KEY[0]), .rate(rate025), .clk(CLOCK_50), .out(clock025) );
 

//MODULE: WAVEMAKER (35)
//INPUTS (GPIO 0 -> 34) & (CLOCK44) & (DEPTH [34:0])
//OUTPUTS (ADDRESS 0 -> 34) & (RDEN 0 -> 34)
//WIRE (ADDRESS [34:0]) & (RDEN 0 -> 34) & (DEPTH [34:0])

localparam depth0 = 15'b000000000000100;
localparam depth1 = 15'b000000000000100;
/*
localparam depth2 = 15'b000011111111000;
localparam depth3 = 15'b101011000100010;
localparam depth4 = 15'b000011111111000;
localparam depth5 = 15'b101011000100010;
localparam depth6 = 15'b101011000100010;
localparam depth7 = 15'b000011111111000;
localparam depth8 = 15'b101011000100010;
localparam depth9 = 15'b000011111111000;
localparam depth10 = 15'b101011000100010;
localparam depth11 = 15'b101011000100010;
localparam depth12 = 15'b000011111111000;
localparam depth13 = 15'b101011000100010;
localparam depth14 = 15'b000011111111000;
localparam depth15 = 15'b101011000100010;
*/
	
wire [14:0] address0, address1;



/*
wire [14:0] address2;
wire [14:0] address3;
wire [14:0] address4;
wire [14:0] address5;
wire [14:0] address6;
wire [14:0] address7;
wire [14:0] address8;
wire [14:0] address9;
wire [14:0] address10;
wire [14:0] address11;
wire [14:0] address12;
wire [14:0] address13;
wire [14:0] address14;
wire [14:0] address15;
*/


//CHANNELS MODULES
wire [1:0] seqOut;
wire [14:0] addressch0, addressch1;
wire [1:0] chEn;

wire [1:0] chData;
assign chData[0] = ~KEY[1];
assign chData[1] = ~KEY[2];

Channel ch0 ( .mode( ~KEY[3] ), .playEn( SW[0] ), .clock( clock025 ), .data( chData ), .seqOut( seqOut ) );


wire [1:0] rden;
//WAVEMAKERS FOR BTNS
WaveMaker wm0 ( .enable( ~KEY[1] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth0 ), .address( address0 ), .playing( rden[0] ) );
WaveMaker wm1 ( .enable( ~KEY[2] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth1 ), .address( address1 ), .playing( rden[1] ) );
//WAVEMAKERS FOR CHS
WaveMaker wmch0 ( .enable( seqOut[0] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth0 ), .address( addressch0 ), .playing( chEn[0] ) );
WaveMaker wmch1 ( .enable( seqOut[1] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth1 ), .address( addressch1 ), .playing( chEn[1] ) );

/*
WaveMaker wm2 ( .enable( ~KEY[3] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth2 ), .address( address2 ), .playing( rden[2] ) );
WaveMaker wm3 ( .enable( GPIO_1[3] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth3 ), .address( address3 ), .playing( rden[3] ) );
WaveMaker wm4 ( .enable( GPIO_1[4] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth4 ), .address( address4 ), .playing( rden[4] ) );
WaveMaker wm5 ( .enable( GPIO_1[5] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth5 ), .address( address5 ), .playing( rden[5] ) );
WaveMaker wm6 ( .enable( GPIO_1[6] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth6 ), .address( address6 ), .playing( rden[6] ) );
WaveMaker wm7 ( .enable( GPIO_1[7] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth7 ), .address( address7 ), .playing( rden[7] ) );
WaveMaker wm8 ( .enable( GPIO_1[8] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth8 ), .address( address8 ), .playing( rden[8] ) );
WaveMaker wm9 ( .enable( GPIO_1[9] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth9 ), .address( address9 ), .playing( rden[9] ) );
WaveMaker wm10 ( .enable( GPIO_1[10] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth10 ), .address( address10 ), .playing( rden[10] ) );
WaveMaker wm11 ( .enable( GPIO_1[11] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth11 ), .address( address11 ), .playing( rden[11] ) );
WaveMaker wm12 ( .enable( GPIO_1[12] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth12 ), .address( address12 ), .playing( rden[12] ) );
WaveMaker wm13 ( .enable( GPIO_1[13] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth13 ), .address( address13 ), .playing( rden[13] ) );
WaveMaker wm14 ( .enable( GPIO_1[14] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth14 ), .address( address14 ), .playing( rden[14] ) );
WaveMaker wm15 ( .enable( GPIO_1[15] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth15 ), .address( address15 ), .playing( rden[15] ) );
*/


//ALL RAMS GO HERE (35)
//INPUTS (ADDRESS 0 -> 34) & (RDEN 0 ->34) & (CLOCK44)
//OUTPUTS (SOUNDOUT 0 -> 34)
//WIRE (SOUNDOUT [34:0])


wire [15:0] soundOut0, soundOut1;
/*
wire [15:0] soundOut2;
wire [15:0] soundOut3;
wire [15:0] soundOut4;
wire [15:0] soundOut5;
wire [15:0] soundOut6;
wire [15:0] soundOut7;
wire [15:0] soundOut8;
wire [15:0] soundOut9;
wire [15:0] soundOut10;
wire [15:0] soundOut11;
wire [15:0] soundOut12;
wire [15:0] soundOut13;
wire [15:0] soundOut14;
wire [15:0] soundOut15;

*/


//ENABLER MODULES GOES HERE
wire [1:0] enable;
Enabler ench0 ( .btn(rden[0]), .ch(chEn[0]), .enable(enable[0]) );
Enabler ench1 ( .btn(rden[1]), .ch(chEn[1]), .enable(enable[1]) );


reg [14:0] adRegOut0, adRegOut1;

initial adRegOut0 = 15'b0;
initial adRegOut1 = 15'b0;

wire [14:0] adOut0, adOut1;

always @ (posedge clock44) begin

	if (rden[0])
		adRegOut0 = address0;
	else if (chEn[0])
		adRegOut0 = addressch0;
		
	if (rden[1])
		adRegOut1 = address1;
	else if (chEn[1])
		adRegOut1 = addressch1;

end

assign adOut0 = adRegOut0;
assign adOut1 = adRegOut1;

//RAM RDEN TAKES IN RESULT OF ENABLE MODULE
RAM0 r0( .address( adOut0 ), .clock(clock44), .rden( enable[0] ), .q(soundOut0));
RAM1 r1( .address( adOut1 ), .clock(clock44), .rden( enable[1] ), .q(soundOut1));

//CHANGE

/*
RAM0 r2( .address( adOut0 ), .clock(clock44), .rden( enable[0] ), .q(soundOut2));
RAM0 r3( .address( adOut0 ), .clock(clock44), .rden( enable[0] ), .q(soundOut3));
RAM0 r4( .address( adOut0 ), .clock(clock44), .rden( enable[0] ), .q(soundOut4));
RAM0 r5( .address( adOut0 ), .clock(clock44), .rden( enable[0] ), .q(soundOut5));
RAM0 r6( .address( adOut0 ), .clock(clock44), .rden( enable[0] ), .q(soundOut6));
RAM0 r7( .address( adOut0 ), .clock(clock44), .rden( enable[0] ), .q(soundOut7));
RAM0 r8( .address( adOut0 ), .clock(clock44), .rden( enable[0] ), .q(soundOut8));
RAM0 r9( .address( adOut0 ), .clock(clock44), .rden( enable[0] ), .q(soundOut9));
RAM0 r10( .address( adOut0 ), .clock(clock44), .rden( enable[0] ), .q(soundOut10));
RAM0 r11( .address( adOut0 ), .clock(clock44), .rden( enable[0] ), .q(soundOut11));
RAM0 r12( .address( adOut0 ), .clock(clock44), .rden( enable[0] ), .q(soundOut12));
RAM0 r13( .address( adOut0 ), .clock(clock44), .rden( enable[0] ), .q(soundOut13));
RAM0 r14( .address( adOut0 ), .clock(clock44), .rden( enable[0] ), .q(soundOut14));
RAM0 r15( .address( adOut0 ), .clock(clock44), .rden( enable[0] ), .q(soundOut15));

*/


reg [15:0] soundToAddReg0, soundToAddReg1;

initial soundToAddReg0 = 16'b0;
initial soundToAddReg1 = 16'b0;

wire [15:0] soundToAdd0, soundToAdd1;

always @ (posedge clock44) begin
	if (enable[0])
		soundToAddReg0 = soundOut0;
	else
		soundToAddReg0 = 16'b0;
	if (enable[1])
		soundToAddReg1 = soundOut1;
	else
		soundToAddReg1 = 16'b0;
end
	
assign soundToAdd0 = soundToAddReg0;
assign soundToAdd1 = soundToAddReg1;



//MODULE: WAVEADDER (1)
//INPUTS (SOUNDOUT[34:0]) & (CLOCK44)
//OUTPUTS (SOUND16)
//WIRE (SOUND16)

// [15:0] sound16;

//WAVE ADDER TAKES IN ENABLE FROM BTNS AND CHANNELS
/*
WaveAdder wa0 (
	.newWave( sound16 ), .playing( enable ), 
	.wave0 ( soundToAdd0 ),
	.wave1 ( soundToAdd1 )
);
*/
//MODULE: AUDIOADAPTER (1)
//INPUTS (DE1 PORTS) & (SOUND16 CONCATENATED TO 32)
//OUTPUTS (DE1 PORTS) & (SPEAKER SOUND)
//WIRE (SOUND32)

//wire [31:0] sound32;
/*
//concatenate to send audio adapter 32 bit sound
assign sound32 = {5'b0, sound16, 11'b0};																	

audioAdapter aa0 ( 
	.resetn(KEY[0]), 
	.soundOut(sound32), 
	.CLOCK_50(CLOCK_50), 
	.AUD_ADCDAT(AUD_ADCDAT), 
	.AUD_BCLK(AUD_BCLK), 
	.AUD_ADCLRCK(AUD_ADCLRCK),
	.AUD_DACLRCK(AUD_DACLRCK), 
	.FPGA_I2C_SDAT(FPGA_I2C_SDAT),
	.AUD_XCK(AUD_XCK),
	.AUD_DACDAT(AUD_DACDAT),
	.FPGA_I2C_SCLK(FPGA_I2C_SCLK)
);


*/


endmodule