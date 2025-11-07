# ACOPF_Extensions

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://mateollivisaca.github.io/ACOPF_Extensions.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://mateollivisaca.github.io/ACOPF_Extensions.jl/dev/)
[![Build Status](https://github.com/mateollivisaca/ACOPF_Extensions.jl/actions/workflows/CI.yml/badge.svg?branch=master)](https://github.com/mateollivisaca/ACOPF_Extensions.jl/actions/workflows/CI.yml?query=branch%3Amaster)
[![Coverage](https://codecov.io/gh/mateollivisaca/ACOPF_Extensions.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/mateollivisaca/ACOPF_Extensions.jl)

A Julia package designed to extend and customize AC Optimal Power Flow (ACOPF) formulations within the [PowerModels.jl].

## Install
```julia
using Pkg
Pkg.add(url="https://github.com/mateollivisaca/ACOPF_Extensions.jl") 
```
## Example
```julia
using ACOPF_Extensions

system = joinpath(@__DIR__, "case", "garverQ")
topology = zeros(Int64,15,1)
topology[9,1] = 1
topology[11,1] = 1
topology[14,1] = 2

result, fobj, state, rc = run_acopf_topology(system, topology; rc=true)

println("Objective value: ", fobj)
println("Optimization state: ", state)
```
