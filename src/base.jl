#
# Project : Lily
# Source  : base.jl
# Author  : Li Huang (huangli@caep.cn)
# Status  : Unstable
#
# Last modified: 2024/09/12
#

"""
    read_param()

Setup the configuration dictionaries via an external file. The valid
format of a configuration file is `toml`.

### Arguments
N/A

### Returns
N/A

See also: [`read_param`](@ref).
"""
function read_param()
    cfg = inp_toml(query_args(), true)
    fil_dict(cfg)
    chk_dict()
    see_dict()
end

"""
    make_grid(T::DataType = F64)

To generate imaginary time grid or Masubara grid for many-body correlator.
It will return a sub-type of the AbstractGrid struct.

### Arguments
* T -> Numerical type.

### Returns
* grid -> Imaginary time or imaginary frequency grid.

See also: [`RawData`](@ref), [`AbstractGrid`](@ref).
"""
function make_grid(rd::RawData; T::DataType = F64)
    grid = get_b("grid")
    ngrid = get_b("ngrid")
    β::T = get_b("beta")

    v = T.(rd._grid)
    @assert ngrid == length(v)

    _grid = nothing
    @cswitch grid begin
        @case "ftime"
            _β = v[end]
            @assert abs(_β - β) ≤ 1e-6
            _grid = FermionicImaginaryTimeGrid(ngrid, β, v)
            break

        @case "fpart"
            _grid = FermionicFragmentTimeGrid(β, v)
            break

        @case "btime"
            _β = v[end]
            @assert abs(_β - β) ≤ 1e-6
            _grid = BosonicImaginaryTimeGrid(ngrid, β, v)
            break

        @case "bpart"
            _grid = BosonicFragmentTimeGrid(β, v)
            break

        @case "ffreq"
            _β = 2.0 * π / (v[2] - v[1])
            @assert abs(_β - β) ≤ 1e-6
            _grid = FermionicMatsubaraGrid(ngrid, β, v)
            break

        @case "ffrag"
            _grid = FermionicFragmentMatsubaraGrid(β, v)
            break

        @case "bfreq"
            _β = 2.0 * π / (v[2] - v[1])
            @assert abs(_β - β) ≤ 1e-6
            _grid = BosonicMatsubaraGrid(ngrid, β, v)
            break

        @case "bfrag"
            _grid = BosonicFragmentMatsubaraGrid(β, v)
            break

        @default
            sorry()
            break
    end

    return _grid
end

"""
    make_mesh(; T::DataType = F64)

Try to generate an uniform (linear) or non-uniform (non-linear) mesh for
the spectral function in real axis. Notice that it supports arbitrary
precision mesh. By default, the precision is F64. One can specify the
precision by the argument `T`.

### Arguments
See above explanations.

### Returns
* mesh -> Real frequency mesh. It should be a subtype of AbstractMesh.

See also: [`LinearMesh`](@ref), [`TangentMesh`](@ref), [`LorentzMesh`](@ref).
"""
function make_mesh(; T::DataType = F64)
    # Predefined parameters for mesh generation
    #
    # Note that the parameters `f1` and `cut` are only for the generation
    # of the non-uniform mesh.
    #
    f1::T = 2.1
    cut::T = 0.01

    # Setup parameters according to case.toml
    pmesh = get_b("pmesh")
    if !isa(pmesh, Missing)
        (length(pmesh) == 1) && begin
            Γ, = pmesh
            f1 = Γ
            cut = Γ
        end
    end

    # Get essential parameters
    ktype = get_b("ktype")
    nmesh = get_b("nmesh")
    mesh = get_b("mesh")
    wmax::T = get_b("wmax")
    wmin::T = get_b("wmin")
    #
    # For bosonic correlators of Hermitian operators, the spectral
    # function is defined in (0, ∞) only.
    if ktype == "bsymm"
        @assert wmin ≥ 0.0
        @assert wmax ≥ 0.0
        @assert wmax > wmin
    end

    # Try to generate the required mesh
    @cswitch mesh begin
        @case "linear"
            return LinearMesh(nmesh, wmin, wmax)
            break

        @case "tangent"
            return TangentMesh(nmesh, wmin, wmax, f1)
            break

        @case "lorentz"
            return LorentzMesh(nmesh, wmin, wmax, cut)
            break

        @case "halflorentz"
            return HalfLorentzMesh(nmesh, wmax, cut)
            break

        @default
            sorry()
            break
    end
end
