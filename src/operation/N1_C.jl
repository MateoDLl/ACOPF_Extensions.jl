# Only AC
function build_opftnep_N1_rcT(pm::_PM.AbstractPowerModel)
    for ctg in pm.data["n_copies"]
        #Variables
        for n in 1:pm.data["Stage"]
            variable_bus_voltage_angle_tnepacdcN1(pm,ctg,nw=n)
            variable_bus_voltage_magnitude_tnepacdcN1(pm,ctg,nw=n)
            variable_gen_power_real_tnepacdcN1(pm,ctg,nw=n)
            variable_gen_power_imaginary_tnepacdcN1(pm,ctg,nw=n)
            variable_branch_power_real_tnepacdcN1(pm,ctg,nw=n)
            variable_branch_power_imaginary_tnepacdcN1(pm,ctg,nw=n)
            variable_art_power_real_tnepacdcN1(pm,ctg,nw=n)
            variable_comp_power_reactive_tnepacdcN1(pm,ctg,nw=n)

            for i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][n][:ref_buses])
                constraint_theta_ref_tnepacdcN1(pm, i,ctg, nw=n)
            end
            for i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][n][:bus])
                constraint_power_balance_ac_tnepacdcN1_oAC(pm, i,ctg, nw=n)
                constraint_comp_reactive_tnepacdcN1(pm, i,ctg, nw=n)
                constraint_art_tnepacdcN1(pm, i,ctg, nw=n)
            end
            for i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][n][:branch])
                constraint_ohms_yt_from_tnepacdcN1(pm, i,ctg, nw=n)
                constraint_ohms_yt_to_tnepacdcN1(pm, i,ctg, nw=n)
                constraint_voltage_angle_difference_tnepacdcN1(pm, i,ctg, nw=n) #angle difference across transformer and reactor - useful for LPAC if available?
                constraint_thermal_limit_from_tnepacdcN1(pm, i,ctg, nw=n)
                constraint_thermal_limit_to_tnepacdcN1(pm, i,ctg, nw=n)
            end
        end
    end
    objective_min_cost_RCN1(pm)
end

function build_opftnep_N1_nrcT(pm::_PM.AbstractPowerModel)
    for ctg in pm.data["n_copies"]
        #Variables
        for n in 1:pm.data["Stage"]
            variable_bus_voltage_angle_tnepacdcN1(pm,ctg,nw=n)
            variable_bus_voltage_magnitude_tnepacdcN1(pm,ctg,nw=n)
            variable_gen_power_real_tnepacdcN1(pm,ctg,nw=n)
            variable_gen_power_imaginary_tnepacdcN1(pm,ctg,nw=n)
            variable_branch_power_real_tnepacdcN1(pm,ctg,nw=n)
            variable_branch_power_imaginary_tnepacdcN1(pm,ctg,nw=n)
            variable_art_power_real_tnepacdcN1(pm,ctg,nw=n)

            for i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][n][:ref_buses])
                constraint_theta_ref_tnepacdcN1(pm, i,ctg, nw=n)
            end
            for i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][n][:bus])
                constraint_power_balance_ac_tnepacdcN1nrc_oAC(pm, i,ctg, nw=n)
                constraint_art_tnepacdcN1(pm, i,ctg, nw=n)
            end
            for i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][n][:branch])
                constraint_ohms_yt_from_tnepacdcN1(pm, i,ctg, nw=n)
                constraint_ohms_yt_to_tnepacdcN1(pm, i,ctg, nw=n)
                constraint_voltage_angle_difference_tnepacdcN1(pm, i,ctg, nw=n) #angle difference across transformer and reactor - useful for LPAC if available?
                constraint_thermal_limit_from_tnepacdcN1(pm, i,ctg, nw=n)
                constraint_thermal_limit_to_tnepacdcN1(pm, i,ctg, nw=n)
            end
        end
    end
    objective_min_cost_RCN1_nrc(pm)
end


function build_opftnep_N1_rcT_nAP(pm::_PM.AbstractPowerModel)
    for ctg in pm.data["n_copies"]
        #Variables
        for n in 1:pm.data["Stage"]
            variable_bus_voltage_angle_tnepacdcN1(pm,ctg,nw=n)
            variable_bus_voltage_magnitude_tnepacdcN1(pm,ctg,nw=n)
            variable_gen_power_real_tnepacdcN1(pm,ctg,nw=n)
            variable_gen_power_imaginary_tnepacdcN1(pm,ctg,nw=n)
            variable_branch_power_real_tnepacdcN1(pm,ctg,nw=n)
            variable_branch_power_imaginary_tnepacdcN1(pm,ctg,nw=n)
            variable_comp_power_reactive_tnepacdcN1(pm,ctg,nw=n)

            for i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][n][:ref_buses])
                constraint_theta_ref_tnepacdcN1(pm, i,ctg, nw=n)
            end
            for i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][n][:bus])
                constraint_power_balance_ac_tnepacdcN1_nAP_oAC(pm, i,ctg, nw=n)
                constraint_comp_reactive_tnepacdcN1(pm, i,ctg, nw=n)
            end
            for i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][n][:branch])
                constraint_ohms_yt_from_tnepacdcN1(pm, i,ctg, nw=n)
                constraint_ohms_yt_to_tnepacdcN1(pm, i,ctg, nw=n)
                constraint_voltage_angle_difference_tnepacdcN1(pm, i,ctg, nw=n) #angle difference across transformer and reactor - useful for LPAC if available?
                constraint_thermal_limit_from_tnepacdcN1(pm, i,ctg, nw=n)
                constraint_thermal_limit_to_tnepacdcN1(pm, i,ctg, nw=n)
            end
        end
    end
    objective_min_cost_RCN1_nAP(pm)
