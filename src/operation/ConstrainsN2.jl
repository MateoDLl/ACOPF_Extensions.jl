#Constrains
function constraint_power_balance_dc_tnepacdcN1(pm::_PM.AbstractPowerModel, i::Int, ctg::Int; nw::Int=_PM.nw_id_default)
    bus_arcs_dcgrid = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus_arcs_dcgrid][i]
    bus_convs_dc = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus_convs_dc][i]
    pd = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:busdc][i]["Pdc"] 
    constraint_power_balance_dcN1(pm, ctg, nw, i, bus_arcs_dcgrid, bus_convs_dc, pd)
end
function constraint_power_balance_dcN1(pm::_PM.AbstractPowerModel, ctg::Int, n::Int, i::Int, bus_arcs_dcgrid, bus_convs_dc, pd)
    p_dcgrid = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:p_dcgrid]
    pconv_dc = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:pconv_dc]
    JuMP.@constraint(pm.model, sum(p_dcgrid[a] for a in bus_arcs_dcgrid) + sum(pconv_dc[c] for c in bus_convs_dc) == (-pd))
end

function constraint_power_balance_dc_tnepacdcN1(pm::_PM.AbstractPowerModel, i::Int, ctg::Int, pr::Int; nw::Int=_PM.nw_id_default)
    bus_arcs_dcgrid = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus_arcs_dcgrid][i]
    bus_convs_dc = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:bus_convs_dc][i]
    pd = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:busdc][i]["Pdc"] 
    constraint_power_balance_dcN1(pm, ctg, nw, i, pr, bus_arcs_dcgrid, bus_convs_dc, pd)
end
function constraint_power_balance_dcN1(pm::_PM.AbstractPowerModel, ctg::Int, n::Int, i::Int, pr::Int, bus_arcs_dcgrid, bus_convs_dc, pd)
    p_dcgrid = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:p_dcgrid]
    pconv_dc = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:pconv_dc]
    JuMP.@constraint(pm.model, sum(p_dcgrid[a,pr] for a in bus_arcs_dcgrid) + sum(pconv_dc[c,pr] for c in bus_convs_dc) == (-pd))
end

function constraint_ohms_dc_branch_tnepacdcN1(pm::_PM.AbstractPowerModel, i::Int, ctg::Int; nw::Int=_PM.nw_id_default)
    branch = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:branchdc][i]
    f_bus = branch["fbusdc"]
    t_bus = branch["tbusdc"]
    f_idx = (i, f_bus, t_bus)
    t_idx = (i, t_bus, f_bus)

    p = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:dcpol]

    constraint_ohms_dc_branchN1(pm, ctg, nw, f_bus, t_bus, f_idx, t_idx, branch["r"], p)
end

function constraint_ohms_dc_branchN1(pm::_PM.AbstractACPModel, ctg::Int, n::Int,  f_bus, t_bus, f_idx, t_idx, r, p)
    p_dc_fr = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:p_dcgrid][f_idx]
    p_dc_to = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:p_dcgrid][t_idx]
    vmdc_fr = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:vdcm][f_bus]
    vmdc_to = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:vdcm][t_bus]
    if r == 0
        JuMP.@constraint(pm.model, p_dc_fr + p_dc_to == 0)
    else
        g = 1 / r
        JuMP.@NLconstraint(pm.model, p_dc_fr == p * g * vmdc_fr * (vmdc_fr - vmdc_to))
        JuMP.@NLconstraint(pm.model, p_dc_to == p * g * vmdc_to * (vmdc_to - vmdc_fr))
    end
end

function constraint_ohms_dc_branch_tnepacdcN1(pm::_PM.AbstractPowerModel, i::Int, ctg::Int, pr::Int; nw::Int=_PM.nw_id_default)
    branch = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:branchdc][i]
    f_bus = branch["fbusdc"]
    t_bus = branch["tbusdc"]
    f_idx = (i, f_bus, t_bus)
    t_idx = (i, t_bus, f_bus)

    p = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:dcpol]

    constraint_ohms_dc_branchN1(pm, ctg, nw, pr, f_bus, t_bus, f_idx, t_idx, branch["r"], p)
end

