module Probably

using Base.Iterators: filter, take, repeated

export State, ⊗

a ⊗ b = kron(a, b)

include("operators.jl")
include("state.jl")
include("buffer.jl")

end # module
