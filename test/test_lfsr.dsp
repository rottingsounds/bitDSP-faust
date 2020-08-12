declare name "lfsr printVals";
declare author "Till Bovermann";
declare reference "http://rottingsounds.org";

import("stdfaust.lib");
b = library("bitDSP.lib");

// plot
// CXXFLAGS="-I ../include" faust2csvplot -I ../lib lfsr.dsp
// ./lfsr -n 10

// compile
// CXXFLAGS="-I ../../../include" faust2caqt -I ../lib lfsr.dsp
// ./lfsr


s_count = (1:+~_) - 1;

// a = (4:b.left_shift(1)) | (6:b.left_shift(1)) | (31:b.left_shift(1));
a = 1: b.lfsr(b.bit_mask((3, 6, 31)));

process  = a : b.print2(0, s_count);
