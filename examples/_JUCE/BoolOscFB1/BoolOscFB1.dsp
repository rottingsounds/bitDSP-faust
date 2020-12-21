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


oscfb1(leakcoef, bias1, bias2, mod1, mod2) = loop ~ _ with {
    loop(fb) = bool_osc1_mod(
        (fb : map(bias1, mod2)),
        (fb : map(bias2, mod1))
    ) : leakdc(leakcoef);
};
oscfb2(leakcoef, bias1, bias2, mod1, mod2) = loop ~ _ with {
    loop(fb) = bool_osc2_mod(
        (fb : map(bias1, mod1)),
        (fb : map(bias2, mod2))
    ) : leakdc(leakcoef);
};

map(bias, scale, in) = max(0, (bias * biasfac) + (scale * in * modfac)) with {
    biasfac = 15000;
    modfac = 15000;
};


// sc-like leakdc
leakdc(coef, x) = y letrec {
  'y = x - x' + coef * y;
};

// MS processor
// ms(x, y, width) = (x + y) * 0.5, (x-y) * 0.5 * width;
ms(1, midIn, sideIn) = (midIn + sideIn) * 0.5, (midIn-sideIn) * 0.5;
ms(width, midIn, sideIn) = (mid + side) * 0.5, (mid-side) * 0.5 with {
    mid = midIn;
    side = sideIn * width;
};


rotate2(r, x, y) = xout, yout with {
    xout = cos(r) * x + sin(r) * y;
    yout = cos(r) * y - sin(r) * x;
};

// stereo out
process =  
    oscfb1(leakcoef, bias1, bias2, mod1, mod2), 
    oscfb2(leakcoef, bias1, bias2, mod1, mod2)
    : leak
    : rotate2(rot)
    : ms(1) : ms(width)
    : vca(distort)
    : tanh
    : vca(amp)
    : fi.lowpass(lporder, lpfreq), fi.lowpass(lporder, lpfreq)
    <: si.bus(2)
with {

    distort = hslider("m_distort[scale:exp]", 1, 1, 100, 0.001) : si.smoo;
    amp = hslider("m_amp", 0, 0, 4, 0.001) : si.smoo;
    width = hslider("m_width", 0, 0, 1, 0.001) : si.smoo;
    rot = hslider("m_rot", 0, 0, 1, 0.001) : si.smoo * ma.PI;
    lpfreq = hslider("m_lpfreq[scale:exp]", 2400, 10, 20000, 1) : si.smoo;

    coef_in = hslider("d_leak", 0, 0, 1, 0.0001) : si.smoo;
    leakcoef = 1 - (coef_in * 0.001);

    mod1 = hslider("d_mod1[scale:exp]", 0.0001, 0.0001, 1, 0.00001) : si.smoo;
    mod2 = hslider("d_mod2[scale:exp]", 0.0001, 0.0001, 1, 0.00001) : si.smoo;
    bias1 = hslider("d_bias1[scale:exp]", 0.0001, 0.0001, 1, 0.00001) : si.smoo;
    bias2 = hslider("d_bias2[scale:exp]", 0.0001, 0.0001, 1, 0.00001) : si.smoo;
    lporder = 4;
    tanh = ma.tanh(_), ma.tanh(_); 
    leak = leakdc(0.999), leakdc(0.999);

    vca(amp) = _ * amp, _ * amp;


};



// process = ma.SR / 100000;