// =============================================================================
//  Preliminary tests for random Boolean networks.
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
// For a period-M LCG, with C != 0, we must satisfy the following conditions:
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
lcg(M, A, C, S) =  ((+ (S - S') * A + C) % M)
                   ~ _;
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
not(N) = int(1 - N);
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
// Roughly, the given seed should be a positive int below 2^16.
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
rand_int(M, S) = abs(random) % M
    with {
        mask = 4294967295; // 2^32-1
        random =    (+(S) : *(1103515245) & mask) 
                    ~ _; // "linear congruential"
    };
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// This recursive function generates a gene with arbitrary K (inputs) based on
// a seed between ~1-2^16.
//
gene(2, S) = uf(lcg_par(1, 14, 15, 5, ba.take(1, seeds) + 1) + 1)
    with {
        seeds = lcg_par(1, 65521, 17364, 0, S);
    };
gene(K, S) = 
    uf(lcg_par(1, 14, 15, 5, ba.take(K - 1, seeds) + 1) + 1, gene(K - 1, S))
    with {
        seeds = lcg_par(K - 1, 65521, 17364, 0, S);
    };
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// This function generates a genes array of size N with arbitrary K based on
// a seed between ~1-2^16.
//
genes2(N, K, S) = par(i, N, gene(K, ba.take(i + 1, seeds)))
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
// and a seed, S. N and K should be power-of-two and the function generates
// homogeneous topologies, that is, genes interactions where individual
// gene contributions are equally but randomly distributed throughout the 
// network.
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
// Random Boolean networks generator. The function takes three ints, N, S_1,
// and S_2, resepctively for the network order (pow-of-2), the seed for the 
// genes array, and the seed for the topology type.
rbn(N, K, S_1, S_2) = genes2(N, K, S_1) ~ topology(N, K, S_2);
// -----------------------------------------------------------------------------
