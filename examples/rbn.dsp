// This is a simple example showing the possibilities offered by
// recursivity combined with nonlinear properties of Boolean operators.
// The network in this example is a fourth-order one, hence with four nodes,
// combining identity and circular topologies. The system parameters are
// the delays between the connections, which determine different chaotic 
// behaviours ranging from limit cycles to strange attractors and 
// unpredictability.

declare name "RBN";
declare description "Recursive Boolean network";
declare author "Dario Sanfilippo";
declare reference "Stuart A Kauffman, “Metabolic stability and epigenesis 
    in randomly constructed genetic nets,” Journal of theoretical 
        biology, vol. 22, no. 3, pp. 437–467, 1969.";

import("stdfaust.lib");
bit = library("bitDSP.lib");

// plot
// CXXFLAGS="-I ../include" faust2csvplot -double -I ../lib rbn-example.dsp
// ./rbn-example -n 50

// compile
// CXXFLAGS="-I ../../../include" faust2caqt -double -I ../lib rbn-example.dsp
// ./rbn-example

d1 = hslider("del1", 0, 0, 9600, 1);
d2 = hslider("del2", 0, 0, 9600, 1);
d3 = hslider("del3", 0, 0, 9600, 1);
d4 = hslider("del4", 0, 0, 9600, 1);
process = bit.bool_osc0(d1, d2, d3, d4);
