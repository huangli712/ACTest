
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

abstract type AbstractGrid end

mutable struct MatsubaraGrid <: AbstractGrid
end

mutable struct ImaginaryTimeGrid <: AbstractGrid
end

abstract type AbstractMesh end

mutable struct LinearMesh <: AbstractMesh
end
