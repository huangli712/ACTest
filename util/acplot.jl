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
        # We should check the spectral function data further
        if any(x -> abs(x) > 100.0, image)
            error("The data in $fn is quite strange.")
        end
        return SpectralFunction(DynamicMesh(ω), image)
    else
        error("File $fn does not exits!")
    end
end

# Draw the true and calculated spectral functions in the same figure. The
# `CairoMakie.jl` package is employed to do this job. The figure file is
# just `image.i.pdf`.
function make_plot(ind::I64, sf1::SpectralFunction, sf2::SpectralFunction)
    # Get boundary for the x-axis
    wmin = get_t("wmin")
    wmax = get_t("wmax")

    # Try to draw the spectral functions
    #
    # Create a Figure
    f = Figure()
    #
    # Setup the axis
    ax = Axis(f[1, 1],
        xlabel = L"\omega",        # Setup x-label and y-label
        ylabel = L"A(\omega)",     #
        xgridvisible = false,      # Disable the grid
        ygridvisible = false,      #
        xminorticksvisible = true, # Enable minor ticks
        yminorticksvisible = true, #
        xticksmirrored = true,     # Enable mirrored ticks
        yticksmirrored = true,     #
        xtickalign = 1.0,          # Setup directions of ticks, in = 1
        ytickalign = 1.0,          #
        xminortickalign = 1.0,     # Setup directions of minor ticks, out = 0
        yminortickalign = 1.0,     #
    )
    #
    # Draw true spectral functions
    lines!(
        ax,
        sf1.mesh.mesh,
        sf1.image,
        color = :tomato,
        linestyle = :dash,
        label = "True",
    )
    #
    # Draw calculated spectral functions
    lines!(
        ax,
        sf2.mesh.mesh,
        sf2.image,
        color = :crimson,
        linestyle = :solid,
        label = "Calc.",
    )
    #
    # Get y-limits
    reset_limits!(ax)
    ymin, ymax = ax.yaxis.attributes.limits[]
    #
    # Setup x-limits and y-limits, legend.
    xlims!(ax, wmin, wmax)
    ylims!(ax, ymin, ymax)
    axislegend(position = :rt)
    #
    # Draw the Fermi level
    lines!(
        ax,
        [0.0,0.0],
        [ymin,ymax],
        color = :black,
        linestyle = :dash,
    )
    #
    # Save the figure
    fn = "image." * string(ind) * ".pdf"
    save(fn, f)
    println("File $fn is generated successfully.")
end

# Try to generate all the figures, in which the true and calculated
# spectral functions are compared with each other.
function make_figures()
    # Get number of tests
    ntest = get_t("ntest")

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
            println(ex.msg)
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
