#
# Project : Lily
# Source  : grid.jl
# Author  : Li Huang (huangli@caep.cn)
# Status  : Unstable
#
# Last modified: 2024/09/11
#

#=
### *Struct : ImaginaryTimeGrid*
=#

"""
    ImaginaryTimeGrid(ntime::I64, β::F64)

A constructor for the ImaginaryTimeGrid struct, which is defined
in `src/types.jl`.

### Arguments
* ntime -> Number of time slices in imaginary axis.
* β     -> Inverse temperature.

### Returns
* grid -> A ImaginaryTimeGrid struct.

See also: [`ImaginaryTimeGrid`](@ref).
"""
function ImaginaryTimeGrid(ntime::I64, β::F64)
    @assert ntime ≥ 1
    @assert β ≥ 0.0
    τ = collect(LinRange(0.0, β, ntime))
    return ImaginaryTimeGrid(ntime, β, τ)
end

"""
    Base.length(grid::ImaginaryTimeGrid)

Return number of grid points in a ImaginaryTimeGrid struct.

See also: [`ImaginaryTimeGrid`](@ref).
"""
function Base.length(grid::ImaginaryTimeGrid)
    grid.ntime
end

"""
    Base.iterate(grid::ImaginaryTimeGrid)

Advance the iterator of a ImaginaryTimeGrid struct to obtain
the next grid point.

See also: [`ImaginaryTimeGrid`](@ref).
"""
function Base.iterate(grid::ImaginaryTimeGrid)
    iterate(grid.τ)
end

"""
    Base.iterate(grid::ImaginaryTimeGrid, i::I64)

This is the key method that allows a ImaginaryTimeGrid struct
to be iterated, yielding a sequences of grid points.

See also: [`ImaginaryTimeGrid`](@ref).
"""
function Base.iterate(grid::ImaginaryTimeGrid, i::I64)
    iterate(grid.τ, i)
end

"""
    Base.eachindex(grid::ImaginaryTimeGrid)

Create an iterable object for visiting each index of a
ImaginaryTimeGrid struct.

See also: [`ImaginaryTimeGrid`](@ref).
"""
function Base.eachindex(grid::ImaginaryTimeGrid)
    eachindex(grid.τ)
end

"""
    Base.firstindex(grid::ImaginaryTimeGrid)

Return the first index of a ImaginaryTimeGrid struct.

See also: [`ImaginaryTimeGrid`](@ref).
"""
function Base.firstindex(grid::ImaginaryTimeGrid)
    firstindex(grid.τ)
end

"""
    Base.lastindex(grid::ImaginaryTimeGrid)

Return the last index of a ImaginaryTimeGrid struct.

See also: [`ImaginaryTimeGrid`](@ref).
"""
function Base.lastindex(grid::ImaginaryTimeGrid)
    lastindex(grid.τ)
end

"""
    Base.getindex(grid::ImaginaryTimeGrid, ind::I64)

Retrieve the value(s) stored at the given key or index within a
ImaginaryTimeGrid struct.

See also: [`ImaginaryTimeGrid`](@ref).
"""
function Base.getindex(grid::ImaginaryTimeGrid, ind::I64)
    @assert 1 ≤ ind ≤ grid.ntime
    return grid.τ[ind]
end

"""
    Base.getindex(grid::ImaginaryTimeGrid, I::UnitRange{I64})

Return a subset of a ImaginaryTimeGrid struct as specified by `I`.

See also: [`ImaginaryTimeGrid`](@ref).
"""
function Base.getindex(grid::ImaginaryTimeGrid, I::UnitRange{I64})
    @assert checkbounds(Bool, grid.τ, I)
    lI = length(I)
    X = similar(grid.τ, lI)
    if lI > 0
        unsafe_copyto!(X, 1, grid.τ, first(I), lI)
    end
    return X
end

"""
    rebuild!(grid::ImaginaryTimeGrid, ntime::I64, β::F64)

Rebuild the ImaginaryTimeGrid struct via new `ntime` and `β`
parameters.

### Arguments
* grid -> A ImaginaryTimeGrid struct.
* ntime -> Number of time slices.
* β -> Inverse temperature.

### Returns
N/A

See also: [`ImaginaryTimeGrid`](@ref).
"""
function rebuild!(grid::ImaginaryTimeGrid, ntime::I64, β::F64)
    @assert ntime ≥ 1
    @assert β ≥ 0.0
    grid.ntime = ntime
    grid.β = β
    grid.τ = collect(LinRange(0.0, grid.β, grid.ntime))
end

#=
### *Struct : MatsubaraGrid*
=#

