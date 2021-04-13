declare name "Bfb";
declare description "bool_osc FB alternative 1";
declare author "Till Bovermann";
declare reference "http://rottingsounds.org";

bit_gen = library("bitDSP_gen.lib");

// bit = library("bitDSP.lib");
// SuperCollider
// CXXFLAGS="-I ../../../../include" faust2supercollider -I ../../lib -noprefix Bfb.dsp
// plot
// CXXFLAGS="-I ../include" faust2csvplot -I ../lib Bfb.dsp
// ./boolOsc_fb -n 10
// compile
// CXXFLAGS="-I ../../../include" faust2caqt -I ../lib -double Bfb.dsp  
// ./Bfb

c1 = hslider("c1", 0, 0, 1, 0.00001);
c2 = hslider("c2", 0, 0, 1, 0.00001);
vol = hslider("vol", 0, 0, 1, 0.001);

process = bit_gen.bfb(c1, c2) : par(i, 2, (_ * vol));