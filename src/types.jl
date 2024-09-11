#
# Project : Lily
# Source  : types.jl
# Author  : Li Huang (huangli@caep.cn)
# Status  : Unstable
#
# Last modified: 2024/09/11
#

#=
### *Customized Types*
=#

"Customized types. It is used to define the following dicts."
const DType = Any

"Customized types. It is used to define the following dicts."
const ADT = Array{DType,1}

#=
### *Customized Dictionaries*
=#

#=
*Remarks* :

The values in the following dictionaries are actually arrays, which
usually contain four elements:
* Element[1] -> Actually value.
* Element[2] -> If it is 1, this key-value pair is mandatory.
                If it is 0, this key-value pair is optional.
* Element[3] -> Numerical type (A julia Symbol).
* Element[4] -> Brief explanations.

The following dictionaries are used as global variables.
=#

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

#=
### *Customized Structs* : *Output Mesh*
=#

"""
    AbstractMesh

An abstract type representing the real axis. It is used to build the
internal type system.
"""
abstract type AbstractMesh end

"""
    LinearMesh

Mutable struct. A linear and uniform mesh.

### Members
* nmesh  -> Number of mesh points.
* wmax   -> Right boundary (maximum value).
* wmin   -> Left boundary (minimum value).
* mesh   -> Mesh itself.
* weight -> Precomputed integration weights (composite trapezoidal rule).

See also: [`TangentMesh`](@ref).
"""
mutable struct LinearMesh <: AbstractMesh
    nmesh :: I64
    wmax :: F64
    wmin :: F64
    mesh :: Vector{F64}
    weight :: Vector{F64}
end

"""
    TangentMesh

Mutable struct. A non-linear and non-uniform mesh. Note that it should
be defined on both negative and positive half-axis.

### Members
* nmesh  -> Number of mesh points.
* wmax   -> Right boundary (maximum value).
* wmin   -> Left boundary (minimum value).
* mesh   -> Mesh itself.
* weight -> Precomputed integration weights (composite trapezoidal rule).

See also: [`LinearMesh`](@ref).
"""
mutable struct TangentMesh <: AbstractMesh
    nmesh :: I64
    wmax :: F64
    wmin :: F64
    mesh :: Vector{F64}
    weight :: Vector{F64}
end

"""
    LorentzMesh

Mutable struct. A non-linear and non-uniform mesh. Note that it should
be defined on both negative and positive half-axis.

### Members
* nmesh  -> Number of mesh points.
* wmax   -> Right boundary (maximum value).
* wmin   -> Left boundary (minimum value).
* mesh   -> Mesh itself.
* weight -> Precomputed integration weights (composite trapezoidal rule).

See also: [`HalfLorentzMesh`](@ref).
"""
mutable struct LorentzMesh <: AbstractMesh
    nmesh :: I64
    wmax :: F64
    wmin :: F64
    mesh :: Vector{F64}
    weight :: Vector{F64}
end

"""
    HalfLorentzMesh

Mutable struct. A non-linear and non-uniform mesh. Note that it should
be defined on positive half-axis only.

### Members
* nmesh  -> Number of mesh points.
* wmax   -> Right boundary (maximum value).
* wmin   -> Left boundary (minimum value). It must be 0.0.
* mesh   -> Mesh itself.
* weight -> Precomputed integration weights (composite trapezoidal rule).

See also: [`LorentzMesh`](@ref).
"""
mutable struct HalfLorentzMesh <: AbstractMesh
    nmesh :: I64
    wmax :: F64
    wmin :: F64
    mesh :: Vector{F64}
    weight :: Vector{F64}
end

abstract type AbstractPeak end

mutable struct GaussianPeak <: AbstractPeak
    A :: F64
    Γ :: F64
    ϵ :: F64
end

mutable struct LorentzianPeak <: AbstractPeak
    s :: F64
    ϵ :: F64
end

mutable struct RectanglePeak <: AbstractPeak
    c :: F64
    w :: F64
    h :: F64
end

abstract type AbstractFunction end

mutable struct SpectralFunction <: AbstractFunction
end

mutable struct GreenFunction <: AbstractFunction
end


