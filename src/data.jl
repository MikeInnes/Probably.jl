struct QBool
  bit::Bit
end

QBool() = QBool(Bit())

Base.show(io::IO, ::QBool) = print(io, "QBool()")

function hadamard(x::QBool)
  apply!(H, x.bit)
  return x
end

function not(x::QBool)
  apply!(X, x.bit)
  return x
end

function cnot(c::QBool, x::QBool)
  apply!(CX, c.bit, x.bit)
  return x
end

measure(x::QBool) = measure!(x.bit)[1]

function epr()
  a, b = QBool(), QBool()
  hadamard(a)
  cnot(a, b)
  return a, b
end
