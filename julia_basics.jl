# this is a comment in Julia

# 3 ways to build an array
x = 1:10
x = [1 2 3 4 5 6 7 8 9 10]
x = range(1, stop=10, 10)

# indexing
x[4]
x[2:2:end]
x[10:-2:1]

# in Julia, we can import new packages to access certain function
using Pkg
Pkg.add("Plots") # we will install a new package for plotting
using Plots # "using" imports all function directly to the workspace
import LinearAlgebra # "import" means we can only access functions with . notation

plot(x')
print(LinearAlgebra.norm(x))


# Loops in Julia are similar to matlab
x = 1:2:20

# this will print the actual VALUE of each item in x
for i in x
    print(i)
end

# this will print the INDEX of each element, not the value
for i in eachindex(x)
    print(i)
end


# we can create matrices that we fill with certain values
A = zeros(5, 5)
A = zeros(Int, 5, 5)
fill!(A, 10) # fill A with all 10s
