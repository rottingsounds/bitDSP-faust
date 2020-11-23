declare name "DSM2";
declare description "Second-order delta-sigma modulator example";
Second-order delta-sigma modulator - example
declare author "Dario Sanfilippo";
declare reference "http://rottingsounds.org";

import("stdfaust.lib");
bit = library("bitDSP.lib");

// plot
// CXXFLAGS="-I ../include" faust2csvplot -double -I ../lib dsm2.dsp
// ./dsm2 -n 10

// compile
// CXXFLAGS="-I ../../../include" faust2caqt -double -I ../lib dsm2.dsp
// ./dsm2

// High-precision sinewave
sine(f) = sin(os.phasor(2 * ma.PI, f));

// Bipolar multi-bit signal to bipolar one-bit signal
// Standard test with a 1 kHz tone
onebitstream = bit.dsm2(sine(1000));

// Bipolar one-bit signal to bipolar multi-bit signal
// The process of low-passing corresponds to averaging
// The low-pass cut-off sets the target bandwidth
// The low-pass resolution of the coefficients sets the bitdepth
// The low-pass order determines the accuracy in the noise removal
multibitstream = fi.lowpass(4, 1000, onebitstream);

// Final output
process = multibitstream;
