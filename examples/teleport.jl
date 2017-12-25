using Probably
using Probably: I, X, Y, Z, apply!

# The quantum state that Alice wants to transmit to Bob
# (This is an arbitrary choice – any ψ can be transferred)
ψ = hadamard(QBool())

# Alice and Bob both get half of an EPR pair
ea, eb = epr()

# Alice encodes the state of ψ by mixing it with the entangled bit `ea`, then
# makes a measurement. Notice that this destroys ψ – quantum information cannot
# be cloned, only moved.

cnot(ψ, ea)
hadamard(ψ)
state = measure.((ψ, ea))

# Bob receives only two bits of classical information – the `state` measured
# above. We use these to decide on an appropriate decoding transform – one of
# the Pauli matrices.

decode = Dict((false, false) => I,
              (false, true)  => X,
              (true, false)  => Z,
              (true, true)   => Y)

apply!(decode[state], eb.bit)

# eb is now in an identical state to the original ψ. You can cheat and look at
# its internal state to be sure.
eb.bit
