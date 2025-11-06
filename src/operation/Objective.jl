#Objective function

function objective_min_cost_RCN1(pm::_PM.AbstractPowerModel)
    gen_cost = Dict()
    comp_cost = Dict()
    art_penalty = Dict()
    storage_cost = Dict()
    for (km, dict) in _PM.nws(pm)
        gen_cost[km] = Dict{Any,Any}()
        comp_cost[km] = Dict{Any,Any}()
        art_penalty[km] = Dict{Any,Any}()
        storage_cost[km] = Dict{Any,Any}()
        for (n, nw_ref) in dict
            for (i,gen) in nw_ref[:gen]
                pg = pm.var[:it][_PM.pm_it_sym][:nw][km][n][:pg][i]
                if length(gen["cost"]) == 1 
                    gen_cost[km][(n,i)] = gen["cost"][1]
                elseif length(gen["cost"]) == 2
                    gen_cost[km][(n,i)] = gen["cost"][1]*pg + gen["cost"][2]
                elseif length(gen["cost"]) == 3
                    gen_cost[km][(n,i)] = gen["cost"][1]*pg^2 + gen["cost"][2]*pg + gen["cost"][3]
                else
                    gen_cost[km][(n,i)] = 0.0
                end
            end
            for (i,comp) in nw_ref[:compcost]
                RCqg = pm.var[:it][_PM.pm_it_sym][:nw][km][n][:RCqg][i] 
                comp_cost[km][(n,i)] = comp["x2"]*RCqg*pm.data["Discount"][n]*nw_ref[:baseMVA]
            end
            for (i,art) in nw_ref[:art_act]
                ARpg = (pm.var[:it][_PM.pm_it_sym][:nw][km][n][:ARpg][i])
                art_penalty[km][(n,i)] = ARpg*1e9
            end
        end
    end

    # Maximum values for each variable
    @variable(pm.model, gen_cost_max[n_i in keys(first(values(gen_cost)))] )
    @variable(pm.model, comp_cost_max[n_i in keys(first(values(comp_cost)))] )
    @variable(pm.model, art_penalty_max[n_i in keys(first(values(art_penalty)))] )

    # Define a max value
    for (km, _) in _PM.nws(pm)
        for n_i in keys(gen_cost[km])
            @constraint(pm.model, gen_cost_max[n_i] >= gen_cost[km][n_i])
        end
        for n_i in keys(comp_cost[km])
            @constraint(pm.model, comp_cost_max[n_i] >= comp_cost[km][n_i])
        end
        for n_i in keys(art_penalty[km])
            @constraint(pm.model, art_penalty_max[n_i] >= art_penalty[km][n_i])
        end
    end

    if length(pm.data["n_copies"]) > 1
        cst_exp = sum(nw_ref[:Cost_Expansion] for (_, nw_ref) in _PM.nws(pm)[:1])
    else
        cst_exp = sum(nw_ref[:Cost_Expansion] for (_, nw_ref) in _PM.nws(pm)[:0])
    end
    @objective(pm.model, Min,
        cst_exp +
        sum(gen_cost_max[n_i] for n_i in keys(gen_cost_max)) +
        sum(comp_cost_max[n_i] for n_i in keys(comp_cost_max)) +
        sum(art_penalty_max[n_i] for n_i in keys(art_penalty_max))
    )    
end

