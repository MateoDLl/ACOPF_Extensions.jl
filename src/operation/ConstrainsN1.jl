#ConstrainsN1
function constraint_theta_ref_tnepacdcN1(pm::_PM.AbstractPowerModel,i::Int,ctg::Int ; nw::Int=_PM.nw_id_default)
    JuMP.@constraint(pm.model, pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:va][i] == 0)
end

function constraint_theta_ref_tnepacdcN1(pm::_PM.AbstractPowerModel,i::Int,ctg::Int,pr::Int; nw::Int=_PM.nw_id_default)
    JuMP.@constraint(pm.model, pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:va][i,pr] == 0)
end

function constraint_power_balance_ac_tnepacdcN1_nAP(pm::_PM.AbstractPowerModel, i::Int, ctg::Int; nw::Int=_PM.nw_id_default)
    bus = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus][i]
    bus_arcs = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus_arcs][i]
    bus_arcs_dc = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus_arcs_dc][i]
    bus_gens = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus_gens][i]
    bus_convs_ac = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus_convs_ac][i]
    bus_loads = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus_loads][i]
    bus_shunts = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus_shunts][i]
    bus_comp = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus_comp][i]

    pd = Dict(k => pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:load][k]["pd"] for k in bus_loads) 
    qd = Dict(k => pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:load][k]["qd"] for k in bus_loads)

    gs = Dict(k => pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:shunt][k]["gs"] for k in bus_shunts)
    bs = Dict(k => pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:shunt][k]["bs"] for k in bus_shunts)

    constraint_power_balance_acN1(pm, ctg, nw, i, bus_arcs, bus_arcs_dc, bus_gens, bus_comp, bus_convs_ac, bus_loads, bus_shunts, pd, qd, gs, bs)
end

function constraint_power_balance_ac_tnepacdcN1_nAP_nRC(pm::_PM.AbstractPowerModel, i::Int, ctg::Int; nw::Int=_PM.nw_id_default)
    bus = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus][i]
    bus_arcs = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus_arcs][i]
    bus_arcs_dc = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus_arcs_dc][i]
    bus_gens = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus_gens][i]
    bus_convs_ac = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus_convs_ac][i]
    bus_loads = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus_loads][i]
    bus_shunts = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus_shunts][i]

    pd = Dict(k => pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:load][k]["pd"] for k in bus_loads) 
    qd = Dict(k => pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:load][k]["qd"] for k in bus_loads)

    gs = Dict(k => pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:shunt][k]["gs"] for k in bus_shunts)
    bs = Dict(k => pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:shunt][k]["bs"] for k in bus_shunts)

    constraint_power_balance_acN1(pm, ctg, nw, i, bus_arcs, bus_arcs_dc, bus_gens, bus_convs_ac, bus_loads, bus_shunts, pd, qd, gs, bs)
end

function constraint_power_balance_ac_tnepacdcN1(pm::_PM.AbstractPowerModel, i::Int, ctg::Int; nw::Int=_PM.nw_id_default)
    bus = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus][i]
    bus_arcs = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus_arcs][i]
    bus_arcs_dc = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus_arcs_dc][i]
    bus_gens = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus_gens][i]
    bus_convs_ac = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus_convs_ac][i]
    bus_loads = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus_loads][i]
    bus_shunts = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus_shunts][i]
    bus_art = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus_art][i]
    bus_comp = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus_comp][i]

    pd = Dict(k => pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:load][k]["pd"] for k in bus_loads) 
    qd = Dict(k => pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:load][k]["qd"] for k in bus_loads)

    gs = Dict(k => pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:shunt][k]["gs"] for k in bus_shunts)
    bs = Dict(k => pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:shunt][k]["bs"] for k in bus_shunts)

    constraint_power_balance_acN1_Arc(pm, ctg, nw, i, bus_arcs, bus_arcs_dc, bus_gens, bus_comp, bus_art, bus_convs_ac, bus_loads, bus_shunts, pd, qd, gs, bs)
end

function constraint_power_balance_ac_tnepacdcN1nrc(pm::_PM.AbstractPowerModel, i::Int, ctg::Int; nw::Int=_PM.nw_id_default)
    bus = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus][i]
    bus_arcs = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus_arcs][i]
    bus_arcs_dc = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus_arcs_dc][i]
    bus_gens = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus_gens][i]
    bus_convs_ac = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus_convs_ac][i]
    bus_loads = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus_loads][i]
    bus_shunts = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus_shunts][i]
    bus_art = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus_art][i]

    pd = Dict(k => pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:load][k]["pd"] for k in bus_loads) 
    qd = Dict(k => pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:load][k]["qd"] for k in bus_loads)

    gs = Dict(k => pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:shunt][k]["gs"] for k in bus_shunts)
    bs = Dict(k => pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:shunt][k]["bs"] for k in bus_shunts)

    constraint_power_balance_acN1_A(pm, ctg, nw, i, bus_arcs, bus_arcs_dc, bus_gens, bus_art, bus_convs_ac, bus_loads, bus_shunts, pd, qd, gs, bs)
