declare name "DSMAdd";
declare author "Till Bovermann, Dario Sanfilippo";
declare reference "http://rottingsounds.org";

import("stdfaust.lib");
bit = library("bitDSP.lib");

// plot
// CXXFLAGS="-I ../include" faust2csvplot -double -I ../lib DSMAdd.dsp
// ./DSM2bipolar -n 10

// compile
// CXXFLAGS="-I ../../../include" faust2caqt -double -I ../lib DSMAdd.dsp
// ./DSM2bipolar

// SuperCollider
// export SUPERCOLLIDER_HEADERS=/localvol/sound/src/supercollider/include/
// faust2supercollider -I ../faust/bitDSP-faust/lib -noprefix DSMAdd.dsp

// Final output
// Bipolar multi-bit signal to bipolar one-bit signal
process = bit.bitstream_adder;
