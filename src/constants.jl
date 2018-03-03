Zero = [1, 0]
One = [0, 1]

I = [1 0
     0 1]

X = [0 1
     1 0]

Y = [0 -im
     im 0]

Z = [1  0
     0 -1]

H = [1  1
     1 -1]/√2

S = classical((a, b) -> (b, a), 2)

control(U) = Zero*Zero' ⊗ eye(U) + One*One' ⊗ U

CX = control(X)

T = control(CX)