end

function constraint_power_balance_ac_tnepacdcN1(pm::_PM.AbstractPowerModel, i::Int, ctg::Int, pr::Int; nw::Int=_PM.nw_id_default)
    bus = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus][i]
    bus_arcs = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus_arcs][i]
    bus_arcs_dc = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus_arcs_dc][i]
    bus_gens = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus_gens][i]
    bus_convs_ac = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus_convs_ac][i]
    bus_loads = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus_loads][i]
    bus_shunts = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus_shunts][i]
    bus_art = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus_art][i]
    bus_comp = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus_comp][i]
    bus_storage = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus_storage][i] 
    #pd = Dict{Int64,Dict}()
    #qd = Dict{Int64,Dict}()
    pd = Dict(k => pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:loads_VP][k][pr]["pd"] for k in bus_loads)
    qd = Dict(k => pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:loads_VP][k][pr]["qd"] for k in bus_loads)
    

    gs = Dict(k => pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:shunt][k]["gs"] for k in bus_shunts)
    bs = Dict(k => pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:shunt][k]["bs"] for k in bus_shunts)

    constraint_power_balance_acN1(pm, ctg, nw, pr, i, bus_arcs, bus_arcs_dc, bus_gens, bus_comp, bus_art, bus_convs_ac, bus_loads, bus_shunts, bus_storage, pd, qd, gs, bs)
end

function constraint_power_balance_acN1(pm::_PM.AbstractACPModel, ctg::Int, nw::Int,  i::Int, bus_arcs, bus_arcs_dc, bus_gens, bus_convs_ac, bus_loads, bus_shunts, pd, qd, gs, bs)
    p = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:p] 
    q = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:q] 
    pg = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:pg] 
    qg = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:qg] 
    pconv_grid_ac = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:pconv_tf_fr] 
    qconv_grid_ac = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:qconv_tf_fr] 

    vm = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:vm][i]
    JuMP.@NLconstraint(pm.model, sum(p[a] for a in bus_arcs) + sum(pconv_grid_ac[c] for c in bus_convs_ac)  == sum(pg[g] for g in bus_gens)  - sum(pd[d] for d in bus_loads) - sum(gs[s] for s in bus_shunts)*vm^2)
    JuMP.@NLconstraint(pm.model, sum(q[a] for a in bus_arcs) + sum(qconv_grid_ac[c] for c in bus_convs_ac)  == sum(qg[g] for g in bus_gens)  - sum(qd[d] for d in bus_loads) + sum(bs[s] for s in bus_shunts)*vm^2)
end

function constraint_power_balance_acN1(pm::_PM.AbstractACPModel, ctg::Int, nw::Int,  i::Int, bus_arcs, bus_arcs_dc, bus_gens, bus_comp, bus_convs_ac, bus_loads, bus_shunts, pd, qd, gs, bs)
    p = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:p] 
    q = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:q] 
    pg = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:pg] 
    qg = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:qg] 
    RCqg = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:RCqg] 
    pconv_grid_ac = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:pconv_tf_fr] 
    qconv_grid_ac = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:qconv_tf_fr] 
    bus_comp_prev = []
    RCqg_prev = RCqg 
    if nw > 1
        bus_comp_prev = bus_comp
        RCqg_prev = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw-1][:RCqg] 
    end

    vm = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:vm][i]
    JuMP.@NLconstraint(pm.model, sum(p[a] for a in bus_arcs) + sum(pconv_grid_ac[c] for c in bus_convs_ac)  == sum(pg[g] for g in bus_gens)   - sum(pd[d] for d in bus_loads) - sum(gs[s] for s in bus_shunts)*vm^2)
    JuMP.@NLconstraint(pm.model, sum(q[a] for a in bus_arcs) + sum(qconv_grid_ac[c] for c in bus_convs_ac)  == sum(RCqg[g] for g in bus_comp) + sum(RCqg_prev[g] for g in bus_comp_prev) + sum(qg[g] for g in bus_gens)  - sum(qd[d] for d in bus_loads) + sum(bs[s] for s in bus_shunts)*vm^2)
end

