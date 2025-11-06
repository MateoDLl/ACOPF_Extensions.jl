
function variable_active_dcbranch_flow_tnepacdcN1(pm::_PM.AbstractPowerModel, ctg::Int; nw::Int=_PM.nw_id_default, bounded::Bool = true, report::Bool=true)
    p = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:p_dcgrid] = JuMP.@variable(pm.model,
    [(l,i,j) in pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:arcs_dcgrid]], #base_name="$(nw)_pdcgrid",
    start = _PM.comp_start_value(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:branchdc][l], "p_start", 1.0)
    )

    if bounded
        for arc in pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:arcs_dcgrid]
            l,i,j = arc
            JuMP.set_lower_bound(p[arc], -pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:branchdc][l]["rateA"])
            JuMP.set_upper_bound(p[arc],  pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:branchdc][l]["rateA"])
        end
    end

    report && sol_component_value_edge(pm, Symbol(_PM.pm_it_name),ctg, nw, :branchdc, :pf, :pt, pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:arcs_dcgrid_from], pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:arcs_dcgrid_to], p)
end

function variable_active_dcbranch_flow_tnepacdcN1(pm::_PM.AbstractPowerModel, ctg::Int, pr::Vector; nw::Int=_PM.nw_id_default, bounded::Bool = true, report::Bool=true)
    p = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:p_dcgrid] = JuMP.@variable(pm.model,
    [(l,i,j) in pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:arcs_dcgrid],k in pr], #base_name="$(nw)_pdcgrid",
    start = _PM.comp_start_value(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:branchdc][l], "p_start", 1.0)
    )

    if bounded
        for k in pr
            for arc in pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:arcs_dcgrid]
                l,i,j = arc
                JuMP.set_lower_bound(p[arc,k], -pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:branchdc][l]["rateA"])
                JuMP.set_upper_bound(p[arc,k],  pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:branchdc][l]["rateA"])
            end
        end
    end

    report && sol_component_value_edge(pm, Symbol(_PM.pm_it_name),ctg, nw, :branchdc, :pf, :pt, pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:arcs_dcgrid_from], pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:arcs_dcgrid_to],pr, p)
end

function variable_dcgrid_voltage_magnitude_tnepacdcN1(pm::_PM.AbstractPowerModel, ctg::Int; nw::Int=_PM.nw_id_default, bounded::Bool = true, report::Bool=true)
    vdcm = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:vdcm] = JuMP.JuMP.@variable(pm.model,
    [i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:busdc])],# base_name="$(nw)_vdcm",
    start = _PM.comp_start_value(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:busdc][i], "Vdc", 1.0)
    )

    if bounded
        for (i, busdc) in pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:busdc]
            JuMP.set_lower_bound(vdcm[i],  busdc["Vdcmin"])
            JuMP.set_upper_bound(vdcm[i],  busdc["Vdcmax"])
        end
    end
        
    report && sol_component_value(pm, ctg, nw, :busdc, :vm, keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:busdc]), vdcm)
end

function variable_dcgrid_voltage_magnitude_tnepacdcN1(pm::_PM.AbstractPowerModel, ctg::Int, pr::Vector; nw::Int=_PM.nw_id_default, bounded::Bool = true, report::Bool=true)
    vdcm = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:vdcm] = JuMP.JuMP.@variable(pm.model,
    [i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:busdc]),k in pr],# base_name="$(nw)_vdcm",
    start = _PM.comp_start_value(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:busdc][i], "Vdc", 1.0)
    )

    if bounded
        for k in pr
            for (i, busdc) in pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:busdc]
                JuMP.set_lower_bound(vdcm[i,k],  busdc["Vdcmin"])
                JuMP.set_upper_bound(vdcm[i,k],  busdc["Vdcmax"])
            end
        end
    end
        
    report && sol_component_value(pm, ctg, nw, :busdc, :vm, keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:busdc]),pr, vdcm)
end
#transformer
function variable_conv_transformer_active_power_to_tnepacdcN1(pm::_PM.AbstractPowerModel, ctg::Int; nw::Int=_PM.nw_id_default, bounded::Bool = true, report::Bool=true)
    bigM = 2;
    ptfto = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:pconv_tf_to] = JuMP.@variable(pm.model,
    [i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc])], #base_name="$(nw)_pconv_tf_to",
    start = _PM.comp_start_value(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc][i], "P_g", 1.0)
    )
    if bounded
        for (c, convdc) in pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc]
            JuMP.set_lower_bound(ptfto[c],  -convdc["Pacrated"] * bigM)
            JuMP.set_upper_bound(ptfto[c],   convdc["Pacrated"] * bigM)
        end
    end

    report && sol_component_value(pm, ctg, nw, :convdc, :pconv_tf_to, keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc]), ptfto)
