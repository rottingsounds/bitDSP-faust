import("stdfaust.lib");
import("bitDSP_gen.lib");
cf1 = hslider("cf1", .5, 0, 1, .000001);
cf2 = hslider("cf2", .5, 0, 1, .000001);
vol = hslider("vol", 0, 0, 1, .000001);
process = gen1(cf1, cf2) : *(vol) , *(vol) ;
