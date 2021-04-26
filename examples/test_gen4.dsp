import("stdfaust.lib");
import("bitDSP_gen.lib");
fb1 = hslider("fb1", 0.1, -1, 1, .000001);
fb2 = fb1; 
//fb2 = hslider("fb2", 0.1, -1, 1, .000001);
vol = hslider("vol", 0, 0, 1, .000001);
process = gen4(fb1, fb2) : *(vol) , *(vol) ;
