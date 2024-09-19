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

# Read true spectral functions from `image.data.i`. This function will
# return a SpectralFunction struct.
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

# Read calculated spectral functions from `Aout.data.i`. This function
# will return a SpectralFunction struct.
function read_Aout(ind::I64)
    fn = "Aout.data." * string(ind)
    #
    if isfile(fn)
        data = readdlm(fn)
        ω = data[:,1]
        image = data[:,2]
        if any(x -> abs(x) > 100.0, image)
            error("The data in $fn is quite strange.")
        end
        return SpectralFunction(DynamicMesh(ω), image)
    else
        error("File $fn does not exits!")
    end
end

function make_plot(ind::I64, sf1::SpectralFunction, sf2::SpectralFunction)
    wmin = get_t("wmin")
    wmax = get_t("wmax")

    f = Figure()
    #
    ax = Axis(f[1, 1],
        xlabel = L"\omega",
        ylabel = L"A(\omega)",
        xgridvisible = false,
        ygridvisible = false,
        xminorticksvisible = true,
        yminorticksvisible = true,
        xticksmirrored = true,
        yticksmirrored = true,
        xtickalign = 1.0,
        ytickalign = 1.0,
        xminortickalign = 1.0,
        yminortickalign = 1.0,
    )
    #
    lines!(
        ax,
        sf1.mesh.mesh,
        sf1.image,
        color = :lawngreen,
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
    reset_limits!(ax)
    ymin, ymax = ax.yaxis.attributes.limits[]
    xlims!(ax, wmin, wmax)
    ylims!(ax, ymin, ymax)
    axislegend(position = :rt)
    #
    lines!(
        ax,
        [0.0,0.0],
        [ymin,ymax],
        color = :black,
        linestyle = :dash,
    )
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
        #try
            sf1 = read_image(i)
            sf2 = read_Aout(i)
            make_plot(i, sf1, sf2)
        #catch ex
            #println("Something wrong for test case $i")
        #end
        #
        println()
    end
end

welcome()
overview()
read_param()
make_figures()
goodbye()
