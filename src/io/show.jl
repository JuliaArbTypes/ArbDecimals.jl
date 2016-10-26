function showall{D,P}(io::IO, x::ArbDec{D,P})
    str = stringall(x)
    print(io, str)
end
showall{D,P}(x::ArbDec{D,P}) = showall(STDOUT, x)

function showcompact{D,P}(io::IO, x::ArbDec{D,P})
    str = stringcompact(x)
    print(io, str)
end
showcompact{D,P}(x::ArbDec{D,P}) = showcompact(STDOUT, x)

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


function show{D,P}(io::IO, x::ArbDec{D,P})
    str = string(x)
    print(io, str)
end
show{D,P}(x::ArbDec{D,P}) = show(STDOUT, x)

function show{D,P}(io::IO, x::ArbDec{D,P}, digs::Int)
    str = string(x, digs)
    print(io, str)
end
show{D,P}(x::ArbDec{D,P}, digs::Int) = show(STDOUT, x, digs)
