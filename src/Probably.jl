module Probably

using Base.Iterators: filter, take, repeated

export State, ⊗

a ⊗ b = kron(a, b)

nbits(U) = round(Int, log2(size(U,1)))

include("state.jl")
include("operators.jl")

end # module