function constraint_ohms_dc_branchN1(pm::_PM.AbstractACPModel, ctg::Int, n::Int, pr::Int,  f_bus, t_bus, f_idx, t_idx, r, p)
    p_dc_fr = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:p_dcgrid][f_idx,pr]
    p_dc_to = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:p_dcgrid][t_idx,pr]
    vmdc_fr = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:vdcm][f_bus,pr]
    vmdc_to = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:vdcm][t_bus,pr]
    if r == 0
        JuMP.@constraint(pm.model, p_dc_fr + p_dc_to == 0)
    else
        g = 1 / r
        JuMP.@NLconstraint(pm.model, p_dc_fr == p * g * vmdc_fr * (vmdc_fr - vmdc_to))
        JuMP.@NLconstraint(pm.model, p_dc_to == p * g * vmdc_to * (vmdc_to - vmdc_fr))
    end
end

function constraint_converter_losses_tnepacdcN1(pm::_PM.AbstractPowerModel, i::Int, ctg::Int; nw::Int=_PM.nw_id_default)
    conv = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc][i]
    a = conv["LossA"]
    b = conv["LossB"]
    c = conv["LossCinv"]
    plmax = conv["LossA"] + conv["LossB"] * conv["Pacrated"] + conv["LossCinv"] * (conv["Pacrated"])^2
    constraint_converter_lossesN1(pm, ctg, nw, i, a, b, c, plmax)
end
function constraint_converter_lossesN1(pm::_PM.AbstractACPModel, ctg::Int, n::Int, i::Int, a, b, c, plmax)
    pconv_ac = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:pconv_ac][i]
    pconv_dc = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:pconv_dc][i]
    iconv = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:iconv_ac][i]

    JuMP.@NLconstraint(pm.model, pconv_ac + pconv_dc == a + b*iconv + c*iconv^2)
end

function constraint_converter_losses_tnepacdcN1(pm::_PM.AbstractPowerModel, i::Int, ctg::Int, pr::Int; nw::Int=_PM.nw_id_default)
    conv = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc][i]
    a = conv["LossA"]
    b = conv["LossB"]
    c = conv["LossCinv"]
    plmax = conv["LossA"] + conv["LossB"] * conv["Pacrated"] + conv["LossCinv"] * (conv["Pacrated"])^2
    constraint_converter_lossesN1(pm, ctg, nw, pr, i, a, b, c, plmax)
end
function constraint_converter_lossesN1(pm::_PM.AbstractACPModel, ctg::Int, n::Int, pr::Int, i::Int, a, b, c, plmax)
    pconv_ac = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:pconv_ac][i,pr]
    pconv_dc = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:pconv_dc][i,pr]
    iconv = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:iconv_ac][i,pr]

    JuMP.@NLconstraint(pm.model, pconv_ac + pconv_dc == a + b*iconv + c*iconv^2)
end

function constraint_converter_current_tnepacdcN1(pm::_PM.AbstractPowerModel, i::Int, ctg::Int; nw::Int=_PM.nw_id_default)
    conv = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc][i]
    Vmax = conv["Vmmax"]
    Imax = conv["Imax"]
    constraint_converter_currentN1(pm, ctg, nw, i, Vmax, Imax)
end
function constraint_converter_currentN1(pm::_PM.AbstractACPModel, ctg::Int, n::Int, i::Int, Umax, Imax)
    vmc = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:vmc][i]
    pconv_ac = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:pconv_ac][i]
    qconv_ac = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:qconv_ac][i]
    iconv = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:iconv_ac][i]

    JuMP.@NLconstraint(pm.model, pconv_ac^2 + qconv_ac^2 == vmc^2 * iconv^2)
end

function constraint_converter_current_tnepacdcN1(pm::_PM.AbstractPowerModel, i::Int, ctg::Int, pr::Int; nw::Int=_PM.nw_id_default)
    conv = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc][i]
    Vmax = conv["Vmmax"]
    Imax = conv["Imax"]
    constraint_converter_currentN1(pm, ctg, nw, pr, i, Vmax, Imax)
end
function constraint_converter_currentN1(pm::_PM.AbstractACPModel, ctg::Int, n::Int, pr::Int, i::Int, Umax, Imax)
    vmc = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:vmc][i,pr]
    pconv_ac = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:pconv_ac][i,pr]
    qconv_ac = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:qconv_ac][i,pr]
    iconv = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:iconv_ac][i,pr]

    JuMP.@NLconstraint(pm.model, pconv_ac^2 + qconv_ac^2 == vmc^2 * iconv^2)
end

