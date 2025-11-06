

#Variables Storage
function variable_storage_power_real_tnepacdcN1(pm::_PM.AbstractPowerModel, ctg::Int, pr::Vector; nw::Int=nw_id_default, bounded::Bool=true, report::Bool=true)
    ps = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:ps] = JuMP.@variable(pm.model,
        [i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:storage]),k in pr], #base_name="$(nw)_ps",
        start = _PM.comp_start_value(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:storage][i], "ps_start")
    )
    
    if bounded
        for k in pr
            inj_lb, inj_ub = _PM.ref_calc_storage_injection_bounds(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:storage], pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus])
        
            for i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:storage])
                if !isinf(inj_lb[i])
                    JuMP.set_lower_bound(ps[i,k], inj_lb[i])
                end
                if !isinf(inj_ub[i])
                    JuMP.set_upper_bound(ps[i,k], inj_ub[i])
                end
            end
        end
    end

    report && sol_component_value(pm, ctg, nw, :storage, :ps, keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:storage]), pr, ps)
end

function variable_storage_power_imaginary_tnepacdcN1(pm::_PM.AbstractPowerModel, ctg::Int, pr::Vector; nw::Int=nw_id_default, bounded::Bool=true, report::Bool=true)
    qs = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:qs] = JuMP.@variable(pm.model,
        [i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:storage]), k in pr], #base_name="$(nw)_qs",
        start = _PM.comp_start_value(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:storage][i], "qs_start")
    )

    if bounded
        for k in pr
            inj_lb, inj_ub = _PM.ref_calc_storage_injection_bounds(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:storage], pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus])

            for (i, storage) in pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:storage]
                JuMP.set_lower_bound(qs[i,k], max(inj_lb[i], storage["qmin"]))
                JuMP.set_upper_bound(qs[i,k], min(inj_ub[i], storage["qmax"]))
            end
        end
    end

    report && sol_component_value(pm, ctg, nw, :storage, :qs, keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:storage]),pr, qs)
end

function variable_storage_power_control_imaginary_tnepacdcN1(pm::_PM.AbstractPowerModel, ctg::Int, pr::Vector; nw::Int=nw_id_default, bounded::Bool=true, report::Bool=true)
    qsc = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:qsc] = JuMP.@variable(pm.model,
        [i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:storage]),k in pr], #base_name="$(nw)_qsc",
        start = _PM.comp_start_value(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:storage][i], "qsc_start")
    )

    if bounded
        for k in pr
            inj_lb, inj_ub = _PM.ref_calc_storage_injection_bounds(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:storage], pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus])

            for (i,storage) in pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:storage]
                if !isinf(inj_lb[i]) || haskey(storage, "qmin")
                    JuMP.set_lower_bound(qsc[i,k], max(inj_lb[i], get(storage, "qmin", -Inf)))
                end
                if !isinf(inj_ub[i]) || haskey(storage, "qmax")
                    JuMP.set_upper_bound(qsc[i,k], min(inj_ub[i], get(storage, "qmax",  Inf)))
                end
            end
        end
    end

    report && sol_component_value(pm, ctg, nw, :storage, :qsc, keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:storage]), pr, qsc)
end

function variable_storage_energy_tnepacdcN1(pm::_PM.AbstractPowerModel, ctg::Int, pr::Vector; nw::Int=nw_id_default, bounded::Bool=true, report::Bool=true)
    se = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:se] = JuMP.@variable(pm.model,
        [i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:storage]),k in pr], #base_name="$(nw)_se",
        start = _PM.comp_start_value(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:storage][i], "se_start", 1)
    )

    if bounded
        for k in pr
            for (i, storage) in pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:storage]
                JuMP.set_lower_bound(se[i,k], 0)
                JuMP.set_upper_bound(se[i,k], storage["energy_rating"])
            end
        end
    end

    report && sol_component_value(pm, ctg, nw, :storage, :se, keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:storage]),pr, se)
end

function variable_storage_charge_tnepacdcN1(pm::_PM.AbstractPowerModel, ctg::Int, pr::Vector; nw::Int=nw_id_default, bounded::Bool=true, report::Bool=true)
    sc = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:sc] = JuMP.@variable(pm.model,
        [i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:storage]),k in pr], #base_name="$(nw)_sc",
        start = _PM.comp_start_value(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:storage][i], "sc_start", 1)
    )
    
    if bounded
        for k in pr
            for (i, storage) in pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:storage]
                JuMP.set_lower_bound(sc[i,k], 0)
                JuMP.set_upper_bound(sc[i,k], storage["charge_rating"])
            end
        end
    end

    report && sol_component_value(pm, ctg, nw, :storage, :sc, keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:storage]), pr, sc)
end

function variable_storage_discharge_tnepacdcN1(pm::_PM.AbstractPowerModel, ctg::Int, pr::Vector; nw::Int=nw_id_default, bounded::Bool=true, report::Bool=true)
    sd = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:sd] = JuMP.@variable(pm.model,
        [i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:storage]),k in pr], #base_name="$(nw)_sd",
        start = _PM.comp_start_value(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:storage][i], "sd_start", 1)
    )

    if bounded
        for k in pr
            for (i, storage) in pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:storage]
                JuMP.set_lower_bound(sd[i,k], 0)
                JuMP.set_upper_bound(sd[i,k], storage["discharge_rating"])
            end
        end
    end

    report && sol_component_value(pm, ctg, nw, :storage, :sd, keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:storage]), pr, sd)
end