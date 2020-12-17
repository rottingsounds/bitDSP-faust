declare name "DSM2unipolar";
declare author "Till Bovermann, Dario Sanfilippo";
declare reference "http://rottingsounds.org";

import("stdfaust.lib");
bit = library("bitDSP.lib");

// plot
// CXXFLAGS="-I ../include" faust2csvplot -double -I ../lib DSM2unipolar.dsp
// ./DSM2unipolar -n 10

// compile
// CXXFLAGS="-I ../../../include" faust2caqt -double -I ../lib DSM2unipolar.dsp
// ./DSM2unipolar

// SuperCollider
// export SUPERCOLLIDER_HEADERS=/localvol/sound/src/supercollider/include/
// faust2supercollider -I ../faust/bitDSP-faust/lib -noprefix DSM2unipolar.dsp

// Final output
// Bipolar multi-bit signal to bipolar one-bit signal
process = bit.dsm2 > 0;
