nbits(U) = round(Int, log2(size(U,1)))

@generated function bits(n, ::Type{Val{N}}) where N
  :($([:(Bool((n >> $(i-1)) & 0x01)) for i = N:-1:1]...),)
end

@generated function int(bits::NTuple{N}) where N
  reduce((x, b) -> :(($x<<1)+$b), 0, [:(bits[$i]) for i = 1:N])
end

int(n::Bool) = int((n,))

function classical(f, ::Type{Val{N}}) where N
  U = zeros(Int, 2^N, 2^N)
  for i = 0:2^N-1
    U[int(f(bits(i, Val{N})))+1, i+1] = 1
  end
  return U
end

classical(f, N) = classical(f, Val{N})

permutation(is::NTuple{N}) where N =
  classical(x -> map(i -> x[i], is), Val{N})

pad(U, l, r) = foldr(⊗, [repeated(I, l)..., U, repeated(I, r)...])

headfirst(n, is...) = permutation((is..., setdiff(1:n, is)...))

function measure(n, m)
  M = zeros(Int, 2^n, 2^(n+m))
  for i = 0:2^n-1, j = 0:2^m-1
    mn = i<<m+j
    M[i+1, mn+1] = 1
  end
  return M
end

I = classical(identity, 1)

CX = classical(x -> (x[1], x[1] ⊻ x[2]), 2)

S = classical(reverse, 2)

T = classical(x -> (x[1], x[2], (x[1] & x[2]) ⊻ x[3]), 3)

X = [0 1
     1 0]

Y = [0 -im
     im 0]

Z = [1  0
     0 -1]

H = [1  1
     1 -1]/√2
