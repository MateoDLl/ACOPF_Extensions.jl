function sol_component_value(aim::_IM.AbstractInfrastructureModel, ctg::Int, n::Int, comp_name::Symbol, field_name::Symbol, comp_ids, variables)
    for i in comp_ids
        @assert !haskey(_IM._sol(aim.sol[:it][Symbol(_PM.pm_it_name)][:nw][ctg][n],comp_name, i), field_name)
        _IM._sol(aim.sol[:it][Symbol(_PM.pm_it_name)][:nw][ctg][n][comp_name],i)[field_name] = variables[i]
    end
end

function sol_component_value(aim::_IM.AbstractInfrastructureModel, ctg::Int, n::Int, comp_name::Symbol, field_name::Symbol, comp_ids, per_ids, variables)
    for i in comp_ids
        for k in per_ids
            @assert !haskey(_IM._sol(aim.sol[:it][Symbol(_PM.pm_it_name)][:nw][ctg][n],comp_name, i), field_name)
            _IM._sol(aim.sol[:it][Symbol(_PM.pm_it_name)][:nw][ctg][n][comp_name][i],k)[field_name] = variables[i,k]
        end
    end
end

function sol_component_value_edge(pm::_IM.AbstractInfrastructureModel, it::Symbol, ctg::Int, n::Int, comp_name::Symbol, field_name_fr::Symbol, field_name_to::Symbol, comp_ids_fr, comp_ids_to, variables)
    for (l, i, j) in comp_ids_fr
        @assert !haskey(_IM._sol(pm.sol[:it][it][:nw][ctg][n],comp_name, l), field_name_fr)
        _IM._sol(pm.sol[:it][it][:nw][ctg][n][comp_name],l)[field_name_fr] = variables[(l, i, j)]
    end

    for (l, i, j) in comp_ids_to
        @assert !haskey(_IM._sol(pm.sol[:it][it][:nw][ctg][n],comp_name, l), field_name_to)
        _IM._sol(pm.sol[:it][it][:nw][ctg][n][comp_name],l)[field_name_to] = variables[(l, i, j)]
    end
end

function sol_component_value_edge(pm::_IM.AbstractInfrastructureModel, it::Symbol, ctg::Int, n::Int, comp_name::Symbol, field_name_fr::Symbol, field_name_to::Symbol, comp_ids_fr, comp_ids_to, per_ids, variables)
    for k in per_ids
        for (l, i, j) in comp_ids_fr
            @assert !haskey(_IM._sol(pm.sol[:it][it][:nw][ctg][n],comp_name, l), field_name_fr)
            _IM._sol(pm.sol[:it][it][:nw][ctg][n][comp_name][l],k)[field_name_fr] = variables[(l, i, j),k]
        end

        for (l, i, j) in comp_ids_to
            @assert !haskey(_IM._sol(pm.sol[:it][it][:nw][ctg][n],comp_name, l), field_name_to)
            _IM._sol(pm.sol[:it][it][:nw][ctg][n][comp_name][l],k)[field_name_to] = variables[(l, i, j),k]
        end
    end
end


function variable_bus_voltage_angle_tnepacdcN1(pm::_PM.AbstractPowerModel,ctg::Int; nw::Int=nw_id_default, bounded::Bool=true, report::Bool=true)
    va = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:va] = JuMP.@variable(pm.model,
        [i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus])],# base_name="$(nw)_va",
        start = _PM.comp_start_value(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus][i], "va_start")
    )
    report && sol_component_value(pm, ctg, nw, :bus, :va,keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus]), va)
end

function variable_bus_voltage_angle_tnepacdcN1(pm::_PM.AbstractPowerModel,ctg::Int, pr::Vector; nw::Int=nw_id_default, bounded::Bool=true, report::Bool=true)
    va = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:va] = JuMP.@variable(pm.model,
        [i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus]),k in pr],# base_name="$(nw)_va",
        start = _PM.comp_start_value(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus][i], "va_start")
    )
    report && sol_component_value(pm, ctg, nw, :bus, :va, keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus]), pr, va)