end

function variable_conv_transformer_active_power_to_tnepacdcN1(pm::_PM.AbstractPowerModel, ctg::Int, pr::Vector; nw::Int=_PM.nw_id_default, bounded::Bool = true, report::Bool=true)
    bigM = 2;
    ptfto = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:pconv_tf_to] = JuMP.@variable(pm.model,
    [i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc]),k in pr], #base_name="$(nw)_pconv_tf_to",
    start = _PM.comp_start_value(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc][i], "P_g", 1.0)
    )
    if bounded
        for k in pr
            for (c, convdc) in pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc]
                JuMP.set_lower_bound(ptfto[c,k],  -convdc["Pacrated"] * bigM)
                JuMP.set_upper_bound(ptfto[c,k],   convdc["Pacrated"] * bigM)
            end
        end
    end

    report && sol_component_value(pm, ctg, nw, :convdc, :pconv_tf_to, keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc]),pr, ptfto)
end

function variable_conv_transformer_reactive_power_to_tnepacdcN1(pm::_PM.AbstractPowerModel, ctg::Int; nw::Int=_PM.nw_id_default, bounded::Bool = true, report::Bool=true)
    bigM = 2;
    qtfto = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:qconv_tf_to] = JuMP.@variable(pm.model,
    [i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc])], #base_name="$(nw)_qconv_tf_to",
    start = _PM.comp_start_value(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc][i], "Q_g", 1.0)
    )
    if bounded
        for (c, convdc) in pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc]
            JuMP.set_lower_bound(qtfto[c],  -convdc["Qacrated"] * bigM)
            JuMP.set_upper_bound(qtfto[c],   convdc["Qacrated"] * bigM)
        end
    end
    
    report && sol_component_value(pm, ctg, nw, :convdc, :qtf_to, keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc]), qtfto)
end

function variable_conv_transformer_reactive_power_to_tnepacdcN1(pm::_PM.AbstractPowerModel, ctg::Int, pr::Vector; nw::Int=_PM.nw_id_default, bounded::Bool = true, report::Bool=true)
    bigM = 2;
    qtfto = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:qconv_tf_to] = JuMP.@variable(pm.model,
    [i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc]),k in pr], #base_name="$(nw)_qconv_tf_to",
    start = _PM.comp_start_value(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc][i], "Q_g", 1.0)
    )
    if bounded
        for k in pr
            for (c, convdc) in pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc]
                JuMP.set_lower_bound(qtfto[c,k],  -convdc["Qacrated"] * bigM)
                JuMP.set_upper_bound(qtfto[c,k],   convdc["Qacrated"] * bigM)
            end
        end
    end
    
    report && sol_component_value(pm, ctg, nw, :convdc, :qtf_to, keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc]), pr, qtfto)
end

"variable: `qconv_pr_from[j]` for `j` in `convdc`"
function variable_conv_reactor_reactive_power_from_tnepacdcN1(pm::_PM.AbstractPowerModel, ctg::Int; nw::Int=_PM.nw_id_default, bounded::Bool = true, report::Bool=true)
    bigM = 2;
    qprfr = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:qconv_pr_fr] = JuMP.@variable(pm.model,
    [i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc])], #base_name="$(nw)_qconv_pr_fr",
    start = _PM.comp_start_value(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc][i], "Q_g", 1.0)
    )
    if bounded
        for (c, convdc) in pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc]
            JuMP.set_lower_bound(qprfr[c],  -convdc["Qacrated"] * bigM)
            JuMP.set_upper_bound(qprfr[c],   convdc["Qacrated"] * bigM)
        end
    end
    
    report && sol_component_value(pm, ctg, nw, :convdc,  :qpr_fr, keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc]), qprfr)
end

