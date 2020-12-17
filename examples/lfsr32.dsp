declare name "LFSR32";
declare author "Till Bovermann";
declare description "linear feedback shift register (32bit) example";
declare reference "http://rottingsounds.org";

// see https://en.wikipedia.org/wiki/Linear-feedback_shift_register

import("stdfaust.lib");
bit32 = library("bitDSP_int32.lib");

// plot
// CXXFLAGS="-I ../include" faust2csvplot -I ../lib lfsr32.dsp
// ./lfsr32 -n 10

// compile
// CXXFLAGS="-I ../../../include" faust2caqt -I ../lib lfsr32.dsp
// // open lfsr32.app

dac_bits   =     int(nentry("dac bits"  ,1,1,32,1));
dac_offset = min(int(nentry("dac offset",0,0,31,1)), 32-dac_bits);

// initial state of the LFSR (!=0)
// change to reset LFSR to start with that new value
lfsr_init = nentry("init val",1,1,492000,1); 

// set your own bits
// lfsr_mask = bit32.bit_mask(
// 	par(i,6,
// 		nentry("parity source bit %i",i,0,31,1)
// 	)
// );
// an example that reasonable sense...
lfsr_mask = bit32.bit_mask((8, 31, 10)); // bits to set high

// lfsr = bit32.lfsr32(lfsr_mask, lfsr_init) <: _,_;
lfsr = bit32.lfsr32(lfsr_mask, lfsr_init);

// select which bit range should be used to create the PCM signal
process = lfsr : par(i, outputs(lfsr), bit32.bitDAC(dac_offset, dac_bits));
