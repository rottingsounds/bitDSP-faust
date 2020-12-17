declare name "LFSR";
declare author "Till Bovermann";
declare description "linear feedback shift register example";
declare reference "http://rottingsounds.org";
// compute lfsr on an n-bit integer bitset (assuming it to be unsigned, [0 < n <= 32] ).
// see https://en.wikipedia.org/wiki/Linear-feedback_shift_register

import("stdfaust.lib");
bit32 = library("bitDSP_int32.lib");

// SuperCollider
// CXXFLAGS="-I ../../../../include" faust2supercollider -d -I ../lib -noprefix lfsr32.dsp

// plot
// CXXFLAGS="-I ../include" faust2csvplot -I ../lib lfsr.dsp
// ./lfsr -n 10

// compile
// CXXFLAGS="-I ../../../include" faust2caqt -I ../lib lfsr.dsp
// // open lfsr.app

dac_bits   =     int(nentry("dacBits",1,1,32,1));
dac_offset = min(int(nentry("dacOffset",0,0,31,1)), 32-dac_bits);


// how many bits the LFSR runs on (1-32)
lfsr_num_bits = int(nentry("lfsrBits",1,1,32,1));

// initial state of the LFSR as 32bit (!=0)
// change to reset LFSR to start with that new value
lfsr_init_state = nentry("init",1,1,492000,1); 
lfsr_parity_mask = bit32.bit_mask(
	par(i,32,
		nentry("pBit%i",i,0,31,1)
	)
);


// lfsr = (
// 	bit32.lfsr(lfsr_num_bits, lfsr_parity_mask, lfsr_init_state),  
// 	bit32.lfsr(lfsr_num_bits, lfsr_parity_mask, lfsr_init_state + 1)
// );

lfsr = bit32.lfsr(lfsr_num_bits, lfsr_parity_mask, lfsr_init_state);

// select which bit range should be used to create the PCM signal
process = lfsr : par(i, outputs(lfsr), bit32.bitDAC(dac_offset, dac_bits));
