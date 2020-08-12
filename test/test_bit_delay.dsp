import("stdfaust.lib");

b = library("bitDSP.lib");

// bit_delay(0, x) = x;
// bit_delay(32, x) = x';
// bit_delay(delta, x) = ((x >> delta) | (x' << (32-delta)));

line = 1:+~_;

input = select2(1', -1216614433, 1216614432);

s_count = (1:+~_) - 1;

// parallel execution of the 32 cases for the bit_delay, 
// I'd like to feed all of them the two values I defined in `input`, 
// where the first value (-1216614433) is x' and the second value (1216614432) is x

process = input <: par(i,32,b.delay32(i) : b.print2(s_count, i));

// process = input <: par(i,32,b.delay32(i));