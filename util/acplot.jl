#!/usr/bin/env julia

#
# This script is used to visualize the true spectral functions and
# the calculated spectral functions. The latters are obtained by using
# the analytic continuation tools, such as the ACFlow toolkit. This
# will launch only 1 process.
#
# This script requires the CairoMakie.jl package.
#
# Usage:
#
#     $ acplot.jl act.toml
#
push!(LOAD_PATH, "/Users/lihuang/Working/devel/ACTest/src/")

using ACTest

using DelimitedFiles
using CairoMakie
using Printf

function read_image(ind::I64)
    fn = "image.data." * string(ind)
    #
    if isfile(fn)
        data = readdlm(fn)
        ω = data[:,1]
        image = data[:,2]
        return SpectralFunction(DynamicMesh(ω), image)
    else
        error("File $fn does not exits!")
    end
end

function read_Aout(ind::I64)
    fn = "Aout.data." * string(ind)
    #
    if isfile(fn)
        data = readdlm(fn)
        ω = data[:,1]
        image = data[:,2]
        return SpectralFunction(DynamicMesh(ω), image)
    else
        error("File $fn does not exits!")
    end
end

function make_plot(ind::I64, sf1::SpectralFunction, sf2::SpectralFunction)
    error("plot")
end

function make_figures()
    ntest = get_t("ntest")
    @show ntest

    # Start the loop
    for i = 1:ntest
        @printf("Test -> %4i / %4i\n", i, ntest)
        #
        try
            sf1 = read_image(i)
            println("sf1 is ready")
            sf2 = read_Aout(i)
            println("sf2 is ready")
            make_plot(i, sf1, sf2)        
        catch ex
            println("Something wrong for test case $i")
        end
        #
        println()
    end
end

welcome()
overview()
read_param()
make_figures()
goodbye()
