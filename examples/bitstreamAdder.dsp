// This is a simple example that tests an adder for 1-bit streams.
// In this example, in particular, we will add together a stream
// of 1s and a stream of 0s. Summing two opposite values results
// in a zero-ed output, which consists of alternating 0s and 1s
// in the delta-sigma-modulated domain.

declare name "Bitstream adder";
declare author "Dario Sanfilippo";
declare reference "O'leary, P., & Maloberti, F. (1990). Bit stream adder 
    for oversampling coded data. Electronics Letters, 26(20), 1708-1709.";

import("stdfaust.lib");
bit = library("bitDSP.lib");

// plot
// CXXFLAGS="-I ../include" faust2csvplot -double -I ../lib 
//      bitstream_adder-example.dsp
// ./bitstream_adder-example -n 50

// compile
// CXXFLAGS="-I ../../../include" faust2caqt -double -I ../lib 
//      bitstream_adder-example.dsp
// ./bitstream_adder-example

process = bit.bitstream_adder(0, 1);
