#
# Project : Lily
# Source  : grid.jl
# Author  : Li Huang (huangli@caep.cn)
# Status  : Unstable
#
# Last modified: 2024/09/11
#

#=
### *Struct : FermionicImaginaryTimeGrid*
=#

"""
    FermionicImaginaryTimeGrid(ntime::I64, β::T) where {T}

A constructor for the FermionicImaginaryTimeGrid struct, which is defined
in `src/types.jl`.

### Arguments
* ntime -> Number of time slices in imaginary axis.
* β     -> Inverse temperature.

### Returns
* grid -> A FermionicImaginaryTimeGrid struct.

See also: [`FermionicImaginaryTimeGrid`](@ref).
"""
function FermionicImaginaryTimeGrid(ntime::I64, β::T) where {T}
    @assert ntime ≥ 1
    @assert β ≥ 0.0
    τ = collect(LinRange(0.0, β, ntime))
    return FermionicImaginaryTimeGrid(ntime, β, τ)
end

"""
    Base.length(fg::FermionicImaginaryTimeGrid)

Return number of grid points in a FermionicImaginaryTimeGrid struct.

See also: [`FermionicImaginaryTimeGrid`](@ref).
"""
function Base.length(fg::FermionicImaginaryTimeGrid)
    fg.ntime
end

"""
    Base.iterate(fg::FermionicImaginaryTimeGrid)

Advance the iterator of a FermionicImaginaryTimeGrid struct to obtain
the next grid point.

See also: [`FermionicImaginaryTimeGrid`](@ref).
"""
function Base.iterate(fg::FermionicImaginaryTimeGrid)
    iterate(fg.τ)
end

"""
    Base.iterate(fg::FermionicImaginaryTimeGrid, i::I64)

This is the key method that allows a FermionicImaginaryTimeGrid struct
to be iterated, yielding a sequences of grid points.

See also: [`FermionicImaginaryTimeGrid`](@ref).
"""
function Base.iterate(fg::FermionicImaginaryTimeGrid, i::I64)
    iterate(fg.τ, i)
end

"""
    Base.eachindex(fg::FermionicImaginaryTimeGrid)

Create an iterable object for visiting each index of a
FermionicImaginaryTimeGrid struct.

See also: [`FermionicImaginaryTimeGrid`](@ref).
"""
function Base.eachindex(fg::FermionicImaginaryTimeGrid)
    eachindex(fg.τ)
end

"""
    Base.firstindex(fg::FermionicImaginaryTimeGrid)

Return the first index of a FermionicImaginaryTimeGrid struct.

See also: [`FermionicImaginaryTimeGrid`](@ref).
"""
function Base.firstindex(fg::FermionicImaginaryTimeGrid)
    firstindex(fg.τ)
end

"""
    Base.lastindex(fg::FermionicImaginaryTimeGrid)

Return the last index of a FermionicImaginaryTimeGrid struct.

See also: [`FermionicImaginaryTimeGrid`](@ref).
"""
function Base.lastindex(fg::FermionicImaginaryTimeGrid)
    lastindex(fg.τ)
end

"""
    Base.getindex(fg::FermionicImaginaryTimeGrid, ind::I64)

Retrieve the value(s) stored at the given key or index within a
FermionicImaginaryTimeGrid struct.

See also: [`FermionicImaginaryTimeGrid`](@ref).
"""
function Base.getindex(fg::FermionicImaginaryTimeGrid, ind::I64)
    @assert 1 ≤ ind ≤ fg.ntime
    return fg.τ[ind]
end

"""
    Base.getindex(fg::FermionicImaginaryTimeGrid, I::UnitRange{I64})

Return a subset of a FermionicImaginaryTimeGrid struct as specified by `I`.

See also: [`FermionicImaginaryTimeGrid`](@ref).
"""
function Base.getindex(fg::FermionicImaginaryTimeGrid, I::UnitRange{I64})
    @assert checkbounds(Bool, fg.τ, I)
    lI = length(I)
    X = similar(fg.τ, lI)
    if lI > 0
        unsafe_copyto!(X, 1, fg.τ, first(I), lI)
    end
    return X
end

"""
    rebuild!(fg::FermionicImaginaryTimeGrid, ntime::I64, β::T) where {T}

Rebuild the FermionicImaginaryTimeGrid struct via new `ntime` and `β`
parameters.

### Arguments
* fg -> A FermionicImaginaryTimeGrid struct.
* ntime -> Number of time slices.
* β -> Inverse temperature.

### Returns
N/A

See also: [`FermionicImaginaryTimeGrid`](@ref).
"""
function rebuild!(fg::FermionicImaginaryTimeGrid, ntime::I64, β::T) where {T}
    @assert ntime ≥ 1
    @assert β ≥ 0.0
    fg.ntime = ntime
    fg.β = β
    fg.τ = collect(LinRange(0.0, fg.β, fg.ntime))
end

#=
### *Struct : FermionicMatsubaraGrid*
=#

