module Probably

using Base.Iterators: filter, take, repeated

export State, QBool, QBuffer, epr,
  measure, hadamard, not, cnot, swap,
  classical, control

a ⊗ b = kron(a, b)

include("operators.jl")
include("state.jl")
include("bits.jl")

include("types/buffer.jl")
include("types/bool.jl")

end # module
