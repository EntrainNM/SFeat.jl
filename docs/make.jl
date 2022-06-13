using Documenter
using SFeat

makedocs(
    sitename = "SFeat",
    format = Documenter.HTML(),
    modules = [SFeat]
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
deploydocs(
    repo = "github.com/EntrainNM/SFeat.jl"
)
