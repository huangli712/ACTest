# Main Features

The current version of the ACTest toolkit is v1.0. Its major features are as follows:

* ACTest can randomly generate any number of $A(\omega)$, as well as corresponding $G(\tau)$ or $G(i\omega_n)$.

* ACTest employs one or more parameterized Gaussian, Lorentzian, $\delta$-like, rectangular, and Rise-And-Decay peaks to assemble $A(\omega)$. $A(\omega)$ can be either positive definite for fermionic Green's functions, or non-positive definite for bosonic Green's functions and matrix-valued Green's functions. The frequency grid, i.e., $\omega$, can be either linear or non-linear (such as tangent, Lorentzian, and half-Lorentzian grids).

* ACTest supports fermionic, bosonic, and symmetric bosonic kernels to generate Green's functions on either imaginary time or Matsubara frequency axes. It supports artificial noise, and the noise level is adjustable.

* ACTest includes a built-in testing dataset, ACT100, which can serve as a relatively fair standard for examining different analytic continuation methods and codes.

* ACTest is already interfaced with ACFlow, which is a full-fledged and open-source analytic continuation toolkit~\cite{Huang:2022}. ACTest can access various analytic continuation methods in the ACFlow toolkit, launch them to perform analytic continuation calculations, and provide benchmark reports on their accuracy and efficiency. ACTest also provides a plotting script, that can be used to visualize and compare the true and reconstructed spectral functions.

* ACTest is an open-source software developed in Julia language. It is quite easy to be extended to implement new features or support the other analytic continuation codes, such as Nevanlinna.jl~\cite{10.21468/SciPostPhysCodeb.19} and SmoQyDEAC.jl~\cite{10.21468/SciPostPhysCodeb.39}. Furthermore, ACTest offers extensive documentation and examples, making it user-friendly.
\end{itemize}

In the following text, we will elaborate on the technical details inside ACTest.
