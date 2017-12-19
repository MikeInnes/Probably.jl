# Probably

[![Build Status](https://travis-ci.org/MikeInnes/Probably.jl.svg?branch=master)](https://travis-ci.org/MikeInnes/Probably.jl)

```julia
Pkg.clone("https://github.com/MikeInnes/Probably.jl")
```

*Probably* is a little simulator for quantum information and computation. It's designed to be flexible enough to experiment with algorithms, protocols and programming models while also scaling to fairly large simulations.

Create an EPR pair:

```julia
julia> using Probably

julia> a, b = QBool(), QBool()
(QBool(), QBool())

julia> hadamard(a)

julia> cnot(a, b)

julia> measure.((a, b))
(true, true) # or (false, false)
```

Lower-level interface: work directly with quantum states and arbitrary unitary transformations:

```julia
julia> using Probably: State, apply!, I, H, CX, ⊗

julia> ψ = State(4)
|0000⟩

julia> apply!(I⊗H⊗I⊗I, ψ)
|0100⟩ * (0.7071067811865475 + 0.0im) +
|0000⟩ * (0.7071067811865475 + 0.0im)

julia> apply!(I⊗CX⊗I, ψ)
|0110⟩ * (0.7071067811865475 + 0.0im) +
|0000⟩ * (0.7071067811865475 + 0.0im)
```
