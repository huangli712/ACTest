#!/usr/bin/env julia
  
#
# This script is used to start analytic continuation simulations with the
# ACFlow toolkit. It will launch only 1 process.
#
# This script can be easily modified to support the other analytic
# configuration tools / methods, or support parallel calculations.
#
# Usage:
#
#     $ acflow.jl act.toml
#

using ACTest
using ACFlow:setup_param
using ACFlow:read_data
using ACFlow:solve

using Printf
using DelimitedFiles

# Prepare configurations for the ACFlow toolkit
function get_dict()
    # General setup
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

    # For analytic continuation solver
    cfg = inp_toml(query_args(), true)
    S = cfg["Solver"]

    return B, S
end

# Evaluate error for the current test. It just calculate distance between
# the true and calculated spectral function.
function get_error(i::I64, mesh::Vector{F64}, Aout::Vector{F64})
    # Read true solution
    data = readdlm("image.data." * string(i))
    Ainp = data[:,2]

    # Calculate the difference
    error = trapz(mesh, abs.(Ainp .- Aout)) / trapz(mesh, abs.(Ainp))

    return error
end

# Write summary for the tests to external file: summary.data
function write_summary(error, ctime)
    # Get number of tests
    ntest = get_t("ntest")

    open("summary.data", "w") do fout
        println(fout, "# index            error         time (s) passed")
        #
        for i = 1:ntest
            @printf(fout, "%7i %16.12f %16.12f", i, error[i], ctime[i])
            if error[i] == 0.0
                @printf(fout, "%7s\n", "false")
            else
                @printf(fout, "%7s\n", "true")
            end
        end
        #

        println(fout, "# Number of tests: ", ntest)
        println(fout, "# Failed tests: ", count(x -> iszero(x), error))
        println(fout, "# Abnormal tests: ", count(x -> isinf(x), error))
    end
end

# Perform analytic continuation simulations using the ACFlow toolkit
function make_test()
    # Get number of tests
    ntest = get_t("ntest")

    # Prepare some counters and essential variables
    nfail = 0
    nsucc = 0
    error = zeros(F64, ntest)
    ctime = zeros(F64, ntest)

    # Prepare configurations
    B, S = get_dict()

    for i = 1:ntest
        @printf("Test -> %4i / %4i\n", i, ntest)
        #
        # Setup configurations further for the current test
        B["finput"] = "green.data." * string(i)
        setup_param(B, S)
        #
        try
            # Solve the analytic continuation problem.
            # The elapsed time is recorded as well.
            start = time_ns()
            mesh, Aout, _ = solve(read_data())
            finish = time_ns()
            #
            # Backup the calculated results
            cp("Aout.data", "Aout.data." * string(i), force = true)
            cp("Gout.data", "Gout.data." * string(i), force = true)
            cp("repr.data", "repr.data." * string(i), force = true)
            #
            # Calculate the accuracy / error
            error[i] = get_error(i, mesh, Aout)
            ctime[i] = (finish - start) / 1e9
            #
            # Increase the counter
            @printf("Accuracy: %16.12f\n", error[i])
            nsucc = nsucc + 1
        catch ex
            error[i] = 0.0
            ctime[i] = 0.0
            nfail = nfail + 1
            println("something wrong for test case $i")
        end
        #
        println()
    end

    @assert nfail + nsucc == ntest
    println("Only $nsucc / $ntest tests can survive!")
    println()

    # Write summary for the test
    write_summary(error, ctime)
end

welcome()
overview()
read_param()
make_test()
goodbye()
