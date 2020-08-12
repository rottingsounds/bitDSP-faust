#include <bitset>
#include <string>
#include <iostream>
#include <climits>

#ifndef bitdsp_h
#define bitdsp_h

typedef std::bitset<32> bit32;

// int bit_shift(int last, int current, int amount) {
//     if (amount < 1)
//     {
//         return current;
//     }
//     if (amount >= 32)
//     {
//         return last;
//     }
//     return ((current >> amount) | (last << (32-amount)));
// }

int bit_not(int x) {
	return ~x;
}

int div_i(int x, int y) {
	return x/y;
}

int bit_print(int in) {
	    std::cout << bit32(in) << '\n';
	    return in;
}

int bit_print2counters(int counter1, int counter2, int in) {
	    std::cout << "(" << std::setfill('0') << std::setw(3) << counter1 << '\t' << std::setfill('0') << std::setw(3) << counter2 << ")\t" << bit32(in) << '\n';
	    return in;
}

int bit_leftShift(int a, int b) {
	return (int) ((uint32_t) a << (uint32_t) b);
}

int bit_rightShift(int a, int b) {
	return (int) ((uint32_t) a >> (uint32_t) b);
}


int parity (int in) {
    // find parity of 32bit uint, 
    // adapted from https://graphics.stanford.edu/~seander/bithacks.html#ParityParallel

	uint32_t ui_op = (uint32_t) in;
	ui_op ^= ui_op >> 16;
	ui_op ^= ui_op >> 8;
	ui_op ^= ui_op >> 4;
	ui_op &= 0xf;
	return (int) ((0x6996 >> ui_op) & 1);
}



#endif
