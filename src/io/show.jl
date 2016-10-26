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
