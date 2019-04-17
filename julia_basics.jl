# this is a comment in Julia

# 3 ways to build an array
x = Array(1:10)
x = [1 2 3 4 5 6 7 8 9 10]
x = Array(range(1, stop=10, 10))

# indexing
x[4]
x[2:2:end]
x[10:-2:1]

# we can do multiple comparisons on the same Line
1 < 2 < 3 < 5 # true; MATLAB equivalent: (1 < 2) & (2 < 3) & (3 < 5)

# in Julia, we can import new packages to access certain function
using Pkg
Pkg.add("Plots") # we will install a new package for plotting
using Plots # "using" imports all function directly to the workspace
import LinearAlgebra # "import" means we can only access functions with . notation

plot(x')
print(LinearAlgebra.norm(x))

# this will print the actual VALUE of each item in x
x = 1:2:20
for i in x
    print(i)
end

# this will print the INDEX of each element, not the value
for i in eachindex(x)
    print(i)
end

# a beautiful thing about Julia (and Python) is "list comprehension", which replaces
# an explicit loop as above with something more concise
y = [i for i in 1:100 if i % 2 == 0]
# same as:
#   y = []
#   for i in 1:100
#       if i % 2 == 0
#           y = [y, i]
#       end
#   end

# we can create matrices that we fill with certain values
A = zeros(5, 5)
A = zeros(Int, 5, 5)
fill!(A, 10) # fill A with all 10s

# Julia allows us to nicely construct functions inline
x = 1:10
f(x) = 2x # you can write like a formula...julia knows this means 2*x
g(x) = x.^2 # .^ means element-wise, like in MATLAB
h(x) = f(g(x)) # could have also written: h(x) = 2x.^2
print(h(x))

# we can also write this as:
function double_square(x)
    return 2x.^2
end

# file I/O is quite easy; we can read in dlm files (text files) using the DelimitedFiles package
using DelimitedFiles
M = readdlm("current_clamp1.atf")
plot(M[:,1], M[:,2:end])

# We can even change the plotting graphics in Julia using different "backends"
plotly() # this plotting environment pushes plots to the web with a dedicated html address
plot(M[:,1], M[:,2:end])
