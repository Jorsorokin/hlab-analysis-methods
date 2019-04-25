import DSP
import LinearAlgebra
using Plots

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

# lets create our own convolution
function myconv(X, K)
    # convolve a signal X with a kernel K

    T_x = length( X )
    T_k = length( K )
    result = zeros(T_x)
    K_flip = K[end:-1:1]
    tau = Int(floor(T_k/2))
    for t in range(tau+1, stop=T_x-tau)
        result[t] = X[t-tau:t+tau]' * K_flip
    end
    return result
end

plot(Y, label="DSP conv")
plot!(myconv(X, K), label="my conv" )

# remember that we could have represented this convolution using matrix multiplication
function matrixconv(X, K)
    # convolve X with kernel K via matrix multiplication

    T_k = length(K)
    T_x = length(X)
    tau = Int(floor(T_k/2))
    M = zeros(T_x, T_x)
    positions = -tau:tau
    L = vcat(T_x-tau:T_x, T_x-1:-1:T_x-tau)
    for (i, pos) in enumerate(positions)
        M += LinearAlgebra.diagm(pos => repeat([K[i]], inner=L[i]))
    end
    return (X' * M')' # transposing M is like fliping it around as we did in "myconv"
end

plot!(matrixconv(X, K), label="matrix conv")
