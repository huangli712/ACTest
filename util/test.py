import numpy as np
import matplotlib.pyplot as plt

#import MiniPole code

#classes to create synthetic data, not needed if you have your data available
from mini_pole import GreenFunc
from mini_pole.spectrum_example import *

#class to perform continuation
from mini_pole import MiniPole

#tools for calculating the Green's function from the corresponding poles
def cal_G_scalar(z, Al, xl):
    G_z = 0.0
    for i in range(xl.size):
        G_z += Al[i] / (z - xl[i])
    return G_z

def cal_G_vector(z, Al, xl):
    G_z = 0.0
    for i in range(xl.size):
        G_z += Al[[i]] / (z.reshape(-1, 1) - xl[i])
    return G_z

beta = 100 #inverse temperature
n_w = 500  #number of non-negative Matsubara points
n_orb = 1  #number of orbitals

#A_x is the expression of the spectral function
A_f_diag = lambda x: 0.25 * gaussian(x, mu=-1.5, sigma=0.5) + 0.5 * gaussian(x, mu=0, sigma=0.5) + 0.25 * gaussian(x, mu=1.5, sigma=0.5)
A_f_offdiag = lambda x: -0.2 * gaussian(x, mu=-1, sigma=0.6) + 0.2 * gaussian(x, mu=1, sigma=0.6)
gf_f1 = GreenFunc("F", beta, "continuous", A_x=A_f_diag   , x_min=-np.inf, x_max=np.inf)
gf_f2 = GreenFunc("F", beta, "continuous", A_x=A_f_offdiag, x_min=-np.inf, x_max=np.inf)

#obtain Matsubara data from numerical integration for the first n_w non-negative frequencies
gf_f1.get_matsubara(n_w)
gf_f2.get_matsubara(n_w)
#G_w: Matsubara data; w: corresponding Matsubara frequencies
w = gf_f1.w
G_w = np.zeros((w.size, n_orb, n_orb), dtype=np.complex_)
for i in range(n_orb):
    for j in range(n_orb):
        if i == j:
            G_w[:, i, j] = gf_f1.G_w
        else:
            G_w[:, i, j] = gf_f2.G_w

#MiniPole for matrix-valued Green's function
#err: error tolerance. Should be set to no less than the noise level
#p = MiniPole(G_w, w, err=1.e-2)
p = MiniPole(gf_f1.G_w, w, err=1.e-2)
print(p.pole_location)
print(np.shape(p.pole_location))
print(p.pole_weight)
print(np.shape(p.pole_weight))

print(np.shape(w))
print(np.shape(gf_f1.G_w))

# Analytic continuation results are stored in p.pole_weight (for pole weights) and p.pole_location (for pole locations)
x = np.linspace(-5, 5, 1000)
G_f_r = cal_G_vector(x, p.pole_weight.reshape(-1, n_orb ** 2), p.pole_location).reshape(-1, n_orb, n_orb)

plt.plot(x, A_f_diag(x), linewidth=1, label="exact - diag")
#plt.plot(x, A_f_offdiag(x), linewidth=3, label="exact - offdiag")
plt.plot(x, -1.0 / np.pi * G_f_r[:, 0, 0].imag, "--", linewidth=2, label="MPM - diag")
#plt.plot(x, -1.0 / np.pi * G_f_r[:, 0, 1].imag, "-.", linewidth=2, label="MPM - offdiag")
plt.legend()
plt.xlim([-5, 5])
plt.ylim([-0.5, 0.5])
plt.xlabel(r"$\omega$")
plt.ylabel(r"$A(\omega)$")
plt.show()
