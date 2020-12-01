declare name "DSMSine";
declare author "Till Bovermann, Dario Sanfilippo";
declare reference "http://rottingsounds.org";

import("stdfaust.lib");
bit = library("bitDSP.lib");

// plot
// CXXFLAGS="-I ../include" faust2csvplot -double -I ../lib dsm2-example.dsp
// ./DSMSine -n 10

// compile
// CXXFLAGS="-I ../../../include" faust2caqt -double -I ../lib dsm2-example.dsp
// open ./DSMSine

// SuperCollider
// export SUPERCOLLIDER_HEADERS=/localvol/sound/src/supercollider/include/
// faust2supercollider -I ../faust/bitDSP-faust/lib -noprefix DSMSine.dsp

freq = hslider("freq",100,0,20000,0);

// High-precision sinewave
sine(f) = sin(os.phasor(2 * ma.PI, f));

// Bipolar multi-bit signal to bipolar one-bit signal
// Standard test with a 1 kHz tone
onebitstream = bit.dsm2(sine(freq));

// Final output
process = onebitstream;
