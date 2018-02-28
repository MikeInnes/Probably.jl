struct QBool
  bit::Bit
end

QBool(v::Bool = false) = QBool(Bit(v))

Base.show(io::IO, ::QBool) = print(io, "QBool()")

function apply!(U, bs::QBool...)
  apply!(U, map(x -> x.bit, bs)...)
  return
end

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

measure(x::QBool) = measure!(x.bit)[1]

function epr()
  a, b = QBool(), QBool()
  hadamard(a)
  cnot(a, b)
  return a, b
end
