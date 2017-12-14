I = [1 0
     0 1]

H = [1  1
     1 -1]/√2

X = [0 1
     1 0]

S = [1 0 0 0
     0 0 1 0
     0 1 0 0
     0 0 0 1]

pad(U, l, r) = foldr(⊗, [repeated(I, l)..., U, repeated(I, r)...])

swap(n) =
  n == 0 ? I :
  n == 1 ? S :
  (I⊗swap(n-1)) * pad(S,0,n-1) * (I⊗swap(n-1))

swap(n, a, b) = pad(swap(b-a),a-1,n-b)

# Sp = [1, 3, 2, 4]
# Ip = [1, 2]
# kronp(as, bs) = [(a-1)*length(bs)+b for a in as for b in bs]
