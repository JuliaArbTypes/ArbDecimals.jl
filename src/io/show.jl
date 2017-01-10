#=
function show{D,P}(io::IO, x::ArbDec{D,P})
    str = string(x)
    print(io, str)
end
show{D,P}(x::ArbDec{D,P}) = show(STDOUT, x)
=#
show{D,P}(io::IO, x::ArbDec{D,P}) = show_small(io, x)
show{D,P}(x::ArbDec{D,P}) = show_small(STDOUT, x)

function show{D,P}(io::IO, x::ArbDec{D,P}, digs::Int)
    str = string(x, digs)
    print(io, str)
end
show{D,P}(x::ArbDec{D,P}, digs::Int) = show(STDOUT, x, digs)


function show_all{D,P}(io::IO, x::ArbDec{D,P})
    str = string_all(x)
    print(io, str)
end
show_all{D,P}(x::ArbDec{D,P}) = show_all(STDOUT, x)

function show_compact{D,P}(io::IO, x::ArbDec{D,P})
    str = string_compact(x)
    print(io, str)
end
show_compact{D,P}(x::ArbDec{D,P}) = show_compact(STDOUT, x)

function show_small{D,P}(io::IO, x::ArbDec{D,P})
    str = string_small(x)
    print(io, str)
end
show_small{D,P}(x::ArbDec{D,P}) = show_small(STDOUT, x)

function show_large{D,P}(io::IO, x::ArbDec{D,P})
    str = string_large(x)
    print(io, str)
end
show_large{D,P}(x::ArbDec{D,P}) = show_large(STDOUT, x)

