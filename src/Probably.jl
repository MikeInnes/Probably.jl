module Probably

using Base.Iterators: filter, take, repeated
import LinearAlgebra

export State, QBool, QUInt, QBuffer, epr,
  measure, hadamard, not, cnot, swap,
  classical, control

eye(m::AbstractMatrix) = Matrix{eltype(m)}(LinearAlgebra.I, size(m))
a ⊗ b = kron(a, b)

include("operators.jl")
include("constants.jl")
include("state.jl")
include("bits.jl")

include("types/buffer.jl")
include("types/bool.jl")
include("types/int.jl")

end # module
