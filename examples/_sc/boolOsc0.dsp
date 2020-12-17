declare name "boolOsc0";
declare description "bool_osc_0 - example";
declare author "Till Bovermann";
declare reference "http://rottingsounds.org";

import("stdfaust.lib");
bit = library("bitDSP.lib");


// SuperCollider
// CXXFLAGS="-I ../../../../include" faust2supercollider -I ../../lib -noprefix boolOsc0.dsp

// plot
// CXXFLAGS="-I ../include" faust2csvplot -I ../lib boolOsc0.dsp
// ./boolOsc0 -n 10

// compile
// CXXFLAGS="-I ../../../include" faust2caqt -I ../lib boolOsc0.dsp
// ./boolOsc0


dt1 = int(hslider("dt1",0,0,1,0) * ma.SR);
dt2 = int(hslider("dt2",0,0,1,0) * ma.SR);
dt3 = int(hslider("dt3",0,0,1,0) * ma.SR);
dt4 = int(hslider("dt4",0,0,1,0) * ma.SR);

// mono out
process = bit.bool_osc0(dt1, dt2, dt3, dt4);