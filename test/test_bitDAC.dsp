import("stdfaust.lib");
b = library("bitDSP.lib");

process = b.bitDAC(6, 0, int(no.noise * b.int_max));