end

function build_opftnep_N1_nrcT_nAP(pm::_PM.AbstractPowerModel)
    for ctg in pm.data["n_copies"]
        #Variables
        for n in 1:pm.data["Stage"]
            variable_bus_voltage_angle_tnepacdcN1(pm,ctg,nw=n)
            variable_bus_voltage_magnitude_tnepacdcN1(pm,ctg,nw=n)
            variable_gen_power_real_tnepacdcN1(pm,ctg,nw=n)
            variable_gen_power_imaginary_tnepacdcN1(pm,ctg,nw=n)
            variable_branch_power_real_tnepacdcN1(pm,ctg,nw=n)
            variable_branch_power_imaginary_tnepacdcN1(pm,ctg,nw=n)

            for i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][n][:ref_buses])
                constraint_theta_ref_tnepacdcN1(pm, i,ctg, nw=n)
            end
            for i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][n][:bus])
                constraint_power_balance_ac_tnepacdcN1_nAP_nRC_oAC(pm, i,ctg, nw=n)
            end
            for i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][n][:branch])
                constraint_ohms_yt_from_tnepacdcN1(pm, i,ctg, nw=n)
                constraint_ohms_yt_to_tnepacdcN1(pm, i,ctg, nw=n)
                constraint_voltage_angle_difference_tnepacdcN1(pm, i,ctg, nw=n) #angle difference across transformer and reactor - useful for LPAC if available?
                constraint_thermal_limit_from_tnepacdcN1(pm, i,ctg, nw=n)
                constraint_thermal_limit_to_tnepacdcN1(pm, i,ctg, nw=n)
            end
        end
    end
    objective_min_cost_RCN1_nRC_nAP(pm)
end

# AC/DC version
function build_opftnep_N1_rcT_ACDC(pm::_PM.AbstractPowerModel)
    for ctg in pm.data["n_copies"]
        #Variables
        for n in 1:pm.data["Stage"]
            variable_bus_voltage_angle_tnepacdcN1(pm,ctg,nw=n)
            variable_bus_voltage_magnitude_tnepacdcN1(pm,ctg,nw=n)
            variable_gen_power_real_tnepacdcN1(pm,ctg,nw=n)
            variable_gen_power_imaginary_tnepacdcN1(pm,ctg,nw=n)
            variable_branch_power_real_tnepacdcN1(pm,ctg,nw=n)
            variable_branch_power_imaginary_tnepacdcN1(pm,ctg,nw=n)
            variable_art_power_real_tnepacdcN1(pm,ctg,nw=n)
            variable_comp_power_reactive_tnepacdcN1(pm,ctg,nw=n)

            variable_active_dcbranch_flow_tnepacdcN1(pm,ctg,nw=n)
            variable_dcgrid_voltage_magnitude_tnepacdcN1(pm,ctg,nw=n)
            variable_conv_transformer_active_power_to_tnepacdcN1(pm,ctg,nw=n)
            variable_conv_transformer_reactive_power_to_tnepacdcN1(pm,ctg,nw=n)
            variable_conv_reactor_reactive_power_from_tnepacdcN1(pm,ctg,nw=n)
            variable_conv_reactor_active_power_from_tnepacdcN1(pm,ctg,nw=n)
            variable_converter_active_power_tnepacdcN1(pm,ctg,nw=n)
            variable_converter_reactive_power_tnepacdcN1(pm,ctg,nw=n)

            variable_acside_current_tnepacdcN1(pm,ctg,nw=n)
            variable_dcside_power_tnepacdcN1(pm,ctg,nw=n)
            variable_converter_firing_angle_tnepacdcN1(pm,ctg,nw=n)
            variable_converter_filter_voltage_magnitude_tnepacdcN1(pm,ctg,nw=n)
            variable_converter_filter_voltage_angle_tnepacdcN1(pm,ctg,nw=n)
            variable_converter_internal_voltage_magnitude_tnepacdcN1(pm,ctg,nw=n)
            variable_converter_internal_voltage_angle_tnepacdcN1(pm,ctg,nw=n)
            variable_converter_to_grid_active_power_tnepacdcN1(pm,ctg,nw=n)
            variable_converter_to_grid_reactive_power_tnepacdcN1(pm,ctg,nw=n)

            for i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][n][:ref_buses])
                constraint_theta_ref_tnepacdcN1(pm, i,ctg, nw=n)
            end
            for i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][n][:bus])
                constraint_power_balance_ac_tnepacdcN1(pm, i,ctg, nw=n)
                constraint_comp_reactive_tnepacdcN1(pm, i,ctg, nw=n)
                constraint_art_tnepacdcN1(pm, i,ctg, nw=n)
            end
            for i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][n][:branch])
                constraint_ohms_yt_from_tnepacdcN1(pm, i,ctg, nw=n)
                constraint_ohms_yt_to_tnepacdcN1(pm, i,ctg, nw=n)
                constraint_voltage_angle_difference_tnepacdcN1(pm, i,ctg, nw=n) #angle difference across transformer and reactor - useful for LPAC if available?
                constraint_thermal_limit_from_tnepacdcN1(pm, i,ctg, nw=n)
                constraint_thermal_limit_to_tnepacdcN1(pm, i,ctg, nw=n)
            end
            for i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][n][:busdc])
                constraint_power_balance_dc_tnepacdcN1(pm, i,ctg, nw=n)
            end
            for i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][n][:branchdc])
                constraint_ohms_dc_branch_tnepacdcN1(pm, i,ctg, nw=n)
            end
            for i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][n][:convdc])
                constraint_converter_losses_tnepacdcN1(pm, i, ctg, nw=n)
                constraint_converter_current_tnepacdcN1(pm, i, ctg, nw=n)
                constraint_conv_transformer_tnepacdcN1(pm, i, ctg, nw=n)
                constraint_conv_reactor_tnepacdcN1(pm, i, ctg, nw=n)
                constraint_conv_filter_tnepacdcN1(pm, i, ctg, nw=n)
                if pm.ref[:it][:pm][:nw][ctg][n][:convdc][i]["islcc"] == 1
                    constraint_conv_firing_angle_tnepacdcN1(pm, i, ctg, nw=n)
                end
            end
        end
    end
    objective_min_cost_RCN1(pm)
