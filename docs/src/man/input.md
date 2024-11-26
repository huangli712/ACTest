# Inputs

The scripts in the ACTest toolkit require only one input file, which is \texttt{act.toml}. Below is a typical \texttt{act.toml} file with some omissions. In this \texttt{act.toml}, text following the ``\#'' symbol is considered as a comment. It contains two sections: \texttt{[Test]} and \texttt{[Solver]}. The \texttt{[Test]} section is mandatory, which controls generation of spectral functions and corresponding Green's functions. We would like to explain the relevant control parameters in the following text. The \texttt{[Solver]} section is optional. Now it is used to configure the analytic continuation methods as implemented in the ACFlow toolkit~\cite{Huang:2022}. Only the \texttt{acflow.jl} script needs to read the \texttt{[Solver]} section. It will transfer these parameters to the ACFlow toolkit to customize the successive analytic continuation calculations. For possible parameters within the \texttt{[Solver]} section, please refer to the documentation of the ACFlow toolkit~\cite{Huang:2022}.
\begin{lstlisting}[language=TOML,
basicstyle=\ttfamily\small,
backgroundcolor=\color{yellow!10},
commentstyle=\color{olive!10!green},
keywordstyle=\color{purple}]
#
# Test: A01
#
# 1. Execute ../../util/acgen.jl act.toml.
# 2. Change solver = "MaxEnt" and modify the [Solver] section accordingly.
# 3. Execute ../../util/acflow.jl act.toml.
# 4. Execute ../../util/acplot.jl act.toml.
#

[Test]
solver  = "MaxEnt"
...

[Solver]
method = "chi2kink"
...
\end{lstlisting}
