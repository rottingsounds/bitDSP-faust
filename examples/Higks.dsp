declare name "Higks";
declare author "Till Bovermann";
declare reference "http://rottingsounds.org";

import("stdfaust.lib");
bit_gen = library("bitDSP_gen.lib");

// SuperCollider
// CXXFLAGS="-I ../../../../include" faust2supercollider -I ../../lib -noprefix Higks.dsp

// plot
// CXXFLAGS="-I ../include" faust2csvplot -I ../lib Higks.dsp
// ./Higks -n 10

// compile
// CXXFLAGS="-I ../../../include" faust2caqt -I ../lib -double Higks.dsp
// ./Higks



c1 = hslider("c1", 0, 0, 1, 0.00001);
c2 = hslider("c2", 0, 0, 1, 0.00001);
vol = hslider("vol", 0, 0, 1, 0.001);

process = bit_gen.higks(c1, c2) : par(i, 2, (_ * vol));