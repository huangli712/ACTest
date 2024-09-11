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
