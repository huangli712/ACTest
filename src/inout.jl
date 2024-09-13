#
# Project : Lily
# Source  : inout.jl
# Author  : Li Huang (huangli@caep.cn)
# Status  : Unstable
#
# Last modified: 2024/09/12
#

"""
    write_spectrum(am::AbstractMesh, Aout::Vector{F64})

Write spectrum A(ω) to `Aout.data`. The grid is defined in `am`, and
the spectral data are contained in `Aout`.

### Arguments
* am   -> Real frequency mesh.
* Aout -> Spectral function.

### Returns
N/A
"""
function write_spectrum(am::AbstractMesh, Aout::Vector{F64})
    @assert length(am) == length(Aout)

    open("Aout.data", "w") do fout
        for i in eachindex(am)
            @printf(fout, "%16.12f %16.12f\n", am[i], Aout[i])
        end
    end
end

"""
    write_backward(ag::AbstractGrid, G::Vector{F64})

We can use the calculated spectrum in real axis to reproduce the input
data in imaginary axis. This function will write the reproduced data to
`repr.data`, which can be compared with the original data. Here, `G` is
the reproduced data.

### Arguments
* ag -> Grid for input data.
* G  -> Reconstructed Green's function.

### Returns
N/A

See also: [`reprod`](@ref).
"""
function write_backward(ag::AbstractGrid, G::Vector{F64})
    ngrid = length(ag)
    ng = length(G)
    @assert ngrid == ng || ngrid * 2 == ng

    # The reproduced data are defined in imaginary time axis.
    if ngrid == ng
        open("repr.data", "w") do fout
            for i in eachindex(ag)
                @printf(fout, "%16.12f %16.12f\n", ag[i], G[i])
            end
        end
    # The reproduced data are defined in Matsubara frequency axis.
    else
        open("repr.data", "w") do fout
            for i in eachindex(ag)
                @printf(fout, "%16.12f %16.12f %16.12f\n", ag[i], G[i], G[i+ngrid])
            end
        end
    end
end

function Base.show(io::IO, 𝑝::GaussianPeak)
end

function Base.show(io::IO, 𝑝::LorentzianPeak)
end

function Base.show(io::IO, 𝑝::RectanglePeak)
    println("peak type : rectangle")
    @printf("    center : %16.12f\n", 𝑝.c)
    @printf("    width  : %16.12f\n", 𝑝.w)
    @printf("    height : %16.12f  ", 𝑝.h)
end
