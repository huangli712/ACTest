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

using CairoMakie
using ACTest

function read_Aout(ind::I64)

end

function read_image(ind::I64)

end

function make_plot(ind::I64, sf1::SpectralFunction, sf2::SpectralFunction)
    
end

welcome()
overview()
read_param()
goodbye()
