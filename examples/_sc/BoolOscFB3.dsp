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

// sc-type mod (always >= 0)
mod(a, 0) = 0;
mod(a, b) = ba.if(a > 0, a % b, a % b + b);


bool_osc1_mod(d1, d2) = node1 letrec {
  'node1 = not(node1 xor node2 & node1) @ min(ma.SR,mod(d1, ma.SR));
  'node2 = not(node2 xor node1 xor node2) @ min(ma.SR,mod(d2, ma.SR));
} with {
 not(x) = rint(1 - x);
};


bool_osc2_mod(d1, d2) = node1 letrec {
  'node1 = not(node1 & node2) @ min(ma.SR,mod(d1, ma.SR));
  'node2 = not(node1 & node2) @ min(ma.SR,mod(d2, ma.SR));
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


selectx(which, x, y) = (which * x) + ((1-which) * y);

// MS processor
ms(width, x, y) = (x + y) * 0.5, (x-y) * 0.5 * width;



coef_in = hslider("coefIn", 0, 0, 1, 0.0001) : si.smoo;
d11bias = hslider("d11bias", 24, 0, 2000, 1);
d11 = hslider("d11", 95/1000, 0, 1, 0.0001) : si.smoo;
d12bias = hslider("d12bias", 49, 0, 2000, 1);
d12 = hslider("d12", 116/1000, 0, 1, 0.0001) : si.smoo;

d21bias = hslider("d21bias", 24, 0, 2000, 1);
d21 = hslider("d21", 95/1000, 0, 1, 0.0001) : si.smoo;
d22bias = hslider("d22bias", 49, 0, 2000, 1);
d22 = hslider("d22", 116/1000, 0, 1, 0.0001) : si.smoo;

lpfreq = hslider("lpfreq", 2400, 0, 10000, 1) : si.smoo;
lporder = 5; // low=pass order
amp = hslider("amp", 0, 0, 1, 0.01) : si.smoo;

xfb = hslider("xfb", 0, 0, 1, 0.01) : si.smoo;


// d1 = 0.03843526787654; 
// d2 = 0.421234567658;
// d1off = 280;
// d2off = 334;


// stereo out
process =  oscfb(leakcoef, xfb, d11bias, d11, d12bias, d12, d21bias, d21, d22bias, d22) 
    : leakdc(0.99999), leakdc(0.99999)
    : ms(1)
    : fi.lowpass(lporder, lpfreq), fi.lowpass(lporder, lpfreq) 
    : _ * amp, _ * amp 
with {
    leakcoef = 1 - ((1-coef_in) * 0.0001);
    
    oscfb(leakcoef, xfb, d11bias, d11, d12bias, d12, d21bias, d21, d22bias, d22) = (loop ~ (_, _)) with {
        loop(fb1, fb2) = 
            loop1(
                selectx(xfb, fb1, fb2), 
                leakcoef, 
                d11bias, d11, 
                d12bias, d12
            ), 
            loop2(
                selectx(xfb, fb2, fb1), 
                leakcoef, 
                d21bias, d21, 
                d22bias, d22
            );

        loop1(fb, coef, d1off, d1, d2off, d2) = 
            bool_osc1_mod(
                max(0, d1off + (fb * 5000 * d1)),
                max(0, d2off + (fb * 5000 * d2))
            ) 
            : leakdc(coef);
        loop2(fb, coef, d1off, d1, d2off, d2) = 
            bool_osc2_mod(
                max(0, d1off + (fb * 5000 * d1)),
                max(0, d2off + (fb * 5000 * d2))
            ) 
            : leakdc(coef);
    };
};
