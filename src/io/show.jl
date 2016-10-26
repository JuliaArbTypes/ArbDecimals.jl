#=
function show{D,P}(io::IO, x::ArbDec{D,P})
    str = string(x)
    print(io, str)
end
show{D,P}(x::ArbDec{D,P}) = show(STDOUT, x)
=#
show{D,P}(io::IO, x::ArbDec{D,P}) = showsmall(io, x)
show{D,P}(x::ArbDec{D,P}) = showsmall(STDOUT, x)

function show{D,P}(io::IO, x::ArbDec{D,P}, digs::Int)
    str = string(x, digs)
    print(io, str)
end
show{D,P}(x::ArbDec{D,P}, digs::Int) = show(STDOUT, x, digs)


function showall{D,P}(io::IO, x::ArbDec{D,P})
    str = string_all(x)
    print(io, str)
end
showall{D,P}(x::ArbDec{D,P}) = showall(STDOUT, x)

function showcompact{D,P}(io::IO, x::ArbDec{D,P})
    str = string_compact(x)
    print(io, str)
end
showcompact{D,P}(x::ArbDec{D,P}) = showcompact(STDOUT, x)

function showsmall{D,P}(io::IO, x::ArbDec{D,P})
    str = string_small(x)
    print(io, str)
end
show_small{D,P}(x::ArbDec{D,P}) = show_small(STDOUT, x)

function showlarge{D,P}(io::IO, x::ArbDec{D,P})
    str = string_large(x)
    print(io, str)
end
show_large{D,P}(x::ArbDec{D,P}) = show_large(STDOUT, x)

