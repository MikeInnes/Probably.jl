struct QBool
  bit::Bit
end

QBool(v::Bool = false) = QBool(Bit(v))

bits(x::QBool) = x.bit
repr(::Type{QBool}, bits) = bits[1]

Base.show(io::IO, ::QBool) = print(io, "QBool()")

function hadamard(x::QBool)
  apply!(H, x)
  return x
end

function not(x::QBool)
  apply!(X, x)
  return x
end

function cnot(c::QBool, x::QBool)
  apply!(CX, c, x)
  return x
end

function swap(a::QBool, b::QBool)
  apply!(S, a, b)
  return
end

function epr()
  a, b = QBool(), QBool()
  hadamard(a)
  cnot(a, b)
  return a, b
end
