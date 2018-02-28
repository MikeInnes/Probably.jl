# Quantum Key Distribution (BB84)
# You can run this from a terminal as `julia --color=yes qkd.jl`
# Try enabling Eve (line 28) to see the key distribution fail.

using Probably

N = 100

a2b = Channel{Any}(32)
b2a = Channel{Any}(32)

eve_bits = []
eve(x) = push!(eve_bits, measure(x))

# Alice
@schedule begin
  bits = []
  bases = []
  for i = 1:N
    # Create a qubit in |0⟩, |1⟩, |+⟩ or |-⟩
    value, basis = rand(Bool), rand([:standard, :hadamard])
    push!(bits, value)
    push!(bases, basis)
    x = QBool()
    value && not(x)
    basis == :hadamard && hadamard(x)
    # Optionally show the qubit to eve (if you think you can trust her)
    # eve(x)
    # Send it to bob
    put!(a2b, x)
  end
  # Share measurement bases used (reveals which bits are correct without
  # revealing the values)
  bob_bases = take!(b2a)
  put!(a2b, bases)
  bits = bits[bases .== bob_bases]
  # Share a subset of the bits to verify they were not tampered with
  subset = [rand(Bool) for i = 1:length(bits)]
  put!(a2b, (subset, bits[subset]))
  bits = bits[.!subset]
end

# Bob
let
  bits = []
  bases = []
  for i = 1:N
    # Take each bit and measure it in a random basis
    # (will be correct ~50% of the time)
    basis = rand([:standard, :hadamard])
    push!(bases, basis)
    x = take!(a2b)
    basis == :hadamard && hadamard(x)
    push!(bits, measure(x))
  end
  # Share measurement bases used
  put!(b2a, bases)
  alice_bases = take!(a2b)
  bits = bits[bases .== alice_bases]
  # Check a subset of the bits
  subset, alice_bits = take!(a2b)
  if bits[subset] != alice_bits
    warn("QKD failed, eavesdropping detected")
  else
    bits = bits[.!subset]
    info("QKD success. Key is:")
    println(Int.(bits))
  end
end
