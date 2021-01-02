// =============================================================================
//  Preliminary tests for random Boolean networks.
//  reference paper: https://arxiv.org/pdf/0706.3351v2.pdf
//  quick introduction: http://www.complexityexplorer.org/system/explore/models/writeup_files/000/000/040/original/random-boolean.pdf
// =============================================================================

declare author "Dario Sanfilippo";
declare copyright "Copyright (C) 2020 Dario Sanfilippo
      <sanfilippo.dario@gmail.com>";
declare lcg_par license "GPL v3 license";

import("stdfaust.lib");

// AUXILIARY FUNCTIONS

//------------------------------------------------------------------------------
// Linear congruential generator for streams of integer values based on
// the equation: y[n] = (A * y[n - 1] + C) % M.
// See https://en.wikipedia.org/wiki/Linear_congruential_generator.
//
// For a period-(M-1) LCG, with C != 0, we must satisfy the following conditions:
//
//      1: M and C are relatively prime,
//      2: A-1 is divisible by all prime factors of M,
//      3: A-1 is divisible by 4 if M is divisible by 4.
//
// This way, full-period cycles are guaranteed with any seeds != 0.
//
// For example, we can use lcg(14, 15, 5, S) to select the update functions
// with uniform probability.
//
// For power-of-two Ms, C should be coprime to M and A should 1+4K, where K 
// is an int, to have a full-cycle LCG.
//
// #### Usage
//
// ````
// lcg(M, A, C, S) : _
// ````
//
// Where:
//
// * M is the divisor in the modulo operation.
// * A is the multiplier.
// * C is the offset.
// * S is the seed.
//
// #### Reference:
//
// L’ecuyer, P. (1999). Tables of linear congruential generators of different
// sizes and good lattice structure. Mathematics of Computation, 68(225),
// 249-260.
//
// Steele, G., & Vigna, S. (2020). Computationally easy, spectrally good
// multipliers for congruential pseudorandom number generators. arXiv
// preprint arXiv:2001.05304.
//
lcg(M, A, C, S) =  ((+ (S - S') * A + C) % M) ~ _;
//------------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Linear congruential list generator
//
lcg_par(1, M, A, C, S) = (A * S + C) % M;
lcg_par(N, M, A, C, S) =   (A * S + C) % M ,
                           lcg_par(N - 1, M, A, C, (A * S + C) % M);
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Negation for single-digit binary values.
//
not(N) = rint(1 - N);
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// UPDATE FUNCTIONS
// The input cases for K = 2 (i.e., two-input genes) are: 00 - 01 - 10 - 11.
// Four input cases and binary updates, hence 2^4 update functions.
// The update functions below determine the next state of each gene depending 
// on the inputs.
// The 'frozen' update functions 1111 and 0000 are not considered.
//
uf(1) = &;                              // 0001
uf(2) = si.bus(2) <: uf(3) & uf(6);     // 0010
uf(3) = _ , 
        (_ : !);                        // 0011
uf(4) = si.bus(2) <: uf(6) & uf(12);    // 0100
uf(5) = (_ : !) ,
        _;                              // 0101
uf(6) = xor;                            // 0110
uf(7) = |;                              // 0111
uf(8) = not(|);                         // 1000
uf(9) = not(xor);                       // 1001
uf(10) = not(uf(5));                    // 1010
uf(12) = not(uf(3));                    // 1100
uf(11) = not(uf(4));                    // 1011
uf(13) = not(uf(2));                    // 1101
uf(14) = not(&);                        // 1110
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// This function creates a list with the digits of an integer number.
//
digits_par(0) = 0 : !;
digits_par(N) = digits_par(int(N / 10)) , 
                N % 10;
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// This function converts from binary to decimal.
//
bin2dec(0) = 0;
bin2dec(B) = digits_par(B) : par(i, elem, *(2 ^ (elem - (i + 1)))) :> _
    with {
        elem = outputs(digits_par(B));
    };
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Genes array generation through randomly chosen update functions.
// This function takes an int, N, indicating the array size, and a seed, S, for
// an LCG function that generates N seeds for N LCG functions. 
// The gene selection has a uniform probability distribution p = 1/14.
// Roughly, the given seed should be a positive int between 1 and 2^16.
//
genes(N, S) = 
    par(i, N, uf(lcg_par(1, 14, 15, 5, ba.take(i + 1, seeds) + 1) + 1))
    with {
        seeds = lcg_par(N, 65521, 17364, 0, S);
    };
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// This function generates uniformely distributed (or almost) positive random
// ints between 0 and M-1. The function also takes a seed, S.
//
rand_int(M, S) = abs(random) % M
    with {
        mask = 4294967295; // 2^32-1
        random =    (+(S) : *(1103515245) & mask) 
                    ~ _; // "linear congruential"
    };
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// This recursive function generates a gene with arbitrary K (inputs) based on
// a seed between 1 and 2^16, roughly. The genes are generated as homogeneous
// combinations of the 14 K=2 update functions defined above.
//
gene(2, S) = uf(ba.take(1, org) + 1)
    with {
        org = lcg_par(1, 14, 15, 5, S);
    };
gene(K, S) = 
    uf(ba.take(K - 1, org) + 1, gene(K - 1, S))
    with {
        org = lcg_par(K - 1, 14, 15, 5, S);
    };
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// This function generates a genes array of size N with arbitrary K based on
// a seed between 1 and 2^16, roughly.
//
genes2(N, K, S) = par(i, N, gene(K, ba.take(i + 1, seeds) + 1))
    with {
        seeds = lcg_par(N, 65521, 17364, 0, S);
    };
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// This function creates a list of N elements with random ints between
// 0 and M-1. The function also takes increment (C) and seed parameters (S).
// The increment should be odd to increase uniformity.
//
rand_int_par(1, M, C, S) = 
    (S + C) * 1103515245 & 4294967295 : abs : %(M);
rand_int_par(N, M, C, S) = 
    (S + C) * 1103515245 & 4294967295 : abs : %(M) ,
    rand_int_par(N - 1, M, C, (S + C) * 1103515245 & 4294967295);
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Topology selection for genes interactions. This function takes an int, N,
// representing the order of the network, the inputs number in each gene, K, 
// and a seed, S. The function generates homogeneous topologies, that is, 
// genes interactions where individual gene contributions are equally but 
// randomly distributed throughout the network. N and K should be pow-of-2
// for maximum homogeneity.
// The seed should be a positive int roughly below 2^16.
//
topology(N, K, S) =
    si.bus(N) <: 
        par(i, N * K, si.bus(N) <:
            ba.selector(ba.take(i + 1, routes), N * K))
    with {
        routes = lcg_par(N * K, N * K, 5, 15, S);
    };
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Random Boolean networks generator. The function takes four ints, N, K, S_1,
// and S_2, respectively for the network order (pow-of-2), genes inputs, 
// the seed for the genes array, the seed for the topology type, and a list 
// of numbers determining the delays in samples for each feedback path. The function also 
// provides a slider to expand or compress the delays.
//
rbn(N, K, S_1, S_2, del_seq) =   
    genes2(N, K, S_1) 
    ~ (delays(N, del_seq) : topology(N, K, S_2));
// -----------------------------------------------------------------------------

// full_adder(x1[n], x2[n], c_in[n]); ------------------------------------------
//
// (author: Dario Sanfilippo)
//
// Adder for binary values. It adds two operands as well as a carrier
// input. It outputs the sum as well as the carrier output.
//
// 3 inputs:
//    x1[n], first operand;
//    x2[n], second operand;
//    c_in[n], carrier input.
//
// 2 outputs:
//    s_out[n], resulting sum;
//    c_out[n], carrier output.
//
full_adder(x1, x2, c_in) = s_out ,
                           c_out
      with {
           s_out = xor(rint(c_in), xor(rint(x1), rint(x2)));
           c_out = (rint(c_in) & xor(rint(x1), rint(x2))) |
                (rint(x1) & rint(x2));
      };
// -----------------------------------------------------------------------------

// bitstream_adder(x1[n], x2[n]); ----------------------------------------------
//
// (author: Dario Sanfilippo)
//
// Adder for delta-sigma-modulated streams.
//
// 2 inputs:
//    x1[n], first bitstream;
//    x2[n], second bitstream.
//
// 1 outputs:
//    y[n], resulting bitstream summation.
//
bitstream_adder(x1, x2) =  loop
                           ~ _ :   ! ,
                                   _
      with {
           loop(fb) = full_adder(x1, x2, fb);
      };
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Binary summing bus of N inputs.
//
bitstream_adderN(1) = _;
bitstream_adderN(2) = bitstream_adder;
bitstream_adderN(N) =   bitstream_adderN(N - 1) , 
                        _ : bitstream_adder;
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// N-delay array.
//
delays(N, sequence) = 
    par(i, N, rint(de.fdelay(ba.take(i + 1, sequence), 
        abs((ba.take(i + 1, sequence) * factor) % ba.take(i + 1, sequence)))))
    with {
        factor = 16 ^ hslider("delays stretching", 0, -1, 1, .001);
    };
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Lists of number sequences for delay lines.
//
seq_primes = 
    (2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53);
seq_fibonacci = 
    (1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987);
seq_hexagonal = 
    (1, 6, 15, 28, 45, 66, 91, 120, 153, 190, 231, 276, 325, 378, 435, 496);
seq_lazycaterer = 
    (1, 2, 4, 7, 11, 16, 22, 29, 37, 46, 56, 67, 79, 92, 106, 121);
seq_magic = 
    (15, 34, 65, 111, 175, 260, 369, 505, 671, 870, 1105, 1379, 1695, 2056, 
        2465, 2925);
seq_pentagonal = 
    (1, 2, 5, 7, 12, 15, 22, 26, 35, 40, 51, 57, 70, 77, 92, 100);
seq_square = 
    (1, 4, 9, 16, 25, 36, 49, 64, 81, 100, 121, 144, 169, 196, 225, 256);
seq_triangular =
    (1, 3, 6, 10, 15, 21, 28, 36, 45, 55, 66, 78, 91, 105, 120, 136);
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Process example.
//
// Try stretch values 0.042 or -0.037.
//
// N = 8;
// K = 8;
// process = 
//     rbn(N, K, 316, 153, seq_hexagonal) : par(i, 2, bitstream_adderN(N / 2));
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Process example.
//
N = 16; // genes array size
K = 8; // genes input size
process =
    rbn(N, K, 231, 415, seq_fibonacci) : par(i, 2, bitstream_adderN(N / 2));
// -----------------------------------------------------------------------------