function variable_conv_reactor_reactive_power_from_tnepacdcN1(pm::_PM.AbstractPowerModel, ctg::Int, pr::Vector; nw::Int=_PM.nw_id_default, bounded::Bool = true, report::Bool=true)
    bigM = 2;
    qprfr = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:qconv_pr_fr] = JuMP.@variable(pm.model,
    [i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc]),k in pr], #base_name="$(nw)_qconv_pr_fr",
    start = _PM.comp_start_value(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc][i], "Q_g", 1.0)
    )
    if bounded
        for k in pr
            for (c, convdc) in pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc]
                JuMP.set_lower_bound(qprfr[c,k],  -convdc["Qacrated"] * bigM)
                JuMP.set_upper_bound(qprfr[c,k],   convdc["Qacrated"] * bigM)
            end
        end
    end
    
    report && sol_component_value(pm, ctg, nw, :convdc,  :qpr_fr, keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc]),pr, qprfr)
end

"variable: `pconv_pr_from[j]` for `j` in `convdc`"
function variable_conv_reactor_active_power_from_tnepacdcN1(pm::_PM.AbstractPowerModel, ctg::Int; nw::Int=_PM.nw_id_default, bounded::Bool = true, report::Bool=true)
    bigM = 2;
    pprfr = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:pconv_pr_fr] = JuMP.@variable(pm.model,
    [i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc])], #base_name="$(nw)_pconv_pr_fr",
    start = _PM.comp_start_value(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc][i], "P_g", 1.0)
    )
    if bounded
        for (c, convdc) in pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc]
            JuMP.set_lower_bound(pprfr[c],  -convdc["Pacrated"] * bigM)
            JuMP.set_upper_bound(pprfr[c],   convdc["Pacrated"] * bigM)
        end
    end
    
    report && sol_component_value(pm, ctg, nw, :convdc, :ppr_fr, keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc]), pprfr)
end

function variable_conv_reactor_active_power_from_tnepacdcN1(pm::_PM.AbstractPowerModel, ctg::Int, pr::Vector; nw::Int=_PM.nw_id_default, bounded::Bool = true, report::Bool=true)
    bigM = 2;
    pprfr = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:pconv_pr_fr] = JuMP.@variable(pm.model,
    [i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc]),k in pr], #base_name="$(nw)_pconv_pr_fr",
    start = _PM.comp_start_value(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc][i], "P_g", 1.0)
    )
    if bounded
        for k in pr
            for (c, convdc) in pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc]
                JuMP.set_lower_bound(pprfr[c,k],  -convdc["Pacrated"] * bigM)
                JuMP.set_upper_bound(pprfr[c,k],   convdc["Pacrated"] * bigM)
            end
        end
    end
    
    report && sol_component_value(pm, ctg, nw, :convdc, :ppr_fr, keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc]),pr, pprfr)
end

"variable: `pconv_ac[j]` for `j` in `convdc`"
function variable_converter_active_power_tnepacdcN1(pm::_PM.AbstractPowerModel, ctg::Int; nw::Int=_PM.nw_id_default, bounded::Bool = true, report::Bool=true)
    pc = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:pconv_ac] = JuMP.@variable(pm.model,
    [i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc])], #base_name="$(nw)_pconv_ac",
    start = _PM.comp_start_value(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc][i], "P_g", 1.0)
    )
    if bounded
        for (c, convdc) in pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc]
            JuMP.set_lower_bound(pc[c],  convdc["Pacmin"])
            JuMP.set_upper_bound(pc[c],  convdc["Pacmax"])
        end
    end

    report && sol_component_value(pm, ctg, nw, :convdc, :pconv, keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc]), pc)
end

function variable_converter_active_power_tnepacdcN1(pm::_PM.AbstractPowerModel, ctg::Int,pr::Vector; nw::Int=_PM.nw_id_default, bounded::Bool = true, report::Bool=true)
    pc = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:pconv_ac] = JuMP.@variable(pm.model,
    [i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc]),k in pr], #base_name="$(nw)_pconv_ac",
    start = _PM.comp_start_value(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc][i], "P_g", 1.0)
    )
    if bounded
        for k in pr
            for (c, convdc) in pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc]
                JuMP.set_lower_bound(pc[c,k],  convdc["Pacmin"])
                JuMP.set_upper_bound(pc[c,k],  convdc["Pacmax"])
            end
        end
    end

    report && sol_component_value(pm, ctg, nw, :convdc, :pconv, keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc]),pr, pc)
end

