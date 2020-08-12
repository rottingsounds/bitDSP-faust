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

numDigits = int(hslider("digits",1,1,32,1));
offset    = int(hslider("offset",0,0,31,1));

// counting samples from start of execution, starting at 0
sample_count = int((1:+~_)) - 1;



// select bits of the samplecount and interpret that chunk as a PCM value

process = bit32.bitDAC(numDigits, min(offset, 32-numDigits), sample_count) <: _,_;