end

function build_opftnep_N1_nrcT_ACDC(pm::_PM.AbstractPowerModel)
    for ctg in pm.data["n_copies"]
        #Variables
        for n in 1:pm.data["Stage"]
            variable_bus_voltage_angle_tnepacdcN1(pm,ctg,nw=n)
            variable_bus_voltage_magnitude_tnepacdcN1(pm,ctg,nw=n)
            variable_gen_power_real_tnepacdcN1(pm,ctg,nw=n)
            variable_gen_power_imaginary_tnepacdcN1(pm,ctg,nw=n)
            variable_branch_power_real_tnepacdcN1(pm,ctg,nw=n)
            variable_branch_power_imaginary_tnepacdcN1(pm,ctg,nw=n)
            variable_art_power_real_tnepacdcN1(pm,ctg,nw=n)

            variable_active_dcbranch_flow_tnepacdcN1(pm,ctg,nw=n)
            variable_dcgrid_voltage_magnitude_tnepacdcN1(pm,ctg,nw=n)
            variable_conv_transformer_active_power_to_tnepacdcN1(pm,ctg,nw=n)
            variable_conv_transformer_reactive_power_to_tnepacdcN1(pm,ctg,nw=n)
            variable_conv_reactor_reactive_power_from_tnepacdcN1(pm,ctg,nw=n)
            variable_conv_reactor_active_power_from_tnepacdcN1(pm,ctg,nw=n)
            variable_converter_active_power_tnepacdcN1(pm,ctg,nw=n)
            variable_converter_reactive_power_tnepacdcN1(pm,ctg,nw=n)

            variable_acside_current_tnepacdcN1(pm,ctg,nw=n)
            variable_dcside_power_tnepacdcN1(pm,ctg,nw=n)
            variable_converter_firing_angle_tnepacdcN1(pm,ctg,nw=n)
            variable_converter_filter_voltage_magnitude_tnepacdcN1(pm,ctg,nw=n)
            variable_converter_filter_voltage_angle_tnepacdcN1(pm,ctg,nw=n)
            variable_converter_internal_voltage_magnitude_tnepacdcN1(pm,ctg,nw=n)
            variable_converter_internal_voltage_angle_tnepacdcN1(pm,ctg,nw=n)
            variable_converter_to_grid_active_power_tnepacdcN1(pm,ctg,nw=n)
            variable_converter_to_grid_reactive_power_tnepacdcN1(pm,ctg,nw=n)

            for i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][n][:ref_buses])
                constraint_theta_ref_tnepacdcN1(pm, i,ctg, nw=n)
            end
            for i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][n][:bus])
                constraint_power_balance_ac_tnepacdcN1nrc(pm, i,ctg, nw=n)
                constraint_art_tnepacdcN1(pm, i,ctg, nw=n)
            end
            for i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][n][:branch])
                constraint_ohms_yt_from_tnepacdcN1(pm, i,ctg, nw=n)
                constraint_ohms_yt_to_tnepacdcN1(pm, i,ctg, nw=n)
                constraint_voltage_angle_difference_tnepacdcN1(pm, i,ctg, nw=n) #angle difference across transformer and reactor - useful for LPAC if available?
                constraint_thermal_limit_from_tnepacdcN1(pm, i,ctg, nw=n)
                constraint_thermal_limit_to_tnepacdcN1(pm, i,ctg, nw=n)
            end
            for i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][n][:busdc])
                constraint_power_balance_dc_tnepacdcN1(pm, i,ctg, nw=n)
            end
            for i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][n][:branchdc])
                constraint_ohms_dc_branch_tnepacdcN1(pm, i,ctg, nw=n)
            end
            for i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][n][:convdc])
                constraint_converter_losses_tnepacdcN1(pm, i, ctg, nw=n)
                constraint_converter_current_tnepacdcN1(pm, i, ctg, nw=n)
                constraint_conv_transformer_tnepacdcN1(pm, i, ctg, nw=n)
                constraint_conv_reactor_tnepacdcN1(pm, i, ctg, nw=n)
                constraint_conv_filter_tnepacdcN1(pm, i, ctg, nw=n)
                if pm.ref[:it][:pm][:nw][ctg][n][:convdc][i]["islcc"] == 1
                    constraint_conv_firing_angle_tnepacdcN1(pm, i, ctg, nw=n)
                end
            end
        end
    end
    objective_min_cost_RCN1_nrc(pm)
