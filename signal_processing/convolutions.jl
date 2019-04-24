import DSP
import LinearAlgebra
using Plots
pyplot() # use pyplot backend, since GR seems to have issues

# let's start with a simple convolution for filtering a noisy signal
X = randn(1000) # gaussian noise
K = DSP.gaussian(25, 0.2) # 25pt gaussian with 0.2 SD
Y = DSP.conv(X, K)
p1 = plot(X, label="raw")
p2 = plot(K, label="kernel")
p3 = plot(Y, label="filtered")
l = @layout [a b; c]
plot(p1, p2, p3, layout = l)

# we can see what happens with different widths/lengths
plot(X)
plot!(DSP.conv(X, DSP.gaussian(25, 0.2)))
plot!(DSP.conv(X, DSP.gaussian(75, 0.2)))

# let's now convolve the signal with a bunch of sin waves and look at the relative power
