module ArbDecimals

export string_small, string_large,
       two, three, four,
       abz, abz2, invsqrt, addmul, submul, muladd, mulsub,
       isexact, notexact,
       isposinf, isneginf,
       notnan, notinf, notposinf, notneginf, notfinite,
       iszero, notzero, nonzero, isone, notone, notinteger,
       ispositive, notpositive, isnegative, notnegative,
       includesAnInteger, excludesIntegers, includesZero, excludesZero,
       includesPositive, excludesPositive, includesNegative, excludesNegative,
       includesNonpositive,  includesNonnegative,
      simeq, nsime, prec, preceq, succ, succeq, # non-strict total ordering comparisons
       (≃), (≄), (≺), (⪯), (≻), (⪰),           #    matched binary operators
       upperbound, lowerbound, bounds,
       areequal, notequal, approxeq, (≊),
       narrow, overlap, donotoverlap,
       contains, iscontainedby, doesnotcontain, isnotcontainedby,
       absz, absz2, invsqrt, pow, root, 
       tanpi, cotpi, logbase, sincos, sincospi, sinhcosh,
       doublefactorial, risingfactorial, rgamma, agm, polylog,
       Dec5, Dec10, Dec15, 
       Dec20, Dec25, Dec30, Dec40, Dec50, Dec60,
       Dec75, Dec80, Dec90, Dec100, Dec125, Dec150, Dec175,
       Dec200, Dec225, Dec250, Dec275, Dec300, Dec325, Dec350, Dec375,
       Dec400, Dec425, Dec450, Dec475, Dec500, Dec525, Dec550, Dec575, Dec600

import Base: hash, convert, promote_rule, STDIN, STDOUT,
             string, show, showcompact, showall,
             copy, deepcopy, typemax, typemin, realmax, realmin,
             decompose, zero, one,
             isequal, isless, (==),(!=),(<),(<=),(>=),(>), contains,
             min, max, minmax, sort,
             signbit, abs, abs2, inv,
             (+), (-), (*), (/), (^), (%),
             sqrt, hypot,
             sin, cos, tan, csc, sec, cot, 
             sinh, cosh, tanh, csch, sech, coth, 
             asin, acos, atan, acsc, asec, acot, atan2, 
             asinh, acosh, atanh, acsch, asech, acoth,
             factorial, gamma, digamma, zeta

#using ArbFloats
import ArbFloats: initializer, c_release_arb, @libarb,
                  ptr_to_midpoint, ptr_to_radius,
                  midpoint, radius, diameter,
                  upperbound, lowerbound, bounds, 
                  ArfFloat


#=
    environmental defaults are constants
      given by the macros defined here
=#
macro digitsForSmallStrings() 12 end
macro digitsForLargeStrings() 72 end



include("type/ArbDec.jl")
include("type/aspects.jl")
include("type/convert.jl")
include("type/promote.jl")

include("basics/predicates.jl")
include("basics/compare.jl")
include("basics/sorting.jl")

include("io/string.jl")
include("io/show.jl")
include("io/stream.jl")

include("math/arith.jl")
include("math/elementary.jl")
include("math/special.jl")

end # module