function objective_min_cost_RCN1_nrc(pm::_PM.AbstractPowerModel)
    gen_cost = Dict()
    art_penalty = Dict()
    for (km, dict) in _PM.nws(pm)
        gen_cost[km] = Dict{Any,Any}()
        art_penalty[km] = Dict{Any,Any}()
        for (n, nw_ref) in dict
            for (i,gen) in nw_ref[:gen]
                pg = pm.var[:it][_PM.pm_it_sym][:nw][km][n][:pg][i]
                if length(gen["cost"]) == 1 
                    gen_cost[km][(n,i)] = gen["cost"][1]
                elseif length(gen["cost"]) == 2
                    gen_cost[km][(n,i)] = gen["cost"][1]*pg + gen["cost"][2]
                elseif length(gen["cost"]) == 3
                    gen_cost[km][(n,i)] = gen["cost"][1]*pg^2 + gen["cost"][2]*pg + gen["cost"][3]
                else
                    gen_cost[km][(n,i)] = 0.0
                end
            end
            for (i,art) in nw_ref[:art_act]
                ARpg = (pm.var[:it][_PM.pm_it_sym][:nw][km][n][:ARpg][i])
                art_penalty[km][(n,i)] = ARpg*1e9
            end
        end
    end

    # Maximum values for each variable
    @variable(pm.model, gen_cost_max[n_i in keys(first(values(gen_cost)))] )
    @variable(pm.model, art_penalty_max[n_i in keys(first(values(art_penalty)))] )

    # Define a max value
    for (km, _) in _PM.nws(pm)
        for n_i in keys(gen_cost[km])
            @constraint(pm.model, gen_cost_max[n_i] >= gen_cost[km][n_i])
        end
        for n_i in keys(art_penalty[km])
            @constraint(pm.model, art_penalty_max[n_i] >= art_penalty[km][n_i])
        end
    end

    if length(pm.data["n_copies"]) > 1
        cst_exp = sum(nw_ref[:Cost_Expansion] for (_, nw_ref) in _PM.nws(pm)[:1])
    else
        cst_exp = sum(nw_ref[:Cost_Expansion] for (_, nw_ref) in _PM.nws(pm)[:0])
    end

    @objective(pm.model, Min,
        cst_exp +
        sum(gen_cost_max[n_i] for n_i in keys(gen_cost_max)) +
        sum(art_penalty_max[n_i] for n_i in keys(art_penalty_max))
    )
end

function objective_min_cost_RCN1_nRC_nAP(pm::_PM.AbstractPowerModel)
    gen_cost = Dict()
    storage_cost = Dict()
    for (km, dict) in _PM.nws(pm)
        gen_cost[km] = Dict{Any,Any}()
        storage_cost[km] = Dict{Any,Any}()
        for (n, nw_ref) in dict
            for (i,gen) in nw_ref[:gen]
                pg = pm.var[:it][_PM.pm_it_sym][:nw][km][n][:pg][i]
                if length(gen["cost"]) == 1 
                    gen_cost[km][(n,i)] = gen["cost"][1]
                elseif length(gen["cost"]) == 2
                    gen_cost[km][(n,i)] = gen["cost"][1]*pg + gen["cost"][2]
                elseif length(gen["cost"]) == 3
                    gen_cost[km][(n,i)] = gen["cost"][1]*pg^2 + gen["cost"][2]*pg + gen["cost"][3]
                else
                    gen_cost[km][(n,i)] = 0.0
                end
            end
        end
    end

    # Maximum values for each variable
    @variable(pm.model, gen_cost_max[n_i in keys(first(values(gen_cost)))] )

    # Define a max value
    for (km, _) in _PM.nws(pm)
        for n_i in keys(gen_cost[km])
            @constraint(pm.model, gen_cost_max[n_i] >= gen_cost[km][n_i])
        end
    end

    if length(pm.data["n_copies"]) > 1
        cst_exp = sum(nw_ref[:Cost_Expansion] for (_, nw_ref) in _PM.nws(pm)[:1])
    else
        cst_exp = sum(nw_ref[:Cost_Expansion] for (_, nw_ref) in _PM.nws(pm)[:0])
    end
    @objective(pm.model, Min,
        cst_exp +
        sum(gen_cost_max[n_i] for n_i in keys(gen_cost_max))
    )    
end

