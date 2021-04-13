declare name "LowPressure";
declare author "Till Bovermann";
declare reference "http://rottingsounds.org";
import("stdfaust.lib");
bit_gen = library("bitDSP_gen.lib");
// plot
// CXXFLAGS="-I ../include" faust2csvplot -I ../lib LowPressure.dsp
// ./boolOsc0 -n 10
// compile
// CXXFLAGS="-I ../../../include" faust2caqt -I ../lib -double LowPressure.dsp
// ./LowPressure


c1 = hslider("c1",0,0,1,0.001);
c2 = hslider("c2",0,0,1,0.001);
vol = hslider("vol", 0, 0, 1, 0.001);

process = bit_gen.lowPressure(c1, c2) : par(i, 2, (_ * vol));

