#!/usr/bin/env julia
  
#
# This script is used to start analytic continuation simulations.
# It will launch only 1 process.
#
# Usage:
#
#     $ actest.jl act.toml
#

push!(LOAD_PATH, "../src")
push!(LOAD_PATH, "/Users/lihuang/Working/devel/ACFlow/src/")

using Printf
using ACTest
using ACFlow:setup_param, read_data, solve

function make_test()
    nspec = get_t("nspec")

    B = Dict{String,Any}(
        "finput" => "green.data",
        "solver" => get_t("solver"),
        "ktype"  => get_t("ktype"),
        "mtype"  => "flat",
        "grid"   => get_t("grid"),
        "mesh"   => get_t("mesh"),
        "ngrid"  => get_t("ngrid"),
        "nmesh"  => get_t("nmesh"),
        "wmax"   => get_t("wmax"),
        "wmin"   => get_t("wmin"),
        "beta"   => get_t("beta"),
        "offdiag" => get_t("offdiag"),
        "pmesh" => get_t("pmesh"),
    )

    cfg = inp_toml(query_args(), true)
    S = cfg["Solver"]

    for i = 1:nspec
        @printf("test case -> %6i\n", i)
        B["finput"] = "green.data." * string(i)
        setup_param(B, S)
        try
            mesh, Aout, Gout = solve(read_data())
            cp("Aout.data", "Aout.data." * string(i), force = true)
            cp("Gout.data", "Gout.data." * string(i), force = true)
            cp("repr.data", "repr.data." * string(i), force = true)
        catch ex
            println("something wrong for test case $i")
        end
        println()
    end
end

welcome()
overview()
read_param()
make_test()
goodbye()
