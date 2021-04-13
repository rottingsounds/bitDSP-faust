declare name "Trck";
declare author "Till Bovermann";
declare reference "http://rottingsounds.org";
import("stdfaust.lib");
bit = library("bitDSP.lib");
bit_gen = library("bitDSP_gen.lib");

// plot
// CXXFLAGS="-I ../include" faust2csvplot -I ../lib Trck.dsp
// ./boolOsc0 -n 10
// compile
// CXXFLAGS="-I ../../../include" faust2caqt -I ../lib Trck.dsp
// ./Trck

import("stdfaust.lib");
// bit = library("bitDSP.lib");

c1 = hslider("c1",0,0,1,0.001);
c2 = hslider("c2",0.5,0,1,0.001);
vol = hslider("vol", 0, 0, 1, 0.0001);





process = bit_gen.trck(c1, c2) 
    : par( i, 2, _ * 2 -1 <: fi.svf.lp(150, 20) - fi.svf.lp(7000, 50))
    : par(i, 2, _ * vol);


//////////////////
