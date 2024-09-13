#
# Project : Lily
# Source  : ACTest.jl
# Author  : Li Huang (huangli@caep.cn)
# Status  : Unstable
#
# Last modified: 2024/09/12
#

"""
    ACTest
"""
module ACTest

using Distributed
using LinearAlgebra
using Statistics
using Random
using Dates
using Printf
using TOML

include("global.jl")
export I32, I64, API
export F32, F64, APF
export C32, C64, APC
export R32, R64, APR
export N32, N64, APN
export __LIBNAME__
export __VERSION__
export __RELEASE__
export __AUTHORS__
export authors

include("types.jl")
export AbstractGrid
export FermionicImaginaryTimeGrid
export FermionicMatsubaraGrid
export BosonicImaginaryTimeGrid
export BosonicMatsubaraGrid
export AbstractMesh
export LinearMesh
export TangentMesh
export LorentzMesh
export HalfLorentzMesh

include("util.jl")
export welcome
export overview
export goodbye

include("math.jl")
export trapz
export simpson
#
export @einsum

include("grid.jl")
export rebuild!
export resize!
export reverse!

include("mesh.jl")
export nearest

include("peak.jl")
include("config.jl")
include("inout.jl")
export write_spectrum
export write_backward

include("kernel.jl")

include("base.jl")
export reprod
export read_param
export make_data
export make_peak
export make_spectrum
export make_green
export make_grid
export make_mesh
export make_kernel

"""
    _precompile()

Here, we would like to precompile the whole `ACTest` toolkit to reduce
the runtime latency and speed up the successive calculations.
"""
function _precompile()
    prompt("Loading...")

    # Get an array of the names exported by the `ACTest` module
    nl = names(ACTest)

    # Go through each name
    cf = 0 # Counter
    for i in eachindex(nl)
        # Please pay attention to that nl[i] is a Symbol, we need to
        # convert it into string and function, respectively.
        str = string(nl[i])
        fun = eval(nl[i])

        # For methods only (macros must be excluded)
        if fun isa Function && !startswith(str, "@")
            # Increase the counter
            cf = cf + 1

            # Extract the signature of the function
            # Actually, `types` is a Core.SimpleVector.
            types = nothing
            try
                types = typeof(fun).name.mt.defs.sig.types
            catch
                @printf("Function %15s (#%3i) is skipped.\r", str, cf)
                continue
            end

            # Convert `types` from SimpleVector into Tuple
            # If length(types) is 1, the method is without arguments.
            T = ()
            if length(types) > 1
                T = tuple(types[2:end]...)
            end

            # Precompile them one by one
            #println(i, " -> ", str, " -> ", length(types), " -> ", T)
            precompile(fun, T)
            @printf("Function %24s (#%4i) is compiled.\r", str, cf)
        end
    end

    prompt("Well, ACTest is compiled and loaded ($cf functions).")
    prompt("We are ready to go!")
    println()
    flush(stdout)
end

"""
    __init__()

This function would be executed immediately after the module is loaded
at runtime for the first time. It works at the REPL mode only.
"""
__init__() = begin
    isinteractive() && _precompile()
end

end
