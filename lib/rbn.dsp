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

// input cases for K = 2 are: 00 - 01 - 10 - 11.
// update functions

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

// 0001 & 0111 = 0001
// 0001 & 0110 = 0000 *
// 0001 & 1110 = 0000 *
// 0001 & 1000 = 0000 *
// 0001 & 1001 = 0001
// 0111 & 0110 = 0110
digits_par(0) = 0 : !;
digits_par(N) = digits_par(int(N / 10)) , 
                N % 10;
bin2dec(0) = 0;
bin2dec(B) = digits_par(B) : par(i, elem, *(2 ^ (elem - (i + 1)))) :> _
    with {
        elem = outputs(digits_par(B));
    };
