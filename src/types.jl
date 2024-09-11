#
# Project : Lily
# Source  : types.jl
# Author  : Li Huang (huangli@caep.cn)
# Status  : Unstable
#
# Last modified: 2024/09/11
#

abstract type AbstractGrid end

mutable struct ImaginaryTimeGrid <: AbstractGrid
    ntime :: I64
    β :: F64
    τ :: Vector{F64}
end

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


