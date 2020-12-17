declare name "BoolOscFB";
declare description "bool_osc FB";
declare author "Till Bovermann";
declare reference "http://rottingsounds.org";

import("stdfaust.lib");
bit = library("bitDSP.lib");


// SuperCollider
// CXXFLAGS="-I ../../../../include" faust2supercollider -I ../../lib -noprefix BoolOscFB.dsp

// plot
// CXXFLAGS="-I ../include" faust2csvplot -I ../lib boolOsc_fb.dsp
// ./boolOsc_fb -n 10

// compile
// CXXFLAGS="-I ../../../include" faust2caqt -I ../lib boolOsc_fb.dsp
// ./boolOsc_fb


// bool_osc1(del1, del2) = node1
//       letrec {
//            'node1 = not(node1 xor node2 & node1) @ max(0, min(ma.SR, del1));
//            'node2 = not(node2 xor node1 xor node2) @ max(0, min(ma.SR, del2));
//       } 
//       with {
//            not(x) = 1 - x;
//       };


// bool_osc2(del1, del2) = node1
                           
//       letrec {
//            'node1 = not(node1 & node2) @ max(0, min(ma.SR, del1));
//            'node2 = not(node1 & node2) @ max(0, min(ma.SR, del2));
//       }
//       with {
//            not(x) = rint(1 - x);
//       };



// lp1p (Dario)
// One-pole lowpass (design by Chamberlin).
//
// 2 inputs:
//    CF[n], cut-off frequency in Hz;
//    x[n].
//
// 1 outputs:
//    y[n], lowpassed x[n].
lp1p(cf, in) = + (in * a0) ~ * (b1) with {
	a0 = 1 - b1;
	b1 = exp(w(cf) * -1);
	w(x) = x * twopi / ma.SR;
	twopi = 2 * ma.PI;
};

// rms (dario)
rms(window, in) = in <: * : lp1p(window) : sqrt; 


// sc-like leakdc
leakdc(coef, x) = y letrec {
	'y = x - x' + coef * y;
};


feedbackOsc(cutoff, dt1, dt2, leakcoef, att,rel) = loop ~ (_, _) with {
	loop(fb1, fb2) =  
		bit.bool_osc1(amp(fb2), amp(fb1))@(dt1), 
		(bit.bool_osc2(amp(fb1), amp(fb2))@(dt2));
	rmsN(sig) = leakdc(leakcoef, rms(cutoff, sig));
    amp(sig) =  40 * leakdc(leakcoef, sig) : an.amp_follower_ud(att,rel);
    // amp(sig) = leakdc(leakcoef, sig) : an.amp_follower(att);
};



dt1 = hslider("dt1",0,0,20000,1);
dt2 = hslider("dt2",0,0,20000,1);
cutoff = hslider("cutoff",100,100,1000,0);
leakcoef = hslider("leakcoef",0.99,0.99, 1, 0.000001);
att = hslider("att",0,0, 1, 0.000001);
rel = hslider("rel",0,0, 1, 0.000001);

// stereo out
process = feedbackOsc(cutoff, dt1, dt2, leakcoef, att, rel);
// process = leakdc(leakcoef, os.impulse);