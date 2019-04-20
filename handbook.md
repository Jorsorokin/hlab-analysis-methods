
#### Hlab analysis methods PDF summary
Welcome! This rather lengthy document summarizes the various topics we will/have covered in the HLab analysis mini series. If this is the .ipynb version of the doc, you can edit/run blocks of code yourself. 

## Table of contents
0. [Basic Setup](#basics)
1. [Linear Algbera](#linalg)
2. [Signal Processing](#sigproc)

### Basic Setup <a name="basics"></a>
If you are new to Julia, fear not, it is quite similar to MATLAB. There are, however a few peculiarities to take care of. First, in Julia we need to *import* packages to use certain functions. For instance, there are no built-in plotting functions, but there is a handy _Plots_ package that we can install and use. In general, to increase the flexibility of Julia we first need to (a) install desired packages, and (b) import them when we wish to use them. 

For the most part, Julia code will look very familiar if you have learned Python and/or MATLAB (it uses the best of both worlds: MATLAB's intuitive linear algebra framework with Python's general-purposeness & modularity). Plotting is a bit different, as are some of the data structures (for instance, a row-vector does not behave the same as a column-vector, but we'll get into that next)

For now, we will need to install at least a few additional packages to get up to speed. If you haven't already, in an active Julia session (or in this notebook if you are using it in Jupyter) type the following commands to get plotting, statistics, and tabular-based data structures available for use:


```julia
using Pkg # allows us to add new packages
Pkg.update()
Pkg.add("Plots")      # plotting capabilities
Pkg.add("StatsPlots") # statsitics-related plotting add ons 
Pkg.add("DataFrames") # tabular data structures
```

We can use these packages once installed via the `using __package_name__` command, which imports all the functions available from that particular package. Contrastingly, importing via the `import __package_name__` imports the package, but you have to use dot (.) notation to access the functions. 

Personally, I prefer the `using` command for packages that you will almost certainly use throughout your code (for instance the `Plots` package), and the `import` command for packages that will be used more rarely. This can help you keep track of which functions stem from which packages, and IMO keeps the code looking cleaner.


```julia
using Plots
x = randn(100)
plot(x)

import Statistics
print([Statistics.mean(x), Statistics.std(x)])
```

    [-0.00331494, 1.05387]

### Linear Algebra <a name="linalg"></a>
Linear algbera is at the core of most (if not all) of the analysis methods we will be covering. As such, knowing even a very surface-level amount of linear algebra can be extremely rewarding/beneficial when creating your analysis pipelines.

Let's begin by creating a simple *vector* in Julia, which is defined as a column-vector by default:


```julia
x = [1, 2, 3, 4, 5] # unlike matlab, you must use commas if you want to specify a column vector
size(x)
```

We see that our variable `x` is a 5 x 1 column vector. This is an important thing to note, since linear algebra cares about the orientation of vectors/matrices. Of course, we can do simple things like add/multiply a scalar. We can also add another vector of the same length, or multiply by another vector or matrix. 


```julia
y = [0, 1, 0, 1, 2]
print(2x) # multiply each element by 2
print(x .* y) # element-wise multiplication
print(x' * y) # dot-product: x[1]*y[1] + ... + x[5]*y[5]
```

# The inner product
Note that the last operation `x' * y` performed _vector-multiplication_ between the vectors `x` and `y`. This is also called the *dot product* or *inner product* between two vectors (or matrices). Note that I had to transpose the vector `x` first for this to work. I also could have imported the `LinearAlgebra` package and used the function `LinearAlgebra.dot(x, y)`. 

We can write our own dot-product function to clarify what it is doing:


```julia
dot(x, y) = sum([i*j for i in x, for j in y]) 
print(x' * y)    # built-in dot product
print(dot(x, y)) # homemade dot product
```

So the inner/dot product is nothing more than summing the resulting vector after doing element wise multiplication. If we have a matrix-vector product or matrix-matrix product, we simply repeat the above procedure for each row/column of the matrices involved. 

Inner products depend on a certain order, so if we have two matrices `A` and `B`, the inner product `A * B` is not the same as `B * A`. The former performs a dot product between each _row of A_ and each _column of B_, while the latter does the opposite. 

Inner products are at the core of much of linear algebra, and indeed many of the analyses we will cover. It can be interpreted in a variety of ways, some of which are more useful than others depending on the context:

1. A similarity score (clustering)
2. A projection of one vector/matrix onto another (dimensionality reduction/PCA)
3. A weighted sum of predictor variables (regression)
4. A rotation/scaling of data (variety of signal/image processing methods)
5. A filter response (signal processing/convolution)
6. A transformation of _inputs_ into _outputs_ (variety of topics/methods, such as neural networks)

I usually find the inner product easiest to think of in terms of (1) and (3), as these are likely to be encountered in your analysis, but it can be useful to visualize/interpret inner products as transformations of vectors/variables:


```julia
# create a correlated scatter plot
x = randn(1000)
y = 3x + 0.5*randn(1000) 
data = [x, y]
plot(x, y, seriestype="scatter")

# now lets flip over the y-axis using an inner product with a rotation matrix
A = [1 0; 0 -1]
data_filped = data * A
plot!(data_flipped[:,1], data_flipped[:,2], seriestype="scatter") 
```

As you can see above, we have used the inner product in a _rotation/transformation_ setting, where we've flipped our data about the y-axis. It is helpful to understand the structure of `A`, and what it is doing to each of our original _dimensions_ (each column of `data`). Our rotation matrix `A` contains the values: 

```
1  0
0 -1
```
Each _row_ of `A` is associated with one dimension/feature/variable of the _input_ data, while each _column_ of `A` is associated with one dimension/feature/variable of the _ouput_ data. Since we have two columns in `data`, and two columns in `A`, we already know that this inner product is NOT going to change the dimensionality of the data. We started with two variables (x, y), and we will be ending with two variables (x_new, y_new). 

Looking at the _columns_ of A, we see that the first column, `[1, 0]`, will be multiplying the _first_ variable in `data` (x) by the value *1*, and the _second_ variable in `data` (y) by the value *0*, then adding the results together to produce `x_new`. Since we are not combining x and y together (since y is multiplied by 0), and since we are only multiplying x by 1, we know that `x_new = x`. 

Similarly, the second column of A, `[0, -1]`, will be multiplying x by *0*, and y by *-1*, then summing the results to produce `y_new`. Since the only contribution to `y_new` is the original `y` variable in `data`, and it is only multiplied by *-1*, we know that `y_new = -y`.

So in general, each _column_ of A specifies how the input variables get weighted before being summed together to produce a new, single, ouput variable. So each column of A is performing a _linear combination_ of the input variables. We can also readily appreciate how we can easily shrink or expand the original dimensionality of the data set (by removing or adding columns to `A`, respectively). 

### Signal Processing <a name="sigproc"></a>