"variable: `qconv_ac[j]` for `j` in `convdc`"
function variable_converter_reactive_power_tnepacdcN1(pm::_PM.AbstractPowerModel, ctg::Int; nw::Int=_PM.nw_id_default, bounded::Bool = true, report::Bool=true)
    qc = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:qconv_ac] = JuMP.@variable(pm.model,
    [i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc])], #base_name="$(nw)_qconv_ac",
    start = _PM.comp_start_value(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc][i], "Q_g", 1.0)
    )
    if bounded
        for (c, convdc) in pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc]
            JuMP.set_lower_bound(qc[c],  convdc["Qacmin"])
            JuMP.set_upper_bound(qc[c],  convdc["Qacmax"])
        end
    end

    report && sol_component_value(pm, ctg, nw, :convdc, :qconv, keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc]), qc)
end

function variable_converter_reactive_power_tnepacdcN1(pm::_PM.AbstractPowerModel, ctg::Int, pr::Vector; nw::Int=_PM.nw_id_default, bounded::Bool = true, report::Bool=true)
    qc = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:qconv_ac] = JuMP.@variable(pm.model,
    [i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc]),k in pr], #base_name="$(nw)_qconv_ac",
    start = _PM.comp_start_value(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc][i], "Q_g", 1.0)
    )
    if bounded
        for k in pr
            for (c, convdc) in pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc]
                JuMP.set_lower_bound(qc[c,k],  convdc["Qacmin"])
                JuMP.set_upper_bound(qc[c,k],  convdc["Qacmax"])
            end
        end
    end

    report && sol_component_value(pm, ctg, nw, :convdc, :qconv, keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc]),pr, qc)
end

"variable: `iconv_ac[j]` for `j` in `convdc`"
function variable_acside_current_tnepacdcN1(pm::_PM.AbstractPowerModel, ctg::Int; nw::Int=_PM.nw_id_default, bounded::Bool = true, report::Bool=true)
    ic = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:iconv_ac] = JuMP.@variable(pm.model,
    [i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc])], #base_name="$(nw)_iconv_ac",
    start = _PM.comp_start_value(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc][i], "P_g", 1.0)
    )
    if bounded
        for (c, convdc) in pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc]
            JuMP.set_lower_bound(ic[c],  0)
            JuMP.set_upper_bound(ic[c],  convdc["Imax"])
        end
    end

    report && sol_component_value(pm, ctg, nw, :convdc, :iconv, keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc]), ic)
end

function variable_acside_current_tnepacdcN1(pm::_PM.AbstractPowerModel, ctg::Int, pr::Vector; nw::Int=_PM.nw_id_default, bounded::Bool = true, report::Bool=true)
    ic = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:iconv_ac] = JuMP.@variable(pm.model,
    [i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc]),k in pr], #base_name="$(nw)_iconv_ac",
    start = _PM.comp_start_value(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc][i], "P_g", 1.0)
    )
    if bounded
        for k in pr
            for (c, convdc) in pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc]
                JuMP.set_lower_bound(ic[c,k],  0)
                JuMP.set_upper_bound(ic[c,k],  convdc["Imax"])
            end
        end
    end

    report && sol_component_value(pm, ctg, nw, :convdc, :iconv, keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc]), pr, ic)
end

"variable: `pconv_dc[j]` for `j` in `convdc`"
function variable_dcside_power_tnepacdcN1(pm::_PM.AbstractPowerModel, ctg::Int; nw::Int=_PM.nw_id_default, bounded::Bool = true, report::Bool=true)
    bigM = 1.2; # to account for losses, maximum losses to be derived
    pcdc = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:pconv_dc] = JuMP.@variable(pm.model,
    [i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc])],# base_name="$(nw)_pconv_dc",
    start = _PM.comp_start_value(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc][i], "Pdcset", 1.0)
    )
    if bounded
        for (c, convdc) in pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc]
            JuMP.set_lower_bound(pcdc[c],  -convdc["Pacrated"] * bigM)
            JuMP.set_upper_bound(pcdc[c],   convdc["Pacrated"] * bigM)
        end
    end

    report && sol_component_value(pm, ctg, nw, :convdc, :pdc, keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc]), pcdc)
end

