import LinearAlgebra
import DelimitedFiles
import StatsBase
using Statistics, Printf, Plots

datapath = "/Users/Jordan/Git/hlab-analysis-methods/data"
file = "NMDA_puff1.atf"

@printf("Loading the data matrix 'M'\n")
M = DelimitedFiles.readdlm(joinpath(datapath, file));
T = M[:,1]
M = M[:,2:end]
nPts, nSweeps = size(M)
@printf("M has %i time points, and %i sweeps\n", nPts, nSweeps)
plot(T, M[:,[1, 5, nSweeps]], label=["first", "middle", "last"], xlab="t (s)", ylab="mV")

### DATA SCALING
# Z-transform the data
μ = mean(M)
σ = std(M)
M = StatsBase.zscore(M)

# visualizing different transforms
x = randn(100)
y = randn(100)*4
plot(x, y, seriestype=:scatter, xlim=[-10, 10], ylim=[-10, 10])

x_z = StatsBase.zscore(x)
x_n = x ./ StatsBase.norm(x)

y_z = StatsBase.zscore(y)
y_n = y ./ StatsBase.norm(y)

plot(x_z, y_z, seriestype=:scatter, xlim=[-5 5], ylim = [-5 5])
plot!(x_n, y_n, seriestype=:scatter, xlim=[-5 5], ylim = [-5 5])

### MATRIX PRODUCTS
# smooth a segment of data using (a) loops, (b) matrix multiplication

# (a), with a loop
x = randn(100)
smooth(x) = LinearAlgebra.dot([0.25, 0.5, 0.25], x) # this is: 0.25*x[1] + 0.5*x[2] + 0.25*x[3]
smooth_x = copy(x) # just make a copy
for i in 2:99
    smooth_x[i] = smooth(x[i-1:i+1])
end

# (b) using matrix multiplication
A = LinearAlgebra.Tridiagonal(fill(0.25, 99), fill(0.5, 100), fill(0.25, 99))
smooth_x2 = A * x

plot(x, size=(500, 500))
plot!(smooth_x)
plot!(smooth_x2)


### DATA TRANSFORMATIONS
