module playSound(	
	//inputs
	//numSounds
	KEY,
	SW,
	
	//GPIO
	GPIO_0,
	CLOCK_50,
	
	AUD_ADCDAT,
	
	// Bidirectionals
	AUD_BCLK,
	AUD_ADCLRCK,
	AUD_DACLRCK,

	FPGA_I2C_SDAT,

	// Outputs
	AUD_XCK,
	AUD_DACDAT,

	FPGA_I2C_SCLK
);

//PARAMETERS FOR AUDIO CONTROLLER

input				AUD_ADCDAT;
// Bidirectionals
inout				AUD_BCLK;
inout				AUD_ADCLRCK;
inout				AUD_DACLRCK;
inout				FPGA_I2C_SDAT;
// Outputs
output				AUD_XCK;
output				AUD_DACDAT;
output				FPGA_I2C_SCLK;


//PARAMETERS FOR LAUNCHPAD IO

input [35:0] GPIO_0;
input [3:0] KEY;
input [9:0] SW;
input CLOCK_50;


//MODULE: RATEDIVIDER (1)
//MAKES CLOCK (clock44) TO DETERMINE RATE AT WHICH SOUNDS WILL BE PARSED AT

//OUTPUT AT 44.100 kHz
wire [27:0] rate44, rate025;
assign rate44 = 28'b0000000000000000010001101100;	// 44.100 kHz => 1 132
assign rate025 = 28'b0000101111101011110000011111;	// 4Hz => 0.25 seconds

wire clock44, clock025;

RateDivider rd0 ( .reset(~KEY[0]), .rate(rate44), .clk(CLOCK_50), .out(clock44) );
RateDivider rd1 ( .reset(~KEY[0]), .rate(rate025), .clk(CLOCK_50), .out(clock025) );
  

//MODULE: WAVEMAKER (35)
//INPUTS (GPIO 0 -> 34) & (CLOCK44) & (DEPTH [34:0])
//OUTPUTS (ADDRESS 0 -> 34) & (RDEN 0 -> 34)
//WIRE (ADDRESS [34:0]) & (RDEN 0 -> 34) & (DEPTH [34:0])

localparam depth0 = 15'b010001001110100;
localparam depth1 = 15'b010001001110100;
localparam depth2 = 15'b010001001110100;
localparam depth3 = 15'b010111101001111;
localparam depth4 = 15'b010001001110100;
localparam depth5 = 15'b010001001110100;
localparam depth6 = 15'b010001001110100;
localparam depth7 = 15'b010000010110011;
localparam depth8 = 15'b010001001110100;
localparam depth9 = 15'b010001001110100;
localparam depth10 = 15'b010001001110100;
localparam depth11 = 15'b110011001001000;
localparam depth12 = 15'b010000011000110;
localparam depth13 = 15'b010000011000110;
localparam depth14 = 15'b010000011000110;
localparam depth15 = 15'b110011001001000;

	
	
wire [14:0] address0;
wire [14:0] address1;
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


//CHANNELS MODULES
//wire [1:0] seqOut;

wire [15:0] ch0SeqOut, ch1SeqOut, ch2SeqOut;


//wire [14:0] addressch0, addressch1;

wire [14:0] ch0Ad0, ch0Ad1, ch0Ad2, ch0Ad3, ch0Ad4, ch0Ad5, ch0Ad6, ch0Ad7, ch0Ad8, ch0Ad9, ch0Ad10, ch0Ad11, ch0Ad12, ch0Ad13, ch0Ad14, ch0Ad15;
wire [14:0] ch1Ad0, ch1Ad1, ch1Ad2, ch1Ad3, ch1Ad4, ch1Ad5, ch1Ad6, ch1Ad7, ch1Ad8, ch1Ad9, ch1Ad10, ch1Ad11, ch1Ad12, ch1Ad13, ch1Ad14, ch1Ad15;
wire [14:0] ch2Ad0, ch2Ad1, ch2Ad2, ch2Ad3, ch2Ad4, ch2Ad5, ch2Ad6, ch2Ad7, ch2Ad8, ch2Ad9, ch2Ad10, ch2Ad11, ch2Ad12, ch2Ad13, ch2Ad14, ch2Ad15;



//wire [1:0] chEn;

wire [15:0] ch0En, ch1En, ch2En;