function constraint_power_balance_acN1_Arc(pm::_PM.AbstractACPModel, ctg::Int, nw::Int,  i::Int, bus_arcs, bus_arcs_dc, bus_gens, bus_comp, bus_art, bus_convs_ac, bus_loads, bus_shunts, pd, qd, gs, bs)
    p = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:p] 
    q = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:q] 
    pg = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:pg] 
    qg = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:qg] 
    RCqg = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:RCqg] 
    ARpg = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:ARpg] 
    pconv_grid_ac = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:pconv_tf_fr] 
    qconv_grid_ac = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:qconv_tf_fr] 
    bus_comp_prev = []
    RCqg_prev = RCqg 
    if nw > 1
        bus_comp_prev = bus_comp
        RCqg_prev = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw-1][:RCqg] 
    end

    vm = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:vm][i]
    JuMP.@NLconstraint(pm.model, sum(p[a] for a in bus_arcs) + sum(pconv_grid_ac[c] for c in bus_convs_ac)  == sum(ARpg[g] for g in bus_art) + sum(pg[g] for g in bus_gens)   - sum(pd[d] for d in bus_loads) - sum(gs[s] for s in bus_shunts)*vm^2)
    JuMP.@NLconstraint(pm.model, sum(q[a] for a in bus_arcs) + sum(qconv_grid_ac[c] for c in bus_convs_ac)  == sum(RCqg[g] for g in bus_comp) + sum(RCqg_prev[g] for g in bus_comp_prev) + sum(qg[g] for g in bus_gens)  - sum(qd[d] for d in bus_loads) + sum(bs[s] for s in bus_shunts)*vm^2)
end

function constraint_power_balance_acN1_A(pm::_PM.AbstractACPModel, ctg::Int, nw::Int,  i::Int, bus_arcs, bus_arcs_dc, bus_gens, bus_art, bus_convs_ac, bus_loads, bus_shunts, pd, qd, gs, bs)
    p = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:p]
    q = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:q] 
    pg = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:pg] 
    qg = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:qg] 
    ARpg = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:ARpg] 
    pconv_grid_ac = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:pconv_tf_fr] 
    qconv_grid_ac = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:qconv_tf_fr] 

    vm = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:vm][i]
    JuMP.@NLconstraint(pm.model, sum(p[a] for a in bus_arcs) + sum(pconv_grid_ac[c] for c in bus_convs_ac)  == sum(ARpg[g] for g in bus_art) + sum(pg[g] for g in bus_gens)   - sum(pd[d] for d in bus_loads) - sum(gs[s] for s in bus_shunts)*vm^2)
    JuMP.@NLconstraint(pm.model, sum(q[a] for a in bus_arcs) + sum(qconv_grid_ac[c] for c in bus_convs_ac)  == sum(qg[g] for g in bus_gens)  - sum(qd[d] for d in bus_loads) + sum(bs[s] for s in bus_shunts)*vm^2)
end

function constraint_power_balance_acN1(pm::_PM.AbstractACPModel, ctg::Int, nw::Int, pr::Int,  i::Int, bus_arcs, bus_arcs_dc, bus_gens, bus_comp, bus_art, bus_convs_ac, bus_loads, bus_shunts, bus_storage, pd, qd, gs, bs)
    p = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:p] 
    q = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:q] 
    pg = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:pg] 
    qg = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:qg] 
    RCqg = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:RCqg] 
    ARpg = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:ARpg] 
    pconv_grid_ac = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:pconv_tf_fr] 
    qconv_grid_ac = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:qconv_tf_fr] 
    ps = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:ps] 
    qs = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:qs] 
    bus_comp_prev = []
    RCqg_prev = RCqg 
    if nw > 1
        bus_comp_prev = bus_comp
        RCqg_prev = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw-1][:RCqg] 
    end

    vm = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:vm][i,pr]
    JuMP.@NLconstraint(pm.model, sum(p[a,pr] for a in bus_arcs) + sum(pconv_grid_ac[c,pr] for c in bus_convs_ac)  == sum(ARpg[g,pr] for g in bus_art) + sum(pg[g,pr] for g in bus_gens) - sum(ps[g,pr] for g in bus_storage)  - sum(pd[d] for d in bus_loads) - sum(gs[s] for s in bus_shunts)*vm^2)
    JuMP.@NLconstraint(pm.model, sum(q[a,pr] for a in bus_arcs) + sum(qconv_grid_ac[c,pr] for c in bus_convs_ac)  == sum(RCqg[g,pr] for g in bus_comp) + sum(RCqg_prev[g,pr] for g in bus_comp_prev) + sum(qg[g,pr] for g in bus_gens) - sum(qs[g,pr] for g in bus_storage)  - sum(qd[d] for d in bus_loads) + sum(bs[s] for s in bus_shunts)*vm^2)
  
end

function constraint_comp_reactive_tnepacdcN1(pm::_PM.AbstractPowerModel, i::Int, ctg::Int; nw::Int=_PM.nw_id_default)
    bus_comp = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus_comp][i]
    if !isempty(bus_comp) == true
        RCqg1 = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:RCqg][bus_comp[1]]
        RCqg2 = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:RCqg][bus_comp[2]]
        JuMP.@NLconstraint(pm.model, RCqg1*RCqg2  == 0)
        # if ctg > 1
        #     RCqg1_a = pm.var[:it][_PM.pm_it_sym][:nw][ctg-1][nw][:RCqg][bus_comp[1]]
        #     RCqg2_a = pm.var[:it][_PM.pm_it_sym][:nw][ctg-1][nw][:RCqg][bus_comp[2]]
        #     @constraint(pm.model, RCqg1 == RCqg1_a)
        #     @constraint(pm.model, RCqg2 == RCqg2_a)
        # end
    end
