#!/usr/bin/env julia

#
# 1. install MiniPole
#    python setup.py install
#
# 2. install PyCall.jl
#
# 3. setup PyCall.jl
#    ENV["PYTHON"] = 
#    Pkg.build("PyCall")
#

push!(LOAD_PATH,"/Users/lihuang/Working/devel/ACTest/src")

#using ACTest

using PyCall
using Printf
using DelimitedFiles

function python_functions()
    py"""
    import numpy as np
    from mini_pole import GreenFunc
    from mini_pole.spectrum_example import *
    from mini_pole import MiniPole
    
    def test_mini_pole():
        beta = 100
        n_w = 500
        n_orb = 1
        A_f_diag = lambda x: 0.25 * gaussian(x, mu=-1.5, sigma=0.5) + 0.5 * gaussian(x, mu=0, sigma=0.5) + 0.25 * gaussian(x, mu=1.5, sigma=0.5)
        gf_f1 = GreenFunc("F", beta, "continuous", A_x=A_f_diag   , x_min=-np.inf, x_max=np.inf)
        gf_f1.get_matsubara(n_w)
        w = gf_f1.w
        p = MiniPole(gf_f1.G_w, w, err=1.e-2)
        #print(p.pole_location)
        #print(np.shape(p.pole_location))
        #print(p.pole_weight)
        #print(np.shape(p.pole_weight))
        return p.pole_location, p.pole_weight[:,0,0]
    
    def try_pole():
        return "hhh"
    """
end

#pole = pyimport("numpy")
#python_functions()
#println(py"hello_world"("Li Huang"))
#location, weight = py"test_mini_pole"()
#@show location
#@show weight
#py"test_struct"(Dict("A"=>1, "B"=>2))