"""
    MatsubaraGrid(type::I64, nfreq::I64, β::F64)

A constructor for the MatsubaraGrid struct, which is defined in
`src/types.jl`. The Matsubara grid is evaluated as ωₙ = (2n - 2) π / β
or ωₙ = (2n - 1) π / β.

### Arguments
* type  -> Type of Matsubara grid, bosonic or fermionic.
* nfreq -> Number of Matsubara frequencies.
* β     -> Inverse temperature.

### Returns
* grid -> A MatsubaraGrid struct.

See also: [`MatsubaraGrid`](@ref).
"""
function MatsubaraGrid(type::I64, nfreq::I64, β::F64)
    @assert nfreq ≥ 1
    @assert β ≥ 0.0
    #
    if type == 0 # Bosonic grid
        wmin = 0.0
        wmax = (2 * nfreq - 2) * π / β
    else         # Fermionic grid
        wmin = π / β
        wmax = (2 * nfreq - 1) * π / β
    end
    #
    ω = collect(LinRange(wmin, wmax, nfreq))
    return MatsubaraGrid(type, nfreq, β, ω)
end

"""
    Base.length(grid::MatsubaraGrid)

Return number of grid points in a MatsubaraGrid struct.

See also: [`MatsubaraGrid`](@ref).
"""
function Base.length(grid::MatsubaraGrid)
    grid.nfreq
end

"""
    Base.iterate(grid::MatsubaraGrid)

Advance the iterator of a MatsubaraGrid struct to obtain
the next grid point.

See also: [`MatsubaraGrid`](@ref).
"""
function Base.iterate(grid::MatsubaraGrid)
    iterate(grid.ω)
end

"""
    Base.iterate(grid::MatsubaraGrid, i::I64)

Create an iterable object for visiting each index of a
MatsubaraGrid struct.

See also: [`MatsubaraGrid`](@ref).
"""
function Base.iterate(grid::MatsubaraGrid, i::I64)
    iterate(grid.ω, i)
end

"""
    Base.eachindex(grid::MatsubaraGrid)

Create an iterable object for visiting each index of a
MatsubaraGrid struct.

See also: [`MatsubaraGrid`](@ref).
"""
function Base.eachindex(grid::MatsubaraGrid)
    eachindex(grid.ω)
end

"""
    Base.firstindex(grid::MatsubaraGrid)

Return the first index of a MatsubaraGrid struct.

See also: [`MatsubaraGrid`](@ref).
"""
function Base.firstindex(grid::MatsubaraGrid)
    firstindex(grid.ω)
end

"""
    Base.lastindex(grid::MatsubaraGrid)

Return the last index of a MatsubaraGrid struct.

See also: [`MatsubaraGrid`](@ref).
"""
function Base.lastindex(grid::MatsubaraGrid)
    lastindex(grid.ω)
end

"""
    Base.getindex(grid::MatsubaraGrid, ind::I64)

Retrieve the value(s) stored at the given key or index within a
MatsubaraGrid struct.

See also: [`MatsubaraGrid`](@ref).
"""
function Base.getindex(grid::MatsubaraGrid, ind::I64)
    @assert 1 ≤ ind ≤ grid.nfreq
    return grid.ω[ind]
end

"""
    Base.getindex(grid::MatsubaraGrid, I::UnitRange{I64})

Return a subset of a MatsubaraGrid struct as specified by `I`.

See also: [`MatsubaraGrid`](@ref).
"""
function Base.getindex(grid::MatsubaraGrid, I::UnitRange{I64})
    @assert checkbounds(Bool, grid.ω, I)
    lI = length(I)
    X = similar(grid.ω, lI)
    if lI > 0
        unsafe_copyto!(X, 1, grid.ω, first(I), lI)
    end
    return X
end

"""
    rebuild!(grid::MatsubaraGrid, nfreq::I64, β::F64)

Rebuild the MatsubaraGrid struct via new `nfreq` and `β` parameters.

### Arguments
* grid -> A MatsubaraGrid struct.
* nfreq -> Number of Matsubara frequencies.
* β -> Inverse temperature.

### Returns
N/A

See also: [`MatsubaraGrid`](@ref).
"""
function rebuild!(grid::MatsubaraGrid, nfreq::I64, β::F64)
    @assert nfreq ≥ 1
    @assert β ≥ 0.0
    grid.nfreq = nfreq
    grid.β = β
    resize!(grid.ω, nfreq)
    for n = 1:nfreq
        grid.ω[n] = (2 * n - 1) * π / grid.β
    end
end

"""
    Base.resize!(grid::MatsubaraGrid, nfreq::I64)

Reduce the size of the Matsubara grid. Note that `nfreq` should be
smaller than or equal to `grid.nfreq`.

### Arguments
* grid -> A MatsubaraGrid struct.
* nfreq -> Number of Matsubara frequencies.

### Returns
N/A

See also: [`MatsubaraGrid`](@ref).
"""
function Base.resize!(grid::MatsubaraGrid, nfreq::I64)
    @assert grid.nfreq ≥ nfreq
    grid.nfreq = nfreq
    resize!(grid.ω, nfreq)
end
