import DSP
import LinearAlgebra
import Wavelets
using Plots, DelimitedFiles


### FOURIER TRANFORMATION
# a fourier transform asks: how similar is my signal to a sine/cosine wave of
# a particular frequency?

# it is nothing more than a dot product of your signal with a sine/cosine wave
# (in the real-complex dual plane)

function fourier(X)
    # computes a discrete fourier transform of X:
    #   F(ω) = sum_t(X(t) * e^(-2πiωt / T))
    #
    #   each F(ω) is the response of the signal X to a particular (complex) sine/cosine wave

    N = length(X)
    n = range(1, stop=N)
    ω = n' # frequencies are increased with the length of X
    weights = exp.(-2π * im * (n * ω) / N) # outer product of n & ω
    return weights * X
end

function plot_fourier(x, fs, xlim=NaN)
    N = Int(floor(length(x)/2))
    dt = 1/fs
    t = range(dt, stop=N*2*dt, step=dt)
    #F = fourier(x)
    F = DSP.fft(x)
    frequencies = LinRange(0, fs/2, N+1)

    if isnan(xlim)
        xlim = [0, 100]
    end

    p1 = plot(t, x, label="")
    p2 = plot(frequencies, abs.(F[1:N+1]), label="", xlim=xlim, yaxis=:log, title="fourier coefficients")
    p3 = plot(frequencies, abs.(F[1:N+1]).^2, label="", xlim=xlim, yaxis=:log, title="fourier power")
    plot(p1, p2, p3, layout = @layout [a; b c])
end

fs = 1000
T = 1
ω = 10
x = sin.(2π * ω * range(1/fs, stop=T, step=1/fs))
plot_fourier(x, fs)

# what happends if we add noise?
x += randn(length(x))*0.5
plot_fourier(x, fs)

# what happens if we use a non-sinusoidal signal?
data = readdlm("/Users/Jordan/Git/hlab-analysis-methods/data/NMDA_puff1.atf")
x = data[:,2]
plot_fourier(x, 10000)


### PERIODOGRAM / TAPERING METHOD
# we can combat this noise by doing a fourier transform on overlapping
# segments of data, then combining the results
P = DSP.periodogram(x, fs=fs)
plot(P.freq, P.power, xlim=[0, 100], yaxis=:log, label="periodogram")
P = DSP.welch_pgram(x, fs=fs)
plot!(P.freq, P.power, xlim=[0, 100], yaxis=:log, label="welch method")
P = DSP.mt_pgram(x, fs=fs)
plot!(P.freq, P.power, xlim=[0, 100], yaxis=:log, label="multi-taper method")


### WAVELET TRANSFORMATION
# so how is a wavelet different? Instead of taking a dot product with a sine/cosine,
# we take a convolution with a little wave-like thingy
sym5 = Wavelets.wavelet(Wavelets.WT.sym5)
batt6 = Wavelets.wavelet(Wavelets.WT.batt6)
W1 = Wavelets.modwt(x, sym5)
W2 = Wavelets.modwt(x, batt6)

p1 = plot(sym5.qmf, title="sym5 wavelet", label="")
p2 = plot(batt6.qmf, title="batt6 wavelet", label="")
p3 = heatmap(W1[1:2:end,:]', color=:coolwarm)
p4 = heatmap(W2[1:2:end,:]', color=:coolwarm)
p5 = plot(W1[:,1:3:end], label="")
p6 = plot(W2[:,1:3:end], label="")
plot(p1, p2, p3, p4, p5, p6, layout=@layout [a b; c d; e f])
