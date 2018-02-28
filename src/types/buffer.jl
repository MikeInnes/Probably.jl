# TODO: store types other than QBool

struct QBuffer
  bits::Bits
end

QBuffer(n::Integer) = QBuffer(Bits{n}())

Base.show(io::IO, buf::QBuffer) = print(io, "QBuffer(", length(buf), ")")

Base.length(buf::QBuffer) = nbits(buf.bits)
Base.endof(buf::QBuffer) = length(buf)

function Base.getindex(buf::QBuffer, i::Integer)
  @assert 1 ≤ i ≤ length(buf)
  QBool(Bit(buf.bits.offset+i-1, buf.bits.state))
end
