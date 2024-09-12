#
# Project : Lily
# Source  : inout.jl
# Author  : Li Huang (huangli@caep.cn)
# Status  : Unstable
#
# Last modified: 2024/09/12
#

"""
    write_spectrum(am::AbstractMesh, Aout::Vector{F64})

Write spectrum A(ω) to `Aout.data`. The grid is defined in `am`, and
the spectral data are contained in `Aout`.

### Arguments
* am   -> Real frequency mesh.
* Aout -> Spectral function.

### Returns
N/A
"""
function write_spectrum(am::AbstractMesh, Aout::Vector{F64})
    @assert length(am) == length(Aout)

    open("Aout.data", "w") do fout
        for i in eachindex(am)
            @printf(fout, "%16.12f %16.12f\n", am[i], Aout[i])
        end
    end
end