function constraint_conv_transformer_tnepacdcN1(pm::_PM.AbstractPowerModel, i::Int, ctg::Int; nw::Int=_PM.nw_id_default)
    conv = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc][i]
    constraint_conv_transformerN1(pm, ctg, nw, i, conv["rtf"], conv["xtf"], conv["busac_i"], conv["tm"], Bool(conv["transformer"]))
end
function constraint_conv_transformerN1(pm::_PM.AbstractACPModel, ctg::Int, n::Int, i::Int, rtf, xtf, acbus, tm, transformer)
    ptf_fr = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:pconv_tf_fr][i]
    qtf_fr = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:qconv_tf_fr][i]
    ptf_to = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:pconv_tf_to][i]
    qtf_to = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:qconv_tf_to][i]

    vm = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:vm][acbus]
    va = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:va][acbus]
    vmf = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:vmf][i]
    vaf = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:vaf][i]

    ztf = rtf + im*xtf
    if transformer
        ytf = 1/(rtf + im*xtf)
        gtf = real(ytf)
        btf = imag(ytf)
        gtf_sh = 0
        c1, c2, c3, c4 = ac_power_flow_constraintsN1(pm.model, gtf, btf, gtf_sh, vm, vmf, va, vaf, ptf_fr, ptf_to, qtf_fr, qtf_to, tm)
    else
        JuMP.@constraint(pm.model, ptf_fr + ptf_to == 0)
        JuMP.@constraint(pm.model, qtf_fr + qtf_to == 0)
        JuMP.@constraint(pm.model, va == vaf)
        JuMP.@constraint(pm.model, vm == vmf)
    end
end
"constraints for a voltage magnitude transformer + series impedance"

function constraint_conv_transformer_tnepacdcN1(pm::_PM.AbstractPowerModel, i::Int, ctg::Int, pr::Int; nw::Int=_PM.nw_id_default)
    conv = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc][i]
    constraint_conv_transformerN1(pm, ctg, nw, pr, i, conv["rtf"], conv["xtf"], conv["busac_i"], conv["tm"], Bool(conv["transformer"]))
end
function constraint_conv_transformerN1(pm::_PM.AbstractACPModel, ctg::Int, n::Int, pr::Int, i::Int, rtf, xtf, acbus, tm, transformer)
    ptf_fr = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:pconv_tf_fr][i,pr]
    qtf_fr = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:qconv_tf_fr][i,pr]
    ptf_to = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:pconv_tf_to][i,pr]
    qtf_to = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:qconv_tf_to][i,pr]

    vm = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:vm][acbus,pr]
    va = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:va][acbus,pr]
    vmf = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:vmf][i,pr]
    vaf = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:vaf][i,pr]

    ztf = rtf + im*xtf
    if transformer
        ytf = 1/(rtf + im*xtf)
        gtf = real(ytf)
        btf = imag(ytf)
        gtf_sh = 0
        c1, c2, c3, c4 = ac_power_flow_constraintsN1(pm.model, gtf, btf, gtf_sh, vm, vmf, va, vaf, ptf_fr, ptf_to, qtf_fr, qtf_to, tm)
    else
        JuMP.@constraint(pm.model, ptf_fr + ptf_to == 0)
        JuMP.@constraint(pm.model, qtf_fr + qtf_to == 0)
        JuMP.@constraint(pm.model, va == vaf)
        JuMP.@constraint(pm.model, vm == vmf)
    end
end
"constraints for a voltage magnitude transformer + series impedance"
function ac_power_flow_constraintsN1(model, g, b, gsh_fr, vm_fr, vm_to, va_fr, va_to, p_fr, p_to, q_fr, q_to, tm)
    c1 = JuMP.@NLconstraint(model, p_fr ==  g/(tm^2)*vm_fr^2 + -g/(tm)*vm_fr*vm_to * cos(va_fr-va_to) + -b/(tm)*vm_fr*vm_to*sin(va_fr-va_to))
    c2 = JuMP.@NLconstraint(model, q_fr == -b/(tm^2)*vm_fr^2 +  b/(tm)*vm_fr*vm_to * cos(va_fr-va_to) + -g/(tm)*vm_fr*vm_to*sin(va_fr-va_to))
    c3 = JuMP.@NLconstraint(model, p_to ==  g*vm_to^2 + -g/(tm)*vm_to*vm_fr  *    cos(va_to - va_fr)     + -b/(tm)*vm_to*vm_fr    *sin(va_to - va_fr))
    c4 = JuMP.@NLconstraint(model, q_to == -b*vm_to^2 +  b/(tm)*vm_to*vm_fr  *    cos(va_to - va_fr)     + -g/(tm)*vm_to*vm_fr    *sin(va_to - va_fr))
    return c1, c2, c3, c4
