declare name "Elementary cellular automata – size-16 lattice example; rule 110";
declare author "Dario Sanfilippo";
declare reference "Stephen Walfram – A New Kind of Science (2002)";

import("stdfaust.lib");
bitBus = library("bitDSP_bitBus.lib");

// plot
// CXXFLAGS="-I ../include" faust2csvplot -double -I ../lib ca-example.dsp
// ./ca-example -n 10

// compile
// CXXFLAGS="-I ../../../include" faust2caqt -double -I ../lib ca-example.dsp
// ./ca-example

process = bitBus.eca(16, 110, 24, ma.SR);


