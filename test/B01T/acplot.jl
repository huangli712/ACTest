#!/usr/bin/env julia

#
# This script is used to visualize the true spectral functions and
# the calculated spectral functions. The latters are generated by using
# the analytic continuation tools, such as the ACFlow toolkit. This script
# will launch only 1 process.
#
# By default, this script will visualize the calculated results for all
# the tests. But you can also visualize those results for the tests that
# you are interested in. To do so, please change `make_figures()` in line
# 342 to `make_figures(ind)` or `make_figures(inds)`. Here, `ind` and
# `inds` denote an I64 number and a vector of I64 numbers, respectively.
# They are the indices of the tests that you want to visualize.
#
# This script requires the CairoMakie.jl package to generate the figures.
#
# Usage:
#
#     $ acplot.jl act.toml
#
push!(LOAD_PATH,"/Users/lihuang/Working/devel/ACTest/src")
using ACTest

using DelimitedFiles
using CairoMakie
using Printf

"""
    read_image(ind::I64, std::Bool)

Read true spectral functions from `image.data.i`. This function will
return a SpectralFunction struct.

### Arguments
* ind -> Index of selected spectral function.
* std -> Is it for standard dataset ACT100?

### Returns
See above explanations.
"""
function read_image(ind::I64, std::Bool)
    # Get essential parameters
    solver = get_t("solver")
    ktype = get_t("ktype")

    # Now we are handling the ACT100 dataset, so ktype might be not
    # compatible with the `act.toml`.
    if std
        ACT100 = union(STD_FG, STD_FD, STD_FRD, STD_BG, STD_BD, STD_BRD)
        ktype = ACT100[ind]["ktype"]
    end

    fn = "image.data." * string(ind)
    #
    if isfile(fn)
        data = readdlm(fn)
        ω = data[:,1]
        image = data[:,2]
        #
        # For bosonic systems, ACTest will always output A(ω) / ω.
        # In order to be compatible with the outputs from some solvers in
        # the ACFlow and MiniPole toolkits, we have to convert it to A(ω).
        if ktype != "fermi"
            if solver in ("BarRat", "StochPX", "MiniPole")
                @. image = image * ω
            end
            # For solvers in ("MaxEnt", "StochAC", "StochSK", "StochOM"),
            # they output A(ω) / ω for bosonic systems. So we don't need
            # to convert the output of ACTest to A(ω).
        end
        #
        return SpectralFunction(DynamicMesh(ω), image)
    else
        error("File $fn does not exits!")
    end
end

"""
    read_Aout(ind::I64)

Read calculated spectral functions from `Aout.data.i`. This function
will return a SpectralFunction struct.

### Arguments
* ind -> Index of selected spectral function.

### Returns
See above explanations.
"""
function read_Aout(ind::I64)
    fn = "Aout.data." * string(ind)
    #
    if isfile(fn)
        data = readdlm(fn)
        ω = data[:,1]
        image = data[:,2]
        #
        # We should check the spectral function data further
        if any(x -> abs(x) > 100.0, image)
            error("The data in $fn is quite strange.")
        end
        #
        return SpectralFunction(DynamicMesh(ω), image)
    else
        error("File $fn does not exits!")
    end
end

"""
    make_plot(
        ind::I64,
        sf1::SpectralFunction,
        sf2::Union{SpectralFunction, Nothing} = nothing
    )

Draw the true and calculated spectral functions in the same figure. The
`CairoMakie.jl` package is employed to do this job. The figure file is
just `image.i.pdf`.

If `sf2` is nothing, then this function will only plot the true spectral
function (`sf1`).

### Arguments
* ind -> Index of selected spectral function.
* sf1 -> True spectral function.
* sf2 -> Calculated spectral function.

### Returns
See above explanations.
"""
function make_plot(
    ind::I64,
    sf1::SpectralFunction,
    sf2::Union{SpectralFunction, Nothing} = nothing
    )
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
        color = isnothing(sf2) ? :crimson : :tomato,
        linestyle = isnothing(sf2) ? :solid : :dash,
        label = "True",
    )
    #
    # Draw calculated spectral functions
    if !isnothing(sf2)
        lines!(
            ax,
            sf2.mesh.mesh,
            sf2.image,
            color = :crimson,
            linestyle = :solid,
            label = get_t("solver"),
        )
    end
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

"""
    make_figures(
        std::Bool = false,
        only_true_spectrum::Bool = false,
        inds::Vector{I64} = I64[]
    )

Try to generate figures for selected spectra. With this function, you can
only visualize calculated spectra for a subset of tests.

If only_true_spectrum is true, only true spectral functions will be plotted.

### Arguments
* std -> Is it for standard dataset ACT100?
* only_true_spectrum -> Whether only the true spectra will be plotted.
* inds -> Indices of selected spectra.

### Returns
N/A
"""
function make_figures(
    std::Bool = false,
    only_true_spectrum::Bool = false,
    inds::Vector{I64}
    )
    @show std, only_true_spectrum, inds
    # Get number of tests (ntest).
    # cinds is used to store the indices of tests.
    ntest = get_t("ntest")
    if isempty(inds)
        cinds = collect(1:ntest)
    else
        cinds = inds
    end

    # Start the loop
    for i in cinds
        @printf("Test -> %4i / %4i\n", i, ntest)
        #
        try
            sf1 = read_image(i, std)
            if only_true_spectrum
                make_plot(i, sf1)
            else
                sf2 = read_Aout(i)
                make_plot(i, sf1, sf2)
            end
        catch ex
            println("Something wrong for test case $i")
            println(ex.msg)
        end
        #
        println()
    end
end

# Entry of this script. It will parse the command line arguments and call
# the corresponding functions.
function main()
    nargs = length(ARGS)

    # Besides the case.toml, no arguments.
    #
    # $ acplot.jl act.toml
    if nargs == 1
        make_figures()
    end

    # Two arguments. Besides the case.toml, we can specify whether the
    # ACT100 dataset is used.
    #
    # $ acplot.jl act.toml std=true
    if nargs == 2
        std = parse(Bool, split(ARGS[2],"=")[2])
        make_figures(std)
    end

    # $ acplot.jl act.toml std=true only=true
    if nargs == 3
        std = parse(Bool, split(ARGS[2],"=")[2])
        only = parse(Bool, split(ARGS[3],"=")[2])
        make_figures(std, only)
    end

    # Three arguments. We can specify whether the ACT100 dataset is used,
    # and the indices of selected tests.
    #
    # $ acplot.jl act.toml std=true inds=[11,12,13]
    # $ acplot.jl act.toml std=true inds=11:13
    if nargs == 4
        std = parse(Bool, split(ARGS[2],"=")[2])
        only = parse(Bool, split(ARGS[3],"=")[2])
        str = split(ARGS[4],"=")[2]
        if contains(str, ",")
            inds = parse.(Int, split(chop(str; head=1, tail=1), ','))
        else
            arr = parse.(Int, split(str, ':'))
            inds = collect(arr[1]:arr[2])
        end
        make_figures(std, only, inds)
    end
end

welcome()
overview()
read_param()
main()
goodbye()
