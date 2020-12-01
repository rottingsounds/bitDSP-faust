declare name "DSM2bipolar";
declare author "Till Bovermann, Dario Sanfilippo";
declare reference "http://rottingsounds.org";

import("stdfaust.lib");
bit = library("bitDSP.lib");

// plot
// CXXFLAGS="-I ../include" faust2csvplot -double -I ../lib DSM2bipolar.dsp
// ./DSM2bipolar -n 10

// compile
// CXXFLAGS="-I ../../../include" faust2caqt -double -I ../lib DSM2bipolar.dsp
// ./DSM2bipolar

// SuperCollider
// export SUPERCOLLIDER_HEADERS=/localvol/sound/src/supercollider/include/
// faust2supercollider -I ../faust/bitDSP-faust/lib -noprefix DSM2bipolar.dsp

// Final output
// Bipolar multi-bit signal to bipolar one-bit signal
process = bit.dsm2;
