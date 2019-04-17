# this is a comment in Julia

##### Arrays / Matrices #####
# 3 ways to build an array
x = Array(1:10)
x = [1 2 3 4 5 6 7 8 9 10]
x = Array(range(1, stop=10, 10))

# indexing
x[4]
x[2:2:end]
x[10:-2:1]

# fancy indexing using logicals
mask = (x % 2 == 0)
print(x[mask])

# indexing with another vector
x[[5,7]] = x[[7,5]] # swapped places 

# we can do multiple comparisons on the same Line
1 < 2 < 3 < 5 # true; MATLAB equivalent: (1 < 2) & (2 < 3) & (3 < 5)
x[3] < x[4] < x[5]

# creating matrices / filling with certain values
A = zeros(5, 5)
A = zeros(Int, 5, 5)
fill!(A, 10) # fill A with all 10s

# broadcast matrices and vectors
noise = randn(1, 5)
A + noise # adds the row-vector "noise" to each row of A
broadcast(+, A, noise) # same as above



##### LOOPS #####
# this will print the actual VALUE of each item in x
x = 1:2:20
for i in x
    print(i)
end

# this will print the INDEX of each element, not the value
for i in eachindex(x)
    print(i)
end

# while loops are the same as in matlab
i = 1
while i < 10
    print(i)
    i = i+1
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

ysq = [i^2 for i in y] # could just do ysq = y.^2, but you get the picture



##### Julia Specifics #####
# in Julia, we can import new packages to access certain function
using Pkg
Pkg.add("Plots") # we will install a new package for plotting
using Plots # "using" imports all function directly to the workspace
import LinearAlgebra # "import" means we can only access functions with . notation

plot(A[:,1])
image(A)
print(LinearAlgebra.norm(x))

# We can even change the plotting graphics in Julia using different "backends"
plotly() # this plotting environment pushes plots to the web with a dedicated html address
plot(A[:,1:3])

# Julia allows us to nicely construct functions inline
f(x) = 2x # you can write like a formula...julia knows this means 2*x
g(x) = x.^2 # .^ means element-wise, like in MATLAB
h(x) = f(g(x)) # could have also written: h(x) = 2x.^2
print(h(1:10))

# we can also write this as:
function double_square(x)
    return 2x.^2
end

# file I/O is quite easy; we can read in dlm files (text files) using the DelimitedFiles package
using DelimitedFiles
M = readdlm("current_clamp1.atf") # "readdlm" came from the DelimitedFiles package
plot(M[:,1], M[:,2:end])