end

function constraint_conv_reactor_tnepacdcN1(pm::_PM.AbstractPowerModel, i::Int, ctg::Int; nw::Int=_PM.nw_id_default)
    conv = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc][i]
    constraint_conv_reactorN1(pm, ctg, nw, i, conv["rc"], conv["xc"], Bool(conv["reactor"]))
end
function constraint_conv_reactorN1(pm::_PM.AbstractACPModel, ctg::Int, n::Int, i::Int, rc, xc, reactor)
    pconv_ac = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:pconv_ac][i]
    qconv_ac = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:qconv_ac][i]
    ppr_to = - pconv_ac
    qpr_to = - qconv_ac
    ppr_fr = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:pconv_pr_fr][i]
    qpr_fr = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:qconv_pr_fr][i]

    vmf = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:vmf][i]
    vaf = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:vaf][i]
    vmc = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:vmc][i]
    vac = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:vac][i]

    zc = rc + im*xc
    if reactor
        yc = 1/(zc)
        gc = real(yc)
        bc = imag(yc)
        JuMP.@NLconstraint(pm.model, - pconv_ac == gc*vmc^2 + -gc*vmc*vmf*cos(vac-vaf) + -bc*vmc*vmf*sin(vac-vaf)) # JuMP doesn't allow affine expressions in NL constraints
        JuMP.@NLconstraint(pm.model, - qconv_ac ==-bc*vmc^2 +  bc*vmc*vmf*cos(vac-vaf) + -gc*vmc*vmf*sin(vac-vaf)) # JuMP doesn't allow affine expressions in NL constraints
        JuMP.@NLconstraint(pm.model, ppr_fr ==  gc *vmf^2 + -gc *vmf*vmc*cos(vaf - vac) + -bc *vmf*vmc*sin(vaf - vac))
        JuMP.@NLconstraint(pm.model, qpr_fr == -bc *vmf^2 +  bc *vmf*vmc*cos(vaf - vac) + -gc *vmf*vmc*sin(vaf - vac))
    else
        JuMP.@constraint(pm.model, ppr_fr + ppr_to == 0)
        JuMP.@constraint(pm.model, qpr_fr + qpr_to == 0)
        JuMP.@constraint(pm.model, vac == vaf)
        JuMP.@constraint(pm.model, vmc == vmf)
    end
end

function constraint_conv_reactor_tnepacdcN1(pm::_PM.AbstractPowerModel, i::Int, ctg::Int, pr::Int; nw::Int=_PM.nw_id_default)
    conv = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc][i]
    constraint_conv_reactorN1(pm, ctg, nw,pr, i, conv["rc"], conv["xc"], Bool(conv["reactor"]))
end
function constraint_conv_reactorN1(pm::_PM.AbstractACPModel, ctg::Int, n::Int, pr::Int, i::Int, rc, xc, reactor)
    pconv_ac = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:pconv_ac][i,pr]
    qconv_ac = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:qconv_ac][i,pr]
    ppr_to = - pconv_ac
    qpr_to = - qconv_ac
    ppr_fr = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:pconv_pr_fr][i,pr]
    qpr_fr = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:qconv_pr_fr][i,pr]

    vmf = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:vmf][i,pr]
    vaf = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:vaf][i,pr]
    vmc = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:vmc][i,pr]
    vac = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:vac][i,pr]

    zc = rc + im*xc
    if reactor
        yc = 1/(zc)
        gc = real(yc)
        bc = imag(yc)
        JuMP.@NLconstraint(pm.model, - pconv_ac == gc*vmc^2 + -gc*vmc*vmf*cos(vac-vaf) + -bc*vmc*vmf*sin(vac-vaf)) # JuMP doesn't allow affine expressions in NL constraints
        JuMP.@NLconstraint(pm.model, - qconv_ac ==-bc*vmc^2 +  bc*vmc*vmf*cos(vac-vaf) + -gc*vmc*vmf*sin(vac-vaf)) # JuMP doesn't allow affine expressions in NL constraints
        JuMP.@NLconstraint(pm.model, ppr_fr ==  gc *vmf^2 + -gc *vmf*vmc*cos(vaf - vac) + -bc *vmf*vmc*sin(vaf - vac))
        JuMP.@NLconstraint(pm.model, qpr_fr == -bc *vmf^2 +  bc *vmf*vmc*cos(vaf - vac) + -gc *vmf*vmc*sin(vaf - vac))
    else
        JuMP.@constraint(pm.model, ppr_fr + ppr_to == 0)
        JuMP.@constraint(pm.model, qpr_fr + qpr_to == 0)
        JuMP.@constraint(pm.model, vac == vaf)
        JuMP.@constraint(pm.model, vmc == vmf)
    end
