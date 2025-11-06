#Integers Variables_Constrains

function constraint_storage_complementarity_mi_tnepacdcN1(pm::_PM.AbstractPowerModel, i::Int, ctg::Int, pr::Int; nw::Int=nw_id_default)
    
    sc = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:sc][i,pr]
    sd = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:sd][i,pr]

    JuMP.@NLconstraint(pm.model, sc*sd == 0.0)
end



#Constrains Storage
function constraint_storage_losses_tnepacdcN1(pm::_PM.AbstractPowerModel, i::Int, ctg::Int, pr::Int; nw::Int=nw_id_default)
    storage = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:storage][i] 
    constraint_storage_lossesN1(pm, ctg, nw, pr, i, storage["storage_bus"], storage["r"], storage["x"], storage["p_loss"], storage["q_loss"])
end

function constraint_storage_lossesN1(pm::_PM.AbstractACPModel, ctg::Int, nw::Int, pr::Int, i, bus, r, x, p_loss, q_loss; conductors=[1])
    vm = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:vm][bus,pr]
    ps = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:ps][i,pr]
    qs = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:qs][i,pr]
    sc = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:sc][i,pr]
    sd = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:sd][i,pr]
    qsc = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:qsc][i,pr]

    JuMP.@NLconstraint(pm.model,
        sum(ps[c] for c in conductors) + (sd - sc)
        ==
        p_loss + sum(r[c]*(ps[c]^2 + qs[c]^2)/vm[c]^2 for c in conductors)
    )

    JuMP.@NLconstraint(pm.model,
        sum(qs[c] for c in conductors)
        ==
        qsc + q_loss + sum(x[c]*(ps[c]^2 + qs[c]^2)/vm[c]^2 for c in conductors)
    )
end


function constraint_storage_thermal_limit_tnepacdcN1(pm::_PM.AbstractPowerModel, i::Int, ctg::Int, pr::Int; nw::Int=nw_id_default)
    storage = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:storage][i] 
    constraint_storage_thermal_limitN1(pm, ctg, nw, pr, i, storage["thermal_rating"])
end
function constraint_storage_thermal_limitN1(pm::_PM.AbstractPowerModel, ctg::Int, nw::Int, pr::Int, i, rating)
    ps = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:ps][i,pr]
    qs = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:qs][i,pr]

    JuMP.@constraint(pm.model, ps^2 + qs^2 <= rating^2)
end

function constraint_storage_state_tnepacdcN1(pm::_PM.AbstractPowerModel, ctg::Int, nw::Int, i::Int, pr::Int)
    storage = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][Symbol("P$(pr)")][i] #_PM.ref(pm, nw, :storage, i)
    

    if haskey(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw], :time_elapsed)
        time_elapsed = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:time_elapsed]
    else
        Memento.warn(_LOGGER, "network data should specify time_elapsed, using 1.0 as a default")
        time_elapsed = 1.0
    end

    constraint_storage_state_initialN1(pm, ctg, nw, i, pr, storage["energy"], storage["charge_efficiency"], storage["discharge_efficiency"], time_elapsed)
end

function constraint_storage_state_tnepacdcN1(pm::_PM.AbstractPowerModel, ctg::Int, nw::Int, i::Int, nw_1::Int, nw_2::Int)
    storage = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][Symbol("P$(nw_2)")][i]#ref(pm, nw_2, :storage, i)
    

    if haskey(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw], :time_elapsed)
        time_elapsed = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:time_elapsed]
    else
        Memento.warn(_LOGGER, "network $(nw) should specify time_elapsed, using 1.0 as a default")
        time_elapsed = 1.0
    end
     #if haskey(ref(pm, nw_1, :storage), i)
    if haskey(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][Symbol("P$(nw_1)")], i)
        constraint_storage_stateN1(pm, ctg, nw, nw_1, nw_2, i, storage["charge_efficiency"], storage["discharge_efficiency"], time_elapsed)
    else
        # if the storage device has status=0 in nw_1, then the stored energy variable will not exist. Initialize storage from data model instead.
        Memento.warn(_LOGGER, "storage component $(i) was not found in network $(nw_1) while building constraint_storage_state between networks $(nw_1) and $(nw_2). Using the energy value from the storage component in network $(nw_2) instead")
        constraint_storage_state_initialN1(pm, ctg, nw, i, nw_2,storage["energy"], storage["charge_efficiency"], storage["discharge_efficiency"], time_elapsed)
    end
end


function constraint_storage_state_initialN1(pm::_PM.AbstractPowerModel, ctg::Int, nw::Int, i::Int, k::Int, energy, charge_eff, discharge_eff, time_elapsed)
    sc = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:sc][i,k]
    sd = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:sd][i,k]
    se = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:se][i,k]

    JuMP.@constraint(pm.model, se - energy == time_elapsed*(charge_eff*sc - sd/discharge_eff))
end


function constraint_storage_stateN1(pm::_PM.AbstractPowerModel, ctg::Int, nw::Int, n_1::Int, n_2::Int, i::Int, charge_eff, discharge_eff, time_elapsed)
    if n_2 != 1
        sc_2 =  pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:sc][i,n_2] #var(pm, n_2, :sc, i)
        sd_2 =  pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:sd][i,n_2] #var(pm, n_2, :sd, i)
        se_2 =  pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:se][i,n_2] #var(pm, n_2, :se, i)
        se_1 =  pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:se][i,n_1] #var(pm, n_1, :se, i)
    else
        sc_2 =  pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:sc][i,n_2] #var(pm, n_2, :sc, i)
        sd_2 =  pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:sd][i,n_2] #var(pm, n_2, :sd, i)
        se_2 =  pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:se][i,n_2] #var(pm, n_2, :se, i)
        se_1 =  pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw-1][:se][i,n_1] #var(pm, n_1, :se, i)
    end

    JuMP.@constraint(pm.model, se_2 - se_1 == time_elapsed*(charge_eff*sc_2 - sd_2/discharge_eff))
end

