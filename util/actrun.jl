#!/usr/bin/env julia
  
#
# This script is used to start analytic continuation simulations.
# It will launch only 1 process.
#
# Usage:
#
#     $ actrun.jl act.toml
#

push!(LOAD_PATH, "../src")

using ACTest

welcome()
overview()
read_param()
