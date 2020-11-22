declare name "bitDAC - example";
declare author "Till Bovermann";
declare reference "http://rottingsounds.org";

import("stdfaust.lib");
bit32 = library("bitDSP_int32.lib");

// plot
// CXXFLAGS="-I ../include" faust2csvplot -I ../lib bitDAC-example.dsp
// ./bitDAC-example -n 10

// compile
// CXXFLAGS="-I ../../../include" faust2caqt -I ../lib bitDAC-example.dsp
// ./bitDAC-example

dac_bits = int(hslider("dac bits",1,1,32,1));
dac_offset    = min(int(hslider("dac offset",0,0,31,1)), 32-dac_bits);

// counting samples from start of execution, starting at 0
sample_count = int((1:+~_)) - 1;



// select bits of the samplecount and interpret that chunk as a PCM value

process = bit32.bitDAC(dac_offset, dac_bits, sample_count) <: _,_;