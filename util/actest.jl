#!/usr/bin/env julia
  
#
# This script is used to start analytic continuation simulations.
# It will launch only 1 process.
#
# Usage:
#
#     $ actest.jl act.toml
#

push!(LOAD_PATH, "../src")
push!(LOAD_PATH, "/Users/lihuang/Working/devel/ACFlow/src/")

using ACTest

welcome()
overview()
read_param()
make_test()
goodbye()
