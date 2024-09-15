#!/usr/bin/env julia
  
#
# This script is used to start analytic continuation simulations.
# It will launch only 1 process.
#
# Usage:
#
#     $ actest.jl act.toml
#

push!(LOAD_PATH, "/Users/lihuang/Working/devel/ACTest/src")
push!(LOAD_PATH, "/Users/lihuang/Working/devel/ACFlow/src/")

using ACTest
using ACFlow:setup_param
using ACFlow:read_data
using ACFlow:solve
using Printf
using DelimitedFiles

function get_dict()
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

    return B, S
end

function test_summary(error)
    ntest = get_t("ntest")
    for i = 1:ntest
        @printf("%5i %16.12f ", i, error[i])
        if error[i] == 0.0
            println("false")
        else
            println("true")
        end
    end
    println("number of tests: ", ntest)
    println("successful tests: ", count(x -> x != 0.0, error))
end

function make_test()
    ntest = get_t("ntest")

    nfail = 0
    nsucc = 0
    error = zeros(F64, ntest)

    B, S = get_dict()

    for i = 1:ntest
        @printf("Test -> %4i / %4i\n", i, ntest)
        B["finput"] = "green.data." * string(i)
        setup_param(B, S)
        try
            mesh, Aout, Gout = solve(read_data())
            #
            cp("Aout.data", "Aout.data." * string(i), force = true)
            cp("Gout.data", "Gout.data." * string(i), force = true)
            cp("repr.data", "repr.data." * string(i), force = true)
            #
            data = readdlm("image.data." * string(i))
            Ainp = data[:,2]
            error[i] = trapz(mesh, abs.(Ainp .- Aout)) / trapz(mesh, abs.(Ainp))
            @printf("Accuracy: %16.12f\n", error[i])
            nsucc = nsucc + 1
        catch ex
            error[i] = 0.0
            nfail = nfail + 1
            println("something wrong for test case $i")
        end
        println()
    end

    @assert nfail + nsucc == ntest

    test_summary()
end

welcome()
overview()
read_param()
make_test()
goodbye()
