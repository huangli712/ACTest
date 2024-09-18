#
# Project : Lily
# Source  : dataset.jl
# Author  : Li Huang (huangli@caep.cn)
# Status  : Unstable
#
# Last modified: 2024/09/18
#

const STD_FG = Dict{String,Any}[
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
            GaussianPeak(0.1,0.8,-3.0),
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
            GaussianPeak(0.1,0.8,3.0)
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

const STD_FD = Dict{String,Any}[
    # Test: 001 / Fermionic + Delta Peaks
    # single peak, central
    Dict(
        "ktype" => "fermi",
        "grid"  => "ffreq",
        "mesh"  => "linear",
        "peaks" => [
            DeltaPeak(1.0,0.02,0.0)
        ],
        "signs" => [1.0]
    ),
    #
    # Test: 002 / Fermionic + Delta Peaks
    # single peak, off-centered (left)
    Dict(
        "ktype" => "fermi",
        "grid"  => "ffreq",
        "mesh"  => "linear",
        "peaks" => [
            DeltaPeak(1.0,0.02,-2.0)
        ],
        "signs" => [1.0]
    ),
    #
    # Test: 003 / Fermionic + Delta Peaks
    # single peak, off-centered (right)
    Dict(
        "ktype" => "fermi",
        "grid"  => "ffreq",
        "mesh"  => "linear",
        "peaks" => [
            DeltaPeak(1.0,0.02,2.0)
        ],
        "signs" => [1.0]
    ),
    #
    # Test: 004 / Fermionic + Delta Peaks
    # single peak, off-centered (left)
    Dict(
        "ktype" => "fermi",
        "grid"  => "ffreq",
        "mesh"  => "linear",
        "peaks" => [
            DeltaPeak(1.0,0.02,-4.0)
        ],
        "signs" => [1.0]
    ),
    #
    # Test: 005 / Fermionic + Delta Peaks
    # single peak, off-centered (right)
    Dict(
        "ktype" => "fermi",
        "grid"  => "ffreq",
        "mesh"  => "linear",
        "peaks" => [
            DeltaPeak(1.0,0.02,4.0)
        ],
        "signs" => [1.0]
    ),
    #
    # Test: 006 / Fermionic + Delta Peaks
    # two peaks, off-centered (left + right)
    Dict(
        "ktype" => "fermi",
        "grid"  => "ffreq",
        "mesh"  => "linear",
        "peaks" => [
            DeltaPeak(1.0,0.02,-2.0),
            DeltaPeak(1.0,0.02,2.0)
        ],
        "signs" => [1.0,1.0]
    ),
    #
    # Test: 007 / Fermionic + Delta Peaks
    # two peaks, off-centered (left + left)
    Dict(
        "ktype" => "fermi",
        "grid"  => "ffreq",
        "mesh"  => "linear",
        "peaks" => [
            DeltaPeak(1.0,0.02,-1.0),
            DeltaPeak(1.0,0.02,-3.0)
        ],
        "signs" => [1.0,1.0]
    ),
    #
    # Test: 008 / Fermionic + Delta Peaks
    # two peaks, off-centered (right + right)
    Dict(
        "ktype" => "fermi",
        "grid"  => "ffreq",
        "mesh"  => "linear",
        "peaks" => [
            DeltaPeak(1.0,0.02,1.0),
            DeltaPeak(1.0,0.02,3.0)
        ],
        "signs" => [1.0,1.0]
    ),
    #
    # Test: 009 / Fermionic + Delta Peaks
    # two peaks, off-centered (left near + right far)
    Dict(
        "ktype" => "fermi",
        "grid"  => "ffreq",
        "mesh"  => "linear",
        "peaks" => [
            DeltaPeak(1.0,0.02,-0.5),
            DeltaPeak(1.0,0.02,3.0)
        ],
        "signs" => [1.0,1.0]
    ),
    #
    # Test: 010 / Fermionic + Delta Peaks
    # two peaks, off-centered (left far + right near)
    Dict(
        "ktype" => "fermi",
        "grid"  => "ffreq",
        "mesh"  => "linear",
        "peaks" => [
            DeltaPeak(1.0,0.02,-3.0),
            DeltaPeak(1.0,0.02,0.5)
        ],
        "signs" => [1.0,1.0]
    ),
    #
    # Test: 011 / Fermionic + Delta Peaks
    # three peaks, small distance
    Dict(
        "ktype" => "fermi",
        "grid"  => "ffreq",
        "mesh"  => "linear",
        "peaks" => [
            DeltaPeak(1.0,0.02,0.0),
            DeltaPeak(1.0,0.02,-0.5),
            DeltaPeak(1.0,0.02,0.5)
        ],
        "signs" => [1.0,1.0,1.0]
    ),
    #
    # Test: 012 / Fermionic + Delta Peaks
    # three peaks, large distance
    Dict(
        "ktype" => "fermi",
        "grid"  => "ffreq",
        "mesh"  => "linear",
        "peaks" => [
            DeltaPeak(1.0,0.02,0.0),
            DeltaPeak(1.0,0.02,-3.0),
            DeltaPeak(1.0,0.02,3.0)
        ],
        "signs" => [1.0,1.0,1.0]
    ),
    #
    # Test: 013 / Fermionic + Delta Peaks
    # four peaks, small distance
    Dict(
        "ktype" => "fermi",
        "grid"  => "ffreq",
        "mesh"  => "linear",
        "peaks" => [
            DeltaPeak(1.0,0.02,-1.5),
            DeltaPeak(1.0,0.02,-0.5),
            DeltaPeak(1.0,0.02,0.5),
            DeltaPeak(1.0,0.02,1.5)
        ],
        "signs" => [1.0,1.0,1.0,1.0]
    ),
    #
    # Test: 014 / Fermionic + Delta Peaks
    # four peaks, large distance
    Dict(
        "ktype" => "fermi",
        "grid"  => "ffreq",
        "mesh"  => "linear",
        "peaks" => [
            DeltaPeak(1.0,0.02,-3.0),
            DeltaPeak(1.0,0.02,-0.5),
            DeltaPeak(1.0,0.02,0.5),
            DeltaPeak(1.0,0.02,3.0)
        ],
        "signs" => [1.0,1.0,1.0,1.0]
    ),
    #
    # Test: 015 / Fermionic + Delta Peaks
    # four peaks, large distance
    Dict(
        "ktype" => "fermi",
        "grid"  => "ffreq",
        "mesh"  => "linear",
        "peaks" => [
            DeltaPeak(1.0,0.02,-3.0),
            DeltaPeak(1.0,0.02,-1.0),
            DeltaPeak(1.0,0.02,1.0),
            DeltaPeak(1.0,0.02,3.0)
        ],
        "signs" => [1.0,1.0,1.0,1.0]
    ),
    #
    # Test: 016 / Fermionic + Delta Peaks
    # five peaks, small distance
    Dict(
        "ktype" => "fermi",
        "grid"  => "ffreq",
        "mesh"  => "linear",
        "peaks" => [
            DeltaPeak(1.0,0.02,0.0),
            DeltaPeak(1.0,0.02,-3.0),
            DeltaPeak(1.0,0.02,-2.5),
            DeltaPeak(1.0,0.02,2.5),
            DeltaPeak(1.0,0.02,3.0)
        ],
        "signs" => [1.0,1.0,1.0,1.0,1.0]
    ),
    #
    # Test: 017 / Fermionic + Delta Peaks
    # five peaks, small distance
    Dict(
        "ktype" => "fermi",
        "grid"  => "ffreq",
        "mesh"  => "linear",
        "peaks" => [
            DeltaPeak(1.0,0.02,0.0),
            DeltaPeak(1.0,0.02,-3.0),
            DeltaPeak(1.0,0.02,-0.5),
            DeltaPeak(1.0,0.02,0.5),
            DeltaPeak(1.0,0.02,3.0)
        ],
        "signs" => [1.0,1.0,1.0,1.0,1.0]
    ),
    #
    # Test: 018 / Fermionic + Delta Peaks
    # five peaks, large distance
    Dict(
        "ktype" => "fermi",
        "grid"  => "ffreq",
        "mesh"  => "linear",
        "peaks" => [
            DeltaPeak(1.0,0.02,0.0),
            DeltaPeak(1.0,0.02,-4.0),
            DeltaPeak(1.0,0.02,-2.0),
            DeltaPeak(1.0,0.02,2.0),
            DeltaPeak(1.0,0.02,4.0)
        ],
        "signs" => [1.0,1.0,1.0,1.0,1.0]
    ),
    #
    # Test: 019 / Fermionic + Delta Peaks
    # six peaks, small distance
    Dict(
        "ktype" => "fermi",
        "grid"  => "ffreq",
        "mesh"  => "linear",
        "peaks" => [
            DeltaPeak(1.0,0.02,-4.0),
            DeltaPeak(1.0,0.02,-3.5),
            DeltaPeak(1.0,0.02,-3.0),
            DeltaPeak(1.0,0.02,3.0),
            DeltaPeak(1.0,0.02,3.5),
            DeltaPeak(1.0,0.02,4.0)
        ],
        "signs" => [1.0,1.0,1.0,1.0,1.0,1.0]
    ),
    #
    # Test: 020 / Fermionic + Delta Peaks
    # three peaks, small distance
    Dict(
        "ktype" => "fermi",
        "grid"  => "ffreq",
        "mesh"  => "linear",
        "peaks" => [
            DeltaPeak(1.0,0.02,-4.0),
            DeltaPeak(1.0,0.02,-1.0),
            DeltaPeak(1.0,0.02,-0.5),
            DeltaPeak(1.0,0.02,0.5),
            DeltaPeak(1.0,0.02,1.0),
            DeltaPeak(1.0,0.02,4.0)
        ],
        "signs" => [1.0,1.0,1.0,1.0,1.0,1.0]
    ),
]

const STD_FRD = Dict{String,Any}[
    # Test: 001 / Fermionic + Rise-And-Decay Peaks
    # single peak, central
    Dict(
        "ktype" => "fermi",
        "grid"  => "ffreq",
        "mesh"  => "linear",
        "peaks" => [
            RiseDecayPeak(0.0,1.5,1.0)
        ],
        "signs" => [-1.0]
    ),
    #
    # Test: 002 / Fermionic + Rise-And-Decay Peaks
    # two peaks, left down + right up
    Dict(
        "ktype" => "fermi",
        "grid"  => "ffreq",
        "mesh"  => "linear",
        "peaks" => [
            RiseDecayPeak(-1.0,1.5,0.5),
            RiseDecayPeak(1.0,1.5,0.5)
        ],
        "signs" => [-1.0,1.0]
    ),
    #
    # Test: 003 / Fermionic + Rise-And-Decay Peaks
    # two peaks, left up + right down
    Dict(
        "ktype" => "fermi",
        "grid"  => "ffreq",
        "mesh"  => "linear",
        "peaks" => [
            RiseDecayPeak(-1.0,1.5,0.5),
            RiseDecayPeak(1.0,1.5,0.5)
        ],
        "signs" => [1.0,-1.0]
    ),
    #
    # Test: 004 / Fermionic + Rise-And-Decay Peaks
    # two peaks, left down small + right up big
    Dict(
        "ktype" => "fermi",
        "grid"  => "ffreq",
        "mesh"  => "linear",
        "peaks" => [
            RiseDecayPeak(-3.0,2.0,0.2),
            RiseDecayPeak(3.0,2.0,0.5)
        ],
        "signs" => [-1.0,1.0]
    ),
    #
    # Test: 005 / Fermionic + Rise-And-Decay Peaks
    # two peaks, left up big + right down small
    Dict(
        "ktype" => "fermi",
        "grid"  => "ffreq",
        "mesh"  => "linear",
        "peaks" => [
            RiseDecayPeak(-3.0,2.0,0.5),
            RiseDecayPeak(3.0,2.0,0.2)
        ],
        "signs" => [1.0,-1.0]
    ),
    #
    # Test: 006 / Fermionic + Rise-And-Decay Peaks
    # two peaks, left down + right down
    Dict(
        "ktype" => "fermi",
        "grid"  => "ffreq",
        "mesh"  => "linear",
        "peaks" => [
            RiseDecayPeak(-2.0,1.5,0.5),
            RiseDecayPeak(2.0,1.5,0.5)
        ],
        "signs" => [-1.0,-1.0]
    ),
    #
    # Test: 007 / Fermionic + Rise-And-Decay Peaks
    # three peaks, down + up + down
    Dict(
        "ktype" => "fermi",
        "grid"  => "ffreq",
        "mesh"  => "linear",
        "peaks" => [
            RiseDecayPeak(-2.5,1.5,0.2),
            RiseDecayPeak(0.0,1.5,0.5),
            RiseDecayPeak(2.5,1.5,0.2)
        ],
        "signs" => [-1.0,1.0,-1.0]
    ),
    #
    # Test: 008 / Fermionic + Rise-And-Decay Peaks
    # three peaks, up + down + up
    Dict(
        "ktype" => "fermi",
        "grid"  => "ffreq",
        "mesh"  => "linear",
        "peaks" => [
            RiseDecayPeak(-2.5,1.5,0.5),
            RiseDecayPeak(0.0,1.5,0.2),
            RiseDecayPeak(2.5,1.5,0.5)
        ],
        "signs" => [1.0,-1.0,1.0]
    ),
    #
    # Test: 009 / Fermionic + Rise-And-Decay Peaks
    # four peaks, down + up + up + down
    Dict(
        "ktype" => "fermi",
        "grid"  => "ffreq",
        "mesh"  => "linear",
        "peaks" => [
            RiseDecayPeak(-3.0,0.5,0.2),
            RiseDecayPeak(-1.0,0.5,0.25),
            RiseDecayPeak(1.0,0.5,0.25),
            RiseDecayPeak(3.0,0.5,0.2)
        ],
        "signs" => [-1.0,1.0,1.0,-1.0]
    ),
    #
    # Test: 010 / Fermionic + Rise-And-Decay Peaks
    # five peaks, up + down + up + down + up
    Dict(
        "ktype" => "fermi",
        "grid"  => "ffreq",
        "mesh"  => "linear",
        "peaks" => [
            RiseDecayPeak(-3.0,0.5,0.2),
            RiseDecayPeak(-1.0,0.5,0.5),
            RiseDecayPeak(0.0,0.5,0.5),
            RiseDecayPeak(1.0,0.5,0.5),
            RiseDecayPeak(3.0,0.5,0.2)
        ],
        "signs" => [1.0,-1.0,1.0,-1.0,1.0]
    ),
]
