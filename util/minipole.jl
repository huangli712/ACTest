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
#using ACFlow:setup_param
using ACFlow:read_data
using ACFlow:solve

using PyCall
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
        # For the following solvers, their outputs (`Aout`) are A(ω) / ω
        # as well. We have to convert them to A(ω) too.
        if B["solver"] in ("MaxEnt", "StochAC", "StochSK", "StochOM")
            @. Aout = Aout * mesh
        end
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

# Perform analytic continuation simulations using the ACFlow toolkit.
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
    #@show S

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
        py"setup_param"(B, S)
        #py"get_param"()
        #exit()
        #
        try
            # Solve the analytic continuation problem.
            # The elapsed time is recorded as well.
            start = time_ns()
            mesh, Aout = py"solve_me"()
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

function python_functions()
    py"""
    import sys
    import numpy as np
    #from mini_pole import GreenFunc
    #from mini_pole.spectrum_example import *
    from mini_pole import MiniPole
    
    _S = None
    _B = None
    #def test_mini_pole():
    #    beta = 100
    #    n_w = 500
    #    n_orb = 1
    #    A_f_diag = lambda x: 0.25 * gaussian(x, mu=-1.5, sigma=0.5) + 0.5 * gaussian(x, mu=0, sigma=0.5) + 0.25 * gaussian(x, mu=1.5, sigma=0.5)
    #    gf_f1 = GreenFunc("F", beta, "continuous", A_x=A_f_diag   , x_min=-np.inf, x_max=np.inf)
    #    gf_f1.get_matsubara(n_w)
    #    w = gf_f1.w
    #    p = MiniPole(gf_f1.G_w, w, err=1.e-2)
    #    #print(p.pole_location)
    #    #print(np.shape(p.pole_location))
    #    #print(p.pole_weight)
    #    #print(np.shape(p.pole_weight))
    #    return p.pole_location, p.pole_weight[:,0,0]

    def cal_G_scalar(z, Al, xl):
        G_z = 0.0
        for i in range(xl.size):
            G_z += Al[i] / (z - xl[i])
        return G_z

    def cal_G_vector(z, Al, xl):
        G_z = 0.0
        for i in range(xl.size):
            G_z += Al[[i]] / (z.reshape(-1, 1) - xl[i])
        return G_z

    def setup_param(B, S):
        global _B
        _B = B
        global _S
        _S = S
    
    def get_param():
        print(_B)
        print(_S)
    
    def read_data():
        w, gre, gim = np.loadtxt(_B["finput"], unpack = True, usecols = (0,1,2) )
        #print(w)
        gw = gre + gim * 1j
        #print(gw)
        return w, gw
    
    def solve_me():
        w, gw = read_data()
        p = MiniPole(gw, w, err = 1e-2)
        #print(np.shape(p.pole_weight.reshape(-1, 1 ** 2)))
        #print(np.shape(p.pole_location))
        x = np.linspace(_B["wmin"], _B["wmax"], _B["nmesh"])
        #print(x.size)
        #print("dfdf")
        Gr = cal_G_vector(x, p.pole_weight.reshape(-1, 1 ** 2), p.pole_location).reshape(-1, 1, 1)
        #print("dfdf")
        #print(Gr)
        Aout = -1.0 / np.pi * Gr[:, 0, 0].imag
        #print(x.size)
        #print(Aout.size)
        with open("Aout.data", "w") as f:
            for i in range(x.size):
                print(i, x[i], Aout[i], file = f)
        #sys.exit(-1)
        return x, Aout
    """
end

python_functions()
welcome()
overview()
read_param()
make_test()
goodbye()