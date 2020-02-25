module ChannelSim (input mode, input playEn, input clock, reset, input[1:0] data);

	wire [1:0] seqOut;
	wire [14:0] addressch0, address0;
	wire chEn, rden;
	
	localparam depth0 = 15'd4;
	
	Channel ch0 ( .mode( mode ), .playEn( playEn ), .clock( clock ), .data( data ), .seqOut( seqOut ) );
	
	WaveMaker wm0 ( .enable(0), .reset(reset), .clock( clock ), .depth( depth0 ), .address( address0 ), .playing( rden ) );
	WaveMaker wmch0 ( .enable( seqOut[0] ), .reset( reset ), .clock( clock ), .depth( depth0 ), .address( addressch0 ), .playing( chEn ) );

	wire enable;
	Enabler ench0 ( .btn(rden), .ch(chEn), .enable(enable) );
	
	
	
endmodule