end

function variable_bus_voltage_magnitude_tnepacdcN1(pm::_PM.AbstractPowerModel,ctg::Int; nw::Int=nw_id_default, bounded::Bool=true, report::Bool=true)
    vm = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:vm] = JuMP.@variable(pm.model,
        [i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus])], #base_name="$(nw)_vm",
        start = _PM.comp_start_value(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus][i], "vm_start", 1.0)
    )
    if bounded
            for (i, bus) in pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus]
                JuMP.set_lower_bound(vm[i], bus["vmin"])
                JuMP.set_upper_bound(vm[i], bus["vmax"])
            end
    end
    report && sol_component_value(pm,ctg, nw, :bus, :vm, keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus]), vm)
end

function variable_bus_voltage_magnitude_tnepacdcN1(pm::_PM.AbstractPowerModel,ctg::Int, pr::Vector; nw::Int=nw_id_default, bounded::Bool=true, report::Bool=true)
    vm = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:vm] = JuMP.@variable(pm.model,
        [i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus]),k in pr], #base_name="$(nw)_vm",
        start = _PM.comp_start_value(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus][i], "vm_start", 1.0)
    )
    if bounded
        for k in pr
            for (i, bus) in pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus]
                JuMP.set_lower_bound(vm[i,k], bus["vmin"])
                JuMP.set_upper_bound(vm[i,k], bus["vmax"])
            end
        end
    end
    report && sol_component_value(pm,ctg, nw, :bus, :vm, keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus]), pr, vm)
end

#Generation Active and Reactive
function variable_gen_power_real_tnepacdcN1(pm::_PM.AbstractPowerModel,ctg::Int; nw::Int=nw_id_default, bounded::Bool=true, report::Bool=true)
    pg = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:pg] = JuMP.@variable(pm.model,
        [i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:gen])],# base_name="$(nw)_pg",
        start = _PM.comp_start_value(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:gen][i], "pg_start")
    )

    if bounded
        for (i, gen) in pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:gen]
            JuMP.set_lower_bound(pg[i], gen["pmin"])
            JuMP.set_upper_bound(pg[i], gen["pmax"])
        end
        
    end

    report && sol_component_value(pm, ctg, nw, :gen, :pg, keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:gen]), pg)
end

function variable_gen_power_real_tnepacdcN1(pm::_PM.AbstractPowerModel,ctg::Int, pr::Vector; nw::Int=nw_id_default, bounded::Bool=true, report::Bool=true)
    pg = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:pg] = JuMP.@variable(pm.model,
        [i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:gen]),k in pr],# base_name="$(nw)_pg",
        start = _PM.comp_start_value(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:gen][i], "pg_start")
    )

    if bounded
        for k in pr
            for (i, gen) in pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:gen]
                JuMP.set_lower_bound(pg[i,k], gen["pmin"])
                JuMP.set_upper_bound(pg[i,k], gen["pmax"])
            end
        end
    end

    report && sol_component_value(pm, ctg, nw, :gen, :pg, keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:gen]),pr, pg)
end

function variable_gen_power_imaginary_tnepacdcN1(pm::_PM.AbstractPowerModel, ctg::Int; nw::Int=nw_id_default, bounded::Bool=true, report::Bool=true)
    qg = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:qg] = JuMP.@variable(pm.model,
        [i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:gen])], #base_name="$(nw)_pg",
        start = _PM.comp_start_value(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:gen][i], "qg_start")
    )

    if bounded
        for (i, gen) in pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:gen]
            JuMP.set_lower_bound(qg[i], gen["qmin"])
            JuMP.set_upper_bound(qg[i], gen["qmax"])
        end
    end
    report && sol_component_value(pm, ctg, nw, :gen, :qg, keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:gen]), qg)
end

