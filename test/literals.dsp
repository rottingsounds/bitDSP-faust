import("stdfaust.lib");
b = library("bitDSP.lib");

// CXXFLAGS="-I ../lib" faust2csvplot -I ../lib literals.dsp
s_count = (1:+~_) - 1;

a = (4:b.left_shift(1)) | (6:b.left_shift(1)) | (31:b.left_shift(1));
process  = a : b.print2(0, s_count);
