mutable struct State{A<:AbstractVector{<:Complex}}
  ψ::A
end

State(ψ::AbstractVector{<:Real}) = State(float(complex(ψ)))

function State(n::Integer, vs::AbstractVector{<:Integer})
  ψ = zeros(Complex128, 2^n)
  foreach(v -> ψ[2^n-v] = 1/√length(vs), vs)
  return State(ψ)
end

State(n::Integer) = State(n, [0])

nbits(s::State) = nbits(s.ψ)
Base.length(s::State) = nbits(s)

labels(s::State) = reverse(map(n -> bits(n-1)[end-nbits(s)+1:end], 1:length(s.ψ)))

probabilities(s::State) = abs2.(s.ψ)

function Base.show(io::IO, s::State; n = 5)
  basis = reverse(collect(Iterators.filter(x -> x[2] ≉ 0, zip(labels(s), probabilities(s)))))
  length(basis) == 1 && return print(io, "|$(basis[1][1])⟩")
  join(io, ["|$l⟩ : $p" for (l, p) in take(basis, n)], "\n")
  length(basis) > n && print(io, "\n    ⋮")
end

function apply!(U::AbstractMatrix, s::State)
  s.ψ = U * s.ψ
  return s
end

function apply!(U::AbstractMatrix, s::State, is...)
  @assert nbits(U) == length(is)
  U = pad(U, 0, nbits(s)-nbits(U))
  S = reduce(*, [swap(nbits(s), i, j) for (i, j) in enumerate(is)])
  apply!(S*U*S, s)
end

# s = State(5)

# apply!(H, s, 3)