function variable_gen_power_imaginary_tnepacdcN1(pm::_PM.AbstractPowerModel, ctg::Int, pr::Vector; nw::Int=nw_id_default, bounded::Bool=true, report::Bool=true)
    qg = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:qg] = JuMP.@variable(pm.model,
        [i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:gen]),k in pr], #base_name="$(nw)_pg",
        start = _PM.comp_start_value(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:gen][i], "qg_start")
    )

    if bounded
        for k in pr
            for (i, gen) in pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:gen]
                JuMP.set_lower_bound(qg[i,k], gen["qmin"])
                JuMP.set_upper_bound(qg[i,k], gen["qmax"])
            end
        end
    end
    report && sol_component_value(pm, ctg, nw, :gen, :qg, keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:gen]), pr, qg)
end

function variable_branch_power_real_tnepacdcN1(pm::_PM.AbstractPowerModel, ctg::Int; nw::Int=nw_id_default, bounded::Bool=true, report::Bool=true)
    p = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:p] = JuMP.@variable(pm.model,
        [(l,i,j) in pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:arcs]], #base_name="$(nw)_p",
        start = _PM.comp_start_value(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:branch][l], "p_start")
    )

    if bounded
        flow_lb, flow_ub = _PM.ref_calc_branch_flow_bounds(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:branch], pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus])
        for arc in pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:arcs]
            l,i,j = arc
            if !isinf(flow_lb[l])
                JuMP.set_lower_bound(p[arc], flow_lb[l])
            end
            if !isinf(flow_ub[l])
                JuMP.set_upper_bound(p[arc], flow_ub[l])
            end
        end
    end
    report && sol_component_value_edge(pm, Symbol(_PM.pm_it_name),ctg, nw, :branch, :pf, :pt, pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:arcs_from], pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:arcs_to], p)
end

function variable_branch_power_real_tnepacdcN1(pm::_PM.AbstractPowerModel, ctg::Int, pr::Vector; nw::Int=nw_id_default, bounded::Bool=true, report::Bool=true)
    p = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:p] = JuMP.@variable(pm.model,
        [(l,i,j) in pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:arcs],k in pr], #base_name="$(nw)_p",
        start = _PM.comp_start_value(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:branch][l], "p_start")
    )

    if bounded
        flow_lb, flow_ub = _PM.ref_calc_branch_flow_bounds(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:branch], pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus])
        for k in pr 
            for arc in pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:arcs]
                l,i,j = arc
                if !isinf(flow_lb[l])
                    JuMP.set_lower_bound(p[arc,k], flow_lb[l])
                end
                if !isinf(flow_ub[l])
                    JuMP.set_upper_bound(p[arc,k], flow_ub[l])
                end
            end
        end
    end
    report && sol_component_value_edge(pm, Symbol(_PM.pm_it_name),ctg, nw, :branch, :pf, :pt, pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:arcs_from], pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:arcs_to], pr, p)
end

function variable_branch_power_imaginary_tnepacdcN1(pm::_PM.AbstractPowerModel, ctg::Int; nw::Int=nw_id_default, bounded::Bool=true, report::Bool=true)
    q = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:q] = JuMP.@variable(pm.model,
        [(l,i,j) in pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:arcs]], #base_name="$(nw)_q",
        start = _PM.comp_start_value(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:branch][l], "q_start")
    )

    if bounded
        flow_lb, flow_ub = _PM.ref_calc_branch_flow_bounds(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:branch], pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus])
        for arc in pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:arcs]
            l,i,j = arc
            if !isinf(flow_lb[l])
                JuMP.set_lower_bound(q[arc], flow_lb[l])
            end
            if !isinf(flow_ub[l])
                JuMP.set_upper_bound(q[arc], flow_ub[l])
            end
        end
    end
    report && sol_component_value_edge(pm, Symbol(_PM.pm_it_name),ctg, nw, :branch, :qf, :qt, pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:arcs_from], pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:arcs_to], q)
end