end

function constraint_comp_reactive_tnepacdcN1(pm::_PM.AbstractPowerModel, i::Int, ctg::Int, pr::Int; nw::Int=_PM.nw_id_default)
    bus_comp = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus_comp][i]
    if !isempty(bus_comp) == true
        RCqg1 = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:RCqg][bus_comp[1],pr]
        RCqg2 = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:RCqg][bus_comp[2],pr]
        JuMP.@NLconstraint(pm.model, RCqg1*RCqg2  == 0)
        if pr > 1
            RCqg1_a = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:RCqg][bus_comp[1],pr-1]
            RCqg2_a = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:RCqg][bus_comp[2],pr-1]
            JuMP.@constraint(pm.model, RCqg1 == RCqg1_a)
            JuMP.@constraint(pm.model, RCqg2 == RCqg2_a)
        end
    end
end

function constraint_art_tnepacdcN1(pm::_PM.AbstractPowerModel, i::Int, ctg::Int; nw::Int=_PM.nw_id_default)
    bus_art = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus_art][i]
    if !isempty(bus_art)
        ARpg = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:ARpg][bus_art[1]]
        JuMP.@constraint(pm.model, ARpg*1e6 >= 0.0)
    end
end

function constraint_art_tnepacdcN1(pm::_PM.AbstractPowerModel, i::Int, ctg::Int, pr::Int; nw::Int=_PM.nw_id_default)
    bus_art = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus_art][i]
    if !isempty(bus_art) == true
        ARpg = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:ARpg][bus_art[1],pr]
        JuMP.@constraint(pm.model, ARpg*1e6 >= 0.0)
    end
end

function constraint_ohms_yt_from_tnepacdcN1(pm::_PM.AbstractPowerModel, i::Int, ctg::Int; nw::Int=nw_id_default)
    branch = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:branch][i]
    f_bus = branch["f_bus"]
    t_bus = branch["t_bus"]
    f_idx = (i, f_bus, t_bus)
    t_idx = (i, t_bus, f_bus)

    g, b = _PM.calc_branch_y(branch)
    tr, ti = _PM.calc_branch_t(branch)
    g_fr = branch["g_fr"]
    b_fr = branch["b_fr"]
    tm = branch["tap"]

    constraint_ohms_yt_fromN1(pm, ctg, nw, f_bus, t_bus, f_idx, t_idx, g, b, g_fr, b_fr, tr, ti, tm)
end
function constraint_ohms_yt_fromN1(pm::_PM.AbstractACPModel, ctg::Int, n::Int, f_bus, t_bus, f_idx, t_idx, g, b, g_fr, b_fr, tr, ti, tm)
    p_fr  = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:p][f_idx]
    q_fr  = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:q][f_idx]
    vm_fr = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:vm][f_bus]
    vm_to = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:vm][t_bus]
    va_fr = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:va][f_bus]
    va_to = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:va][t_bus]

    JuMP.@NLconstraint(pm.model, p_fr ==  (g+g_fr)/tm^2*vm_fr^2 + (-g*tr+b*ti)/tm^2*(vm_fr*vm_to*cos(va_fr-va_to)) + (-b*tr-g*ti)/tm^2*(vm_fr*vm_to*sin(va_fr-va_to)) )
    JuMP.@NLconstraint(pm.model, q_fr == -(b+b_fr)/tm^2*vm_fr^2 - (-b*tr-g*ti)/tm^2*(vm_fr*vm_to*cos(va_fr-va_to)) + (-g*tr+b*ti)/tm^2*(vm_fr*vm_to*sin(va_fr-va_to)) ) 
end

function constraint_ohms_yt_from_tnepacdcN1(pm::_PM.AbstractPowerModel, i::Int, ctg::Int, pr::Int; nw::Int=nw_id_default)
    branch = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:branch][i]
    f_bus = branch["f_bus"]
    t_bus = branch["t_bus"]
    f_idx = (i, f_bus, t_bus)
    t_idx = (i, t_bus, f_bus)

    g, b = _PM.calc_branch_y(branch)
    tr, ti = _PM.calc_branch_t(branch)
    g_fr = branch["g_fr"]
    b_fr = branch["b_fr"]
    tm = branch["tap"]

    constraint_ohms_yt_fromN1(pm, ctg, nw, pr, f_bus, t_bus, f_idx, t_idx, g, b, g_fr, b_fr, tr, ti, tm)