end

function constraint_conv_filter_tnepacdcN1(pm::_PM.AbstractPowerModel, i::Int, ctg::Int; nw::Int=_PM.nw_id_default)
    conv = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc][i]
    constraint_conv_filterN1(pm, ctg, nw, i, conv["bf"], Bool(conv["filter"]) )
end
function constraint_conv_filterN1(pm::_PM.AbstractACPModel, ctg::Int, n::Int, i::Int, bv, filter)
    ppr_fr = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:pconv_pr_fr][i]
    qpr_fr = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:qconv_pr_fr][i]
    ptf_to = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:pconv_tf_to][i]
    qtf_to = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:qconv_tf_to][i]

    vmf = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:vmf][i]

    JuMP.@constraint(pm.model,   ppr_fr + ptf_to == 0 )
    JuMP.@NLconstraint(pm.model, qpr_fr + qtf_to +  (-bv) * filter *vmf^2 == 0)
end

function constraint_conv_filter_tnepacdcN1(pm::_PM.AbstractPowerModel, i::Int, ctg::Int, pr::Int; nw::Int=_PM.nw_id_default)
    conv = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc][i]
    constraint_conv_filterN1(pm, ctg, nw, pr, i, conv["bf"], Bool(conv["filter"]) )
end
function constraint_conv_filterN1(pm::_PM.AbstractACPModel, ctg::Int, n::Int, pr::Int, i::Int, bv, filter)
    ppr_fr = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:pconv_pr_fr][i,pr]
    qpr_fr = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:qconv_pr_fr][i,pr]
    ptf_to = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:pconv_tf_to][i,pr]
    qtf_to = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:qconv_tf_to][i,pr]

    vmf = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:vmf][i,pr]

    JuMP.@constraint(pm.model,   ppr_fr + ptf_to == 0 )
    JuMP.@NLconstraint(pm.model, qpr_fr + qtf_to +  (-bv) * filter *vmf^2 == 0)
end

function constraint_conv_firing_angle_tnepacdcN1(pm::_PM.AbstractPowerModel, i::Int, ctg::Int; nw::Int=_PM.nw_id_default)
    conv = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc][i]
    S = conv["Pacrated"]
    P1 = cos(0) * S
    Q1 = sin(0) * S
    P2 = cos(pi) * S
    Q2 = sin(pi) * S
    constraint_conv_firing_angleN1(pm, ctg, nw, i, S, P1, Q1, P2, Q2)
end
function constraint_conv_firing_angleN1(pm::_PM.AbstractACPModel, ctg::Int, n::Int, i::Int, S, P1, Q1, P2, Q2)
    p = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:pconv_ac][i]
    q = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:qconv_ac][i]
    phi = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:phiconv][i]

    JuMP.@NLconstraint(pm.model,   p == cos(phi) * S)
    JuMP.@NLconstraint(pm.model,   q == sin(phi) * S)
end

function constraint_conv_firing_angle_tnepacdcN1(pm::_PM.AbstractPowerModel, i::Int, ctg::Int, pr::Int; nw::Int=_PM.nw_id_default)
    conv = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc][i]
    S = conv["Pacrated"]
    P1 = cos(0) * S
    Q1 = sin(0) * S
    P2 = cos(pi) * S
    Q2 = sin(pi) * S
    constraint_conv_firing_angleN1(pm, ctg, nw, pr, i, S, P1, Q1, P2, Q2)
end
function constraint_conv_firing_angleN1(pm::_PM.AbstractACPModel, ctg::Int, n::Int, pr::Int, i::Int, S, P1, Q1, P2, Q2)
    p = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:pconv_ac][i,pr]
    q = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:qconv_ac][i,pr]
    phi = pm.var[:it][_PM.pm_it_sym][:nw][ctg][n][:phiconv][i,pr]

    JuMP.@NLconstraint(pm.model,   p == cos(phi) * S)
    JuMP.@NLconstraint(pm.model,   q == sin(phi) * S)
end