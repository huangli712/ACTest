#!/usr/bin/env julia

#
# 1. install MiniPole
#    python setup.py install
#
# 2. install PyCall.jl
#
# 3. setup PyCall.jl
#    ENV["PYTHON"] =
#    Pkg.build("PyCall")
#

push!(LOAD_PATH,"/Users/lihuang/Working/devel/ACFlow/src")
push!(LOAD_PATH,"/Users/lihuang/Working/devel/ACTest/src")

using ACTest

using PyCall
using Printf
using DelimitedFiles

# Prepare configurations for the MiniPole toolkit
function get_dict()
    # General setup
    B = Dict{String,Any}(
        "finput" => "green.data",
        "ktype"  => get_t("ktype"),
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

# Fix configuration dynamically. This is essential for standard test.
# Note that for standard test, the correlation functions could be
# fermionic or bosonic, diagonal or non-diagonal. We have to make sure
# the configurations are consistent with the original setups.
function fix_dict!(i::I64, B::Dict{String,Any})
    # Get dicts for the standard test (ACT100)
    ACT100 = union(STD_FG, STD_FD, STD_FRD, STD_BG, STD_BD, STD_BRD)

    # We have to make sure ntest == 100
    ntest = get_t("ntest")
    @assert ntest == length(ACT100) == 100

    # Fix ktype, grid, and mesh
    B["ktype"] = ACT100[i]["ktype"]
    B["grid"] = ACT100[i]["grid"]
    B["mesh"] = ACT100[i]["mesh"]
    B["offdiag"] = ACT100[i]["offdiag"]
end

# Evaluate error for the current test. It just calculates the distance
# between the true and calculated spectral function.
function get_error(
    i::I64,
    mesh::Vector{F64},
    Aout::Vector{F64},
    B::Dict{String,Any}
    )
    # Read true solution
    data = readdlm("image.data." * string(i))
    ω = data[:,1]
    Ainp = data[:,2]

    # If there is a bosonic system, Ainp is actually A(ω) / ω. We should
    # convert it to A(ω).
    if B["ktype"] != "fermi"
        @. Ainp = Ainp * ω
    end

    # Calculate the difference
    error = trapz(mesh, abs.(Ainp .- Aout)) / trapz(mesh, abs.(Ainp))

    # Sometimes Aout could be extremely high δ-like peaks. We have to
    # take care of these cases.
    if error > 1000.0
        error = Inf
    end

    return error
end

# Write summary for the tests to external file `summary.data`
function write_summary(
    inds::Vector{I64},
    error::Vector{F64},
    ctime::Vector{F64}
    )
    # Get number of tests
    ntest = length(inds)

    open("summary.data", "a") do fout
        println(fout, "# index            error         time (s) passed")
        #
        for i in inds
            @printf(fout, "%7i %16.12f %16.12f", i, error[i], ctime[i])
            if error[i] == 0.0
                @printf(fout, "%7s\n", "false")
            else
                @printf(fout, "%7s\n", "true")
            end
        end
        #
        println(fout, "# Number of tests: ", ntest)
        println(fout, "# Failed tests: ", count(x -> iszero(x), error[inds]))
        println(fout, "# Abnormal tests: ", count(x -> isinf(x), error[inds]))
    end
end

# Perform analytic continuation simulations using the MiniPole toolkit.
# if `std` is true, then the ACT100 dataset is considered.
# if `inds` is not empty, then only the selected tests are handled.
function make_test(std::Bool = false, inds::Vector{I64} = I64[])
    # Get number of tests (ntest).
    # cinds is used to store the indices of tests.
    ntest = get_t("ntest")
    if isempty(inds)
        cinds = collect(1:ntest)
    else
        cinds = inds
    end

    # Prepare some counters and essential variables
    nfail = 0
    nsucc = 0
    error = zeros(F64, ntest)
    ctime = zeros(F64, ntest)

    # Prepare configurations
    B, S = get_dict()

    # Start the loop
    for i in cinds
        @printf("Test -> %4i / %4i\n", i, ntest)
        #
        # Setup configurations further for the current test
        B["finput"] = "green.data." * string(i)
        # If we want to perform standard test, we have to change `ktype`
        # and `grid` parameters dynamically.
        if std == true
            println("Note: the act100 dataset is being used!")
            fix_dict!(i, B)
        end
        mesh = make_mesh(B["ktype"])
        py"setup_param"(B, S, mesh.mesh)
        #
        try
            # Solve the analytic continuation problem.
            # The elapsed time is recorded as well.
            start = time_ns()
            mesh, Aout = py"solve"()
            #exit()
            #mesh, Aout, _ = solve(read_data())
            finish = time_ns()
            #
            # Backup the calculated results for further analytics
            cp("Aout.data", "Aout.data." * string(i), force = true)
            #cp("Gout.data", "Gout.data." * string(i), force = true)
            #cp("repr.data", "repr.data." * string(i), force = true)
            #
            # Calculate the accuracy / error
            error[i] = get_error(i, mesh, Aout, B)
            ctime[i] = (finish - start) / 1e9
            #
            # Increase the counter
            @printf("Accuracy: %16.12f\n", error[i])
            nsucc = nsucc + 1
        catch ex
            error[i] = 0.0
            ctime[i] = 0.0
            nfail = nfail + 1
            println("Something wrong for test case $i")
        end
        #
        println()
    end

    @assert nfail + nsucc == length(cinds)
    println("Only $nsucc / $(length(cinds)) tests can survive!")
    println("Please check summary.data for more details.")
    println()

    # Write summary for the test
    write_summary(cinds, error, ctime)
end

function python()
    py"""
    import numpy as np
    from mini_pole import MiniPole

    _B = None
    _ω = None
    #
    _P = {
        'n0' : "auto",
        'n0_shift' : 0,
        'err' : None,
        'err_type' : "abs",
        'M' : None,
        'symmetry' : False,
        'G_symmetric' : False,
        'compute_const' : False,
        'plane' : None,
        'include_n0' : False,
        'k_max' : 999,
        'ratio_max' : 10
    }

    def setup_param(B, S, ω):
        global _B
        _B = B
        #
        global _ω
        _ω = ω
        #
        global _P
        for k in S.keys():
            if k not in _P:
                print("error: this parameter " + k + " is not supported")
                import sys
                sys.exit(-1)
            else:
                _P[k] = S[k]

    def read_data():
        iωₙ, Gᵣ, Gᵢ = np.loadtxt(
            _B["finput"],
            unpack = True,
            usecols = (0,1,2)
        )
        G = Gᵣ + Gᵢ * 1j
        return iωₙ, G

    def write_data():
        with open("Aout.data", "w") as f:
            for i in range(_ω.size):
                print(i, _ω[i], Aout[i], file = f)

    def calc_green(z, 𝔸, 𝕏):
        Gz = 0.0
        for i in range(𝕏.size):
            Gz += 𝔸[i] / (z - 𝕏[i])
        return Gz

    def calc_spectrum(G):
        return -1.0 / np.pi * G.imag

    def solve():
        iωₙ, G = read_data()
        #
        p = MiniPole(
            G, iωₙ, 
            n0 = _P["n0"],
            n0_shift = _P["n0_shift"],
            err = _P["err"],
            err_type = _P["err_type"],
            M = _P["M"],
            symmetry = _P["symmetry"],
            G_symmetric = _P["G_symmetric"],
            compute_const = _P["compute_const"],
            plane = _P["plane"],
            include_n0 = _P["include_n0"],
            k_max = _P["k_max"],
            ratio_max = _P["ratio_max"]
        )
        #
        location = p.pole_location
        weight = p.pole_weight.reshape(-1)
        Gout = calc_green(_ω, weight, location)
        Grepr = calc_green(iωₙ, weight, location)
        Aout = calc_spectrum(Gout)
        return _ω, Aout
    """
end

python()
welcome()
overview()
read_param()
make_test()
goodbye()
