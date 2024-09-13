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
        "Library" => Any[
        ],
    ],
)