function variable_branch_power_imaginary_tnepacdcN1(pm::_PM.AbstractPowerModel, ctg::Int, pr::Vector; nw::Int=nw_id_default, bounded::Bool=true, report::Bool=true)
    q = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:q] = JuMP.@variable(pm.model,
        [(l,i,j) in pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:arcs],k in pr], #base_name="$(nw)_q",
        start = _PM.comp_start_value(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:branch][l], "q_start")
    )

    if bounded
        flow_lb, flow_ub = _PM.ref_calc_branch_flow_bounds(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:branch], pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus])
        for k in pr
            for arc in pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:arcs]
                l,i,j = arc
                if !isinf(flow_lb[l])
                    JuMP.set_lower_bound(q[arc, k], flow_lb[l])
                end
                if !isinf(flow_ub[l])
                    JuMP.set_upper_bound(q[arc, k], flow_ub[l])
                end
            end
        end
    end
    report && sol_component_value_edge(pm, Symbol(_PM.pm_it_name),ctg, nw, :branch, :qf, :qt, pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:arcs_from], pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:arcs_to],pr, q)
end

function variable_art_power_real_tnepacdcN1(pm::_PM.AbstractPowerModel, ctg::Int; nw::Int=nw_id_default, bounded::Bool=true, report::Bool=true)
    ARpg = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:ARpg] = JuMP.@variable(pm.model,
        [i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:art_act])],# base_name="$(nw)_pg",
        start = _PM.comp_start_value(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:art_act][i], "ARpg_start", 1.0e-14)
    )

    if bounded
        for (i, gen) in pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:art_act]
            JuMP.set_lower_bound(ARpg[i], gen["pmin"])
            JuMP.set_upper_bound(ARpg[i], gen["pmax"])
        end
    end

    report && sol_component_value(pm, ctg, nw, :art_act, :ARpg, keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:art_act]), ARpg)
end

function variable_art_power_real_tnepacdcN1(pm::_PM.AbstractPowerModel, ctg::Int, pr::Vector; nw::Int=nw_id_default, bounded::Bool=true, report::Bool=true)
    ARpg = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:ARpg] = JuMP.@variable(pm.model,
        [i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:art_act]),k in pr],# base_name="$(nw)_pg",
        start = _PM.comp_start_value(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:art_act][i], "ARpg_start", 1.0e-14)
    )

    if bounded
        for k in pr
            for (i, gen) in pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:art_act]
                JuMP.set_lower_bound(ARpg[i,k], gen["pmin"])
                JuMP.set_upper_bound(ARpg[i,k], gen["pmax"])
            end
        end
    end

    report && sol_component_value(pm, ctg, nw, :art_act, :ARpg, keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:art_act]), pr, ARpg)
end

function variable_comp_power_reactive_tnepacdcN1(pm::_PM.AbstractPowerModel, ctg::Int; nw::Int=nw_id_default, bounded::Bool=true, report::Bool=true)
    RCqg = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:RCqg] = JuMP.@variable(pm.model,
        [i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:comp_react])],# base_name="$(nw)_pg",
        start = _PM.comp_start_value(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:comp_react][i], "RCqg_start")
    )

    if bounded
        for (i, gen) in pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:comp_react]
            JuMP.set_lower_bound(RCqg[i], gen["qmin"])
            JuMP.set_upper_bound(RCqg[i], gen["qmax"])
        end
    end

    report && sol_component_value(pm, ctg, nw, :comp_react, :RCqg, keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:comp_react]), RCqg)
end

function variable_comp_power_reactive_tnepacdcN1(pm::_PM.AbstractPowerModel, ctg::Int, pr::Vector; nw::Int=nw_id_default, bounded::Bool=true, report::Bool=true)
    RCqg = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:RCqg] = JuMP.@variable(pm.model,
        [i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:comp_react]),k in pr],# base_name="$(nw)_pg",
        start = _PM.comp_start_value(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:comp_react][i], "RCqg_start")
    )

    if bounded
        for k in pr
            for (i, gen) in pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:comp_react]
                JuMP.set_lower_bound(RCqg[i,k], gen["qmin"])
                JuMP.set_upper_bound(RCqg[i,k], gen["qmax"])
            end
        end
    end

    report && sol_component_value(pm, ctg, nw, :comp_react, :RCqg, keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:comp_react]), pr, RCqg)
end