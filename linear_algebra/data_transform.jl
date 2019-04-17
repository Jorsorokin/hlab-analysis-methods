import LinearAlgebra
import StatsBase
using Statistics, Plots

### DATA SCALING
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

plot(x, size=(500, 500), label = "original", lw=2)
plot!(smooth_x, label = "smoothed with loop", lw=2)
plot!(smooth_x2, label = "smoothed with matrix product", lw=2)


### DATA ROTATIONS/TRANSFORMS
f(x) = 2x .+ 5.0
x = Array(range(0, stop=10, length=100))
data = hcat(x, f(x)) + randn(100,2)
plot(view(data, :, 1), view(data, :, 2), seriestype=:scatter,
    xlim = [0, 30], ylim = [-30, 30], label="original")

# make a rotation matrix around the y-axis
A = [1 0; 0 -1]
data2 = data * A
plot!(view(data2, :, 1), view(data2, :, 2), seriestype=:scatter,
    label = "(1x, -1y)")

# squash the y-vals by 50%, expand x-vals by 100%
A = [2 0; 0 0.5]
data2 = data * A
plot!(view(data2, :, 1), view(data2, :, 2), seriestype=:scatter,
    label = "(2x, 0.5y)")


### DATA PROJECTIONS
# now let's project the data onto subspaces
A_x = [1 0; 0 0] # x-axis projection
A_y = [0 0; 0 1] # y-axis projection
A_xy = [0.3 0.5; 0.1 -0.6] # different linear combinations of x and y,
datax = data * A_x
datay = data * A_y
dataxy = data * A_xy
plot(view(data, :, 1), view(data, :, 2), seriestype=:scatter,
    xlim = [0, 30], ylim = [-30, 30], label="original")
plot!(view(datax, :, 1), view(datax, :, 2), seriestype=:scatter,
    label = "(1x+0y, 0x+0y)")
plot!(view(datay, :, 1), view(datay, :, 2), seriestype=:scatter,
    label = "(0x+0y, 0x+1y)")
plot!(view(dataxy, :, 1), view(dataxy, :, 2), seriestype=:scatter,
    label = "(.3x+.1y, .5x-.6y)")

# the linear matrices "A"" are performing linear functions on the columns of "data"
f_xy(data) = hcat(0.3data[:,1] + 0.1data[:,2], 0.5data[:,1] - 0.6data[:,2])
isapprox(dataxy, f_xy(data))


### MATRIX RANKS
# rank of a matrix determines how "complex" it is (how many independent columns)
x = rand(10, 5)
LinearAlgebra.rank(x)

# here we are just copying the same vector and scaling it by a constant,
# so each column can be described by a single column
x = rand(10) * [1 2 3 4 5] # this is an outer product
LinearAlgebra.rank(x)

# let's observe different rank matrices, and see how they get combined into something
# that looks complex (this is at the heart of dimensionality reduction techniques like PCA)
A = zeros(10, 10)
heatmap(A)
for i in 1:3
    A += rand(10) * randn(1,10)
    heatmap!(A)
    sleep(1)
