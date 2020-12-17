declare name "DSM2PCM";
declare author "Till Bovermann, Dario Sanfilippo";
declare reference "http://rottingsounds.org";

import("stdfaust.lib");
bit = library("bitDSP.lib");

// plot
// CXXFLAGS="-I ../include" faust2csvplot -double -I ../lib DSM2PCM.dsp
// ./DSM2PCM -n 10

// compile
// CXXFLAGS="-I ../../../include" faust2caqt -double -I ../lib DSM2PCM.dsp
// ./DSM2PCM

// SuperCollider
// export SUPERCOLLIDER_HEADERS=/localvol/sound/src/supercollider/include/
// faust2supercollider -double -I ../faust/bitDSP-faust/lib -noprefix DSM2PCM.dsp

// downsample_factor = hslider("downsample",2,2,64,2);
freq = hslider("freq", 100, 100, 192000, 0);

// Bipolar one-bit signal to bipolar multi-bit signal
// The process of low-passing corresponds to averaging
// The low-pass cut-off sets the target bandwidth
// The low-pass resolution of the coefficients sets the bitdepth
// The low-pass order determines the accuracy in the noise removal
// process = fi.lowpass(8, ma.SR / downsample_factor);
process = fi.lowpass(8, freq);