function variable_dcside_power_tnepacdcN1(pm::_PM.AbstractPowerModel, ctg::Int, pr::Vector; nw::Int=_PM.nw_id_default, bounded::Bool = true, report::Bool=true)
    bigM = 1.2; # to account for losses, maximum losses to be derived
    pcdc = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:pconv_dc] = JuMP.@variable(pm.model,
    [i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc]),k in pr],# base_name="$(nw)_pconv_dc",
    start = _PM.comp_start_value(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc][i], "Pdcset", 1.0)
    )
    if bounded
        for k in pr
            for (c, convdc) in pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc]
                JuMP.set_lower_bound(pcdc[c,k],  -convdc["Pacrated"] * bigM)
                JuMP.set_upper_bound(pcdc[c,k],   convdc["Pacrated"] * bigM)
            end
        end
    end

    report && sol_component_value(pm, ctg, nw, :convdc, :pdc, keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc]),pr, pcdc)
end
"variable: `pconv_dc[j]` for `j` in `convdc`"
function variable_converter_firing_angle_tnepacdcN1(pm::_PM.AbstractPowerModel, ctg::Int; nw::Int=_PM.nw_id_default, bounded::Bool = true, report::Bool=true)
    phic = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:phiconv] = JuMP.@variable(pm.model,
    [i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc])], #base_name="$(nw)_phiconv",
    start = acos(_PM.comp_start_value(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc][i], "Pdcset", 1.0) / sqrt((_PM.comp_start_value(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc][i], "Pacrated", 1.0))^2 + (_PM.comp_start_value(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc][i], "Qacrated", 1.0))^2))
    )
    if bounded
        for (c, convdc) in pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc]
            JuMP.set_lower_bound(phic[c],  0)
            JuMP.set_upper_bound(phic[c],  pi)
        end
    end

    report && sol_component_value(pm, ctg, nw, :convdc, :phi, keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc]), phic)
end

function variable_converter_firing_angle_tnepacdcN1(pm::_PM.AbstractPowerModel, ctg::Int, pr::Vector; nw::Int=_PM.nw_id_default, bounded::Bool = true, report::Bool=true)
    phic = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:phiconv] = JuMP.@variable(pm.model,
    [i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc]),k in pr], #base_name="$(nw)_phiconv",
    start = acos(_PM.comp_start_value(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc][i], "Pdcset", 1.0) / sqrt((_PM.comp_start_value(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc][i], "Pacrated", 1.0))^2 + (_PM.comp_start_value(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc][i], "Qacrated", 1.0))^2))
    )
    if bounded
        for k in pr
            for (c, convdc) in pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc]
                JuMP.set_lower_bound(phic[c,k],  0)
                JuMP.set_upper_bound(phic[c,k],  pi)
            end
        end
    end

    report && sol_component_value(pm, ctg, nw, :convdc, :phi, keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc]),pr, phic)
end

"variable: `vmf[j]` for `j` in `convdc`"
function variable_converter_filter_voltage_magnitude_tnepacdcN1(pm::_PM.AbstractPowerModel, ctg::Int; nw::Int=_PM.nw_id_default, bounded::Bool = true, report::Bool=true)
    bigM = 1.2; # only internal converter voltage is strictly regulated
    vmf = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:vmf] = JuMP.@variable(pm.model,
    [i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc])], #base_name="$(nw)_vmf",
    start = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc][i]["Vtar"]
    )
    if bounded
        for (c, convdc) in pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc]
            JuMP.set_lower_bound(vmf[c], convdc["Vmmin"] / bigM)
            JuMP.set_upper_bound(vmf[c], convdc["Vmmax"] * bigM)
        end
    end
    report && sol_component_value(pm, ctg, nw, :convdc, :vmfilt, keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc]), vmf)
end

function variable_converter_filter_voltage_magnitude_tnepacdcN1(pm::_PM.AbstractPowerModel, ctg::Int, pr::Vector; nw::Int=_PM.nw_id_default, bounded::Bool = true, report::Bool=true)
    bigM = 1.2; # only internal converter voltage is strictly regulated
    vmf = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:vmf] = JuMP.@variable(pm.model,
    [i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc]),k in pr], #base_name="$(nw)_vmf",
    start = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc][i]["Vtar"]
    )
    if bounded
        for k in pr
            for (c, convdc) in pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc]
                JuMP.set_lower_bound(vmf[c,k], convdc["Vmmin"] / bigM)
                JuMP.set_upper_bound(vmf[c,k], convdc["Vmmax"] * bigM)
            end
        end
    end
    report && sol_component_value(pm, ctg, nw, :convdc, :vmfilt, keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc]),pr, vmf)
