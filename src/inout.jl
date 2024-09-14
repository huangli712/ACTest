#
# Project : Lily
# Source  : inout.jl
# Author  : Li Huang (huangli@caep.cn)
# Status  : Unstable
#
# Last modified: 2024/09/14
#

"""
    write_spectrum(am::AbstractMesh, Aout::Vector{F64})

Write spectrum A(ω) to `image.data`. The grid is defined in `am`, and
the spectral data are contained in `Aout`.

### Arguments
* am   -> Real frequency mesh, ω.
* Aout -> Spectral function, A(ω).

### Returns
N/A
"""
function write_spectrum(am::AbstractMesh, Aout::Vector{F64})
    @assert length(am) == length(Aout)

    open("image.data", "w") do fout
        for i in eachindex(am)
            @printf(fout, "%16.12f %16.12f\n", am[i], Aout[i])
        end
    end
end

"""
    write_spectrum(ind::I64, sf::SpectralFunction)

Write spectrum A(ω) to `image.data.i`. All information about the spectral
function is included in `sf`.

### Arguments
* ind -> Index for the spectral function.
* sf -> A SpectralFunction struct.

### Returns
N/A
"""
function write_spectrum(ind::I64, sf::SpectralFunction)
    @assert ind ≥ 1

    open("image.data." * string(ind), "w") do fout
        for i in eachindex(sf.mesh)
            @printf(fout, "%16.12f %16.12f\n", sf.mesh[i], sf.image[i])
        end
    end
end

"""
    write_backward(ag::AbstractGrid, G::Vector{F64})

We can use the calculated spectrum in real axis to generate the Green's
function data in imaginary axis. This function will write the data to
`green.data`, which can be fed into the analytic continuation tools.
Here, `G` is the constructed Green's function data.

### Arguments
* ag -> Grid for input data.
* G  -> Constructed Green's function.

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
        open("green.data", "w") do fout
            for i in eachindex(ag)
                @printf(fout, "%16.12f %16.12f\n", ag[i], G[i])
            end
        end
    # The reproduced data are defined in Matsubara frequency axis.
    else
        open("green.data", "w") do fout
            for i in eachindex(ag)
                @printf(fout, "%16.12f %16.12f %16.12f\n", ag[i], G[i], G[i+ngrid])
            end
        end
    end
end

"""
    write_backward(ind::I64, gf::GreenFunction)

Write the Green's function data to `green.data.i`. All information about
the Green's function is included in `gf`.

### Arguments
* ind -> Index for the spectral function.
* gf -> A GreenFunction struct.

### Returns
N/A

See also: [`reprod`](@ref).
"""
function write_backward(ind::I64, green::GreenFunction)
    @assert ind ≥ 1

    ag = green.grid
    G = green.green
    err = green.error

    ngrid = length(ag)
    ng = length(G)
    @assert ngrid == ng || ngrid * 2 == ng

    # The reproduced data are defined in imaginary time axis.
    if ngrid == ng
        open("green.data." * string(ind), "w") do fout
            for i in eachindex(ag)
                @printf(fout, "%16.12f ", ag[i])
                @printf(fout, "%16.12f %16.12f\n", G[i], err[i])
            end
        end
    # The reproduced data are defined in Matsubara frequency axis.
    else
        open("green.data." * string(ind), "w") do fout
            for i in eachindex(ag)
                @printf(fout, "%16.12f ", ag[i])
                @printf(fout, "%16.12f %16.12f ", G[i], G[i+ngrid])
                @printf(fout, "%16.12f %16.12f\n", err[i], err[i+ngrid])
            end
        end
    end
end

function Base.show(io::IO, 𝑝::GaussianPeak)
    println("peak type : gaussian")
    @printf("  amplitude   : %16.12f\n", 𝑝.A)
    @printf("  broadening  : %16.12f\n", 𝑝.Γ)
    @printf("  shift       : %16.12f  ", 𝑝.ϵ)
end

function Base.show(io::IO, 𝑝::LorentzianPeak)
    println("peak type : lorentzian")
    @printf("  amplitude   : %16.12f\n", 𝑝.A)
    @printf("  broadening  : %16.12f\n", 𝑝.Γ)
    @printf("  shift       : %16.12f  ", 𝑝.ϵ)
end

function Base.show(io::IO, 𝑝::DeltaPeak)
    println("peak type : delta")
    @printf("  amplitude   : %16.12f\n", 𝑝.A)
    @printf("  broadening  : %16.12f\n", 𝑝.Γ)
    @printf("  shift       : %16.12f  ", 𝑝.ϵ)
end

function Base.show(io::IO, 𝑝::RectanglePeak)
    println("peak type : rectangle")
    @printf("  center : %16.12f\n", 𝑝.c)
    @printf("  width  : %16.12f\n", 𝑝.w)
    @printf("  height : %16.12f  ", 𝑝.h)
end
