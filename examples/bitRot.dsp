declare name "bitRot";
declare description "bitRot - example";
declare author "Till Bovermann";
declare reference "http://rottingsounds.org";

import("stdfaust.lib");
bit = library("bitDSP.lib");

// plot
// CXXFLAGS="-I ../include" faust2csvplot -I ../lib bitRot.dsp
// ./bitRot -n 10

// compile
// CXXFLAGS="-I ../../../include" faust2caqt -I ../lib bitRot.dsp
// ./bitRot



/////////////////////////// UI ////////////////////////////////
chance = hslider("chance", 0, 0, 1, 0.0001);
type   = hslider("type"  , 1, 1, 3, 1);
amp    = hslider("amp"  , 0, 0, 1, 0.001) : si.smoo;


/////////////////////////// Input /////////////////////////////
bitSin = bit.ddsm1(os.osc(50));
dirac = 1 - 1';
silence = fbPath(dirac) ~ _ with {
    fbPath(init, fb) = -fb + init;
};

// noise needs to be unimodal
noise = (no.noise + 1) * 0.5;

// process = bitSin <: _, bitrot(noise, chance, type) : bit2mbit, bit2mbit with {
// 	bit2mbit(x) = fi.lowpass(4, 4000, x);
// };


process = bitSin : bit.bitrot(noise, chance, type) : outPCM(2, amp) with {
	outPCM(N, amp, x) = fi.lowpass(2, 4000, x) * amp : leakdc(0.999) <: si.bus(N);
	leakdc(coef, x) = y letrec {
	  'y = x - x' + coef * y;
	};
};