end
function constraint_ohms_yt_fromN1(pm::_PM.AbstractACPModel, ctg::Int, n::Int, pr::Int, f_bus, t_bus, f_idx, t_idx, g, b, g_fr, b_fr, tr, ti, tm)
    p_fr  = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:p][f_idx,pr]
    q_fr  = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:q][f_idx,pr]
    vm_fr = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:vm][f_bus,pr]
    vm_to = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:vm][t_bus,pr]
    va_fr = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:va][f_bus,pr]
    va_to = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:va][t_bus,pr]

    JuMP.@NLconstraint(pm.model, p_fr ==  (g+g_fr)/tm^2*vm_fr^2 + (-g*tr+b*ti)/tm^2*(vm_fr*vm_to*cos(va_fr-va_to)) + (-b*tr-g*ti)/tm^2*(vm_fr*vm_to*sin(va_fr-va_to)) )
    JuMP.@NLconstraint(pm.model, q_fr == -(b+b_fr)/tm^2*vm_fr^2 - (-b*tr-g*ti)/tm^2*(vm_fr*vm_to*cos(va_fr-va_to)) + (-g*tr+b*ti)/tm^2*(vm_fr*vm_to*sin(va_fr-va_to)) ) 
end


""
function constraint_ohms_yt_to_tnepacdcN1(pm::_PM.AbstractPowerModel, i::Int, ctg::Int; nw::Int=nw_id_default)
    branch = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:branch][i]
    f_bus = branch["f_bus"]
    t_bus = branch["t_bus"]
    f_idx = (i, f_bus, t_bus)
    t_idx = (i, t_bus, f_bus)

    g, b = _PM.calc_branch_y(branch)
    tr, ti = _PM.calc_branch_t(branch)
    g_to = branch["g_to"]
    b_to = branch["b_to"]
    tm = branch["tap"]

    constraint_ohms_yt_toN1(pm, ctg, nw, f_bus, t_bus, f_idx, t_idx, g, b, g_to, b_to, tr, ti, tm)
end

function constraint_ohms_yt_toN1(pm::_PM.AbstractACPModel, ctg::Int, n::Int, f_bus, t_bus, f_idx, t_idx, g, b, g_to, b_to, tr, ti, tm) 
    p_to  = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:p][t_idx]
    q_to  = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:q][t_idx]
    vm_fr = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:vm][f_bus]
    vm_to = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:vm][t_bus]
    va_fr = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:va][f_bus]
    va_to = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:va][t_bus]

    JuMP.@NLconstraint(pm.model, p_to ==  (g+g_to)*vm_to^2 + (-g*tr-b*ti)/tm^2*(vm_to*vm_fr*cos(va_to-va_fr)) + (-b*tr+g*ti)/tm^2*(vm_to*vm_fr*sin(va_to-va_fr)) )
    JuMP.@NLconstraint(pm.model, q_to == -(b+b_to)*vm_to^2 - (-b*tr+g*ti)/tm^2*(vm_to*vm_fr*cos(va_to-va_fr)) + (-g*tr-b*ti)/tm^2*(vm_to*vm_fr*sin(va_to-va_fr)) )
end

function constraint_ohms_yt_to_tnepacdcN1(pm::_PM.AbstractPowerModel, i::Int, ctg::Int, pr::Int; nw::Int=nw_id_default)
    branch = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:branch][i]
    f_bus = branch["f_bus"]
    t_bus = branch["t_bus"]
    f_idx = (i, f_bus, t_bus)
    t_idx = (i, t_bus, f_bus)

    g, b = _PM.calc_branch_y(branch)
    tr, ti = _PM.calc_branch_t(branch)
    g_to = branch["g_to"]
    b_to = branch["b_to"]
    tm = branch["tap"]

    constraint_ohms_yt_toN1(pm, ctg, nw, pr, f_bus, t_bus, f_idx, t_idx, g, b, g_to, b_to, tr, ti, tm)
end

function constraint_ohms_yt_toN1(pm::_PM.AbstractACPModel, ctg::Int, n::Int, pr::Int, f_bus, t_bus, f_idx, t_idx, g, b, g_to, b_to, tr, ti, tm) 
    p_to  = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:p][t_idx,pr]
    q_to  = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:q][t_idx,pr]
    vm_fr = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:vm][f_bus,pr]
    vm_to = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:vm][t_bus,pr]
    va_fr = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:va][f_bus,pr]
    va_to = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:va][t_bus,pr]

    JuMP.@NLconstraint(pm.model, p_to ==  (g+g_to)*vm_to^2 + (-g*tr-b*ti)/tm^2*(vm_to*vm_fr*cos(va_to-va_fr)) + (-b*tr+g*ti)/tm^2*(vm_to*vm_fr*sin(va_to-va_fr)) )
    JuMP.@NLconstraint(pm.model, q_to == -(b+b_to)*vm_to^2 - (-b*tr+g*ti)/tm^2*(vm_to*vm_fr*cos(va_to-va_fr)) + (-g*tr-b*ti)/tm^2*(vm_to*vm_fr*sin(va_to-va_fr)) )