end


function build_opftnep_N1_rcT_nAP_ACDC(pm::_PM.AbstractPowerModel)
    for ctg in pm.data["n_copies"]
        #Variables
        for n in 1:pm.data["Stage"]
            variable_bus_voltage_angle_tnepacdcN1(pm,ctg,nw=n)
            variable_bus_voltage_magnitude_tnepacdcN1(pm,ctg,nw=n)
            variable_gen_power_real_tnepacdcN1(pm,ctg,nw=n)
            variable_gen_power_imaginary_tnepacdcN1(pm,ctg,nw=n)
            variable_branch_power_real_tnepacdcN1(pm,ctg,nw=n)
            variable_branch_power_imaginary_tnepacdcN1(pm,ctg,nw=n)
            variable_comp_power_reactive_tnepacdcN1(pm,ctg,nw=n)

            variable_active_dcbranch_flow_tnepacdcN1(pm,ctg,nw=n)
            variable_dcgrid_voltage_magnitude_tnepacdcN1(pm,ctg,nw=n)
            variable_conv_transformer_active_power_to_tnepacdcN1(pm,ctg,nw=n)
            variable_conv_transformer_reactive_power_to_tnepacdcN1(pm,ctg,nw=n)
            variable_conv_reactor_reactive_power_from_tnepacdcN1(pm,ctg,nw=n)
            variable_conv_reactor_active_power_from_tnepacdcN1(pm,ctg,nw=n)
            variable_converter_active_power_tnepacdcN1(pm,ctg,nw=n)
            variable_converter_reactive_power_tnepacdcN1(pm,ctg,nw=n)

            variable_acside_current_tnepacdcN1(pm,ctg,nw=n)
            variable_dcside_power_tnepacdcN1(pm,ctg,nw=n)
            variable_converter_firing_angle_tnepacdcN1(pm,ctg,nw=n)
            variable_converter_filter_voltage_magnitude_tnepacdcN1(pm,ctg,nw=n)
            variable_converter_filter_voltage_angle_tnepacdcN1(pm,ctg,nw=n)
            variable_converter_internal_voltage_magnitude_tnepacdcN1(pm,ctg,nw=n)
            variable_converter_internal_voltage_angle_tnepacdcN1(pm,ctg,nw=n)
            variable_converter_to_grid_active_power_tnepacdcN1(pm,ctg,nw=n)
            variable_converter_to_grid_reactive_power_tnepacdcN1(pm,ctg,nw=n)

            for i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][n][:ref_buses])
                constraint_theta_ref_tnepacdcN1(pm, i,ctg, nw=n)
            end
            for i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][n][:bus])
                constraint_power_balance_ac_tnepacdcN1_nAP(pm, i,ctg, nw=n)
                constraint_comp_reactive_tnepacdcN1(pm, i,ctg, nw=n)
            end
            for i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][n][:branch])
                constraint_ohms_yt_from_tnepacdcN1(pm, i,ctg, nw=n)
                constraint_ohms_yt_to_tnepacdcN1(pm, i,ctg, nw=n)
                constraint_voltage_angle_difference_tnepacdcN1(pm, i,ctg, nw=n) #angle difference across transformer and reactor - useful for LPAC if available?
                constraint_thermal_limit_from_tnepacdcN1(pm, i,ctg, nw=n)
                constraint_thermal_limit_to_tnepacdcN1(pm, i,ctg, nw=n)
            end
            for i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][n][:busdc])
                constraint_power_balance_dc_tnepacdcN1(pm, i,ctg, nw=n)
            end
            for i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][n][:branchdc])
                constraint_ohms_dc_branch_tnepacdcN1(pm, i,ctg, nw=n)
            end
            for i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][n][:convdc])
                constraint_converter_losses_tnepacdcN1(pm, i, ctg, nw=n)
                constraint_converter_current_tnepacdcN1(pm, i, ctg, nw=n)
                constraint_conv_transformer_tnepacdcN1(pm, i, ctg, nw=n)
                constraint_conv_reactor_tnepacdcN1(pm, i, ctg, nw=n)
                constraint_conv_filter_tnepacdcN1(pm, i, ctg, nw=n)
                if pm.ref[:it][:pm][:nw][ctg][n][:convdc][i]["islcc"] == 1
                    constraint_conv_firing_angle_tnepacdcN1(pm, i, ctg, nw=n)
                end
            end
        end
    end
    objective_min_cost_RCN1_nAP(pm)
