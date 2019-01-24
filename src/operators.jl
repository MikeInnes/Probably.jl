nbits(U) = round(Int, log2(size(U,1)))

@generated function bits(n, ::Type{Val{N}}) where N
  :($([:(Bool((n >> $(i-1)) & 0x01)) for i = N:-1:1]...),)
end

@generated function int(bits::NTuple{N}) where N
  reduce((x, b) -> :(($x<<1)+$b), [:(bits[$i]) for i = 1:N]; init = 0)
end

int(n::Bool) = int((n,))

function classical(f, ::Type{Val{N}}) where N
  U = zeros(Int, 2^N, 2^N)
  for i = 0:2^N-1
    U[int(f(bits(i, Val{N})...))+1, i+1] = 1
  end
  return U
end

classical(f, N) = classical(f, Val{N})

permutation(is::NTuple{N}) where N =
  classical((x...) -> map(i -> x[i], is), Val{N})

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
