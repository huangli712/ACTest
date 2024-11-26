# Generating spectra and correlators

In the \texttt{actest/tests} directory, there are seven typical test cases. Users can modify them to meet their requirements. This section will use an independent example to demonstrate the basic usage of the ACTest toolkit.

Now let us test the performance of the maximum entropy method~\cite{JARRELL1996133,PhysRevB.41.2380,PhysRevB.44.6011,PhysRevB.81.155107} in the ACFlow toolkit~\cite{Huang:2022}. We just consider four typical scenarios: (1) Fermionic Green's functions, $A(\omega) > 0$; (2) Fermionic Green's functions, $A(\omega)$ is non-positive definite; (3) Bosonic Green's functions, $A(\omega) > 0$; (4) Bosonic Green's functions, $A(\omega)$ is non-positive definite. For each scenario, we apply the ACTest toolkit to randomly generate 100 spectral functions and corresponding Green's functions. The spectral functions are continuum. They are constructed with Gaussian peaks. The number of possible peaks in each $A(\omega)$ ranges from 1 to 6. The synthetic Green's functions are on the Matsubara frequency axis. The number of Matsubara frequency points is 10. The noise level is $10^{-6}$. The \texttt{act.toml} file for scenario (3) is shown below.
\begin{lstlisting}[language=TOML,
basicstyle=\ttfamily\small,
backgroundcolor=\color{yellow!10},
commentstyle=\color{olive!10!green},
keywordstyle=\color{purple}]
[Test]
solver  = "MaxEnt" # Analytic continuation solver in the ACFlow toolkit
ptype   = "gauss"  # Type of peaks
ktype   = "boson"  # Type of kernels
grid    = "bfreq"  # Type of grids
mesh    = "linear" # Type of meshes
ngrid   = 10       # Number of grid points
nmesh   = 801      # Number of mesh points
ntest   = 100      # Number of tests
wmax    = 8.0      # Right boundary of frequency mesh
wmin    = -8.0     # Left boundary of frequency mesh
pmax    = 4.0      # Right boundary of peaks
pmin    = -4.0     # Left boundary of peaks
beta    = 20.0     # Inverse temperature
noise   = 1.0e-6   # Noise level
offdiag = false    # Whether the spectrum is positive
lpeak   = [1,2,3,4,5,6] # Possible number of peaks
\end{lstlisting}
Once the \texttt{act.toml} file is prepared, the following command should be executed in the terminal:
\begin{verbatim}
    $ actest/util/acgen.jl act.toml
\end{verbatim}
Then, the ACTest toolkit will generate the required data in the present directory. Now there are 100 \texttt{image.data.i} and \texttt{green.data.i} files, where $i$ ranges from 1 to 100. These correspond to $A(\omega)$ and $G(i\omega_n)$ for bosonic systems. We can further verify the data to make sure $A(\omega) > 0$. Finally, we have to copy the \texttt{act.toml} file to another directory, change the \texttt{ktype}, \texttt{grid}, and \texttt{offdiag} parameters in it, and then execute the above command again to generate testing datasets for the other scenarios.
