declare name "boolOsc2";
declare description "bool_osc_0 - example";
declare author "Till Bovermann";
declare reference "http://rottingsounds.org";

import("stdfaust.lib");
bit = library("bitDSP.lib");


// SuperCollider
// CXXFLAGS="-I ../../../../include" faust2supercollider -I ../../lib -noprefix boolOsc2.dsp

// plot
// CXXFLAGS="-I ../include" faust2csvplot -I ../lib boolOsc2.dsp
// ./boolOsc2 -n 10

// compile
// CXXFLAGS="-I ../../../include" faust2caqt -I ../lib boolOsc2.dsp
// ./boolOsc2


dt1 = int(hslider("dt1",0,0,1,0) * ma.SR);
dt2 = int(hslider("dt2",0,0,1,0) * ma.SR);

// mono out
process = bit.bool_osc2(dt1, dt2);