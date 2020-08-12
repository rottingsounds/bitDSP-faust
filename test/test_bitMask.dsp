import("stdfaust.lib");
b = library("bitDSP.lib");

// compile
// CXXFLAGS="-I ../lib" faust2csvplot -I ../lib bitMask.dsp
// ./bitMask -n 10

s_count = (1:+~_) - 1;

// a = (4:b.left_shift(1)) | (6:b.left_shift(1)) | (31:b.left_shift(1));
a = b.bit_mask((s_count % 32, 6, 31));

process  = a : b.print2(0, s_count);
