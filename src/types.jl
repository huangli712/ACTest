#
# Project : Lily
# Source  : types.jl
# Author  : Li Huang (huangli@caep.cn)
# Status  : Unstable
#
# Last modified: 2024/09/11
#

#=
### *Customized Structs* : *Input Grid*
=#

"""
    AbstractGrid

An abstract type representing the imaginary axis. It is used to build
the internal type system.
"""
abstract type AbstractGrid end

"""
    ImaginaryTimeGrid

Mutable struct. It represents the imaginary time grid.

### Members
* ntime -> Number of time slices.
* β     -> Inverse temperature.
* τ     -> Vector of grid points， τᵢ.

See also: [`MatsubaraGrid`](@ref).
"""
mutable struct ImaginaryTimeGrid <: AbstractGrid
    ntime :: I64
    β :: F64
    τ :: Vector{F64}
end

"""
    MatsubaraGrid

Mutable struct. It represents the Matsubara frequency grid.

### Members
* type  -> Type of Matsubara grid (0 for bosonic, 1 for fermionic).
* nfreq -> Number of Matsubara frequency points.
* β     -> Inverse temperature.
* ω     -> Vector of grid points, iωₙ.

See also: [`ImaginaryTimeGrid`](@ref).
"""
mutable struct MatsubaraGrid <: AbstractGrid
    type :: I64
    nfreq :: I64
    β :: F64
    ω :: Vector{F64}
end

abstract type AbstractMesh end

mutable struct LinearMesh <: AbstractMesh
    nmesh :: I64
    wmax :: F64
    wmin :: F64
    mesh :: Vector{F64}
    weight :: Vector{F64}
end

mutable struct TangentMesh{T} <: AbstractMesh
    nmesh :: I64
    wmax :: T
    wmin :: T
    mesh :: Vector{T}
    weight :: Vector{T}
end

mutable struct LorentzMesh{T} <: AbstractMesh
    nmesh :: I64
    wmax :: T
    wmin :: T
    mesh :: Vector{T}
    weight :: Vector{T}
end

mutable struct HalfLorentzMesh{T} <: AbstractMesh
    nmesh :: I64
    wmax :: T
    wmin :: T
    mesh :: Vector{T}
    weight :: Vector{T}
end

abstract type AbstractPeak end

mutable struct GaussianPeak <: AbstractPeak
end

mutable struct LorentzianPeak <: AbstractPeak
end

mutable struct RectanglePeak <: AbstractPeak
end


abstract type AbstractFunction end

mutable struct SpectralFunction <: AbstractFunction
end

mutable struct GreenFunction <: AbstractFunction
end


