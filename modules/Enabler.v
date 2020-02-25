module Enabler ( input btn, ch0, ch1, ch2, output enable);

	assign enable = btn | ch0 | ch1 | ch2;

endmodule