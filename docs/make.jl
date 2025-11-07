using Documenter
using ACOPF_Extensions

DocMeta.setdocmeta!(ACOPF_Extensions, :DocTestSetup, :(using ACOPF_Extensions); recursive=true)

makedocs(;
    modules=[ACOPF_Extensions],
    authors="Mateo Llivisaca",
    sitename="ACOPF_Extensions.jl",
    format=Documenter.HTML(;
        canonical="https://mateollivisaca.github.io/ACOPF_Extensions.jl",
        edit_link="master",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/mateollivisaca/ACOPF_Extensions.jl",
    branch="gh-pages",   
    devbranch="master",
)