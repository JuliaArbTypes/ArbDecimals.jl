function serialize{D,P}(ser::AbstractSerializer, a::ArbDec{D,P})
    serialize_type(ser, T)
    write(ser.io, string_typed(a))
end

function deserialize{D,P}(ser::AbstractSerializer, ::Type{ArbDec{D,P}})
    parse( read(ser.io, String) )
end