end

"variable: `vaf[j]` for `j` in `convdc`"
function variable_converter_filter_voltage_angle_tnepacdcN1(pm::_PM.AbstractPowerModel, ctg::Int; nw::Int=_PM.nw_id_default, bounded::Bool = true, report::Bool=true)
    bigM = 2*pi; #
    vaf = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:vaf] = JuMP.@variable(pm.model,
    [i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc])], #base_name="$(nw)_vaf",
    start = 0
    )
    if bounded
        for (c, convdc) in pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc]
            JuMP.set_lower_bound(vaf[c], -bigM)
            JuMP.set_upper_bound(vaf[c],  bigM)
        end
    end
    report && sol_component_value(pm, ctg, nw, :convdc, :vafilt, keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc]), vaf)
end

function variable_converter_filter_voltage_angle_tnepacdcN1(pm::_PM.AbstractPowerModel, ctg::Int, pr::Vector; nw::Int=_PM.nw_id_default, bounded::Bool = true, report::Bool=true)
    bigM = 2*pi; #
    vaf = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:vaf] = JuMP.@variable(pm.model,
    [i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc]),k in pr], #base_name="$(nw)_vaf",
    start = 0
    )
    if bounded
        for k in pr
            for (c, convdc) in pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc]
                JuMP.set_lower_bound(vaf[c,k], -bigM)
                JuMP.set_upper_bound(vaf[c,k],  bigM)
            end
        end
    end
    report && sol_component_value(pm, ctg, nw, :convdc, :vafilt, keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc]),pr, vaf)
end

"variable: `vmc[j]` for `j` in `convdc`"
function variable_converter_internal_voltage_magnitude_tnepacdcN1(pm::_PM.AbstractPowerModel, ctg::Int; nw::Int=_PM.nw_id_default, bounded::Bool = true, report::Bool=true)
    vmc = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:vmc] = JuMP.@variable(pm.model,
    [i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc])],# base_name="$(nw)_vmc",
    start = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc][i]["Vtar"]
    )
    if bounded
        for (c, convdc) in pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc]
            JuMP.set_lower_bound(vmc[c], convdc["Vmmin"])
            JuMP.set_upper_bound(vmc[c], convdc["Vmmax"])
        end
    end
    report && sol_component_value(pm, ctg, nw, :convdc, :vmconv, keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc]), vmc)
end

function variable_converter_internal_voltage_magnitude_tnepacdcN1(pm::_PM.AbstractPowerModel, ctg::Int, pr::Vector; nw::Int=_PM.nw_id_default, bounded::Bool = true, report::Bool=true)
    vmc = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:vmc] = JuMP.@variable(pm.model,
    [i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc]),k in pr],# base_name="$(nw)_vmc",
    start = pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc][i]["Vtar"]
    )
    if bounded
        for k in pr
            for (c, convdc) in pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc]
                JuMP.set_lower_bound(vmc[c,k], convdc["Vmmin"])
                JuMP.set_upper_bound(vmc[c,k], convdc["Vmmax"])
            end
        end
    end
    report && sol_component_value(pm, ctg, nw, :convdc, :vmconv, keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc]),pr, vmc)
end

"variable: `vac[j]` for `j` in `convdc`"
function variable_converter_internal_voltage_angle_tnepacdcN1(pm::_PM.AbstractPowerModel, ctg::Int; nw::Int=_PM.nw_id_default, bounded::Bool = true, report::Bool=true)
    bigM = 2*pi; #
    vac = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:vac] = JuMP.@variable(pm.model,
    [i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc])], #base_name="$(nw)_vac",
    start = 0
    )
    if bounded
        for (c, convdc) in pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc]
            JuMP.set_lower_bound(vac[c], -bigM)
            JuMP.set_upper_bound(vac[c],  bigM)
        end
    end
    report && sol_component_value(pm, ctg, nw, :convdc, :vaconv, keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc]), vac)
end

