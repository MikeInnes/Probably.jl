# Bell inequality

using Probably
import Probably: apply!

° = π/180

rot(θ) = [cos(θ) -sin(θ);
          sin(θ) cos(θ)]

# Construct an EPR pair – |11⟩ or |00⟩.
function epr()
  a, b = QBool(), QBool()
  hadamard(a)
  cnot(a, b)
  return a, b
end

# Simulate measurement by a polaroid at angle θ to the x / |1⟩ axis, by
# projecting the polaroid's basis into the standard basis and back
function polaroid(x, θ)
  apply!(rot(θ), x.bit)
  result = measure(x)
  apply!(rot(-θ), x.bit)
  return result
end

# Create an EPR pair, measure both at a random angle, and see if they agree.
function experiment1()
  a, b = epr()
  θ = rand([-60°, 0°, 60°])
  !(polaroid(a, θ) ⊻ polaroid(b, θ))
end

# When measured at the same angle the qubits always agree.
mean(experiment1() for _ = 1:10^4)

# Create an EPR pair, measure both at different random angles, and see if they
# agree.
function experiment2()
  a, b = epr()
  θa, θb = rand([-60°, 0°, 60°], 2)
  !(polaroid(a, θa) ⊻ polaroid(b, θb))
end

# At different angles the qubits agree 50% of the time.
mean(experiment() for i = 1:10^4)

# A local hidden variable theory *cannot* give this prediction. Say qubit `a` is
# in a state that determines measurement outcomes at each angle [-60, 0, 60]
# (say [1, 0, 1]). We know that when the polaroids are at the same angle they
# always agree, so `b` must be in an equivalent state.

# Qubit state – [60° => 1, 0° => 0, 60° => 1]

# polaroid 1, polaroid 2, outcome (1 ⊻ 2)
#  0           0          1
#  60          60         1
# -60         -60         1
#  0           60         0 (× 2)
#  0          -60         0 (× 2)
#  60         -60         1 (× 2)

# In this hidden state the qubits agree 5/9s of the time. Other states like [1,
# 1, 1] and [1, 0, 0] will agree as much or more than this, so the probability
# of agreement is at least 5/9 overall, contradicting the result of our
# experiment.
