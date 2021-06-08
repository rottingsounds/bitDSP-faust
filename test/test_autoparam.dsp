import("stdfaust.lib");
inspect(i) = bit.inspect(i, -1, 1);
bit = library("bitDSP.lib");
gen = library("bitDSP_gen.lib");
fb1 = hslider("fb1", 0.1, -1, 1, .000001);
fb2 = hslider("fb2", 0.1, -1, 1, .000001);

process = gen.gen3 ~ (ro.cross(2) : par(i, 2, bit.autoparam + .54233) : par(i, 2, inspect(i))) : par(i, 2, fi.highpass(1, 20));

//process = gen.gen3(fb1, fb2) <: par(i, 2, fi.highpass(1, 20)) , (par(i, 2, bit.autoparam) : par(i, 2, inspect(i)));

