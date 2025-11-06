function setup_case(namefile::String, reactive::Bool, contingency::Bool;
    Stage::Int=1,growth_rate::Float64=20.0, d_rate::Float64=10.0, years_stage::Int=1)

    Memento.setlevel!(Memento.getlogger(PowerModels), "error")
    Memento.setlevel!(Memento.getlogger(PowerModelsACDC), "error")
    _PM.silence()
    case_data = PowerModels.parse_file(namefile * ".m")
    PowerModelsACDC.process_additional_data!(case_data)

    case_data["ReactiveCompensation"] = reactive
    case_data["Contingency"] = contingency
    if contingency == false
        case_data["n_copies"] = [0]
        case_data["N_Contingency"] = 0
    else
        case_data["N_Contingency"] = length(case_data["N1contingency"])
        case_data["n_copies"] = sort(collect(1:length(case_data["N1contingency"])))
    end
    case_data["STORAGE"] = false
    case_data["Stage"] = Stage
    V_Growth = [1/((1+growth_rate/100)^(Stage-j)) for j = 1:Stage]
    #V_Growth = [(1-growth*t/100)+ (j-1)*growth*t/100/(t-1) for j = 1:t ]
    V_Discount = [1/(1+(d_rate/100))^(years_stage*(j-1)) for j = 1:Stage]
    case_data["Discount"] = V_Discount
    case_data["Growth"] = V_Growth
    case_data["Period_Stage"] = [1]
    case_data["Mat_cost"] = Calculate_Mat_Cost(case_data)
    case_data["solver_Us"] = JuMP.optimizer_with_attributes(Ipopt.Optimizer, "print_level" => 0,"max_iter" => 500, "sb" => "yes")
    case_data["title"] = namefile * "_" * fecha_str_clean
    case_data["nlines"] = length(case_data["Mat_cost"])
    case_data["Inicial_Top"] = zeros(case_data["nlines"],Stage) 
    case_data["Unct"] = false
    case_data["ReactiveCompesation"] = reactive
    return case_data
end

function Calculate_Mat_Cost(data::Dict)
    if haskey(data,"ne_branch")
        SOL = length(data["ne_branch"])
    else
        SOL = 0
    end
    if haskey(data,"branchdc_ne")
        SOL_dc = length(data["branchdc_ne"])
    else
        SOL_dc = 0
    end
    if haskey(data,"storagecost") && data["STORAGE"] == true
        SOL_st = length(data["storagecost"])
    else
        SOL_st = 0
    end
    Matrx_cost = zeros(SOL+SOL_dc+SOL_st,1)
    if SOL > 0
        for k in 1:SOL
            Matrx_cost[k,1] = data["ne_branch"][string(k)]["construction_cost"]
        end
    end
    if SOL_dc > 0
        for k in 1:SOL_dc
            Matrx_cost[k+SOL,1] = data["branchdc_ne"][string(k)]["cost"]
        end
    end
    if SOL_st > 0
        for k in 1:SOL_st
            Matrx_cost[k+SOL+SOL_dc,1] = data["storagecost"][string(k)]["cost"]
        end
    end 
    return Matrx_cost
end