end

function build_opftnep_N1_nrcT_nAP_ACDC(pm::_PM.AbstractPowerModel)
    for ctg in pm.data["n_copies"]
        #Variables
        for n in 1:pm.data["Stage"]
            variable_bus_voltage_angle_tnepacdcN1(pm,ctg,nw=n)
            variable_bus_voltage_magnitude_tnepacdcN1(pm,ctg,nw=n)
            variable_gen_power_real_tnepacdcN1(pm,ctg,nw=n)
            variable_gen_power_imaginary_tnepacdcN1(pm,ctg,nw=n)
            variable_branch_power_real_tnepacdcN1(pm,ctg,nw=n)
            variable_branch_power_imaginary_tnepacdcN1(pm,ctg,nw=n)

            variable_active_dcbranch_flow_tnepacdcN1(pm,ctg,nw=n)
            variable_dcgrid_voltage_magnitude_tnepacdcN1(pm,ctg,nw=n)
            variable_conv_transformer_active_power_to_tnepacdcN1(pm,ctg,nw=n)
            variable_conv_transformer_reactive_power_to_tnepacdcN1(pm,ctg,nw=n)
            variable_conv_reactor_reactive_power_from_tnepacdcN1(pm,ctg,nw=n)
            variable_conv_reactor_active_power_from_tnepacdcN1(pm,ctg,nw=n)
            variable_converter_active_power_tnepacdcN1(pm,ctg,nw=n)
            variable_converter_reactive_power_tnepacdcN1(pm,ctg,nw=n)

            variable_acside_current_tnepacdcN1(pm,ctg,nw=n)
            variable_dcside_power_tnepacdcN1(pm,ctg,nw=n)
            variable_converter_firing_angle_tnepacdcN1(pm,ctg,nw=n)
            variable_converter_filter_voltage_magnitude_tnepacdcN1(pm,ctg,nw=n)
            variable_converter_filter_voltage_angle_tnepacdcN1(pm,ctg,nw=n)
            variable_converter_internal_voltage_magnitude_tnepacdcN1(pm,ctg,nw=n)
            variable_converter_internal_voltage_angle_tnepacdcN1(pm,ctg,nw=n)
            variable_converter_to_grid_active_power_tnepacdcN1(pm,ctg,nw=n)
            variable_converter_to_grid_reactive_power_tnepacdcN1(pm,ctg,nw=n)

            for i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][n][:ref_buses])
                constraint_theta_ref_tnepacdcN1(pm, i,ctg, nw=n)
            end
            for i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][n][:bus])
                constraint_power_balance_ac_tnepacdcN1_nAP_nRC(pm, i,ctg, nw=n)
            end
            for i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][n][:branch])
                constraint_ohms_yt_from_tnepacdcN1(pm, i,ctg, nw=n)
                constraint_ohms_yt_to_tnepacdcN1(pm, i,ctg, nw=n)
                constraint_voltage_angle_difference_tnepacdcN1(pm, i,ctg, nw=n) #angle difference across transformer and reactor - useful for LPAC if available?
                constraint_thermal_limit_from_tnepacdcN1(pm, i,ctg, nw=n)
                constraint_thermal_limit_to_tnepacdcN1(pm, i,ctg, nw=n)
            end
            for i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][n][:busdc])
                constraint_power_balance_dc_tnepacdcN1(pm, i,ctg, nw=n)
            end
            for i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][n][:branchdc])
                constraint_ohms_dc_branch_tnepacdcN1(pm, i,ctg, nw=n)
            end
            for i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][n][:convdc])
                constraint_converter_losses_tnepacdcN1(pm, i, ctg, nw=n)
                constraint_converter_current_tnepacdcN1(pm, i, ctg, nw=n)
                constraint_conv_transformer_tnepacdcN1(pm, i, ctg, nw=n)
                constraint_conv_reactor_tnepacdcN1(pm, i, ctg, nw=n)
                constraint_conv_filter_tnepacdcN1(pm, i, ctg, nw=n)
                if pm.ref[:it][:pm][:nw][ctg][n][:convdc][i]["islcc"] == 1
                    constraint_conv_firing_angle_tnepacdcN1(pm, i, ctg, nw=n)
                end
            end
        end
    end
    objective_min_cost_RCN1_nRC_nAP(pm)
