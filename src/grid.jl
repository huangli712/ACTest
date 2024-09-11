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
    ImaginaryTimeGrid(ntime::I64, β::T) where {T}

A constructor for the ImaginaryTimeGrid struct, which is defined
in `src/types.jl`.

### Arguments
* ntime -> Number of time slices in imaginary axis.
* β     -> Inverse temperature.

### Returns
* grid -> A ImaginaryTimeGrid struct.

See also: [`ImaginaryTimeGrid`](@ref).
"""
function ImaginaryTimeGrid(ntime::I64, β::T) where {T}
    @assert ntime ≥ 1
    @assert β ≥ 0.0
    τ = collect(LinRange(0.0, β, ntime))
    return ImaginaryTimeGrid(ntime, β, τ)
end

"""
    Base.length(fg::ImaginaryTimeGrid)

Return number of grid points in a ImaginaryTimeGrid struct.

See also: [`ImaginaryTimeGrid`](@ref).
"""
function Base.length(fg::ImaginaryTimeGrid)
    fg.ntime
end

"""
    Base.iterate(fg::ImaginaryTimeGrid)

Advance the iterator of a ImaginaryTimeGrid struct to obtain
the next grid point.

See also: [`ImaginaryTimeGrid`](@ref).
"""
function Base.iterate(fg::ImaginaryTimeGrid)
    iterate(fg.τ)
end

"""
    Base.iterate(fg::ImaginaryTimeGrid, i::I64)

This is the key method that allows a ImaginaryTimeGrid struct
to be iterated, yielding a sequences of grid points.

See also: [`ImaginaryTimeGrid`](@ref).
"""
function Base.iterate(fg::ImaginaryTimeGrid, i::I64)
    iterate(fg.τ, i)
end

"""
    Base.eachindex(fg::ImaginaryTimeGrid)

Create an iterable object for visiting each index of a
ImaginaryTimeGrid struct.

See also: [`ImaginaryTimeGrid`](@ref).
"""
function Base.eachindex(fg::ImaginaryTimeGrid)
    eachindex(fg.τ)
end

"""
    Base.firstindex(fg::ImaginaryTimeGrid)

Return the first index of a ImaginaryTimeGrid struct.

See also: [`ImaginaryTimeGrid`](@ref).
"""
function Base.firstindex(fg::ImaginaryTimeGrid)
    firstindex(fg.τ)
end

"""
    Base.lastindex(fg::ImaginaryTimeGrid)

Return the last index of a ImaginaryTimeGrid struct.

See also: [`ImaginaryTimeGrid`](@ref).
"""
function Base.lastindex(fg::ImaginaryTimeGrid)
    lastindex(fg.τ)
end

"""
    Base.getindex(fg::ImaginaryTimeGrid, ind::I64)

Retrieve the value(s) stored at the given key or index within a
ImaginaryTimeGrid struct.

See also: [`ImaginaryTimeGrid`](@ref).
"""
function Base.getindex(fg::ImaginaryTimeGrid, ind::I64)
    @assert 1 ≤ ind ≤ fg.ntime
    return fg.τ[ind]
end

"""
    Base.getindex(fg::ImaginaryTimeGrid, I::UnitRange{I64})

Return a subset of a ImaginaryTimeGrid struct as specified by `I`.

See also: [`ImaginaryTimeGrid`](@ref).
"""
function Base.getindex(fg::ImaginaryTimeGrid, I::UnitRange{I64})
    @assert checkbounds(Bool, fg.τ, I)
    lI = length(I)
    X = similar(fg.τ, lI)
    if lI > 0
        unsafe_copyto!(X, 1, fg.τ, first(I), lI)
    end
    return X
end

"""
    rebuild!(fg::ImaginaryTimeGrid, ntime::I64, β::T) where {T}

Rebuild the ImaginaryTimeGrid struct via new `ntime` and `β`
parameters.

### Arguments
* fg -> A ImaginaryTimeGrid struct.
* ntime -> Number of time slices.
* β -> Inverse temperature.

### Returns
N/A

See also: [`ImaginaryTimeGrid`](@ref).
"""
function rebuild!(fg::ImaginaryTimeGrid, ntime::I64, β::T) where {T}
    @assert ntime ≥ 1
    @assert β ≥ 0.0
    fg.ntime = ntime
    fg.β = β
    fg.τ = collect(LinRange(0.0, fg.β, fg.ntime))
end

#=
### *Struct : MatsubaraGrid*
=#

"""
    MatsubaraGrid(nfreq::I64, β::T) where {T}

A constructor for the MatsubaraGrid struct, which is defined in
`src/types.jl`. The Matsubara grid is evaluated as ωₙ = (2n - 1) π / β.

### Arguments
* nfreq -> Number of Matsubara frequencies.
* β     -> Inverse temperature.

