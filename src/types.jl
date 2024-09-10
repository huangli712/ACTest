#
# Project : Lily
# Source  : types.jl
# Author  : Li Huang (huangli@caep.cn)
# Status  : Unstable
#
# Last modified: 2024/09/10
#

abstract type AbstractGrid end

mutable struct MatsubaraGrid{T} <: AbstractGrid
    nfreq :: I64
    β :: T
    ω :: Vector{T}
end

mutable struct ImaginaryTimeGrid <: AbstractGrid
    ntime :: I64
    β :: T
    τ :: Vector{T}
end

abstract type AbstractMesh end

mutable struct LinearMesh{T} <: AbstractMesh
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


