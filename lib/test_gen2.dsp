import("stdfaust.lib");
import("bitDSP_gen.lib");
G = hslider("G", 1, 1, 1024, .000001);
fb = hslider("fb", 0, 0, 1, .000001);
vol = hslider("vol", 0, 0, 1, .000001);
process = gen2(G, fb) : *(vol) , *(vol) ;
