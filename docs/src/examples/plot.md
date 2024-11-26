# Visualizations

!!! info

    In the **actest/tests** directory, there are seven typical test cases. Users can modify them to meet their requirements. This section will use an independent example to demonstrate the basic usage of the ACTest toolkit.

Finally, we can utilize the \texttt{acplot.jl} script to generate figures for the spectral functions. To achieve that effect, please execute the following command in the terminal:
```shell
    $ actest/util/acplot.jl act.toml
```
These figures are in standard PDF format. They are used to analyze the differences between the true spectral functions ``A_{\text{true}}(\omega)`` and the calculated spectral functions ``A_{\text{calc}}(\omega)``. Figures~\ref{fig:fermi} and ~\ref{fig:boson} illustrate the spectral functions of typical fermionic systems and bosonic systems, respectively. As can be seen from the figures, aside from some very sharp peaks, the calculated spectral functions agree quite well with the true ones.

\begin{figure}[th]
\centering
\includegraphics[width=0.48\textwidth]{T_f_d_82.pdf}
\includegraphics[width=0.48\textwidth]{T_f_od_4.pdf}
\caption{Selected analytic continuation results for Matsubara Green's functions (fermionic systems). (Left) Spectra for diagonal Green's function. (Right) Spectra for off-diagonal Green's function. The exact spectra are generated randomly by the ACTest toolkit. The vertical dashed lines denote the Fermi level. \label{fig:fermi}}
\end{figure}

\begin{figure}[th]
\centering
\includegraphics[width=0.48\textwidth]{T_b_d_3.pdf}
\includegraphics[width=0.48\textwidth]{T_b_od_47.pdf}
\caption{Selected analytic continuation results for Matsubara Green's functions (bosonic systems). (Left) Spectra for diagonal Green's function. (Right) Spectra for off-diagonal Green's function. The exact spectra are generated randomly by the ACTest toolkit. The vertical dashed lines denote the Fermi level. \label{fig:boson}}
\end{figure}
