declare name "lfsr - example";
declare author "Till Bovermann";
declare reference "http://rottingsounds.org";
// see https://en.wikipedia.org/wiki/Linear-feedback_shift_register

import("stdfaust.lib");
bit32 = library("bitDSP_int32.lib");

// plot
// CXXFLAGS="-I ../include" faust2csvplot -I ../lib lfsr-example.dsp
// ./lfsr-example -n 10

// compile
// CXXFLAGS="-I ../../../include" faust2caqt -I ../lib lfsr-example.dsp
// // open lfsr-example.app

dac_bits = int(nentry("dac bits",1,1,32,1));
dac_offset    = min(int(nentry("dac offset",0,0,31,1)), 32-dac_bits);

lfsr_bits = int(nentry("lfsr bits",1,1,32,1));
lfsr_init = nentry("init val",1,1,492000,1); 
lfsr_mask = bit32.bit_mask(
	par(i,6,
		nentry("parity source bit %i",i,0,31,1)
	)
);


lfsr = (
	bit32.lfsr(lfsr_bits, lfsr_mask, lfsr_init),  
	bit32.lfsr(lfsr_bits, lfsr_mask, lfsr_init + 1)
);

// select which bit range should be used to create the PCM signal
process = lfsr : par(i, outputs(lfsr), bit32.bitDAC(dac_offset, dac_bits));
