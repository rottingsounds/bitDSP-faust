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


// bool_osc1_mod(del1, del2) = node1 letrec {
//   'node1 = not(node1 xor node2 & node1) @ min(maxDel,(del1 % maxDel));
//   'node2 = not(node2 xor node1 xor node2) @ min(maxDel,(del2 % maxDel));
// };


// bool_osc2_mod(del1, del2) = node1 letrec {
//   'node1 = not(node1 & node2) @ min(maxDel,(del1 % maxDel));
//   'node2 = not(node1 & node2) @ min(maxDel,(del2 % maxDel));
// };

bool_osc1_mod(d1, d2) = node1 letrec {
  'node1 = delay(d1, not(node1 xor node2 & node1));
  'node2 = delay(d2, not(node2 xor node1 xor node2));
};


bool_osc2_mod(d1, d2) = node1 letrec {
  'node1 = delay(d1, not(node1 & node2));
  'node2 = delay(d2, not(node1 & node2));
};




delay(d, x) = de.delay(maxDel, (d % maxDel), x);
not(x) = rint(1 - x);
maxDel = ma.SR / 4;


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
process = (
    oscfb1(leakcoef, bias1, bias2, mod1, mod2),
    oscfb2(leakcoef, bias1, bias2, mod1, mod2)
)
    : leakDC
    : rotate2(rot)
    : ms(1) : ms(width)
    : vca(distort)
    : tanh
    : vca(amp)
    : fi.lowpass(lporder, lpfreq), fi.lowpass(lporder, lpfreq)
    // <: si.bus(2)
with {
    mod1 =    hslider("[01]mod1[scale:exp]", 0.0001, 0.0001, 1, 0.00001) : si.smoo;
    mod2 =    hslider("[02]mod2[scale:exp]", 0.0001, 0.0001, 1, 0.00001) : si.smoo;
    bias1 =   hslider("[03]bias1[scale:exp]", 0.0001, 0.0001, 1, 0.00001) : si.smoo;
    bias2 =   hslider("[04]bias2[scale:exp]", 0.0001, 0.0001, 1, 0.00001) : si.smoo;

    leak =    hslider("[05]leak", 0.01, 0, 1, 0.0001) : si.smoo;
    leakcoef = 1 - (leak * 0.001);


    distort = hslider("[06]distort[scale:exp]", 1, 1, 10, 0.001) : si.smoo;
    amp =     hslider("[07]amp", 0.5, 0, 1, 0.001) : si.smoo;

    width =   hslider("[08]width", 1, 0, 1, 0.001) : si.smoo;
    rot =     hslider("[09]rot", 0.25, 0, 1, 0.001) : si.smoo * ma.PI;
    lpfreq =  hslider("[10]lpfreq[scale:exp]", 10000, 10, 20000, 1) : si.smoo;


    lporder = 4;
    tanh = ma.tanh(_), ma.tanh(_);
    leakDC = leakdc(0.999), leakdc(0.999);

    vca(amp) = _ * amp, _ * amp;


};
