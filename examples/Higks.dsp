declare name "Higks";
declare author "Till Bovermann";
declare reference "http://rottingsounds.org";

import("stdfaust.lib");
bit_gen = library("bitDSP_gen.lib");

// SuperCollider
// CXXFLAGS="-I ../../../../include" faust2supercollider -I ../../lib -noprefix Higks.dsp

// plot
// CXXFLAGS="-I ../include" faust2csvplot -I ../lib Higks.dsp
// ./Higks -n 10

// compile
// CXXFLAGS="-I ../../../include" faust2caqt -I ../lib -double Higks.dsp
// ./Higks



c1 = hslider("c1",0,0,1,0.001);
c2 = hslider("c2",0.5,0,1,0.001);
rot = hslider("rot",0.5,0, ma.PI, 0.001) : si.smoo;
lFreq = hslider("lFreq [scale:log]",100,25, 10000, 1) : si.smoo;
hFreq = hslider("hFreq [scale:log]",100,25, 10000, 1) : si.smoo;
vol = hslider("vol", 0, 0, 1, 0.0001) : si.smoo;

rotate2(r, x, y) = xout, yout with {
    xout = cos(r) * x + sin(r) * y;
    yout = cos(r) * y - sin(r) * x;
};


// process = bit_gen.higks(c1, c2) : par(i, 2, (_ * vol));



process = bit_gen.higks(c1, c2) 
    : par( i, 2, _ * vol)
    : par( i, 2, _ * 2 -1 <: fi.svf.lp(lFreq, 20) - fi.svf.lp(hFreq, 50))
    : rotate2(rot);
