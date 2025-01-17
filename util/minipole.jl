#!/usr/bin/env julia

push!(LOAD_PATH,"/Users/lihuang/Working/devel/ACTest/src")

using PyCall
using ACTest
using Printf
using DelimitedFiles

function __init__()
    py"""
    import numpy as np

    def hello_world(s):
        return s + " hello world!"
    """
end

__init__()
println(py"hello_world"("Li Huang"))
