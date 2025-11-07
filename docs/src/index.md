```@meta
CurrentModule = ACOPF_Extensions
```

# ACOPF_Extensions

Documentation for [ACOPF_Extensions](https://github.com/mateollivisaca/ACOPF_Extensions.jl).

```@index
```

```@autodocs
Modules = [ACOPF_Extensions]
```
**ACOPF_Extensions.jl** provides tools for running AC Optimal Power Flow (AC-OPF) simulations
with extended modeling features such as:
- Reactive compensation (shunt),
- Artificial generation for feasibility analysis,
- Multi-stage topology expansion,
- N-1 contingency evaluation.

---

## Installation

```julia
using Pkg
Pkg.add(url="https://github.com/mateollivisaca/ACOPF_Extensions.jl")


