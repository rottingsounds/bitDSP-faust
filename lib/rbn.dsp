// =============================================================================
//  Preliminary tests for random Boolean networks.
// =============================================================================

declare author "Dario Sanfilippo";
declare copyright "Copyright (C) 2020 Dario Sanfilippo
      <sanfilippo.dario@gmail.com>";
declare lcg_par license "GPL v3 license";

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
uf(0) = &;                              // 0001
uf(1) = |;                              // 0111
uf(2) = xor;                            // 0110
uf(3) = not(&);                         // 1110
uf(4) = not(|);                         // 1000
uf(5) = not(xor);                       // 1001
uf(6) = _ , 
        (_ : !);                        // 0011
uf(7) = (_ : !) ,
        _;                              // 0101
uf(8) = not(uf(6));                     // 1100
uf(9) = not(uf(7));                     // 1010
uf(10) = si.bus(2) <: uf(2) & uf(7);    // 0100
uf(11) = si.bus(2) <: uf(6) & uf(9);    // 0010
uf(12) = not(uf(10));                   // 1011
uf(13) = not(uf(11));                   // 1101
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
genes(N, S) = par(i, N, uf(lcg_par(1, 14, 15, 5, ba.take(i + 1, seeds) + 1)))
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
        random =    (+(S) : *(1103515245) & mask) ~ _; // "linear congruential"
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
// representing the order of the network, and a seed, S, which in turn
// generates two seeds for two LCG function to select the connections to each
// gene.
// The seed should be a positive int roughly below 2^16.
//
topology(N, S) =
    si.bus(N) <: par(i, N, si.bus(N) <:
        ba.selectn(N, lcg_par(1, 16, 5, 3, ba.take(i * 2 + 1, seeds))) ,
        ba.selectn(N, lcg_par(1, 16, 5, 3, ba.take(i * 2 + 2, seeds))))
    with {
        seeds = lcg_par(N * 2, 65521, 17364, 0, S);
    };
// -----------------------------------------------------------------------------
