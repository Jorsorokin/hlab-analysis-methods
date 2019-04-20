
### Hlab analysis methods PDF summary
Welcome! This rather lengthy document summarizes the various topics we will/have covered in the HLab analysis mini series. If this is the .ipynb version of the doc, you can edit/run blocks of code yourself. 

# Table of contents
0. [Basic Setup](#basics)
1. [Linear Algbera](#linalg)
2. [Signal Processing](#sigproc)

## Basic Setup <a name="basics"></a>
If you are new to Julia, fear not, it is quite similar to MATLAB. There are, however a few peculiarities to take care of. First, in Julia we need to *import* packages to use certain functions. For instan, there is no plotting function built in, but there is a handy _Plots_ function that we can use. In order to use these, we first need to (a) install the packages, and (b) import them when we wish to use them. 

We will need to install at least a few additional packages to get up to speed. If you haven't already, in an active Julia session type the following commands to get plotting, statistics, and tabular-based data structures available for use

```julia
using Pkg # allows us to add new packages
Pkg.add("Plots") # plotting capabilities
Pkg.add("StatsPlots") # statsitics-related plotting addons
Pkg.add("DataFrames") # tabular data frames
```

## Linear Algebra <a name="linalg"></a>


## Signal Processing <a name="sigproc"></a>
