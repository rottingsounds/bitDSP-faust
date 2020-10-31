// =============================================================================
//  Preliminary tests for random Boolean networks.
// =============================================================================

declare author "Dario Sanfilippo";
declare copyright "Copyright (C) 2020 Dario Sanfilippo
      <sanfilippo.dario@gmail.com>";
declare lcg_par license "GPL v3 license";

// AUXILIARY FUNCTIONS

// -----------------------------------------------------------------------------
// linear congruential list generator
//
lcg_par(1, M, A, C, S) = (A * S + C) % M;
lcg_par(N, M, A, C, S) =   (A * S + C) % M ,
                           lcg_par(N - 1, M, A, C, (A * S + C) % M);
// -----------------------------------------------------------------------------

// m2.matrix(R, C); ------------------------------------------------------------
//
// R-input, C-output matrix:
//
// a11 a12 … a1C
// a21 a22 … a2C
//  ⋮   ⋮  ⋱  ⋮
// aR1 aR2 … aRC
// 
// R+R*C inputs:
//    R, input signals to be distributed through the C outputs;
//    R*C, coefficients as shown in the diagram above;
//
// C outputs.
//
// 2 compile-time arguments:
//    R, (integer) number of rows;
//    C, (integer) number columns.
//
matrix(r, c) = (si.bus(r), ro.interleave(c, r)) : ro.interleave(r, c + 1) :
      par(i, r, (_ <: si.bus(c)) , 
      si.bus(c) : ro.interleave(c, 2) : par(i, c, *)) :> si.bus(c);
// -----------------------------------------------------------------------------

matrix(r, c) = (si.bus(r), ro.interleave(c, r)) : ro.interleave(r, c + 1) :
      par(i, r, (_ <: si.bus(c)) ,
      si.bus(c) : ro.interleave(c, 2) : par(i, c, *)) :> si.bus(c);
not(N) = int(1 - N);

// -----------------------------------------------------------------------------
// UPDATE FUNCTIONS
// The input cases for K = 2 (i.e., two-input genes) are: 00 - 01 - 10 - 11.
// Four input cases and binary updates, hence 2^4 update functions.
// The update functions below determine the next state of each gene depending 
// on the inputs.
// The 'frozen' update functions 1111 and 0000 are not considered.
//
uf(0) = &; //           0001
uf(1) = |; //           0111
uf(2) = xor; //         0110
uf(3) = not(&); //      1110
uf(4) = not(|); //      1000
uf(5) = not(xor); //    1001
uf(6) = _ , 
        (_ : !); //     0011
uf(7) = (_ : !) ,
        _; //           0101
uf(8) = not(uf(6)); //  1100
uf(9) = not(uf(7)); //  1010
uf(10) = si.bus(2) <: uf(2) & uf(7); // 0100
uf(11) = si.bus(2) <: uf(6) & uf(9); // 0010
uf(12) = not(uf(10)); // 1011
uf(13) = not(uf(11)); // 1101
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

