struct QUInt{N}
  bits::Bits{N}
end

QUInt{N}(v::Integer = 0) where N = QUInt{N}(Bits{N}(v))

const uint_types = [UInt8,UInt16,UInt32,UInt64]
@generated uint_type(::Type{QUInt{N}}) where N = uint_types[ceil(Int,N/8)]

bits(x::QUInt) = x.bits
repr(::Type{QUInt{N}}, bits) where N = uint_type(QUInt{N})(int(bits))
Base.show(io::IO, x::QUInt) = print(io, "QUInt{$(nbits(x.bits))}()")

for N in [4,8,16,32,64]
  QUIntN = Symbol(:QUInt,N)
  @eval export $QUIntN
  @eval const $QUIntN = QUInt{$N}
end
