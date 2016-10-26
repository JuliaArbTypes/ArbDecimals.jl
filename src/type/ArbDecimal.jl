    #       D is number of digits shown as a parameter
    #       P is the precision in bits as a parameter
    #
type ArbDec{D,P} <: AbstractFloat
                               ##     ArfFloat{P}
    exponentOf2 ::Int          ##        exponentOf2
    nwords_sign::Int           ##        nwords_sign
    significand1::UInt         ##        significand1
    significand2::UInt         ##        significand2
                               ###    ArbMag{P}
    radius_exponentOf2::Int    ####      radius_exponentOf2
    radius_significand::UInt   ####      radius_significand
end


macro workingDigitsGivenWorkingBits(bits)
    quote cld(($bits * 3010), 10000) end
end
macro workingDigitsGivenDigitsShown(digs)
    quote ($digs << 1) + 8 end
end

macro workingBitsGivenDigitsShown(digs)
    quote (cld(($digs * 10000), 3010) << 1) + 24  end
end
macro digitsShownGivenWorkingBits(bits)
    quote (cld(($bits * 3010), 10000) - 8) >> 1 end
end


function releaseArbDec{D,P}(x::ArbDec{D,P})
    ccall(@libarb(arb_clear), Void, (Ptr{ArbDec{D,P}}, ), &x)
end

function initializer{D,P}(::Type{ArbDec{D,P}})
    z = ArbDec{D,P}(0,0,0,0,0,0)
    ccall(@libarb(arb_init), Void, (Ptr{ArbDec{D,P}}, ), &z)
    finalizer(z, releaseArbDec)
    return z
end

function initializer{D}(::Type{ArbDec{D}})
    P = @workingBitsGivenDigitsShown(D)
    z = ArbDec{D,P}(0,0,0,0,0,0)
    ccall(@libarb(arb_init), Void, (Ptr{ArbDec}, ), &z)
    finalizer(z, releaseArbDec)
    return z
end

# a type specific hash function helps the type to 'just work'
const hash_arbdec_lo = (UInt === UInt64) ? 0x163320026ea54ace : 0x361c4d89;
const hash_0_arbdec_lo = hash(zero(UInt), hash_arbdec_lo);
# two values of the same precision
#    with identical midpoint significands and identical radus_exponentOf2s hash equal
# they are the same value, one is less accurate yet centered about the other
hash{D,P}(z::ArbDec{D,P}, h::UInt) =
    hash(z.significand1$z.exponentOf2,
         (h $ hash(z.significand2$(~reinterpret(UInt,P)), hash_arbdec_lo)
            $ hash_0_arbdec_lo))


# D is Decimal Digits Shown
# P is Precision, Working Bits Used
#
#                         D    P
#                        ---  ----
typealias Dec5   ArbDec{   5,   58 }
typealias Dec6   ArbDec{   6,   64 }
typealias Dec8   ArbDec{   8,   70 }
typealias Dec10  ArbDec{  10,   92 }
typealias Dec12  ArbDec{  12,  104 }
typealias Dec15  ArbDec{  15,  124 }
typealias Dec17  ArbDec{  17,  138 }
typealias Dec18  ArbDec{  18,  144 }
typealias Dec20  ArbDec{  20,  158 }
typealias Dec25  ArbDec{  25,  192 }
typealias Dec30  ArbDec{  30,  224 }
typealias Dec35  ArbDec{  35,  258 }
typealias Dec40  ArbDec{  40,  290 }
typealias Dec45  ArbDec{  45,  324 }
typealias Dec50  ArbDec{  50,  358 }
typealias Dec60  ArbDec{  60,  424 }
typealias Dec70  ArbDec{  70,  490 }
typealias Dec75  ArbDec{  75,  524 }
typealias Dec80  ArbDec{  80,  556 }
typealias Dec90  ArbDec{  90,  624 }
typealias Dec100 ArbDec{ 100,  690 }
typealias Dec125 ArbDec{ 125,  856 }
typealias Dec150 ArbDec{ 150, 1022 }
typealias Dec175 ArbDec{ 175, 1188 }
typealias Dec200 ArbDec{ 200, 1354 }
typealias Dec225 ArbDec{ 225, 1520 }
typealias Dec250 ArbDec{ 250, 1686 }
typealias Dec275 ArbDec{ 275, 1852 }
typealias Dec300 ArbDec{ 300, 2018 }
typealias Dec325 ArbDec{ 325, 2184 }
typealias Dec350 ArbDec{ 350, 2350 }
typealias Dec375 ArbDec{ 375, 2516 }
typealias Dec400 ArbDec{ 400, 2692 }
typealias Dec425 ArbDec{ 425, 2848 }
typealias Dec450 ArbDec{ 450, 3016 }
typealias Dec475 ArbDec{ 475, 3182 }
typealias Dec500 ArbDec{ 500, 3348 }
typealias Dec525 ArbDec{ 525, 3514 }
typealias Dec550 ArbDec{ 550, 3680 }
typealias Dec575 ArbDec{ 575, 3846 }
typealias Dec600 ArbDec{ 600, 4012 }


