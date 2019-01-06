using Probably
using Probably: Bits, apply!, H, ⊗

# (N = 2^n)th root of unity
ω(n) = MathConstants.e^(-2π*im/(2^n))

# The Fourier transform is represented by the matrix W.
# We could use W directly, but it's more interesting
# to build it from basic (one or two qubit) gates.
W(n) = ω(n) .^ [i*j for i = 0:2^n-1, j = 0:2^n-1] ./ √(2^n)

# We will use the same recursive decomposition that powers the FFT.

# W(k+1) = 1|I D(k)|  * |W(k) 0  | * R(k+1)
#         √2|I D(k)|    | 0  W(k)|
# Where
# D(k) = diagm(ω(k+1) .^ (0:2^k-1))
# R(k)[i,j] = 2i == j || 2(i-2^k)+1 == j

# R moves the least significant bit to the front
function R(buf)
  for i = length(buf):-1:2
    swap(buf[i],buf[i-1])
  end
end

# Phase shift gates that make up D
Ds(k) = [[1 0; 0 ω(i)] for i = 1:k]

# Apply |I D(k)| by decomposition
#       |I D(k)|
function D(buf)
  ds = Ds(length(buf))
  for i = 2:length(buf)
    apply!(control(ds[i]), buf[1], buf[i])
  end
  hadamard(buf[1])
end

function QFT(buf::QBuffer)
  if length(buf) == 1
    hadamard(buf[1])
  else
    R(buf)
    QFT(buf[2:end])
    D(buf)
  end
  return buf
end

# Test it

buf = QBuffer(4)
# Set up an interesting state
hadamard(buf[1])
cnot(buf[1], buf[2])
# Cheat and check what the result will be
cheat_fft = W(4)*buf.bits.state.ψ
# Apply the QFT
QFT(buf)
buf.bits.state.ψ ≈ cheat_fft
