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
    f = Figure()
    #
    ax = Axis(f[1, 1],
        title = L"x^2",
        xlabel = L"\omega",
        ylabel = L"A(\omega)",
    )
    #
    lines!(
        ax,
        sf1.mesh.mesh,
        sf1.image,
        color = :tomato,
        linestyle = :dash,
        label = "True",
    )
    #
    lines!(
        ax,
        sf2.mesh.mesh,
        sf2.image,
        color = :crimson,
        linestyle = :solid,
        label = "Calc.",
    )
    #
    axislegend(position = :rb)
    #
    fn = "image." * string(ind) * ".pdf"
    save(fn, f)
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
            sf2 = read_Aout(i)
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