end

function constraint_voltage_angle_difference_tnepacdcN1(pm::_PM.AbstractPowerModel, i::Int, ctg::Int; nw::Int=nw_id_default)
    branch = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:branch][i]
    f_bus = branch["f_bus"]
    t_bus = branch["t_bus"]
    f_idx = (i, f_bus, t_bus)
    pair = (f_bus, t_bus)
    buspair = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:buspairs][pair]
    if buspair["branch"] == i
        constraint_voltage_angle_differenceN1(pm, ctg, nw, f_idx, buspair["angmin"], buspair["angmax"])
    end
end

function constraint_voltage_angle_differenceN1(pm::_PM.AbstractPolarModels, ctg::Int, n::Int, f_idx, angmin, angmax)
    i, f_bus, t_bus = f_idx
    va_fr = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:va][f_bus]
    va_to = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:va][t_bus]
    JuMP.@constraint(pm.model, va_fr - va_to <= angmax)
    JuMP.@constraint(pm.model, va_fr - va_to >= angmin)
end

function constraint_voltage_angle_difference_tnepacdcN1(pm::_PM.AbstractPowerModel, i::Int, ctg::Int, pr::Int; nw::Int=nw_id_default)
    branch = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:branch][i]
    f_bus = branch["f_bus"]
    t_bus = branch["t_bus"]
    f_idx = (i, f_bus, t_bus)
    pair = (f_bus, t_bus)
    buspair = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:buspairs][pair]
    if buspair["branch"] == i
        constraint_voltage_angle_differenceN1(pm, ctg, nw, pr, f_idx, buspair["angmin"], buspair["angmax"])
    end
end

function constraint_voltage_angle_differenceN1(pm::_PM.AbstractPolarModels, ctg::Int, n::Int, pr::Int, f_idx, angmin, angmax)
    i, f_bus, t_bus = f_idx
    va_fr = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:va][f_bus,pr]
    va_to = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:va][t_bus,pr]
    JuMP.@constraint(pm.model, va_fr - va_to <= angmax)
    JuMP.@constraint(pm.model, va_fr - va_to >= angmin)
end

function constraint_thermal_limit_from_tnepacdcN1(pm::_PM.AbstractPowerModel, i::Int, ctg::Int; nw::Int=nw_id_default)
    branch = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:branch][i]
    f_bus = branch["f_bus"]
    t_bus = branch["t_bus"]
    f_idx = (i, f_bus, t_bus)

    if haskey(branch, "rate_a")
        constraint_thermal_limit_fromN1(pm, ctg, nw, f_idx, branch["rate_a"])
    end
end

# Generic thermal limit constraint
"`p[f_idx]^2 + q[f_idx]^2 <= rate_a^2`"
function constraint_thermal_limit_fromN1(pm::_PM.AbstractPowerModel, ctg::Int, n::Int, f_idx, rate_a)
    p_fr = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:p][f_idx]
    q_fr = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:q][f_idx]

    JuMP.@constraint(pm.model, p_fr^2 + q_fr^2 <= rate_a^2)
end

function constraint_thermal_limit_from_tnepacdcN1(pm::_PM.AbstractPowerModel, i::Int, ctg::Int, pr::Int; nw::Int=nw_id_default)
    branch = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:branch][i]
    f_bus = branch["f_bus"]
    t_bus = branch["t_bus"]
    f_idx = (i, f_bus, t_bus)

    if haskey(branch, "rate_a")
        constraint_thermal_limit_fromN1(pm, ctg, nw, pr, f_idx, branch["rate_a"])
    end
end

# Generic thermal limit constraint
"`p[f_idx]^2 + q[f_idx]^2 <= rate_a^2`"
function constraint_thermal_limit_fromN1(pm::_PM.AbstractPowerModel, ctg::Int, n::Int, pr::Int, f_idx, rate_a)
    p_fr = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:p][f_idx,pr]
    q_fr = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:q][f_idx,pr]

    JuMP.@constraint(pm.model, p_fr^2 + q_fr^2 <= rate_a^2)
end

function constraint_thermal_limit_to_tnepacdcN1(pm::_PM.AbstractPowerModel, i::Int, ctg::Int; nw::Int=nw_id_default)
    branch = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:branch][i]
    f_bus = branch["f_bus"]
    t_bus = branch["t_bus"]
    t_idx = (i, t_bus, f_bus)

    if haskey(branch, "rate_a")
        constraint_thermal_limit_toN1(pm, ctg, nw, t_idx, branch["rate_a"])
    end
