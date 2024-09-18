#
# Project : Lily
# Source  : dataset.jl
# Author  : Li Huang (huangli@caep.cn)
# Status  : Unstable
#
# Last modified: 2024/09/18
#

const STANDARD = Dict{String,Any}[
    # Test: 001 / Fermionic + Gaussian Peaks
    # single peak, central
    Dict(
        "ktype" => "fermi",
        "grid"  => "ffreq",
        "mesh"  => "linear",
        "peaks" => [
            GaussianPeak(1.0,0.8,0.0)
        ],
        "signs" => [1.0]
    ),
    #
    # Test: 002 / Fermionic + Gaussian Peaks
    # single peak, off-centered (left)
    Dict(
        "ktype" => "fermi",
        "grid"  => "ffreq",
        "mesh"  => "linear",
        "peaks" => [
            GaussianPeak(1.0,0.8,-2.0)
        ],
        "signs" => [1.0]
    ),
    #
    # Test: 003 / Fermionic + Gaussian Peaks
    # single peak, off-centered (right)
    Dict(
        "ktype" => "fermi",
        "grid"  => "ffreq",
        "mesh"  => "linear",
        "peaks" => [
            GaussianPeak(1.0,0.8,2.0)
        ],
        "signs" => [1.0]
    ),
    #
    # Test: 004 / Fermionic + Gaussian Peaks
    # two peaks, gapless
    Dict(
        "ktype" => "fermi",
        "grid"  => "ffreq",
        "mesh"  => "linear",
        "peaks" => [
            GaussianPeak(1.0,0.5,-0.8),
            GaussianPeak(1.0,0.5,0.8)
        ],
        "signs" => [1.0,1.0]
    ),
    #
    # Test: 005 / Fermionic + Gaussian Peaks
    # two peaks, small gap
    Dict(
        "ktype" => "fermi",
        "grid"  => "ffreq",
        "mesh"  => "linear",
        "peaks" => [
            GaussianPeak(1.0,0.5,-1.8),
            GaussianPeak(1.0,0.5,1.8)
        ],
        "signs" => [1.0,1.0]
    ),
    #
    # Test: 006 / Fermionic + Gaussian Peaks
    # two peaks, large gap
    Dict(
        "ktype" => "fermi",
        "grid"  => "ffreq",
        "mesh"  => "linear",
        "peaks" => [
            GaussianPeak(1.0,0.5,-3.0),
            GaussianPeak(1.0,0.5,3.0)
        ],
        "signs" => [1.0,1.0]
    ),
    #
    # Test: 007 / Fermionic + Gaussian Peaks
    # two peaks, central + off-centered (left)
    Dict(
        "ktype" => "fermi",
        "grid"  => "ffreq",
        "mesh"  => "linear",
        "peaks" => [
            GaussianPeak(1.0,0.4,0.0),
            GaussianPeak(1.0,0.4,-3.0)
        ],
        "signs" => [1.0,1.0]
    ),
    #
    # Test: 008 / Fermionic + Gaussian Peaks
    # two peaks, central + off-centered (right)
    Dict(
        "ktype" => "fermi",
        "grid"  => "ffreq",
        "mesh"  => "linear",
        "peaks" => [
            GaussianPeak(1.0,0.4,0.0),
            GaussianPeak(1.0,0.4,3.0)
        ],
        "signs" => [1.0,1.0]
    ),
    #
    # Test: 009 / Fermionic + Gaussian Peaks
    # two peaks, off-centered (left small + right big)
    Dict(
        "ktype" => "fermi",
        "grid"  => "ffreq",
        "mesh"  => "linear",
        "peaks" => [
            GaussianPeak(0.5,0.5,-3.0),
            GaussianPeak(1.5,0.5,3.0)
        ],
        "signs" => [1.0,1.0]
    ),
    #
    # Test: 010 / Fermionic + Gaussian Peaks
    # two peaks, off-centered (left big + right small)
    Dict(
        "ktype" => "fermi",
        "grid"  => "ffreq",
        "mesh"  => "linear",
        "peaks" => [
            GaussianPeak(1.5,0.5,-3.0),
            GaussianPeak(0.5,0.5,3.0)
        ],
        "signs" => [1.0,1.0]
    ),
    #
    # Test: 011 / Fermionic + Gaussian Peaks
    # three peaks, gapless
    Dict(
        "ktype" => "fermi",
        "grid"  => "ffreq",
        "mesh"  => "linear",
        "peaks" => [
            GaussianPeak(1.0,0.1,0.0),
            GaussianPeak(0.5,1.0,-1.0),
            GaussianPeak(0.5,1.0,1.0)
        ],
        "signs" => [1.0,1.0,1.0]
    ),
    #
    # Test: 012 / Fermionic + Gaussian Peaks
    # three peaks, gapless
    Dict(
        "ktype" => "fermi",
        "grid"  => "ffreq",
        "mesh"  => "linear",
        "peaks" => [
            GaussianPeak(1.0,0.1,0.0),
            GaussianPeak(0.5,1.0,-2.0),
            GaussianPeak(0.5,1.0,2.0)
        ],
        "signs" => [1.0,1.0,1.0]
    ),
    #
    # Test: 013 / Fermionic + Gaussian Peaks
    # three peaks, gapless
    Dict(
        "ktype" => "fermi",
        "grid"  => "ffreq",
        "mesh"  => "linear",
        "peaks" => [
            GaussianPeak(1.0,0.05,0.0),
            GaussianPeak(0.5,1.0,-3.0),
            GaussianPeak(0.5,1.0,3.0)
        ],
        "signs" => [1.0,1.0,1.0]
    ),
    #
    # Test: 014 / Fermionic + Gaussian Peaks
    # three peaks, gapless
    Dict(
        "ktype" => "fermi",
        "grid"  => "ffreq",
        "mesh"  => "linear",
        "peaks" => [
            GaussianPeak(1.0,0.05,0.0),
            GaussianPeak(0.4,0.5,-3.5),
            GaussianPeak(0.4,0.5,3.5)
        ],
        "signs" => [1.0,1.0,1.0]
    ),
    #
    # Test: 015 / Fermionic + Gaussian Peaks
    # three peaks, large gap
    Dict(
        "ktype" => "fermi",
        "grid"  => "ffreq",
        "mesh"  => "linear",
        "peaks" => [
            GaussianPeak(1.0,0.05,-1.0),
            GaussianPeak(0.4,0.8,-3.0),
            GaussianPeak(0.4,0.8,3.0)
        ],
        "signs" => [1.0,1.0,1.0]
    ),
    #
    # Test: 016 / Fermionic + Gaussian Peaks
    # three peaks, large gap
    Dict(
        "ktype" => "fermi",
        "grid"  => "ffreq",
        "mesh"  => "linear",
        "peaks" => [
            GaussianPeak(1.0,0.05,1.0),
            GaussianPeak(0.4,0.8,-3.0),
            GaussianPeak(0.4,0.8,3.0)
        ],
        "signs" => [1.0,1.0,1.0]
    ),
    #
    # Test: 017 / Fermionic + Gaussian Peaks
    # three peaks, gapless, left
    Dict(
        "ktype" => "fermi",
        "grid"  => "ffreq",
        "mesh"  => "linear",
        "peaks" => [
            GaussianPeak(1.0,0.2,0.0),
            GaussianPeak(0.6,0.6,-1.0),
            GaussianPeak(0.6,0.6,-3.0)
        ],
        "signs" => [1.0,1.0,1.0]
    ),
    #
    # Test: 018 / Fermionic + Gaussian Peaks
    # three peaks, gapless, right
    Dict(
        "ktype" => "fermi",
        "grid"  => "ffreq",
        "mesh"  => "linear",
        "peaks" => [
            GaussianPeak(1.0,0.2,0.0),
            GaussianPeak(0.6,0.6,1.0),
            GaussianPeak(0.6,0.6,3.0)
        ],
        "signs" => [1.0,1.0,1.0]
    ),
    #
    # Test: 019 / Fermionic + Gaussian Peaks
    # three peaks, gapless, left small, right big
    Dict(
        "ktype" => "fermi",
        "grid"  => "ffreq",
        "mesh"  => "linear",
        "peaks" => [
            GaussianPeak(1.0,0.2,0.0),
            GaussianPeak(0.1,0.4,-2.0),
            GaussianPeak(0.6,1.0,2.0)
        ],
        "signs" => [1.0,1.0,1.0]
    ),
    #
    # Test: 020 / Fermionic + Gaussian Peaks
    # three peaks, gapless, left big, right small
    Dict(
        "ktype" => "fermi",
        "grid"  => "ffreq",
        "mesh"  => "linear",
        "peaks" => [
            GaussianPeak(1.0,0.2,0.0),
            GaussianPeak(0.1,0.4,2.0),
            GaussianPeak(0.6,1.0,-2.0)
        ],
        "signs" => [1.0,1.0,1.0]
    ),
]
