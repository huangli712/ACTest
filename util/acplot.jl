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

welcome()
overview()
read_param()
goodbye()
