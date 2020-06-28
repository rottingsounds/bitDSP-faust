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

#endif