end
"`p[t_idx]^2 + q[t_idx]^2 <= rate_a^2`"
function constraint_thermal_limit_toN1(pm::_PM.AbstractPowerModel, ctg::Int, n::Int, t_idx, rate_a)
    p_to = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:p][t_idx]
    q_to = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:q][t_idx]

    JuMP.@constraint(pm.model, p_to^2 + q_to^2 <= rate_a^2)
end

function constraint_thermal_limit_to_tnepacdcN1(pm::_PM.AbstractPowerModel, i::Int, ctg::Int, pr::Int; nw::Int=nw_id_default)
    branch = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:branch][i]
    f_bus = branch["f_bus"]
    t_bus = branch["t_bus"]
    t_idx = (i, t_bus, f_bus)

    if haskey(branch, "rate_a")
        constraint_thermal_limit_toN1(pm, ctg, nw, pr, t_idx, branch["rate_a"])
    end
end
"`p[t_idx]^2 + q[t_idx]^2 <= rate_a^2`"
function constraint_thermal_limit_toN1(pm::_PM.AbstractPowerModel, ctg::Int, n::Int, pr::Int, t_idx, rate_a)
    p_to = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:p][t_idx,pr]
    q_to = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:q][t_idx,pr]

    JuMP.@constraint(pm.model, p_to^2 + q_to^2 <= rate_a^2)
end

function constraint_power_balance_ac_tnepacdcN1_oAC(pm::_PM.AbstractPowerModel, i::Int, ctg::Int; nw::Int=_PM.nw_id_default)
    bus = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus][i]
    bus_arcs = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus_arcs][i]
    # bus_arcs_dc = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus_arcs_dc][i]
    bus_gens = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus_gens][i]
    # bus_convs_ac = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus_convs_ac][i]
    bus_loads = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus_loads][i]
    bus_shunts = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus_shunts][i]
    bus_art = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus_art][i]
    bus_comp = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus_comp][i]

    pd = Dict(k => pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:load][k]["pd"] for k in bus_loads) 
    qd = Dict(k => pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:load][k]["qd"] for k in bus_loads)

    gs = Dict(k => pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:shunt][k]["gs"] for k in bus_shunts)
    bs = Dict(k => pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:shunt][k]["bs"] for k in bus_shunts)

    constraint_power_balance_acN1_Arc(pm, ctg, nw, i, bus_arcs, bus_gens, bus_comp, bus_art, bus_loads, bus_shunts, pd, qd, gs, bs)
end

function constraint_power_balance_ac_tnepacdcN1nrc_oAC(pm::_PM.AbstractPowerModel, i::Int, ctg::Int; nw::Int=_PM.nw_id_default)
    bus = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus][i]
    bus_arcs = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus_arcs][i]
    # bus_arcs_dc = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus_arcs_dc][i]
    bus_gens = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus_gens][i]
    # bus_convs_ac = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus_convs_ac][i]
    bus_loads = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus_loads][i]
    bus_shunts = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus_shunts][i]
    bus_art = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus_art][i]

    pd = Dict(k => pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:load][k]["pd"] for k in bus_loads) 
    qd = Dict(k => pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:load][k]["qd"] for k in bus_loads)

    gs = Dict(k => pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:shunt][k]["gs"] for k in bus_shunts)
    bs = Dict(k => pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:shunt][k]["bs"] for k in bus_shunts)

    constraint_power_balance_acN1_A(pm, ctg, nw, i, bus_arcs, bus_gens, bus_art, bus_loads, bus_shunts, pd, qd, gs, bs)
end

function constraint_power_balance_ac_tnepacdcN1_nAP_oAC(pm::_PM.AbstractPowerModel, i::Int, ctg::Int; nw::Int=_PM.nw_id_default)
    bus = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus][i]
    bus_arcs = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus_arcs][i]
    bus_gens = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus_gens][i]
    bus_loads = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus_loads][i]
    bus_shunts = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus_shunts][i]
    bus_comp = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus_comp][i]

    pd = Dict(k => pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:load][k]["pd"] for k in bus_loads) 
    qd = Dict(k => pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:load][k]["qd"] for k in bus_loads)

    gs = Dict(k => pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:shunt][k]["gs"] for k in bus_shunts)
    bs = Dict(k => pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:shunt][k]["bs"] for k in bus_shunts)

    constraint_power_balance_acN1(pm, ctg, nw, i, bus_arcs, bus_gens, bus_comp, bus_loads, bus_shunts, pd, qd, gs, bs)
end

function constraint_power_balance_ac_tnepacdcN1_nAP_nRC_oAC(pm::_PM.AbstractPowerModel, i::Int, ctg::Int; nw::Int=_PM.nw_id_default)
    bus = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus][i]
    bus_arcs = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus_arcs][i]
    # bus_arcs_dc = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus_arcs_dc][i]
    bus_gens = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus_gens][i]
    # bus_convs_ac = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus_convs_ac][i]
    bus_loads = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus_loads][i]
    bus_shunts = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus_shunts][i]

    pd = Dict(k => pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:load][k]["pd"] for k in bus_loads) 
    qd = Dict(k => pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:load][k]["qd"] for k in bus_loads)

    gs = Dict(k => pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:shunt][k]["gs"] for k in bus_shunts)
    bs = Dict(k => pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:shunt][k]["bs"] for k in bus_shunts)

    constraint_power_balance_acN1(pm, ctg, nw, i, bus_arcs, bus_gens, bus_loads, bus_shunts, pd, qd, gs, bs)
