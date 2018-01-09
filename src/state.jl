mutable struct State{A<:AbstractVector{<:Complex}}
  ψ::A
end

State(ψ::AbstractVector{<:Real}) = State(float(complex(ψ)))

function State(n::Integer, vs::NTuple{N,Integer}) where N
  ψ = zeros(Complex128, 2^n)
  foreach(v -> ψ[v+1] = 1/√length(vs), vs)
  return State(ψ)
end

State(n::Integer) = State(n, (0,))

nbits(s::State) = nbits(s.ψ)
Base.length(s::State) = nbits(s)

labels(s::State) = map(n -> Base.bits(n-1)[end-nbits(s)+1:end], 1:length(s.ψ))

probabilities(s::State) = abs2.(s.ψ)

function Base.show(io::IO, s::State; n = 5)
  basis = reverse(collect(Iterators.filter(x -> x[2] ≉ 0, zip(labels(s), s.ψ))))
  length(basis) == 1 && basis[1][2] ≈ 1 && return print(io, "|$(basis[1][1])⟩")
  join(io, ["|$l⟩ * ($p)" for (l, p) in take(basis, n)], " +\n")
  length(basis) > n && print(io, "\n    ⋮")
end

function apply!(U::AbstractMatrix, s::State)
  s.ψ = U * s.ψ
  return s
end

function apply!(U::AbstractMatrix, s::State, is...)
  @assert nbits(U) == length(is)
  U = pad(U, 0, nbits(s)-nbits(U))
  S = headfirst(nbits(s), is...)
  apply!(S'*U*S, s)
end

function probabilities(s::State, is...)
  n = length(is)
  M = measure(n, nbits(s)-length(is))*headfirst(nbits(s), is...)
  M*probabilities(s)
end

function sample(ps)
  x = rand()
  s = zero(eltype(ps))
  for i = 1:length(ps)
    s += ps[i]
    s > x && return i
  end
end

function measure!(s::State, is...)
  n = length(is)
  M = measure(n, nbits(s)-length(is))*headfirst(nbits(s), is...)
  ps = M*probabilities(s)
  i = sample(ps)
  s.ψ .*= M[i,:]./sqrt(ps[i])
  bits(i-1, Val{length(is)})
end
