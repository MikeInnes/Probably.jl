using Probably
using Probably: apply!

# Here's a function of a single bit.
# We're interested in whether the function is constant. On a classical computer
# we have to evaluate `f` twice to see `f(true)` and `f(false)`. On a quantum
# computer can evaluate `f` just once.

# Try uncommenting different definitions of `f` to see the result change.

# Here are some variable functions:
f(x) = !x
# f(x) = x

# Here's a constant function (it ignores its input):
# f(x) = true

# Generate the reversable unitary matrix for `f`:
U = classical((x, y) -> (x, f(x) ⊻ y), 2)

# Verify that the function behaves as expected:
x = true # or false
a = QBool(x)
b = QBool()
apply!(U, a, b)
measure(b) == f(x)

# Now we apply `f` with the inputs in superposition.
a = hadamard(QBool(false)) # a = |+⟩
b = hadamard(QBool(true))  # b = |-⟩
apply!(U, a, b)
hadamard(a)

# The output will always be `false` if `f` is constant.
measure(a)
