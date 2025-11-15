"""
    run_acopf_topology(system::Dict, topology::Matrix{Int};
        rc::Bool=false, n1::Bool=false,
        drate::Float64=20.0, grate::Float64=10.0, yp::Int=1)

Runs an **AC Optimal Power Flow (AC-OPF)** problem for a given network topology,
optionally including replacement components, contingency (N-1) analysis, and
demand/generation growth over multiple stages.

# Arguments
- `system::Dict`: Dictionary containing the base electrical network data.
- `topology::Matrix{Int}`: Binary matrix representing candidate lines and their
  activation per stage (1 = active, 0 = inactive).
- `rc::Bool=false`: If `true`, includes the model with component replacement.
- `n1::Bool=false`: If `true`, activates N-1 contingency constraints.
- `drate::Float64=20.0`: Discount rate (%).
- `grate::Float64=10.0`: Load and generation growth rate (%).
- `yp::Int=1`: Number of years per planning stage.

# Returns
A tuple with:
1. `result` — Dictionary with the optimization results.
2. `fobj` — Objective value (total expansion or operation cost).
3. `state` — Solver termination status (`MathOptInterface.TerminationStatusCode`).
4. `rc_nodes` — Nodes and amounth of RC p.u. [MVAR].

# Example
```julia
using ACOPF_Extensions, PowerModels

system = joinpath(@__DIR__, "case", "garverQ")
topology = zeros(Int64,15,1)
topology[9,1] = 1
topology[11,1] = 1
topology[14,1] = 2

result, fobj, state, rc_nodes = run_acopf_topology(system, topology; n1=true) 

```
"""
function run_acopf_topology(system::String,topology::Matrix{Int};
    rc::Bool=false,n1::Bool=false,
    drate::Float64=20.0,grate::Float64=10.0,yp::Int=1)  

    stages = size(topology,2)
    case = setup_case(system, rc, n1,
            Stage=stages,growth_rate=grate, d_rate=drate, years_stage=yp)
    if rc 
        result, fobj, state, rc_nodes = solve_tnep_N1_rc(case, topology)
    else
        result, fobj, state, rc_nodes = solve_tnep_N1_nrc(case, topology)
    end
    return result, fobj, state, rc_nodes
end


function run_acopf_topology(case::Dict,topology::Matrix{Int})  
    if case["ReactiveCompensation"] 
        result, fobj, state, rc_nodes = solve_tnep_N1_rc(case, topology)
    else
        result, fobj, state, rc_nodes = solve_tnep_N1_nrc(case, topology)
    end
    return result, fobj, state, rc_nodes
end

function run_acopf_idx_topology(system::String,topology::Matrix{Int};
    rc::Bool=false,n1::Bool=false,
    drate::Float64=20.0,grate::Float64=10.0,yp::Int=1)  

    stages = size(topology,2)
    case = setup_case(system, rc, n1,
            Stage=stages,growth_rate=grate, d_rate=drate, years_stage=yp)
    if rc
        result, fobj, state, rc_nodes, idx_node = solve_tnep_N1_idx_rc(case, topology)
    else
        result, fobj, state, rc_nodes, idx_node = solve_tnep_N1_idx_nrc(case, topology)
    end
    return result, fobj, state, rc_nodes, idx_node
end

function run_acopf_idx_topology(case::Dict,topology::Matrix{Int})  
    if case["ReactiveCompensation"] 
        result, fobj, state, rc_nodes, idx_node = solve_tnep_N1_idx_rc(case, topology)
    else
        result, fobj, state, rc_nodes, idx_node = solve_tnep_N1_idx_nrc(case, topology)
    end
    return result, fobj, state, rc_nodes, idx_node
end

"""
    run_acopf_ag_topology(system::Dict, topology::Matrix{Int};
        rc::Bool=false, n1::Bool=false,
        drate::Float64=20.0, grate::Float64=10.0, yp::Int=1)

Runs an **AC Optimal Power Flow (AC-OPF)** problem including *artificial generation (AG)* units,
which represent virtual or flexible generation sources used to enhance system feasibility
or simulate active power not supplied.

This function extends `run_acopf_topology` by adding artificial generation buses and
related constraints into the optimization model.

# Arguments
- `system::Dict`: Dictionary containing the base electrical network data.
- `topology::Matrix{Int}`: Binary matrix representing candidate lines and their
  activation per stage (1 = active, 0 = inactive).
- `rc::Bool=false`: If `true`, includes the model with component replacement.
- `n1::Bool=false`: If `true`, activates N-1 contingency constraints.
- `drate::Float64=20.0`: Discount rate (%).
- `grate::Float64=10.0`: Load or generation growth rate (%).
- `yp::Int=1`: Number of years per planning stage.

# Returns
A tuple with:
1. `result` — Dictionary with the optimization results including AG variables.
2. `fobj` — Objective value (including AG operation cost).
3. `state` — Solver termination status (`MathOptInterface.TerminationStatusCode`).
4. `rc_nodes` — Nodes and amounth of RC p.u. [MVAR].

# Example
```julia
using ACOPF_Extensions, PowerModels

system = joinpath(@__DIR__, "case", "garverQ")
topology = zeros(Int64,15,1)
topology[9,1] = 1
topology[11,1] = 1
topology[14,1] = 2

result, fobj, state, rc_nodes = run_acopf_ag_topology(system, topology; rc=true)
```
"""
function run_acopf_ag_topology(system::String,topology::Matrix{Int};
    rc::Bool=false,n1::Bool=false,
    drate::Float64=20.0,grate::Float64=10.0,yp::Int=1)  

    stages = size(topology,2)
    case = setup_case(system, rc, n1,
            Stage=stages,growth_rate=grate, d_rate=drate, years_stage=yp)
    if rc 
        result, fobj, state, rc_nodes = solve_tnep_N1_rc_AP(case, topology)
    else
        result, fobj, state, rc_nodes = solve_tnep_N1_nrc_AP(case, topology)
    end
    return result, fobj, state, rc_nodes
end



function run_acopf_ag_topology(case::Dict,topology::Matrix{Int})  
    if case["ReactiveCompensation"] 
        result, fobj, state, rc_nodes = solve_tnep_N1_rc_AP(case, topology)
    else
        result, fobj, state, rc_nodes = solve_tnep_N1_nrc_AP(case, topology)
    end
    return result, fobj, state, rc_nodes
end