"""
    FermionicMatsubaraGrid(nfreq::I64, β::T) where {T}

A constructor for the FermionicMatsubaraGrid struct, which is defined in
`src/types.jl`. The Matsubara grid is evaluated as ωₙ = (2n - 1) π / β.

### Arguments
* nfreq -> Number of Matsubara frequencies.
* β     -> Inverse temperature.

### Returns
* grid -> A FermionicMatsubaraGrid struct.

See also: [`FermionicMatsubaraGrid`](@ref).
"""
function FermionicMatsubaraGrid(nfreq::I64, β::T) where {T}
    @assert nfreq ≥ 1
    @assert β ≥ 0.0
    wmin = π / β
    wmax = (2 * nfreq - 1) * π / β
    ω = collect(LinRange(wmin, wmax, nfreq))
    return FermionicMatsubaraGrid(nfreq, β, ω)
end

"""
    Base.length(fg::FermionicMatsubaraGrid)

Return number of grid points in a FermionicMatsubaraGrid struct.

See also: [`FermionicMatsubaraGrid`](@ref).
"""
function Base.length(fg::FermionicMatsubaraGrid)
    fg.nfreq
end

"""
    Base.iterate(fg::FermionicMatsubaraGrid)

Advance the iterator of a FermionicMatsubaraGrid struct to obtain
the next grid point.

See also: [`FermionicMatsubaraGrid`](@ref).
"""
function Base.iterate(fg::FermionicMatsubaraGrid)
    iterate(fg.ω)
end

"""
    Base.iterate(fg::FermionicMatsubaraGrid, i::I64)

Create an iterable object for visiting each index of a
FermionicMatsubaraGrid struct.

See also: [`FermionicMatsubaraGrid`](@ref).
"""
function Base.iterate(fg::FermionicMatsubaraGrid, i::I64)
    iterate(fg.ω, i)
end

"""
    Base.eachindex(fg::FermionicMatsubaraGrid)

Create an iterable object for visiting each index of a
FermionicMatsubaraGrid struct.

See also: [`FermionicMatsubaraGrid`](@ref).
"""
function Base.eachindex(fg::FermionicMatsubaraGrid)
    eachindex(fg.ω)
end

"""
    Base.firstindex(fg::FermionicMatsubaraGrid)

Return the first index of a FermionicMatsubaraGrid struct.

See also: [`FermionicMatsubaraGrid`](@ref).
"""
function Base.firstindex(fg::FermionicMatsubaraGrid)
    firstindex(fg.ω)
end

"""
    Base.lastindex(fg::FermionicMatsubaraGrid)

Return the last index of a FermionicMatsubaraGrid struct.

See also: [`FermionicMatsubaraGrid`](@ref).
"""
function Base.lastindex(fg::FermionicMatsubaraGrid)
    lastindex(fg.ω)
end

"""
    Base.getindex(fg::FermionicMatsubaraGrid, ind::I64)

Retrieve the value(s) stored at the given key or index within a
FermionicMatsubaraGrid struct.

See also: [`FermionicMatsubaraGrid`](@ref).
"""
function Base.getindex(fg::FermionicMatsubaraGrid, ind::I64)
    @assert 1 ≤ ind ≤ fg.nfreq
    return fg.ω[ind]
end

"""
    Base.getindex(fg::FermionicMatsubaraGrid, I::UnitRange{I64})

Return a subset of a FermionicMatsubaraGrid struct as specified by `I`.

See also: [`FermionicMatsubaraGrid`](@ref).
"""
function Base.getindex(fg::FermionicMatsubaraGrid, I::UnitRange{I64})
    @assert checkbounds(Bool, fg.ω, I)
    lI = length(I)
    X = similar(fg.ω, lI)
    if lI > 0
        unsafe_copyto!(X, 1, fg.ω, first(I), lI)
    end
    return X
end

"""
    rebuild!(fg::FermionicMatsubaraGrid, nfreq::I64, β::T) where {T}

Rebuild the FermionicMatsubaraGrid struct via new `nfreq` and `β`
parameters.

### Arguments
* fg -> A FermionicMatsubaraGrid struct.
* nfreq -> Number of Matsubara frequencies.
* β -> Inverse temperature.

### Returns
N/A

See also: [`FermionicMatsubaraGrid`](@ref).
"""
function rebuild!(fg::FermionicMatsubaraGrid, nfreq::I64, β::T) where {T}
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
    Base.resize!(fg::FermionicMatsubaraGrid, nfreq::I64)

Reduce the size of the fermionic Matsubara grid. Note that `nfreq` should
be smaller than or equal to `fg.nfreq`. This function is called by the
NevanAC solver only.

### Arguments
* fg -> A FermionicMatsubaraGrid struct.
* nfreq -> Number of Matsubara frequencies.

### Returns
N/A

See also: [`FermionicMatsubaraGrid`](@ref).
"""
function Base.resize!(fg::FermionicMatsubaraGrid, nfreq::I64)
    @assert fg.nfreq ≥ nfreq
    fg.nfreq = nfreq
    resize!(fg.ω, nfreq)
end

"""
    Base.reverse!(fg::FermionicMatsubaraGrid)

Reverse the fermionic Matsubara grid. This function is called by the
`NevanAC` solver only.

See also: [`FermionicMatsubaraGrid`](@ref).
"""
function Base.reverse!(fg::FermionicMatsubaraGrid)
    reverse!(fg.ω)
end