function variable_converter_internal_voltage_angle_tnepacdcN1(pm::_PM.AbstractPowerModel, ctg::Int, pr::Vector; nw::Int=_PM.nw_id_default, bounded::Bool = true, report::Bool=true)
    bigM = 2*pi; #
    vac = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:vac] = JuMP.@variable(pm.model,
    [i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc]),k in pr], #base_name="$(nw)_vac",
    start = 0
    )
    if bounded
        for k in pr
            for (c, convdc) in pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc]
                JuMP.set_lower_bound(vac[c,k], -bigM)
                JuMP.set_upper_bound(vac[c,k],  bigM)
            end
        end
    end
    report && sol_component_value(pm, ctg, nw, :convdc, :vaconv, keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc]),pr, vac)
end

"variable: `pconv_grid_ac[j]` for `j` in `convdc`"
function variable_converter_to_grid_active_power_tnepacdcN1(pm::_PM.AbstractPowerModel, ctg::Int; nw::Int=_PM.nw_id_default, bounded::Bool = true, report::Bool=true)
    bigM = 2;
    ptffr = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:pconv_tf_fr] = JuMP.@variable(pm.model,
    [i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc])],# base_name="$(nw)_pconv_tf_fr",
    start = _PM.comp_start_value(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc][i], "P_g", 1.0)
    )
    if bounded
        for (c, convdc) in pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc]
            JuMP.set_lower_bound(ptffr[c],  -convdc["Pacrated"] * bigM)
            JuMP.set_upper_bound(ptffr[c],   convdc["Pacrated"] * bigM)
        end
    end

    report && sol_component_value(pm, ctg, nw, :convdc, :pgrid, keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc]), ptffr)
end

function variable_converter_to_grid_active_power_tnepacdcN1(pm::_PM.AbstractPowerModel, ctg::Int, pr::Vector; nw::Int=_PM.nw_id_default, bounded::Bool = true, report::Bool=true)
    bigM = 2;
    ptffr = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:pconv_tf_fr] = JuMP.@variable(pm.model,
    [i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc]),k in pr],# base_name="$(nw)_pconv_tf_fr",
    start = _PM.comp_start_value(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc][i], "P_g", 1.0)
    )
    if bounded
        for k in pr
            for (c, convdc) in pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc]
                JuMP.set_lower_bound(ptffr[c,k],  -convdc["Pacrated"] * bigM)
                JuMP.set_upper_bound(ptffr[c,k],   convdc["Pacrated"] * bigM)
            end
        end
    end

    report && sol_component_value(pm, ctg, nw, :convdc, :pgrid, keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc]),pr, ptffr)
end

"variable: `qconv_grid_ac[j]` for `j` in `convdc`"
function variable_converter_to_grid_reactive_power_tnepacdcN1(pm::_PM.AbstractPowerModel, ctg::Int; nw::Int=_PM.nw_id_default, bounded::Bool = true, report::Bool=true)
    bigM = 2;
    qtffr = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:qconv_tf_fr] = JuMP.@variable(pm.model,
    [i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc])],# base_name="$(nw)_qconv_tf_fr",
    start = _PM.comp_start_value(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc][i], "Q_g", 1.0)
    )
    if bounded
        for (c, convdc) in pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc]
            JuMP.set_lower_bound(qtffr[c],  -convdc["Qacrated"] * bigM)
            JuMP.set_upper_bound(qtffr[c],   convdc["Qacrated"] * bigM)
        end
    end

    report && sol_component_value(pm, ctg, nw, :convdc, :qgrid, keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc]), qtffr)
end

function variable_converter_to_grid_reactive_power_tnepacdcN1(pm::_PM.AbstractPowerModel, ctg::Int, pr::Vector; nw::Int=_PM.nw_id_default, bounded::Bool = true, report::Bool=true)
    bigM = 2;
    qtffr = pm.var[:it][_PM.pm_it_sym][:nw][ctg][nw][:qconv_tf_fr] = JuMP.@variable(pm.model,
    [i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc]),k in pr],# base_name="$(nw)_qconv_tf_fr",
    start = _PM.comp_start_value(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc][i], "Q_g", 1.0)
    )
    if bounded
        for k in pr
            for (c, convdc) in pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc]
                JuMP.set_lower_bound(qtffr[c,k],  -convdc["Qacrated"] * bigM)
                JuMP.set_upper_bound(qtffr[c,k],   convdc["Qacrated"] * bigM)
            end
        end
    end

    report && sol_component_value(pm, ctg, nw, :convdc, :qgrid, keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][nw][:convdc]),pr, qtffr)
end