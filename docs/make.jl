push!(LOAD_PATH, "../src")
  
using Documenter
using Random
using ACTest

makedocs(
    sitename = "ACTest",
    clean = false,
    authors = "Li Huang <huangli@caep.cn> and contributors",
    format = Documenter.HTML(
        prettyurls = false,
        ansicolor = true,
        repolink = "https://github.com/huangli712/ACTest",
        size_threshold = 409600, # 400kb
    ),
    #format = Documenter.LaTeX(),
    remotes = nothing,
    modules = [ACTest],
    pages = [
        "Home" => "index.md",
        "Introduction" => Any[
            "Motivation" => "intro/motivation.md",
            "Acknowledgements" => "intro/ack.md",
            "Citation" => "intro/cite.md",
        ],
        "Manual" => Any[
            "Main Features" => "man/feature.md",
        ],
        "Theory" => Any[
            "Grids" => "theory/grid.md",
        ],
        "Library" => Any[
            "Outline" => "library/outline.md",
            "ACTest" => "library/actest.md",
            "Constants" => "library/global.md",
            "Types" => "library/type.md",
            "Core" => "library/base.md",
            "Peaks" => "library/peak.md",
            "Spectra" => "library/spectrum.md",
            "Standard dataset" => "library/dataset.md",
            "Grids" => "library/grid.md",
            "Meshes" => "library/mesh.md",
            "Kernels" => "library/kernel.md",
            "Configuration" => "library/config.md",
            "Input and output" => "library/inout.md",
            "Math" => "library/math.md",
            "Utilities" => "library/util.md",
        ],
    ],
)