end

function build_opftnep_N1_rcT_strg(pm::_PM.AbstractPowerModel)
    Period_Stage = pm.data["Period_Stage"]
    for ctg in pm.data["n_copies"]
        for n in 1:pm.data["Stage"]
            variable_bus_voltage_angle_tnepacdcN1(pm,ctg,Period_Stage,nw=n)
            variable_bus_voltage_magnitude_tnepacdcN1(pm,ctg,Period_Stage,nw=n)
            variable_gen_power_real_tnepacdcN1(pm,ctg,Period_Stage,nw=n)
            variable_gen_power_imaginary_tnepacdcN1(pm,ctg,Period_Stage,nw=n)
            variable_branch_power_real_tnepacdcN1(pm,ctg,Period_Stage,nw=n)
            variable_branch_power_imaginary_tnepacdcN1(pm,ctg,Period_Stage,nw=n)
            variable_art_power_real_tnepacdcN1(pm,ctg,Period_Stage,nw=n)
            variable_comp_power_reactive_tnepacdcN1(pm,ctg,Period_Stage,nw=n)

            variable_storage_power_real_tnepacdcN1(pm,ctg,Period_Stage,nw=n)
            variable_storage_power_imaginary_tnepacdcN1(pm,ctg,Period_Stage,nw=n)
            variable_storage_power_control_imaginary_tnepacdcN1(pm,ctg,Period_Stage,nw=n)
            variable_storage_energy_tnepacdcN1(pm,ctg,Period_Stage,nw=n)
            variable_storage_charge_tnepacdcN1(pm,ctg,Period_Stage,nw=n)
            variable_storage_discharge_tnepacdcN1(pm,ctg,Period_Stage,nw=n)

            variable_active_dcbranch_flow_tnepacdcN1(pm,ctg,Period_Stage,nw=n)
            variable_dcgrid_voltage_magnitude_tnepacdcN1(pm,ctg,Period_Stage,nw=n)
            variable_conv_transformer_active_power_to_tnepacdcN1(pm,ctg,Period_Stage,nw=n)
            variable_conv_transformer_reactive_power_to_tnepacdcN1(pm,ctg,Period_Stage,nw=n)
            variable_conv_reactor_reactive_power_from_tnepacdcN1(pm,ctg,Period_Stage,nw=n)
            variable_conv_reactor_active_power_from_tnepacdcN1(pm,ctg,Period_Stage,nw=n)
            variable_converter_active_power_tnepacdcN1(pm,ctg,Period_Stage,nw=n)
            variable_converter_reactive_power_tnepacdcN1(pm,ctg,Period_Stage,nw=n)

            variable_acside_current_tnepacdcN1(pm,ctg,Period_Stage,nw=n)
            variable_dcside_power_tnepacdcN1(pm,ctg,Period_Stage,nw=n)
            variable_converter_firing_angle_tnepacdcN1(pm,ctg,Period_Stage,nw=n)
            variable_converter_filter_voltage_magnitude_tnepacdcN1(pm,ctg,Period_Stage,nw=n)
            variable_converter_filter_voltage_angle_tnepacdcN1(pm,ctg,Period_Stage,nw=n)
            variable_converter_internal_voltage_magnitude_tnepacdcN1(pm,ctg,Period_Stage,nw=n)
            variable_converter_internal_voltage_angle_tnepacdcN1(pm,ctg,Period_Stage,nw=n)
            variable_converter_to_grid_active_power_tnepacdcN1(pm,ctg,Period_Stage,nw=n)
            variable_converter_to_grid_reactive_power_tnepacdcN1(pm,ctg,Period_Stage,nw=n)

            for k in Period_Stage
                for i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][n][:ref_buses])
                    constraint_theta_ref_tnepacdcN1(pm, i,ctg,k,nw=n)
                end
                for i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][n][:bus])
                    constraint_power_balance_ac_tnepacdcN1(pm, i,ctg,k, nw=n)
                    constraint_comp_reactive_tnepacdcN1(pm, i,ctg,k, nw=n)
                    constraint_art_tnepacdcN1(pm, i,ctg,k, nw=n)
                end
                for i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][n][:storage])
                    constraint_storage_complementarity_mi_tnepacdcN1(pm, i,ctg,k, nw=n)
                    constraint_storage_losses_tnepacdcN1(pm, i,ctg,k, nw=n)
                    constraint_storage_thermal_limit_tnepacdcN1(pm, i,ctg,k, nw=n)
                end
                for i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][n][:branch])
                    constraint_ohms_yt_from_tnepacdcN1(pm, i,ctg,k, nw=n)
                    constraint_ohms_yt_to_tnepacdcN1(pm, i,ctg,k, nw=n)
                    constraint_voltage_angle_difference_tnepacdcN1(pm, i,ctg,k, nw=n) #angle difference across transformer and reactor - useful for LPAC if available?
                    constraint_thermal_limit_from_tnepacdcN1(pm, i,ctg,k, nw=n)
                    constraint_thermal_limit_to_tnepacdcN1(pm, i,ctg,k, nw=n)
                end
                for i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][n][:busdc])
                    constraint_power_balance_dc_tnepacdcN1(pm, i,ctg,k, nw=n)
                end
                for i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][n][:branchdc])
                    constraint_ohms_dc_branch_tnepacdcN1(pm, i,ctg,k, nw=n)
                end
                for i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][n][:convdc])
                    constraint_converter_losses_tnepacdcN1(pm, i, ctg,k, nw=n)
                    constraint_converter_current_tnepacdcN1(pm, i, ctg,k, nw=n)
                    constraint_conv_transformer_tnepacdcN1(pm, i, ctg,k, nw=n)
                    constraint_conv_reactor_tnepacdcN1(pm, i, ctg,k, nw=n)
                    constraint_conv_filter_tnepacdcN1(pm, i, ctg,k, nw=n)
                    if pm.ref[:it][:pm][:nw][ctg][n][:convdc][i]["islcc"] == 1
                        constraint_conv_firing_angle_tnepacdcN1(pm, i, ctg,k, nw=n)
                    end
                end
            end

            n_1 = Period_Stage[1]
            if n == 1
                for i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][n][Symbol("P$(n_1)")])
                    constraint_storage_state_tnepacdcN1(pm, ctg, n ,i, n_1)
                end
            else
                for i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][n][Symbol("P$(n_1)")])
                    constraint_storage_state_tnepacdcN1(pm, ctg, n, i, Period_Stage[end], n_1)
                end
            end

            for n_2 in Period_Stage[2:end]
                for i in keys(pm.ref[:it][_PM.pm_it_sym][:nw][ctg][n][Symbol("P$(n_2)")])
                    constraint_storage_state_tnepacdcN1(pm, ctg, n, i, n_1, n_2)
                end
                n_1 = n_2
            end
        end
    end
    objective_min_cost_strg_RCN1(pm)