end

function constraint_power_balance_acN1(pm::_PM.AbstractACPModel, ctg::Int, nw::Int,  i::Int, bus_arcs, bus_gens, bus_loads, bus_shunts, pd, qd, gs, bs)
    p = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:p] 
    q = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:q] 
    pg = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:pg] 
    qg = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:qg] 

    vm = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:vm][i]
    JuMP.@NLconstraint(pm.model, sum(p[a] for a in bus_arcs) == sum(pg[g] for g in bus_gens)  - sum(pd[d] for d in bus_loads) - sum(gs[s] for s in bus_shunts)*vm^2)
    JuMP.@NLconstraint(pm.model, sum(q[a] for a in bus_arcs) == sum(qg[g] for g in bus_gens)  - sum(qd[d] for d in bus_loads) + sum(bs[s] for s in bus_shunts)*vm^2)
end

function constraint_power_balance_acN1(pm::_PM.AbstractACPModel, ctg::Int, nw::Int,  i::Int, bus_arcs, bus_gens, bus_comp, bus_loads, bus_shunts, pd, qd, gs, bs)
    p = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:p] 
    q = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:q] 
    pg = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:pg] 
    qg = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:qg] 
    RCqg = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:RCqg] 
    bus_comp_prev = []
    RCqg_prev = RCqg 
    if nw > 1
        bus_comp_prev = bus_comp
        RCqg_prev = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw-1][:RCqg] 
    end

    vm = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:vm][i]
    JuMP.@NLconstraint(pm.model, sum(p[a] for a in bus_arcs)  == sum(pg[g] for g in bus_gens)   - sum(pd[d] for d in bus_loads) - sum(gs[s] for s in bus_shunts)*vm^2)
    JuMP.@NLconstraint(pm.model, sum(q[a] for a in bus_arcs)  == sum(RCqg[g] for g in bus_comp) + sum(RCqg_prev[g] for g in bus_comp_prev) + sum(qg[g] for g in bus_gens)  - sum(qd[d] for d in bus_loads) + sum(bs[s] for s in bus_shunts)*vm^2)
end

function constraint_power_balance_acN1_Arc(pm::_PM.AbstractACPModel, ctg::Int, nw::Int,  i::Int, bus_arcs, bus_gens, bus_comp, bus_art, bus_loads, bus_shunts, pd, qd, gs, bs)
    p = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:p] 
    q = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:q] 
    pg = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:pg] 
    qg = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:qg] 
    RCqg = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:RCqg] 
    ARpg = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:ARpg]  
    bus_comp_prev = []
    RCqg_prev = RCqg 
    if nw > 1
        bus_comp_prev = bus_comp
        RCqg_prev = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw-1][:RCqg] 
    end

    vm = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:vm][i]
    JuMP.@NLconstraint(pm.model, sum(p[a] for a in bus_arcs) == sum(ARpg[g] for g in bus_art) + sum(pg[g] for g in bus_gens)   - sum(pd[d] for d in bus_loads) - sum(gs[s] for s in bus_shunts)*vm^2)
    JuMP.@NLconstraint(pm.model, sum(q[a] for a in bus_arcs) == sum(RCqg[g] for g in bus_comp) + sum(RCqg_prev[g] for g in bus_comp_prev) + sum(qg[g] for g in bus_gens)  - sum(qd[d] for d in bus_loads) + sum(bs[s] for s in bus_shunts)*vm^2)
end

function constraint_power_balance_acN1_A(pm::_PM.AbstractACPModel, ctg::Int, nw::Int,  i::Int, bus_arcs, bus_gens, bus_art, bus_loads, bus_shunts, pd, qd, gs, bs)
    p = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:p]
    q = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:q] 
    pg = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:pg] 
    qg = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:qg] 
    ARpg = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:ARpg] 

    vm = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:vm][i]
    JuMP.@NLconstraint(pm.model, sum(p[a] for a in bus_arcs) == sum(ARpg[g] for g in bus_art) + sum(pg[g] for g in bus_gens)   - sum(pd[d] for d in bus_loads) - sum(gs[s] for s in bus_shunts)*vm^2)
    JuMP.@NLconstraint(pm.model, sum(q[a] for a in bus_arcs) == sum(qg[g] for g in bus_gens)  - sum(qd[d] for d in bus_loads) + sum(bs[s] for s in bus_shunts)*vm^2)
end