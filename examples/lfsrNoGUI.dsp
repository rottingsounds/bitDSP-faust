declare name "LFSRNoGUI";
declare description "linear feedback shift register example without GUI";
declare author "Till Bovermann";
declare reference "http://rottingsounds.org";
// see https://en.wikipedia.org/wiki/Linear-feedback_shift_register

import("stdfaust.lib");
bit32 = library("bitDSP_int32.lib");

// plot
// CXXFLAGS="-I ../include" faust2csvplot -I ../lib lfsrNoGUI.dsp
// ./lfsrNoGUI -n 10

// compile
// CXXFLAGS="-I ../../../include" faust2caqt -I ../lib lfsrNoGUI.dsp
// // open lfsrNoGUI.app

// dac_bits = int(nentry("dac bits",1,1,32,1));
// dac_offset    = min(int(nentry("dac offset",0,0,31,1)), 32-dac_bits);
dac_bits   = 31;
dac_offset = 0;

// lfsr_bits = int(nentry("lfsr bits",1,1,32,1));
lfsr_bits = 16;
// lfsr_init = nentry("init val",1,1,492000,1); 
lfsr_init = 12356; 
// lfsr_mask = bit32.bit_mask(
// 	par(i,6,
// 		nentry("parity source bit %i",i,0,31,1)
// 	)
// );
lfsr_mask = bit32.bit_mask((15, 13, 11, 10, 2));


lfsr = (
	bit32.lfsr(lfsr_bits, lfsr_mask, lfsr_init),  
	bit32.lfsr(lfsr_bits, lfsr_mask, lfsr_init + 1)
);

// select which bit range should be used to create the PCM signal
process = lfsr : par(i, outputs(lfsr), bit32.bitDAC(dac_offset, dac_bits));
