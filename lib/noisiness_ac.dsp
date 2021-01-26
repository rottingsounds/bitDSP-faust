import("stdfaust.lib");
import("bandpass.lib");

declare name "Time-domain noisiness measurement through autocorrelation approximation.";
declare author "Dario Sanfilippo";
declare copyright "Copyright (C) 2021 Dario Sanfilippo 
    <sanfilippo.dario@gmail.com>";
declare version "0.10";
declare license "GPL v3.0 license";

ddsm1(x) = y
    letrec {
        'y = ba.if(fi.pole(1, x - y) < 0, -1, 1);
    };

test = ddsm1(bp(cf, q, no.noise)) > 0;
cf = hslider("f[1][scale:log]", 1000, 10, 20000, .00001) : si.smoo;
q = hslider("q[2]", 1, 0.001, 1000, .000001);
cal = nentry("calibrate[3]", 1, 0, 1024, .000001);
noisiness(x) = par(i, 32, smooth(abs(delta(ba.take(i + 1, lags), x))) : inspect(ba.take(i + 1, prime_bands), 0, 1)) : (1 - aad(32) * cal) : inspect(0, -5, 5)
    with {
        prime_bands = ( 17, 19, 23, 31, 41, 53, 61, 79, 101, 127, 157, 199,
                        251, 317, 397, 503, 631, 797, 997, 1259, 1583, 1997,
                        2521, 3163, 3989, 5011, 6301, 7949, 10007, 12589, 15859,
                        19949);
        lags = par(i, 32, (1 / ba.take(i + 1, prime_bands)) * ma.SR);
        delta(del, in) = in xor (in @ del);
        smooth(in) = fi.pole(1 - (1 / ma.SR), in * (1 / ma.SR));
        inspect(i, lower, upper) =
            _ <:    _ ,
                    vbargraph("sig_%2i [style:numerical][2i]", lower, upper)
                        : attach;
        aad(N) =
            si.bus(N) <:    (si.bus(N) ,
                            (si.bus(N) :> / (N) <: si.bus(N))
                                : ro.interleave(N, 2) :
                                    par(i, N, (- : abs)) :> _) ,
                                        (si.bus(N) :> / (N)) : div :
                                            /((N - 1) * 2);
        div(x1, x2) = x1 / ba.if(   x2 < 0,
                                    min(ma.EPSILON * -1, x2),
                                    max(ma.EPSILON, x2));
    };
process = (bp(cf, q, no.noise) <: si.bus(2)) , noisiness(test) * checkbox("unmute");

