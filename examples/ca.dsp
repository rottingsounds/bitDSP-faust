// This is a simple example showing pattern-formation through
// elementary cellular automata. The cellular automata function
// is called with four integer arguments: size of the circular lattice;
// the rule that determines the next state of each cell; the initial
// state of the cells; the iteration rate.
//
// The size of the lattice also determines the number of outputs of the 
// function. The patterns can be displayed easily compiling the
// faust2csvplot program as indicated below.

declare name "ca";
declare description "Elementary cellular automata – size-16 lattice example; rule 110";
declare author "Dario Sanfilippo";
declare reference "Stephen Wolfram – A New Kind of Science (2002)";

import("stdfaust.lib");
bitBus = library("bitDSP_bitBus.lib");

// plot
// CXXFLAGS="-I ../include" faust2csvplot -double -I ../lib ca-example.dsp
// ./ca-example -n 50

// compile
// CXXFLAGS="-I ../../../include" faust2caqt -double -I ../lib ca-example.dsp
// ./ca-example

process = bitBus.eca(16, 110, 24, ma.SR);