function objective_min_cost_RCN1_nAP(pm::_PM.AbstractPowerModel)
    gen_cost = Dict()
    comp_cost = Dict()
    for (km, dict) in _PM.nws(pm)
        gen_cost[km] = Dict{Any,Any}()
        comp_cost[km] = Dict{Any,Any}()
        for (n, nw_ref) in dict
            for (i,gen) in nw_ref[:gen]
                pg = pm.var[:it][_PM.pm_it_sym][:nw][km][n][:pg][i]
                if length(gen["cost"]) == 1 
                    gen_cost[km][(n,i)] = gen["cost"][1]
                elseif length(gen["cost"]) == 2
                    gen_cost[km][(n,i)] = gen["cost"][1]*pg + gen["cost"][2]
                elseif length(gen["cost"]) == 3
                    gen_cost[km][(n,i)] = gen["cost"][1]*pg^2 + gen["cost"][2]*pg + gen["cost"][3]
                else
                    gen_cost[km][(n,i)] = 0.0
                end
            end
            for (i,comp) in nw_ref[:compcost]
                RCqg = pm.var[:it][_PM.pm_it_sym][:nw][km][n][:RCqg][i] 
                comp_cost[km][(n,i)] = comp["x2"]*RCqg*pm.data["Discount"][n]*nw_ref[:baseMVA]
            end
        end
    end

    # Maximum values for each variable
    @variable(pm.model, gen_cost_max[n_i in keys(first(values(gen_cost)))] )
    @variable(pm.model, comp_cost_max[n_i in keys(first(values(comp_cost)))] )

    # Define a max value
    for (km, _) in _PM.nws(pm)
        for n_i in keys(gen_cost[km])
            @constraint(pm.model, gen_cost_max[n_i] >= gen_cost[km][n_i])
        end
        for n_i in keys(comp_cost[km])
            @constraint(pm.model, comp_cost_max[n_i] >= comp_cost[km][n_i])
        end
    end

    if length(pm.data["n_copies"]) > 1
        cst_exp = sum(nw_ref[:Cost_Expansion] for (_, nw_ref) in _PM.nws(pm)[:1])
    else
        cst_exp = sum(nw_ref[:Cost_Expansion] for (_, nw_ref) in _PM.nws(pm)[:0])
    end
    @objective(pm.model, Min,
        cst_exp +
        sum(gen_cost_max[n_i] for n_i in keys(gen_cost_max)) +
        sum(comp_cost_max[n_i] for n_i in keys(comp_cost_max))
    )
end

function objective_min_cost_strg_RCN1(pm::_PM.AbstractPowerModel)
    Prd_Stage = pm.data["Period_Stage"]
    gen_cost = Dict()
    comp_cost = Dict()
    art_penalty = Dict()
    storage_cost = Dict()
    for (km, dict) in _PM.nws(pm)
        gen_cost[km] = Dict{Any,Any}()
        comp_cost[km] = Dict{Any,Any}()
        art_penalty[km] = Dict{Any,Any}()
        storage_cost[km] = Dict{Any,Any}()
        for (n, nw_ref) in dict
            for (i,gen) in nw_ref[:gen]
                pg = sum(pm.var[:it][_PM.pm_it_sym][:nw][km][n][:pg][i,k] for k in Prd_Stage)
                if length(gen["cost"]) == 1 
                    gen_cost[km][(n,i)] = gen["cost"][1]
                elseif length(gen["cost"]) == 2
                    gen_cost[km][(n,i)] = gen["cost"][1]*pg + gen["cost"][2]
                elseif length(gen["cost"]) == 3
                    gen_cost[km][(n,i)] = gen["cost"][1]*pg^2 + gen["cost"][2]*pg + gen["cost"][3]
                else
                    gen_cost[km][(n,i)] = 0.0
                end
            end
            for (i,comp) in nw_ref[:compcost]
                RCqg = pm.var[:it][_PM.pm_it_sym][:nw][km][n][:RCqg][i,1] 
                comp_cost[km][(n,i)] = comp["x2"]*RCqg*pm.data["Discount"][n]*nw_ref[:baseMVA]
            end
            for (i,art) in nw_ref[:art_act]
                ARpg = sum(pm.var[:it][_PM.pm_it_sym][:nw][km][n][:ARpg][i,k] for k in Prd_Stage)
                art_penalty[km][(n,i)] = ARpg*10^8
            end
        end
    end
    N_Ctg = length(pm.data["n_copies"])
    if N_Ctg > 1
        return JuMP.@objective(pm.model, Min,
        sum(sum(
            nw_ref[:Cost_Expansion]+
            sum( gen_cost[km][(n,i)] for (i,gen) in nw_ref[:gen]) +
            sum(comp_cost[km][(n,i)] for (i,comp) in nw_ref[:compcost])+
            sum(art_penalty[km][(n,i)]  for (i,art) in nw_ref[:art_act])
        for (n, nw_ref) in dict) for (km, dict) in _PM.nws(pm))/N_Ctg
        )
    else
        return JuMP.@objective(pm.model, Min,
        sum(sum(
            nw_ref[:Cost_Expansion]+
            sum( gen_cost[km][(n,i)] for (i,gen) in nw_ref[:gen]) +
            sum(comp_cost[km][(n,i)] for (i,comp) in nw_ref[:compcost])+
            sum(art_penalty[km][(n,i)]  for (i,art) in nw_ref[:art_act])
        for (n, nw_ref) in dict) for (km, dict) in _PM.nws(pm))
        )
    end
end