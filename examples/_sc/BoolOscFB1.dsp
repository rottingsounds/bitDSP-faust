declare name "BoolOscFB1";
declare description "bool_osc FB alternative 1";
declare author "Till Bovermann";
declare reference "http://rottingsounds.org";

import("stdfaust.lib");
// bit = library("bitDSP.lib");


// SuperCollider
// CXXFLAGS="-I ../../../../include" faust2supercollider -I ../../lib -noprefix BoolOscFB1.dsp

// plot
// CXXFLAGS="-I ../include" faust2csvplot -I ../lib boolOsc_fb.dsp
// ./boolOsc_fb -n 10

// compile
// CXXFLAGS="-I ../../../include" faust2caqt -I ../lib boolOsc_fb.dsp
// ./boolOsc_fb


bool_osc1_mod(del1, del2) = node1 letrec {
  'node1 = not(node1 xor node2 & node1) @ min(ma.SR,(del1 % ma.SR));
  'node2 = not(node2 xor node1 xor node2) @ min(ma.SR,(del2 % ma.SR));
} with {
 not(x) = 1 - x;
};


bool_osc2_mod(del1, del2) = node1 letrec {
  'node1 = not(node1 & node2) @ min(ma.SR,(del1 % ma.SR));
  'node2 = not(node1 & node2) @ min(ma.SR,(del2 % ma.SR));
} with {
  not(x) = rint(1 - x);
};

// bitrot(noise, chance, type) = _ <: select3(type-1, low(noise, chance, _), flip(noise, chance, _), high(noise, chance, _)) with {
//   low(noise, chance, x) = select2(coin(noise, chance), x, 0);
//   high(noise, chance, x) = select2(coin(noise, chance), x, 1);
//   flip(noise, chance, x) = select2(coin(noise, chance), x, 1-x);
//   coin(noise, chance) = noise < chance;
// };



// rms (dario)
rms(window, in) = in <: * : lp1p(window) : sqrt with {
  // lp1p (Dario)
  // One-pole lowpass (design by Chamberlin).
  lp1p(cf, in) = + (in * a0) ~ * (b1) with {
    a0 = 1 - b1;
    b1 = exp(w(cf) * -1);
    w(x) = x * twopi / ma.SR;
    twopi = 2 * ma.PI;
  };
}; 


// sc-like leakdc
leakdc(coef, x) = y letrec {
  'y = x - x' + coef * y;
};

// MS processor
ms(x, y, width) = (x + y) * 0.5, (x-y) * 0.5 * width;

coef = 1 - ((1-coef_in) * 0.0001);
oscfb1 = leakdc(0.9999, loop ~ _) with {
  loop(fb) = leakdc(coef, bool_osc1_mod(
    10 + max(0, fb * 10000 * d1),
    10 + max(0, fb * 10000 * d2)
  ));
};
oscfb2 = leakdc(0.9999, loop ~ _) with {
  loop(fb) = leakdc(coef, bool_osc2_mod(
    d1off + max(0, fb * 10000 * d1),
    d2off + max(0, fb * 10000 * d2)
  ));
};


coef_in = hslider("coefIn", 0, 0, 1, 0.0001) : si.smoo;
d1 = hslider("d1", 95/1000, 0, 1, 0.0001) : si.smoo;
d2 = hslider("d2", 116/1000, 0, 1, 0.0001) : si.smoo;
d1off = hslider("d1off", 24, 0, 1000, 1);
d2off = hslider("d2off", 49, 0, 1000, 1);
lpfreq = hslider("lpfreq", 2400, 0, 10000, 1) : si.smoo;


// d1 = 0.03843526787654; 
// d2 = 0.421234567658;
// d1off = 280;
// d2off = 334;


// stereo out
process =  ms(oscfb1, oscfb2, 0.5) : fi.lowpass(1, lpfreq), fi.lowpass(1, lpfreq);
