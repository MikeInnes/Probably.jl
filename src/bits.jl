mutable struct Bits{N}
  offset::Int
  state::State
end

const Bit = Bits{1}

const states = WeakKeyDict()

function Bits{N}(vs::Integer...) where N
  b = Bits{N}(0, State(N, vs))
  states[b.state] = WeakKeyDict(b=>nothing)
  return b
end

Bits{N}() where N = Bits{N}(0)

bits(b::Bits) = b

nbits(::Bits{N}) where N = N

function Base.show(io::IO, b::Bits)
  println(io, "$(nbits(b)) bits with offset $(b.offset)")
  show(io, b.state)
end

function combine(a::State, b::State)
  a === b && return a
  of = nbits(a)
  a.ψ = a.ψ ⊗ b.ψ
  for buf in keys(states[b])
    buf.state = a
    buf.offset += of
    states[a][buf] = nothing
  end
  return a
end

combine(b::Bits) = b.state
combine(bs::Bits...) = reduce(combine, map(x -> x.state, bs))

bitindices(b::Bits{N}) where N = ntuple(i -> b.offset+i, Val{N})

tcat(x::Tuple) = x
tcat(x::Tuple, y::Tuple, ys::Tuple...) = tcat((x..., y...), ys...)

function apply!(U, bs::Bits...)
  s = combine(bs...)
  is = tcat(bitindices.(bs)...)
  apply!(U, s, is...)
  return
end

apply!(U, bs...) = apply!(U, bits.(bs)...)

measure(b::Bits) = measure!(b.state, bitindices(b)...)

measure(x) = repr(typeof(x),measure(bits(x)))
