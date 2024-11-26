# Peaks

In the ACTest toolkit, the spectral function ``A(\omega)`` is treated as a superposition of some peaks (i.e., features). That is to say:
```math
\begin{equation}
A(\omega) = \sum^{N_{p}}_{i = 1} p_i(\omega),
\end{equation}
```
where ``N_{p}`` is the number of peaks, ``p(\omega)`` is the peak generation function. Now ACTest supports the following types of peaks:

* Gaussian peak

```math
\begin{equation}
p(\omega) = A\exp{\left[-\frac{(\omega - \epsilon)^2}{2\Gamma^2}\right]}
\end{equation}
```

* Lorentzian peak

```math
\begin{equation}
p(\omega) = \frac{A}{\pi} \frac{\Gamma}{(\omega - \epsilon)^2 + \Gamma^2}
\end{equation}
```

* ``\delta``-like peak

```math
\begin{equation}
p(\omega) = A\exp{\left[-\frac{(\omega - \epsilon)^2}{2\gamma^2}\right]},~
\text{where}~\gamma = 0.01
\end{equation}
```

* Rectangular peak

```math
\begin{equation}
p(\omega) =
\begin{cases}
h, \quad \text{if}~\omega \in [c-w/2,c+w/2], \\
0, \quad \text{else}. \\
\end{cases}
\end{equation}
```

* Rise-And-Decay peak

```math
\begin{equation}
p(\omega) = h \exp{(-|\omega - c|^{\gamma})}
\end{equation}
```

Here we just use a narrow Gaussian peak to mimic the ``\delta``-like peak. In the above equations, ``\mathcal{C} = \{A,~\Gamma,~\epsilon,~h,~c,~w,~\gamma\}`` is a collection for essential parameters. The ACTest toolkit will randomize ``\mathcal{C}`` and use it to parameterize the peaks.
