import("stdfaust.lib");

a = int(os.osc(440) * 20);
b = 7;
process  = int(a/b);
