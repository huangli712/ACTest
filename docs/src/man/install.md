# Installation

\subsubsection{Prerequisites}
We chose the Julia language to develop the ACTest toolkit. Julia is an interpreted language. Hence, to run the ACTest toolkit, the latest version of the Julia interpreter must be installed on the target system. Actually, Julia's version number should not be less than 1.6. The core features of the ACTest toolkit rely only on Julia's standard library. However, if one needs to invoke the ACFlow toolkit for analytic continuation calculations, the toolkit must be available in the system. As for how to install and configure the ACFlow toolkit, please refer to the relevant paper~\cite{Huang:2022}. Additionally, if one wants to use the built-in script of ACTest to visualize the calculated results (i.e., the spectral functions), support from the CairoMakie.jl package is necessary. CairoMakie.jl is a 2D plotting program developed in Julia. It can be installed via Julia's package manager:
\begin{verbatim}
    julia> ]
    (@v1.11) pkg> add CairoMakie
\end{verbatim}

\subsubsection{Main program}

The official repository of the ACTest toolkit is hosted on github. Its URL is as follows:
\begin{verbatim}
    https://github.com/huangli712/ACTest
\end{verbatim}
Since the ACTest toolkit has not yet been registered as a regular Julia package, please type the following commands in Julia's REPL to install it:
\begin{verbatim}
    julia> using Pkg
    julia> Pkg.add("https://github.com/huangli712/ACTest")
\end{verbatim}
If this method fails due to an unstable network connection, an offline method should be adopted. First of all, please download the compressed package for the ACTest toolkit from github. Usually it is called \texttt{actest.tar.gz} or \texttt{actest.zip}. Second, please copy it to your favorite directory (such as \texttt{/home/your\_home}), and then enter the following command in the terminal to decompress it:
\begin{verbatim}
    $ tar xvfz actest.tar.gz
\end{verbatim}
or
\begin{verbatim}
    $ unzip actest.zip
\end{verbatim}
Finally, we just assume that the ACTest toolkit is placed in the directory: 
\begin{verbatim}
    /home/your_home/actest
\end{verbatim}
Now we have to manually insert the following codes at the beginning of all ACTest's scripts (see Section~\ref{subsec:scripts}):
\begin{verbatim}
    # Add the ACTest package to the Julia load path
    push!(LOAD_PATH, "/home/your_home/actest/src")
\end{verbatim}
These modifications just ensure that the Julia interpreter can find and import the ACTest toolkit correctly. Now it should work as expected.

\subsubsection{Documentation}

The ACTest toolkit ships with detailed documentation, including the user's manual and application programming interface. They are developed with the Markdown language and the Documenter.jl package. So, please make sure that the latest version of the Documenter.jl package is ready (see \texttt{https://github.com/JuliaDocs/Documenter.jl} for more details). If everything is OK, users can generate the documentation by themselves. Please enter the following commands in the terminal:
\begin{verbatim}
    $ pwd
    /home/your_home/actest
    $ cd docs
    $ julia make.jl
\end{verbatim}
After a few seconds, the documentation is built and saved in the \texttt{actest/docs/build} directory. The entry of the documentation is \texttt{actest/docs/build/index.html}. You can open it with any web browser.
