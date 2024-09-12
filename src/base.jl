#
# Project : Lily
# Source  : base.jl
# Author  : Li Huang (huangli@caep.cn)
# Status  : Unstable
#
# Last modified: 2024/09/12
#

"""
    reprod(am::AbstractMesh, kernel::Matrix{F64}, A::Vector{F64})

Try to reproduce the input data, which can be compared with the raw data
to see whether the analytic continuation is reasonable.

### Arguments
* am -> Real frequency mesh.
* kernel -> The kernel function.
* A -> The calculated spectral function, A(ω).

### Returns
* G -> Reconstructed correlators, G(τ) or G(iωₙ), Vector{F64}.

See also: [`AbstractMesh`](@ref).
"""
function reprod(am::AbstractMesh, kernel::Matrix{F64}, A::Vector{F64})
    ndim, nmesh = size(kernel)
    @assert nmesh == length(am) == length(A)

    @einsum KA[i,j] := kernel[i,j] * A[j]

    G = zeros(F64, ndim)
    for i = 1:ndim
        G[i] = trapz(am, view(KA, i, :))
    end

    return G
end

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

function make_data()
    nspec = get_t("nspec")

    # Prepare grid for input data
    grid = make_grid()
    println("Build grid for input data: ", length(grid), " points")

    # Prepare mesh for output spectrum
    mesh = make_mesh()
    println("Build mesh for spectrum: ", length(mesh), " points")

    for i = 1:nspec
        @printf("[dataset]: %4i / %4i\n", i, nspec)
    end

    println()
end

function make_peak()
end

function make_spectrum()
end

function make_green()
end

"""
    make_grid()

To generate imaginary time grid or Masubara grid for many-body correlator.
It will return a sub-type of the AbstractGrid struct.

### Arguments
N/A

### Returns
* grid -> Imaginary time or imaginary frequency grid.

See also: [`AbstractGrid`](@ref).
"""
function make_grid()
    # Extract key parameters
    grid = get_t("grid")
    ngrid = get_t("ngrid")
    β = get_t("beta")

    _grid = nothing
    @cswitch grid begin
        @case "ftime"
            _grid = ImaginaryTimeGrid(ngrid, β)
            break

        @case "btime"
            _grid = ImaginaryTimeGrid(ngrid, β)
            break

        @case "ffreq"
            gtype = 1
            _grid = MatsubaraGrid(gtype, ngrid, β)
            break

        @case "bfreq"
            gtype = 0
            _grid = MatsubaraGrid(gtype, ngrid, β)
            break

        @default
            sorry()
            break
    end

    return _grid
end

"""
    make_mesh()

Try to generate an uniform (linear) or non-uniform (non-linear) mesh for
the spectral function in real axis.

### Arguments
N/A

### Returns
* mesh -> Real frequency mesh. It should be a subtype of AbstractMesh.

See also: [`LinearMesh`](@ref), [`TangentMesh`](@ref), [`LorentzMesh`](@ref).
"""
function make_mesh()
    # Predefined parameters for mesh generation
    #
    # Note that the parameters `f1` and `cut` are only for the generation
    # of the non-uniform mesh.
    #
    f1::F64 = 2.1
    cut::F64 = 0.01

    # Setup parameters according to act.toml
    pmesh = get_t("pmesh")
    if !isa(pmesh, Missing)
        (length(pmesh) == 1) && begin
            Γ, = pmesh
            f1 = Γ
            cut = Γ
        end
    end

    # Get essential parameters
    ktype = get_t("ktype")
    nmesh = get_t("nmesh")
    mesh = get_t("mesh")
    wmax::F64 = get_t("wmax")
    wmin::F64 = get_t("wmin")
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

"""
    make_kernel(am::AbstractMesh, ag::AbstractGrid)

Try to generate various kernel functions.

### Arguments
* am -> Real frequency mesh.
* ag -> Imaginary axis grid.

### Returns
* kernel -> Kernel function, a 2D array, (ntime,nmesh) or (nfreq,nmesh).

See also: [`AbstractMesh`](@ref), [`AbstractGrid`](@ref).
"""
function make_kernel(am::AbstractMesh, ag::AbstractGrid)
    ktype = get_t("ktype")
    grid = get_t("grid")

    @cswitch ktype begin
        @case "fermi"
            @assert grid in ("ftime", "ffreq")
            return build_kernel(am, ag)
            break

        @case "boson"
            @assert grid in ("btime", "bfreq")
            return build_kernel(am, ag)
            break

        @case "bsymm"
            @assert grid in ("btime", "bfreq")
            return build_kernel_symm(am, ag)
            break

        @default
            sorry()
            break
    end
end
