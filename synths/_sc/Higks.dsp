declare name "Higks";
declare author "Till Bovermann";
declare reference "http://rottingsounds.org";

import("stdfaust.lib");
// bit = library("bitDSP.lib");
bit_gen = library("bitDSP_gen.lib");

// SuperCollider
// export SUPERCOLLIDER_HEADERS=/localvol/sound/src/supercollider/include/
// faust2supercollider -I ../../lib -noprefix Higks.dsp

c1 = hslider("c1",0,0,1,0.001);
c2 = hslider("c2",0.5,0,1,0.001);

// Final output
process = bit_gen.higks(c1, c2) : si.bus(2);