end


function extract_rc_nodes(data::Dict, solution::Dict, Stage::Int)
    RCCt = Dict{Int64, Dict{Int64, Float64}}()
    for k in 1:Stage
        RCqg = Dict{Int64, Float64}()
        for ctg in data["n_copies"]
            comps = solution[string(ctg)][string(k)]["comp_react"]
            for (id, val) in comps
                rcqg_val = val["RCqg"]
                if abs(rcqg_val) > 0.001
                    bus_gen = data["comp_react"][id]["bus_gen"]
                    if haskey(RCqg, bus_gen)
                        RCqg[bus_gen] = max(RCqg[bus_gen], rcqg_val)
                    else
                        RCqg[bus_gen] = rcqg_val
                    end
                end
            end
        end
        RCCt[k] = RCqg
    end
    return RCCt
end

function solve_tnep_N1_idx_nrc(data::Dict, SolT::Matrix; subgra::Bool=false)
    Stage = size(SolT,2) 
    num_contingencies = data["Contingency"] ? length(data["N1contingency"]) : 0
    data = uncertain(data)
    dataR = replicate_modify_N1(data ,num_contingencies, Stage, Set(["time_series", "per_unit"]),SolT)
    pm = instantiate_model(dataR, _PM.ACPPowerModel, build_opftnep_N1_nrcT_nAP, ref_add_core_N1!, Set(["time_series", "per_unit"]),_PM.pm_it_sym
    ;ref_extensions = [add_ref_dcgridN1!])
    result = optimize_model!(pm, relax_integrality=false, optimizer=data["solver_Us"], solution_processors=[])
    indx_nodes = extract_idx(dataR["nw"], result["solution"]["nw"], Stage, calcular_subgrafos=subgra)
    rcct = Dict()

    return result["solution"]["nw"], result["objective"], result["termination_status"] , rcct, indx_nodes
end

function solve_tnep_N1_idx_rc(data::Dict, SolT::Matrix; subgra::Bool=false) 
    Stage = size(SolT,2)
    num_contingencies = data["Contingency"] ? length(data["N1contingency"]) : 0
    data = uncertain(data)
    dataR = replicate_modify_N1(data ,num_contingencies, Stage, Set(["time_series", "per_unit"]),SolT)
    pm = instantiate_model(dataR, _PM.ACPPowerModel, build_opftnep_N1_rcT_nAP, ref_add_core_N1!, Set(["time_series", "per_unit"]),_PM.pm_it_sym
    ;ref_extensions = [add_ref_COMP_N1!,add_ref_dcgridN1!])
    result = optimize_model!(pm, relax_integrality=false, optimizer=data["solver_Us"], solution_processors=[])
    indx_nodes = extract_idx(dataR["nw"], result["solution"]["nw"], Stage, calcular_subgrafos=subgra)
    rcct = extract_rc_nodes(data, result["solution"]["nw"], Stage)
    
    return result["solution"]["nw"], result["objective"], result["termination_status"] , rcct, indx_nodes
end

