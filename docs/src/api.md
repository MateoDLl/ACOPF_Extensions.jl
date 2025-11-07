# ACOPF_Extensions.jl

Welcome to the documentation for **ACOPF_Extensions.jl** — a Julia package designed to extend and customize AC Optimal Power Flow (ACOPF) formulations within the [PowerModels.jl](https://lanl-ansi.github.io/PowerModels.jl/stable/) framework.

This package introduces additional modeling layers for **N-1 contingency analysis**, **multi-stage operation**, and **artificial generation support**.  
It is primarily developed for research on **Transmission Network Expansion Planning (TNEP)**.
---
## Installation

To install the package, use the Julia package manager:

```julia
using Pkg
Pkg.add(url="https://github.com/MateoDLl/ACOPF_Extensions.jl.git") 
```

---

## Overview

ACOPF_Extensions.jl provides extended ACOPF models, building upon **PowerModels.jl**, and integrates seamlessly with **JuMP** and nonlinear solvers like **Ipopt**.

The main exported functions are:

*run_acopf_topology*: Runs an ACOPF considering topology-based constraints.

*run_acopf_ag_topology*: Similar to the previous one, but includes artificial generators to improve network feasibility.