### Returns
* grid -> A MatsubaraGrid struct.

See also: [`MatsubaraGrid`](@ref).
"""
function MatsubaraGrid(nfreq::I64, β::T) where {T}
    @assert nfreq ≥ 1
    @assert β ≥ 0.0
    wmin = π / β
    wmax = (2 * nfreq - 1) * π / β
    ω = collect(LinRange(wmin, wmax, nfreq))
    return MatsubaraGrid(nfreq, β, ω)
end

"""
    Base.length(fg::MatsubaraGrid)

Return number of grid points in a MatsubaraGrid struct.

See also: [`MatsubaraGrid`](@ref).
"""
function Base.length(fg::MatsubaraGrid)
    fg.nfreq
end

"""
    Base.iterate(fg::MatsubaraGrid)

Advance the iterator of a MatsubaraGrid struct to obtain
the next grid point.

See also: [`MatsubaraGrid`](@ref).
"""
function Base.iterate(fg::MatsubaraGrid)
    iterate(fg.ω)
end

"""
    Base.iterate(fg::MatsubaraGrid, i::I64)

Create an iterable object for visiting each index of a
MatsubaraGrid struct.

See also: [`MatsubaraGrid`](@ref).
"""
function Base.iterate(fg::MatsubaraGrid, i::I64)
    iterate(fg.ω, i)
end

"""
    Base.eachindex(fg::MatsubaraGrid)

Create an iterable object for visiting each index of a
MatsubaraGrid struct.

See also: [`MatsubaraGrid`](@ref).
"""
function Base.eachindex(fg::MatsubaraGrid)
    eachindex(fg.ω)
end

"""
    Base.firstindex(fg::MatsubaraGrid)

Return the first index of a MatsubaraGrid struct.

See also: [`MatsubaraGrid`](@ref).
"""
function Base.firstindex(fg::MatsubaraGrid)
    firstindex(fg.ω)
end

"""
    Base.lastindex(fg::MatsubaraGrid)

Return the last index of a MatsubaraGrid struct.

See also: [`MatsubaraGrid`](@ref).
"""
function Base.lastindex(fg::MatsubaraGrid)
    lastindex(fg.ω)
end

"""
    Base.getindex(fg::MatsubaraGrid, ind::I64)

Retrieve the value(s) stored at the given key or index within a
MatsubaraGrid struct.

See also: [`MatsubaraGrid`](@ref).
"""
function Base.getindex(fg::MatsubaraGrid, ind::I64)
    @assert 1 ≤ ind ≤ fg.nfreq
    return fg.ω[ind]
end

"""
    Base.getindex(fg::MatsubaraGrid, I::UnitRange{I64})

Return a subset of a MatsubaraGrid struct as specified by `I`.

See also: [`MatsubaraGrid`](@ref).
"""
function Base.getindex(fg::MatsubaraGrid, I::UnitRange{I64})
    @assert checkbounds(Bool, fg.ω, I)
    lI = length(I)
    X = similar(fg.ω, lI)
    if lI > 0
        unsafe_copyto!(X, 1, fg.ω, first(I), lI)
    end
    return X
end

"""
    rebuild!(fg::MatsubaraGrid, nfreq::I64, β::T) where {T}

Rebuild the MatsubaraGrid struct via new `nfreq` and `β`
parameters.

### Arguments
* fg -> A MatsubaraGrid struct.
* nfreq -> Number of Matsubara frequencies.
* β -> Inverse temperature.

### Returns
N/A

See also: [`MatsubaraGrid`](@ref).
"""
function rebuild!(fg::MatsubaraGrid, nfreq::I64, β::T) where {T}
    @assert nfreq ≥ 1
    @assert β ≥ 0.0
    fg.nfreq = nfreq
    fg.β = β
    resize!(fg.ω, nfreq)
    for n = 1:nfreq
        fg.ω[n] = (2 * n - 1) * π / fg.β
    end
end

"""
    Base.resize!(fg::MatsubaraGrid, nfreq::I64)

Reduce the size of the  Matsubara grid. Note that `nfreq` should
be smaller than or equal to `fg.nfreq`. This function is called by the
NevanAC solver only.

### Arguments
* fg -> A MatsubaraGrid struct.
* nfreq -> Number of Matsubara frequencies.

### Returns
N/A

See also: [`MatsubaraGrid`](@ref).
"""
function Base.resize!(fg::MatsubaraGrid, nfreq::I64)
    @assert fg.nfreq ≥ nfreq
    fg.nfreq = nfreq
    resize!(fg.ω, nfreq)
end

"""
    Base.reverse!(fg::MatsubaraGrid)

Reverse the  Matsubara grid. This function is called by the
`NevanAC` solver only.

See also: [`MatsubaraGrid`](@ref).
"""
function Base.reverse!(fg::MatsubaraGrid)
    reverse!(fg.ω)
end