function solve_tnep_N1_nrc(data::Dict, SolT::Matrix; subgra::Bool=false)
    Stage = size(SolT,2) 
    num_contingencies = data["Contingency"] ? length(data["N1contingency"]) : 0
    data = uncertain(data)
    dataR = replicate_modify_N1(data ,num_contingencies, Stage, Set(["time_series", "per_unit"]),SolT)
    pm = instantiate_model(dataR, _PM.ACPPowerModel, build_opftnep_N1_nrcT_nAP, ref_add_core_N1!, Set(["time_series", "per_unit"]),_PM.pm_it_sym
    ;ref_extensions = [add_ref_dcgridN1!])
    result = optimize_model!(pm, relax_integrality=false, optimizer=data["solver_Us"], solution_processors=[])
    rcct = Dict()

    return result["solution"]["nw"], result["objective"], result["termination_status"] , rcct
end

function solve_tnep_N1_rc(data::Dict, SolT::Matrix; subgra::Bool=false) 
    Stage = size(SolT,2)
    num_contingencies = data["Contingency"] ? length(data["N1contingency"]) : 0
    data = uncertain(data)
    dataR = replicate_modify_N1(data ,num_contingencies, Stage, Set(["time_series", "per_unit"]),SolT)
    pm = instantiate_model(dataR, _PM.ACPPowerModel, build_opftnep_N1_rcT_nAP, ref_add_core_N1!, Set(["time_series", "per_unit"]),_PM.pm_it_sym
    ;ref_extensions = [add_ref_COMP_N1!,add_ref_dcgridN1!])
    result = optimize_model!(pm, relax_integrality=false, optimizer=data["solver_Us"], solution_processors=[])
    rcct = extract_rc_nodes(data, result["solution"]["nw"], Stage)
    
    return result["solution"]["nw"], result["objective"], result["termination_status"] , rcct
end

function solve_tnep_N1_nrc_AP(data::Dict, SolT::Matrix; subgra::Bool=false)
    Stage = size(SolT,2) 
    num_contingencies = data["Contingency"] ? length(data["N1contingency"]) : 0
    data = uncertain(data)
    dataR = replicate_modify_N1(data ,num_contingencies, Stage, Set(["time_series", "per_unit"]),SolT)
    pm = instantiate_model(dataR, _PM.ACPPowerModel, build_opftnep_N1_nrcT, ref_add_core_N1!, Set(["time_series", "per_unit"]),_PM.pm_it_sym
    ;ref_extensions = [add_ref_dcgridN1!, add_ref_ARTCOMP_N1!])
    result = optimize_model!(pm, relax_integrality=false, optimizer=data["solver_Us"], solution_processors=[])
    rcct = Dict()

    return result["solution"]["nw"], result["objective"], result["termination_status"] , rcct
end

function solve_tnep_N1_rc_AP(data::Dict, SolT::Matrix; subgra::Bool=false) 
    Stage = size(SolT,2)
    num_contingencies = data["Contingency"] ? length(data["N1contingency"]) : 0
    data = uncertain(data)
    dataR = replicate_modify_N1(data ,num_contingencies, Stage, Set(["time_series", "per_unit"]),SolT)
    pm = instantiate_model(dataR, _PM.ACPPowerModel, build_opftnep_N1_rcT, ref_add_core_N1!, Set(["time_series", "per_unit"]),_PM.pm_it_sym
    ;ref_extensions = [add_ref_COMP_N1!,add_ref_dcgridN1!,add_ref_ARTCOMP_N1!])
    result = optimize_model!(pm, relax_integrality=false, optimizer=data["solver_Us"], solution_processors=[])
    rcct = extract_rc_nodes(data, result["solution"]["nw"], Stage)
    
    return result["solution"]["nw"], result["objective"], result["termination_status"] , rcct
end

function uncertain(sn_data::Dict)
    if haskey(sn_data,"Uncert") && sn_data["Unct"]==true
        sn_data["Uncert"]["L"] = Dict{String,Float64}()
        sn_data["Uncert"]["G"] = Dict{String,Float64}()
        varL =  sn_data["Uncert"]["varL"]
        varG =  sn_data["Uncert"]["varG"]
        if sn_data["Uncert"]["p"] == 1
            for (i,dL) in data["load"]
                sn_data["Uncert"]["L"][i] = Distributions.normal(1, varL)
            end
            for (i,dG) in data["gen"]
                sn_data["Uncert"]["G"][i] = Distributions.normal(1, varG)
            end
        else
            for (i,dL) in data["load"]
                sn_data["Uncert"]["L"][i] = 1.0 + varL
            end
            for (i,dG) in data["gen"]
                sn_data["Uncert"]["G"][i] = 1.0 + varG
            end
        end
    else    
        sn_data["Uncert"] = Dict{String,Dict}("L" => Dict{String,Float64}(i => 1.0 for (i,dL) in sn_data["load"]), "G" => Dict{String,Float64}(i => 1.0 for (i,dG) in sn_data["gen"]))
    end
    return sn_data
end