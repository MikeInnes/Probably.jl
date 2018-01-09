using Probably
using Probably: apply!

# Here's a function of a single bit.
# We're interested in whether the function is constant.
# Try uncommenting different definitions of `f` to see the result change.

# Here are some variable functions:
f(x) = !x
# f(x) = x

# Here's a constant function (it ignores its input):
# f(x) = true

# Generate the reversable unitary matrix for `f`:
U = classical((x, y) -> (x, f(x) ⊻ y), 2)

# Verify that the function behaves as expected:
x = true
a = QBool(x)
b = QBool()
apply!(U, a, b)
measure(b) == f(x)

# Now we apply `f` with the inputs in superposition.
a = hadamard(QBool(0)) # a = |+⟩
b = hadamard(QBool(1)) # b = |-⟩
apply!(U, a, b)
hadamard(a)

# The output will always be `false` if `f` is constant.
measure(a)
