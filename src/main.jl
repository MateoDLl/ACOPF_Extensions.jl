
function run_acopf_topology(system::String,topology::Matrix{Int};
    rc::Bool=false,n1::Bool=false,
    drate::Float64=20.0,grate::Float64=10.0,yp::Int=1)  

    stages = size(topology,2)
    case = setup_case(system, rc, n1,
            Stage=stages,growth_rate=grate, d_rate=drate, years_stage=yp)
        
    # dict_result, objective, status, shunt comp
    if rc 
        result, fobj, state, rc_nodes, _ = solve_tnep_N1_idx_rc(case, topology)
    else
        result, fobj, state, rc_nodes, _ = solve_tnep_N1_idx_nrc(case, topology)
    end
    return result, fobj, state, rc_nodes
end

function run_acopf_ag_topology(system::String,topology::Matrix{Int};
    rc::Bool=false,n1::Bool=false,
    drate::Float64=20.0,grate::Float64=10.0,yp::Int=1)  

    stages = size(topology,2)
    case = setup_case(system, rc, n1,
            Stage=stages,growth_rate=grate, d_rate=drate, years_stage=yp)

    # dict_result, objective, status, shunt comp
    if rc 
        result, fobj, state, rc_nodes, _ = solve_tnep_N1_idx_rc_AP(case, topology)
    else
        result, fobj, state, rc_nodes, _ = solve_tnep_N1_idx_nrc_AP(case, topology)
    end
    return result, fobj, state, rc_nodes
end