//wire [1:0] chData;
//assign chData[0] = ~KEY[1];
//assign chData[1] = ~KEY[2];
//Channel ch0 (.mode(~KEY[3]), .clear(~KEY[0]), .playEn(SW[0]), .clock(clock44), .data(chData), .seqOut(seqOut));
//ChannelHardCodePlay ch0 (.mode(~KEY[3]), .clear(~KEY[0]), .playEn(SW[0]), .clock(clock44), .data(chData), .seqOut(seqOut));


wire [15:0] chData;
//ASSUME THESE GPIOs ARE RIGHT
//assign chData = 16'b0;
assign chData = {1'b0,SW[3],SW[4],SW[5],SW[6],SW[7],SW[8], SW[9], GPIO_0[7],GPIO_0[6],GPIO_0[5],GPIO_0[4],GPIO_0[3],GPIO_0[2],GPIO_0[1],GPIO_0[0]};
Channel ch0 (.mode(~KEY[1]), .clear(~KEY[0]), .playEn(SW[0]), .clock(clock44), .data(chData), .seqOut(ch0SeqOut));
Channel ch1 (.mode(~KEY[2]), .clear(~KEY[0]), .playEn(SW[1]), .clock(clock44), .data(chData), .seqOut(ch1SeqOut));
Channel ch2 (.mode(~KEY[3]), .clear(~KEY[0]), .playEn(SW[2]), .clock(clock44), .data(chData), .seqOut(ch2SeqOut));



//wire [1:0] rden;

wire [15:0] rden;


//WAVEMAKERS FOR BTNS
//WaveMaker wm0 ( .enable( ~KEY[1] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth0 ), .address( address0 ), .playing( rden[0] ) );
//WaveMaker wm1 ( .enable( ~KEY[2] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth1 ), .address( address1 ), .playing( rden[1] ) );

WaveMaker wm0 ( .enable( GPIO_0[0] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth0 ), .address( address0 ), .playing( rden[0] ) );
WaveMaker wm1 ( .enable( GPIO_0[1] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth1 ), .address( address1 ), .playing( rden[1] ) );
WaveMaker wm2 ( .enable( GPIO_0[2] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth2 ), .address( address2 ), .playing( rden[2] ) );
WaveMaker wm3 ( .enable( GPIO_0[3] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth3 ), .address( address3 ), .playing( rden[3] ) );
WaveMaker wm4 ( .enable( GPIO_0[4] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth4 ), .address( address4 ), .playing( rden[4] ) );
WaveMaker wm5 ( .enable( GPIO_0[5] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth5 ), .address( address5 ), .playing( rden[5] ) );
WaveMaker wm6 ( .enable( GPIO_0[6] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth6 ), .address( address6 ), .playing( rden[6] ) );
WaveMaker wm7 ( .enable( GPIO_0[7] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth7 ), .address( address7 ), .playing( rden[7] ) );
WaveMaker wm8 ( .enable( SW[9] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth8 ), .address( address8 ), .playing( rden[8] ) );
WaveMaker wm9 ( .enable( SW[8] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth9 ), .address( address9 ), .playing( rden[9] ) );
WaveMaker wm10 ( .enable( SW[7] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth10 ), .address( address10 ), .playing( rden[10] ) );
WaveMaker wm11 ( .enable( SW[6] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth11 ), .address( address11 ), .playing( rden[11] ) );
WaveMaker wm12 ( .enable( SW[5] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth12 ), .address( address12 ), .playing( rden[12] ) );
WaveMaker wm13 ( .enable( SW[4] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth13 ), .address( address13 ), .playing( rden[13] ) );
WaveMaker wm14 ( .enable( SW[3] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth14 ), .address( address14 ), .playing( rden[14] ) );
WaveMaker wm15 ( .enable( 0 ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth15 ), .address( address15 ), .playing( rden[15] ) );
//WAVEMAKERS FOR CHS
//WaveMaker wmch0 ( .enable( seqOut[0] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth0 ), .address( addressch0 ), .playing( chEn[0] ) );
//WaveMaker wmch1 ( .enable( seqOut[1] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth1 ), .address( addressch1 ), .playing( chEn[1] ) );

//16 PER CHANNEL; 3 CHANNELS

WaveMaker ch0wm0 ( .enable( ch0SeqOut[0] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth0 ), .address( ch0Ad0 ), .playing( ch0En[0] ) );
WaveMaker ch0wm1 ( .enable( ch0SeqOut[1] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth1 ), .address( ch0Ad1 ), .playing( ch0En[1] ) );
WaveMaker ch0wm2 ( .enable( ch0SeqOut[2] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth2 ), .address( ch0Ad2 ), .playing( ch0En[2] ) );
WaveMaker ch0wm3 ( .enable( ch0SeqOut[3] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth3 ), .address( ch0Ad3 ), .playing( ch0En[3] ) );
WaveMaker ch0wm4 ( .enable( ch0SeqOut[4] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth4 ), .address( ch0Ad4 ), .playing( ch0En[4] ) );
WaveMaker ch0wm5 ( .enable( ch0SeqOut[5] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth5 ), .address( ch0Ad5 ), .playing( ch0En[5] ) );
WaveMaker ch0wm6 ( .enable( ch0SeqOut[6] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth6 ), .address( ch0Ad6 ), .playing( ch0En[6] ) );
WaveMaker ch0wm7 ( .enable( ch0SeqOut[7] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth7 ), .address( ch0Ad7 ), .playing( ch0En[7] ) );
WaveMaker ch0wm8 ( .enable( ch0SeqOut[8] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth8 ), .address( ch0Ad8 ), .playing( ch0En[8] ) );
WaveMaker ch0wm9 ( .enable( ch0SeqOut[9] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth9 ), .address( ch0Ad9 ), .playing( ch0En[9] ) );
WaveMaker ch0wm10 ( .enable( ch0SeqOut[10] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth10 ), .address( ch0Ad10 ), .playing( ch0En[10] ) );
WaveMaker ch0wm11 ( .enable( ch0SeqOut[11] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth11 ), .address( ch0Ad11 ), .playing( ch0En[11] ) );
WaveMaker ch0wm12 ( .enable( ch0SeqOut[12] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth12 ), .address( ch0Ad12 ), .playing( ch0En[12] ) );
WaveMaker ch0wm13 ( .enable( ch0SeqOut[13] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth13 ), .address( ch0Ad13 ), .playing( ch0En[13] ) );
WaveMaker ch0wm14 ( .enable( ch0SeqOut[14] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth14 ), .address( ch0Ad14 ), .playing( ch0En[14] ) );
WaveMaker ch0wm15 ( .enable( ch0SeqOut[15] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth15 ), .address( ch0Ad15 ), .playing( ch0En[15] ) );

WaveMaker ch1wm0 ( .enable( ch1SeqOut[0] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth0 ), .address( ch1Ad0 ), .playing( ch1En[0] ) );
WaveMaker ch1wm1 ( .enable( ch1SeqOut[1] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth1 ), .address( ch1Ad1 ), .playing( ch1En[1] ) );
WaveMaker ch1wm2 ( .enable( ch1SeqOut[2] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth2 ), .address( ch1Ad2 ), .playing( ch1En[2] ) );
WaveMaker ch1wm3 ( .enable( ch1SeqOut[3] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth3 ), .address( ch1Ad3 ), .playing( ch1En[3] ) );
WaveMaker ch1wm4 ( .enable( ch1SeqOut[4] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth4 ), .address( ch1Ad4 ), .playing( ch1En[4] ) );
WaveMaker ch1wm5 ( .enable( ch1SeqOut[5] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth5 ), .address( ch1Ad5 ), .playing( ch1En[5] ) );
WaveMaker ch1wm6 ( .enable( ch1SeqOut[6] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth6 ), .address( ch1Ad6 ), .playing( ch1En[6] ) );
WaveMaker ch1wm7 ( .enable( ch1SeqOut[7] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth7 ), .address( ch1Ad7 ), .playing( ch1En[7] ) );
WaveMaker ch1wm8 ( .enable( ch1SeqOut[8] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth8 ), .address( ch1Ad8 ), .playing( ch1En[8] ) );
WaveMaker ch1wm9 ( .enable( ch1SeqOut[9] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth9 ), .address( ch1Ad9 ), .playing( ch1En[9] ) );
WaveMaker ch1wm10 ( .enable( ch1SeqOut[10] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth10 ), .address( ch1Ad10 ), .playing( ch1En[10] ) );
WaveMaker ch1wm11 ( .enable( ch1SeqOut[11] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth11 ), .address( ch1Ad11 ), .playing( ch1En[11] ) );
WaveMaker ch1wm12 ( .enable( ch1SeqOut[12] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth12 ), .address( ch1Ad12 ), .playing( ch1En[12] ) );
WaveMaker ch1wm13 ( .enable( ch1SeqOut[13] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth13 ), .address( ch1Ad13 ), .playing( ch1En[13] ) );
WaveMaker ch1wm14 ( .enable( ch1SeqOut[14] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth14 ), .address( ch1Ad14 ), .playing( ch1En[14] ) );
WaveMaker ch1wm15 ( .enable( ch1SeqOut[15] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth15 ), .address( ch1Ad15 ), .playing( ch1En[15] ) );

WaveMaker ch2wm0 ( .enable( ch2SeqOut[0] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth0 ), .address( ch2Ad0 ), .playing( ch2En[0] ) );
WaveMaker ch2wm1 ( .enable( ch2SeqOut[1] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth1 ), .address( ch2Ad1 ), .playing( ch2En[1] ) );
WaveMaker ch2wm2 ( .enable( ch2SeqOut[2] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth2 ), .address( ch2Ad2 ), .playing( ch2En[2] ) );
WaveMaker ch2wm3 ( .enable( ch2SeqOut[3] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth3 ), .address( ch2Ad3 ), .playing( ch2En[3] ) );
WaveMaker ch2wm4 ( .enable( ch2SeqOut[4] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth4 ), .address( ch2Ad4 ), .playing( ch2En[4] ) );
WaveMaker ch2wm5 ( .enable( ch2SeqOut[5] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth5 ), .address( ch2Ad5 ), .playing( ch2En[5] ) );
WaveMaker ch2wm6 ( .enable( ch2SeqOut[6] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth6 ), .address( ch2Ad6 ), .playing( ch2En[6] ) );
WaveMaker ch2wm7 ( .enable( ch2SeqOut[7] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth7 ), .address( ch2Ad7 ), .playing( ch2En[7] ) );
WaveMaker ch2wm8 ( .enable( ch2SeqOut[8] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth8 ), .address( ch2Ad8 ), .playing( ch2En[8] ) );
WaveMaker ch2wm9 ( .enable( ch2SeqOut[9] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth9 ), .address( ch2Ad9 ), .playing( ch2En[9] ) );
WaveMaker ch2wm10 ( .enable( ch2SeqOut[10] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth10 ), .address( ch2Ad10 ), .playing( ch2En[10] ) );
WaveMaker ch2wm11 ( .enable( ch2SeqOut[11] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth11 ), .address( ch2Ad11 ), .playing( ch2En[11] ) );
WaveMaker ch2wm12 ( .enable( ch2SeqOut[12] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth12 ), .address( ch2Ad12 ), .playing( ch2En[12] ) );
WaveMaker ch2wm13 ( .enable( ch2SeqOut[13] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth13 ), .address( ch2Ad13 ), .playing( ch2En[13] ) );
WaveMaker ch2wm14 ( .enable( ch2SeqOut[14] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth14 ), .address( ch2Ad14 ), .playing( ch2En[14] ) );
WaveMaker ch2wm15 ( .enable( ch2SeqOut[15] ), .reset( ~KEY[0] ), .clock( clock44 ), .depth( depth15 ), .address( ch2Ad15 ), .playing( ch2En[15] ) );



//ALL RAMS GO HERE (35)
//INPUTS (ADDRESS 0 -> 34) & (RDEN 0 ->34) & (CLOCK44)
//OUTPUTS (SOUNDOUT 0 -> 34)
//WIRE (SOUNDOUT [34:0])


wire [5:0] soundOut0;
wire [5:0] soundOut1;
wire [5:0] soundOut2;
wire [5:0] soundOut3;
wire [5:0] soundOut4;
wire [5:0] soundOut5;
wire [5:0] soundOut6;
wire [5:0] soundOut7;
wire [5:0] soundOut8;
wire [5:0] soundOut9;
wire [5:0] soundOut10;
wire [5:0] soundOut11;
wire [5:0] soundOut12;
wire [5:0] soundOut13;
wire [5:0] soundOut14;
wire [5:0] soundOut15;



//ENABLER MODULES GOES HERE
//wire [1:0] enable;
//Enabler en0 ( .btn(rden[0]), .ch(chEn[0]), .enable(enable[0]) );
//Enabler en1 ( .btn(rden[1]), .ch(chEn[1]), .enable(enable[1]) );


wire[15:0] enable;
Enabler en0 ( .btn(rden[0]), .ch0(ch0En[0]), .ch1(ch1En[0]), .ch2(ch2En[0]), .enable(enable[0]) );
Enabler en1 ( .btn(rden[1]), .ch0(ch0En[1]), .ch1(ch1En[1]), .ch2(ch2En[1]), .enable(enable[1]) );
Enabler en2 ( .btn(rden[2]), .ch0(ch0En[2]), .ch1(ch1En[2]), .ch2(ch2En[2]), .enable(enable[2]) );
Enabler en3 ( .btn(rden[3]), .ch0(ch0En[3]), .ch1(ch1En[3]), .ch2(ch2En[3]), .enable(enable[3]) );
Enabler en4 ( .btn(rden[4]), .ch0(ch0En[4]), .ch1(ch1En[4]), .ch2(ch2En[4]), .enable(enable[4]) );
Enabler en5 ( .btn(rden[5]), .ch0(ch0En[5]), .ch1(ch1En[5]), .ch2(ch2En[5]), .enable(enable[5]) );
Enabler en6 ( .btn(rden[6]), .ch0(ch0En[6]), .ch1(ch1En[6]), .ch2(ch2En[6]), .enable(enable[6]) );
Enabler en7 ( .btn(rden[7]), .ch0(ch0En[7]), .ch1(ch1En[7]), .ch2(ch2En[7]), .enable(enable[7]) );
Enabler en8 ( .btn(rden[8]), .ch0(ch0En[8]), .ch1(ch1En[8]), .ch2(ch2En[8]), .enable(enable[8]) );
Enabler en9 ( .btn(rden[9]), .ch0(ch0En[9]), .ch1(ch1En[9]), .ch2(ch2En[9]), .enable(enable[9]) );
Enabler en10 ( .btn(rden[10]), .ch0(ch0En[10]), .ch1(ch1En[10]), .ch2(ch2En[10]), .enable(enable[10]) );
Enabler en11 ( .btn(rden[11]), .ch0(ch0En[11]), .ch1(ch1En[11]), .ch2(ch2En[11]), .enable(enable[11]) );
Enabler en12 ( .btn(rden[12]), .ch0(ch0En[12]), .ch1(ch1En[12]), .ch2(ch2En[12]), .enable(enable[12]) );
Enabler en13 ( .btn(rden[13]), .ch0(ch0En[13]), .ch1(ch1En[13]), .ch2(ch2En[13]), .enable(enable[13]) );
Enabler en14 ( .btn(rden[14]), .ch0(ch0En[14]), .ch1(ch1En[14]), .ch2(ch2En[14]), .enable(enable[14]) );
Enabler en15 ( .btn(rden[15]), .ch0(ch0En[15]), .ch1(ch1En[15]), .ch2(ch2En[15]), .enable(enable[15]) );





//reg [14:0] adRegOut0, adRegOut1;

reg [14:0] adRegOut0, adRegOut1, adRegOut2, adRegOut3, adRegOut4, adRegOut5, adRegOut6, adRegOut7, adRegOut8, adRegOut9, adRegOut10, adRegOut11;
reg [14:0] adRegOut12, adRegOut13, adRegOut14, adRegOut15;


//initial adRegOut0 = 15'b0;
//initial adRegOut1 = 15'b0;

initial adRegOut0 = 15'b0;
initial adRegOut1 = 15'b0;
initial adRegOut2 = 15'b0;
initial adRegOut3 = 15'b0;
initial adRegOut4 = 15'b0;
initial adRegOut5 = 15'b0;
initial adRegOut6 = 15'b0;
initial adRegOut7 = 15'b0;
initial adRegOut8 = 15'b0;
initial adRegOut9 = 15'b0;
initial adRegOut10 = 15'b0;
initial adRegOut11 = 15'b0;
initial adRegOut12 = 15'b0;
initial adRegOut13 = 15'b0;
initial adRegOut14 = 15'b0;
initial adRegOut15 = 15'b0;



//wire [14:0] adOut0, adOut1;

wire [14:0] adOut0, adOut1, adOut2, adOut3, adOut4, adOut5, adOut6, adOut7, adOut8, adOut9, adOut10, adOut11, adOut12, adOut13, adOut14, adOut15; 



always @ (posedge clock44) begin
	/*
	if (rden[0])
		adRegOut0 = address0;
	else if (chEn[0])
		adRegOut0 = addressch0;
		
	if (rden[1])
		adRegOut1 = address1;
	else if (chEn[1])
		adRegOut1 = addressch1;
	*/
	
	if (rden[0])
		adRegOut0 = address0;
	else if (ch0En[0])
		adRegOut0 = ch0Ad0;
	else if (ch1En[0])
		adRegOut0 = ch1Ad0;
	else if (ch2En[0])
		adRegOut0 = ch2Ad0;
	
	if (rden[1])
		adRegOut1 = address1;
	else if (ch0En[1])
		adRegOut1 = ch0Ad1;
	else if (ch1En[1])
		adRegOut1 = ch1Ad1;
	else if (ch2En[1])
		adRegOut1 = ch2Ad1;
		
	if (rden[2])
		adRegOut2 = address2;
	else if (ch0En[2])
		adRegOut2 = ch0Ad2;
	else if (ch1En[2])
		adRegOut2 = ch1Ad2;
	else if (ch2En[2])
		adRegOut2 = ch2Ad2;
	
	if (rden[3])
		adRegOut3 = address3;
	else if (ch0En[3])
		adRegOut3 = ch0Ad3;
	else if (ch1En[3])
		adRegOut3 = ch1Ad3;
	else if (ch2En[3])
		adRegOut3 = ch2Ad3;
	
	if (rden[4])
		adRegOut4 = address4;
	else if (ch0En[4])
		adRegOut4 = ch0Ad4;
	else if (ch1En[4])
		adRegOut4 = ch1Ad4;
	else if (ch2En[4])
		adRegOut4 = ch2Ad4;

	if (rden[5])
		adRegOut5 = address5;
	else if (ch0En[5])
		adRegOut5 = ch0Ad5;
	else if (ch1En[5])
		adRegOut5 = ch1Ad5;
	else if (ch2En[5])
		adRegOut5 = ch2Ad5;
	
	if (rden[6])
		adRegOut6 = address6;
	else if (ch0En[6])
		adRegOut6 = ch0Ad6;
	else if (ch1En[6])
		adRegOut6 = ch1Ad6;
	else if (ch2En[6])
		adRegOut6 = ch2Ad6;

		
	if (rden[7])
		adRegOut7 = address7;
	else if (ch0En[7])
		adRegOut7 = ch0Ad7;
	else if (ch1En[7])
		adRegOut7 = ch1Ad7;
	else if (ch2En[7])
		adRegOut7 = ch2Ad7;
	
	if (rden[8])
		adRegOut8 = address8;
	else if (ch0En[8])
		adRegOut8 = ch0Ad8;
	else if (ch1En[8])
		adRegOut8 = ch1Ad8;
	else if (ch2En[8])
		adRegOut8 = ch2Ad8;
	
	if (rden[9])
		adRegOut9 = address9;
	else if (ch0En[9])
		adRegOut9 = ch0Ad9;
	else if (ch1En[9])
		adRegOut9 = ch1Ad9;
	else if (ch2En[9])
		adRegOut9 = ch2Ad9;

	if (rden[10])
		adRegOut10 = address10;
	else if (ch0En[10])
		adRegOut10 = ch0Ad10;
	else if (ch1En[10])
		adRegOut10 = ch1Ad10;
	else if (ch2En[10])
		adRegOut10 = ch2Ad10;
	
	
	if (rden[11])
		adRegOut11 = address11;
	else if (ch0En[11])
		adRegOut11 = ch0Ad11;
	else if (ch1En[11])
		adRegOut11 = ch1Ad11;
	else if (ch2En[11])
		adRegOut11 = ch2Ad11;
		
	if (rden[12])
		adRegOut12 = address12;
	else if (ch0En[12])
		adRegOut12 = ch0Ad12;
	else if (ch1En[12])
		adRegOut12 = ch1Ad12;
	else if (ch2En[12])
		adRegOut12 = ch2Ad12;
	
	if (rden[13])
		adRegOut13 = address13;
	else if (ch0En[13])
		adRegOut13 = ch0Ad13;
	else if (ch1En[13])
		adRegOut13 = ch1Ad13;
	else if (ch2En[13])
		adRegOut13 = ch2Ad13;
	
	if (rden[14])
		adRegOut14 = address14;
	else if (ch0En[14])
		adRegOut14 = ch0Ad14;
	else if (ch1En[14])
		adRegOut14 = ch1Ad14;
	else if (ch2En[14])
		adRegOut14 = ch2Ad14;

	if (rden[15])
		adRegOut15 = address15;
	else if (ch0En[15])
		adRegOut15 = ch0Ad15;
	else if (ch1En[15])
		adRegOut15 = ch1Ad15;
	else if (ch2En[15])
		adRegOut15 = ch2Ad15;
	
	

end

//assign adOut0 = adRegOut0;
//assign adOut1 = adRegOut1;

assign adOut0 = adRegOut0;
assign adOut1 = adRegOut1;
assign adOut2 = adRegOut2;
assign adOut3 = adRegOut3;
assign adOut4 = adRegOut4;
assign adOut5 = adRegOut5;
assign adOut6 = adRegOut6;
assign adOut7 = adRegOut7;
assign adOut8 = adRegOut8;
assign adOut9 = adRegOut9;
assign adOut10 = adRegOut10;
assign adOut11 = adRegOut11;
assign adOut12 = adRegOut12;
assign adOut13 = adRegOut13;
assign adOut14 = adRegOut14;
assign adOut15 = adRegOut15;




//RAM RDEN TAKES IN RESULT OF ENABLE MODULE
nRAM0 r0( .address( adOut0 ), .clock(clock44), .rden( enable[0] ), .q(soundOut0));
nRAM1 r1( .address( adOut1 ), .clock(clock44), .rden( enable[1] ), .q(soundOut1));
nRAM2 r2( .address( adOut2 ), .clock(clock44), .rden( enable[2] ), .q(soundOut2));
nRAM3 r3( .address( adOut3 ), .clock(clock44), .rden( enable[3] ), .q(soundOut3));
nRAM4 r4( .address( adOut4 ), .clock(clock44), .rden( enable[4] ), .q(soundOut4));
nRAM5 r5( .address( adOut5 ), .clock(clock44), .rden( enable[5] ), .q(soundOut5));
nRAM6 r6( .address( adOut6 ), .clock(clock44), .rden( enable[6] ), .q(soundOut6));
nRAM7 r7( .address( adOut7 ), .clock(clock44), .rden( enable[7] ), .q(soundOut7));
nRAM8 r8( .address( adOut8 ), .clock(clock44), .rden( enable[8] ), .q(soundOut8));
nRAM9 r9( .address( adOut9 ), .clock(clock44), .rden( enable[9] ), .q(soundOut9));
nRAM10 r10( .address( adOut10 ), .clock(clock44), .rden( enable[10] ), .q(soundOut10));
nRAM11 r11( .address( adOut11 ), .clock(clock44), .rden( enable[11] ), .q(soundOut11));
nRAM12 r12( .address( adOut12 ), .clock(clock44), .rden( enable[12] ), .q(soundOut12));
nRAM13 r13( .address( adOut13 ), .clock(clock44), .rden( enable[13] ), .q(soundOut13));
nRAM14 r14( .address( adOut14 ), .clock(clock44), .rden( enable[14] ), .q(soundOut14));
nRAM15 r15( .address( adOut15 ), .clock(clock44), .rden( enable[15] ), .q(soundOut15));


//reg [15:0] soundToAddReg0, soundToAddReg1;

reg [5:0] soundToAddReg0, soundToAddReg1, soundToAddReg2, soundToAddReg3, soundToAddReg4, soundToAddReg5, soundToAddReg6, soundToAddReg7;
reg [5:0] soundToAddReg8, soundToAddReg9, soundToAddReg10, soundToAddReg11, soundToAddReg12, soundToAddReg13, soundToAddReg14, soundToAddReg15;


//initial soundToAddReg0 = 16'b0;
//initial soundToAddReg1 = 16'b0;

initial soundToAddReg0 = 6'b0;
initial soundToAddReg1 = 6'b0;
initial soundToAddReg2 = 6'b0;
initial soundToAddReg3 = 6'b0;
initial soundToAddReg4 = 6'b0;
initial soundToAddReg5 = 6'b0;
initial soundToAddReg6 = 6'b0;
initial soundToAddReg7 = 6'b0;
initial soundToAddReg8 = 6'b0;
initial soundToAddReg9 = 6'b0;
initial soundToAddReg10 = 6'b0;
initial soundToAddReg11 = 6'b0;
initial soundToAddReg12 = 6'b0;
initial soundToAddReg13 = 6'b0;
initial soundToAddReg14 = 6'b0;
initial soundToAddReg15 = 6'b0;



//wire [15:0] soundToAdd0, soundToAdd1;

wire [5:0] soundToAdd0, soundToAdd1, soundToAdd2, soundToAdd3, soundToAdd4, soundToAdd5, soundToAdd6, soundToAdd7;
wire [5:0] soundToAdd8, soundToAdd9, soundToAdd10, soundToAdd11, soundToAdd12, soundToAdd13, soundToAdd14, soundToAdd15;


always @ (posedge clock44) begin

	if (enable[0])
		soundToAddReg0 = soundOut0;
	else
		soundToAddReg0 = 6'b0;
		
	if (enable[1])
		soundToAddReg1 = soundOut1;
	else
		soundToAddReg1 = 6'b0;
		
	
	if (enable[2])
		soundToAddReg2 = soundOut2;
	else
		soundToAddReg2 = 6'b0;
		
	if (enable[3])
		soundToAddReg3 = soundOut3;
	else
		soundToAddReg3 = 6'b0;
		
	if (enable[4])
		soundToAddReg4 = soundOut4;
	else
		soundToAddReg4 = 6'b0;
		
	if (enable[5])
		soundToAddReg5 = soundOut5;
	else
		soundToAddReg5 = 6'b0;
		
	if (enable[6])
		soundToAddReg6 = soundOut6;
	else
		soundToAddReg6 = 6'b0;
		
	if (enable[7])
		soundToAddReg7 = soundOut7;
	else
		soundToAddReg7 = 6'b0;
		
	if (enable[8])
		soundToAddReg8 = soundOut8;
	else
		soundToAddReg8 = 6'b0;
	
	if (enable[9])
		soundToAddReg9 = soundOut9;
	else
		soundToAddReg9 = 6'b0;
		
	if (enable[10])
		soundToAddReg10 = soundOut10;
	else
		soundToAddReg10 = 6'b0;
		
	if (enable[11])
		soundToAddReg11 = soundOut11;
	else
		soundToAddReg11 = 6'b0;
		
	if (enable[12])
		soundToAddReg12 = soundOut12;
	else
		soundToAddReg12 = 6'b0;
		
	if (enable[13])
		soundToAddReg13 = soundOut13;
	else
		soundToAddReg13 = 6'b0;
		
	if (enable[14])
		soundToAddReg14 = soundOut14;
	else
		soundToAddReg14 = 6'b0;
		
	if (enable[15])
		soundToAddReg15 = soundOut15;
	else
		soundToAddReg15 = 6'b0;
	
	
end
	
//assign soundToAdd0 = soundToAddReg0;
//assign soundToAdd1 = soundToAddReg1;

assign soundToAdd0 = soundToAddReg0;
assign soundToAdd1 = soundToAddReg1;
assign soundToAdd2 = soundToAddReg2;
assign soundToAdd3 = soundToAddReg3;
assign soundToAdd4 = soundToAddReg4;
assign soundToAdd5 = soundToAddReg5;
assign soundToAdd6 = soundToAddReg6;
assign soundToAdd7 = soundToAddReg7;
assign soundToAdd8 = soundToAddReg8;
assign soundToAdd9 = soundToAddReg9;
assign soundToAdd10 = soundToAddReg10;
assign soundToAdd11 = soundToAddReg11;
assign soundToAdd12 = soundToAddReg12;
assign soundToAdd13 = soundToAddReg13;
assign soundToAdd14 = soundToAddReg14;
assign soundToAdd15 = soundToAddReg15;




//MODULE: WAVEADDER (1)
//INPUTS (SOUNDOUT[34:0]) & (CLOCK44)
//OUTPUTS (SOUND16)
//WIRE (SOUND16)

wire [5:0] sound16;

//WAVE ADDER TAKES IN ENABLE FROM BTNS AND CHANNELS
//MODIFY WAVE ADDER TO TAKE IN 16 WAVES, USE DIFFERENT SUM, USE DIFFERENT DIVIDER
//20 BIT SUM, 16 NUMWAVES (4 BIT), 16 BIT ENABLE/PLAYING, 20 BIT QUOTIENT, 4 BIT REMAIN
WaveAdder wa0 (
	.newWave( sound16 ), .playing( enable ), 
	.wave0 ( soundToAdd0 ),
	.wave1 ( soundToAdd1 ),
	.wave2 ( soundToAdd2 ),
	.wave3 ( soundToAdd3 ),
	.wave4 ( soundToAdd4 ),
	.wave5 ( soundToAdd5 ),
	.wave6 ( soundToAdd6 ),
	.wave7 ( soundToAdd7 ),
	.wave8 ( soundToAdd8 ),
	.wave9 ( soundToAdd9 ),
	.wave10 ( soundToAdd10 ),
	.wave11 ( soundToAdd11 ),
	.wave12 ( soundToAdd12 ),
	.wave13 ( soundToAdd13 ),
	.wave14 ( soundToAdd14 ),
	.wave15 ( soundToAdd15 )
);

//MODULE: AUDIOADAPTER (1)
//INPUTS (DE1 PORTS) & (SOUND16 CONCATENATED TO 32)
//OUTPUTS (DE1 PORTS) & (SPEAKER SOUND)
//WIRE (SOUND32)

wire [31:0] sound32;

//concatenate to send audio adapter 32 bit sound
assign sound32 = {5'b0, sound16, 21'b0};																	

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





endmodule