#Replicate and modify data

"Transforms a single network into a multinetwork with several deepcopies of the original network"
function replicate_modify_N1(sn_data::Dict{String,<:Any}, count::Int, stageCT::Int, global_keys::Set{String},SolT::Matrix)
    ldc=0
    Nst=0
    
    if haskey(sn_data,"ne_branch")
        if haskey(sn_data,"branchdc_ne")
            lac = length(sn_data["ne_branch"])
            ldc = length(sn_data["branchdc_ne"])
        else
            lac = length(sn_data["ne_branch"])
            ldc = 0
        end
    else
        lac = 0
    end
    if haskey(sn_data,"branchdc_ne")
        ldc = length(sn_data["branchdc_ne"])
    end
    if haskey(sn_data,"storage") && sn_data["STORAGE"]==true
        Nst = length(sn_data["storage"])
    end
    SOL = zeros(size(SolT))
    SOL[:,1] = deepcopy(SolT[:,1])
    Stage = size(SolT,2)
    for j in 2:Stage
        SOL[:,j] = SOL[:,j-1]+SolT[:,j]
    end

    
    SOL_CONV = []
    if haskey(sn_data,"convdc_ne")
        if haskey(sn_data,"convdc")
            conv_exis = length(sn_data["convdc"])
        else
            conv_exis = 0
        end
        SOL_CONV = zeros(length(sn_data["convdc_ne"])+conv_exis,Stage)
        for i in 1:Stage
            for k in 1:ldc
                if SOL[k+lac,i] > 0
                    bf = sn_data["branchdc_ne"][string(k)]["fbusdc"]
                    bt = sn_data["branchdc_ne"][string(k)]["tbusdc"]
                    for (n,info) in sn_data["convdc_ne"]
                        if info["busdc_i"] == bf || info["busdc_i"] == bt
                            SOL_CONV[parse(Int,n),i] = 1
                        end
                    end
                end
            end 
        end
    end
    if haskey(sn_data,"convdc_ne")
        SolT_CONV = zeros(size(SOL_CONV))
        SolT_CONV[:,1] = deepcopy(SOL_CONV[:,1])
        for i in 2:Stage
            SolT_CONV[:,i] = SOL_CONV[:,i] - SOL_CONV[:,i-1]
        end
    end


    @assert count >= 0
    if _IM.ismultinetwork(sn_data)
        Memento.error(_LOGGER, "replicate can only be used on single networks")
    end

    name = get(sn_data, "name", "anonymous")

    mnn_data = Dict{String,Any}(
        "nw" => Dict{String,Any}()
    )

    mnn_data["multinetwork"] = true
    mnn_data["n_copies"] = sn_data["n_copies"]
    mnn_data["Stage"] = sn_data["Stage"]
    mnn_data["Period_Stage"] = sn_data["Period_Stage"]
    mnn_data["Discount"] = sn_data["Discount"]
    mnn_data["Growth"] = sn_data["Growth"]
    mnn_data["Contingency"] = sn_data["Contingency"]
    mnn_data["Uncert"] = sn_data["Uncert"]
    sn_data_tmp = deepcopy(sn_data)
    for k in global_keys
        if haskey(sn_data_tmp, k)
            mnn_data[k] = sn_data_tmp[k]
        end

        # note this is robust to cases where k is not present in sn_data_tmp
        delete!(sn_data_tmp, k)
    end

    mnn_data["name"] = "$(count)x$(stageCT) replicates of $(name)"
    
    for km in sn_data["n_copies"]
        mn_data = Dict{String, Any}("nw" => Dict{String, Any}())
        for n in 1:stageCT
            mn_data["nw"]["$n"] = deepcopy(sn_data_tmp)
            if sn_data["Contingency"] == true
                mn_data["nw"]["$n"]["branch"][string(sn_data_tmp["N1contingency"]["$km"]["N"])]["br_status"] = 0
            end
            mn_data["nw"]["$n"]["Cost_Expansion"] = 0
            if !haskey(mn_data["nw"]["$n"],"branch")
                mn_data["nw"]["$n"]["branch"] = Dict{String,Any}()
            end
            linesac = length(mn_data["nw"]["$n"]["branch"])

            if !haskey(mn_data["nw"]["$n"],"branchdc")
                mn_data["nw"]["$n"]["branchdc"] = Dict{String,Any}()
            end
            linesdc = length(mn_data["nw"]["$n"]["branchdc"])


            for i in 1:lac
                if SOL[i,n] > 0
                    mn_data["nw"]["$n"]["branch"][string(linesac+i)] = deepcopy(mn_data["nw"]["$n"]["ne_branch"][string(i)])
                    mn_data["nw"]["$n"]["branch"][string(linesac+i)]["rate_a"] = SOL[i,n]*deepcopy(mn_data["nw"]["$n"]["ne_branch"][string(i)]["rate_a"])
                    mn_data["nw"]["$n"]["branch"][string(linesac+i)]["br_r"] = (1/SOL[i,n])*deepcopy(mn_data["nw"]["$n"]["ne_branch"][string(i)]["br_r"])
                    mn_data["nw"]["$n"]["branch"][string(linesac+i)]["br_x"] = (1/SOL[i,n])*deepcopy(mn_data["nw"]["$n"]["ne_branch"][string(i)]["br_x"])
                    mn_data["nw"]["$n"]["branch"][string(linesac+i)]["g_to"] = (SOL[i,n])*deepcopy(mn_data["nw"]["$n"]["ne_branch"][string(i)]["g_to"])
                    mn_data["nw"]["$n"]["branch"][string(linesac+i)]["g_fr"] = (SOL[i,n])*deepcopy(mn_data["nw"]["$n"]["ne_branch"][string(i)]["g_fr"])
                    mn_data["nw"]["$n"]["branch"][string(linesac+i)]["angmin"] = deepcopy(mn_data["nw"]["$n"]["ne_branch"][string(i)]["angmin"])
                    mn_data["nw"]["$n"]["branch"][string(linesac+i)]["angmax"] = deepcopy(mn_data["nw"]["$n"]["ne_branch"][string(i)]["angmax"])
                    mn_data["nw"]["$n"]["branch"][string(linesac+i)]["br_status"] = 1.0
                    mn_data["nw"]["$n"]["branch"][string(linesac+i)]["source_id"] = Vector{Any}(["branch",Int(linesac+i)])
                    mn_data["nw"]["$n"]["branch"][string(linesac+i)]["index"] = Int(linesac+i)
                    mn_data["nw"]["$n"]["Cost_Expansion"] += SolT[i,n]*mn_data["nw"]["$n"]["branch"][string(linesac+i)]["construction_cost"]*sn_data["Discount"][n]
                    #delete!(mn_data["nw"]["$n"]["branch"][string(linesac+i)],"construction_cost")
                end
            end
            for j in 1:ldc
                if SOL[j+lac,n] > 0
                    mn_data["nw"]["$n"]["branchdc"][string(linesdc+j)] = deepcopy(mn_data["nw"]["$n"]["branchdc_ne"][string(j)])
                    mn_data["nw"]["$n"]["branchdc"][string(linesdc+j)]["rateA"] = SOL[j+lac,n]*deepcopy(mn_data["nw"]["$n"]["branchdc_ne"][string(j)]["rateA"])
                    mn_data["nw"]["$n"]["branchdc"][string(linesdc+j)]["r"] = (1/SOL[j+lac,n])*deepcopy(mn_data["nw"]["$n"]["branchdc_ne"][string(j)]["r"])
                    mn_data["nw"]["$n"]["branchdc"][string(linesdc+j)]["status"] = 1.0
                    mn_data["nw"]["$n"]["branchdc"][string(linesdc+j)]["index"] = Int(linesdc+j+lac)
                    mn_data["nw"]["$n"]["branchdc"][string(linesdc+j)]["source_id"] = Vector{Any}(["branchdc",Int(linesdc+j)])
                    mn_data["nw"]["$n"]["Cost_Expansion"] += SolT[j+lac,n]*mn_data["nw"]["$n"]["branchdc"][string(linesdc+j)]["cost"]*sn_data["Discount"][n]
                    #delete!(mn_data["nw"]["$n"]["branchdc"][string(linesdc+j+lac)],"cost")
                end
            end
            for j in 1:Nst
                if SOL[j+lac+ldc,n] > 0
                    mn_data["nw"]["$n"]["storage"][string(j)]["status"] = 1
                    mn_data["nw"]["$n"]["Cost_Expansion"] += SolT[j+lac+ldc,n]*mn_data["nw"]["$n"]["storagecost"][string(j)]["cost"]*sn_data["Discount"][n]
                end
            end
            if !haskey(mn_data["nw"]["$n"],"convdc")
                mn_data["nw"]["$n"]["convdc"] = Dict{String,Any}()
            end
            if !haskey(mn_data["nw"]["$n"],"busdc")
                mn_data["nw"]["$n"]["busdc"] = Dict{String,Any}()
            end
            if haskey(sn_data,"convdc_ne")
                for (j,info) in sn_data["convdc_ne"]
                    #ADD converter
                    if SOL_CONV[parse(Int,j),n] > 0
                        mn_data["nw"]["$n"]["convdc"][j] = deepcopy(info)
                        mn_data["nw"]["$n"]["convdc"][j]["status"] = 1.0
                        mn_data["nw"]["$n"]["Cost_Expansion"] += SolT_CONV[parse(Int,j)+conv_exis,n]*mn_data["nw"]["$n"]["convdc"][j]["cost"]*sn_data["Discount"][n]
                        delete!(mn_data["nw"]["$n"]["convdc"][j],"cost")
                        if !haskey(mn_data["nw"]["$n"]["busdc"],j)
                            mn_data["nw"]["$n"]["busdc"][j] = deepcopy(mn_data["nw"]["$n"]["busdc_ne"][j])
                        end
                    end
                end
            end
            #Generation and loads
            
            FactorL_Un = sn_data["Uncert"]["L"]
            FactorG_Un = sn_data["Uncert"]["G"]
                  
            for (i,info) in mn_data["nw"]["$n"]["gen"]
                mn_data["nw"]["$n"]["gen"][i]["pmax"] = deepcopy(sn_data["Growth"][n]*info["pmax"]*FactorG_Un[i])
                mn_data["nw"]["$n"]["gen"][i]["pmin"] = deepcopy(sn_data["Growth"][n]*info["pmin"]*FactorG_Un[i])
                mn_data["nw"]["$n"]["gen"][i]["qmax"] = deepcopy(sn_data["Growth"][n]*info["qmax"]*FactorG_Un[i])
                mn_data["nw"]["$n"]["gen"][i]["qmin"] = deepcopy(sn_data["Growth"][n]*info["qmin"]*FactorG_Un[i])
            end
            for (i,info) in mn_data["nw"]["$n"]["load"]
                mn_data["nw"]["$n"]["load"][i]["pd"] = deepcopy(sn_data["Growth"][n]*info["pd"]*FactorL_Un[i])
                mn_data["nw"]["$n"]["load"][i]["qd"] = deepcopy(sn_data["Growth"][n]*info["qd"]*FactorL_Un[i])
            end
            mn_data["nw"]["$n"]["loads_VP"] = Dict{String,Any}()
            #if length(Period_Stage) > 1
            if  haskey(mn_data["nw"]["$n"],"load_curve") && sn_data["STORAGE"]==true
                for (i,info) in mn_data["nw"]["$n"]["load"]
                    loads =  Dict{Int64,Dict}()
                    for k in mn_data["nw"]["$n"]["Period_Stage"]
                        loads[k] = Dict{String,Float64}("pd"=>info["pd"]*mn_data["nw"]["$n"]["load_curve"][string(k)]["RTL"], "qd"=>info["qd"]*mn_data["nw"]["$n"]["load_curve"][string(k)]["RTL"])
                    end
                    mn_data["nw"]["$n"]["loads_VP"][i] = deepcopy(loads)
                end
            end
            #end
        end
        mnn_data["nw"]["$km"] = deepcopy(mn_data)
    end
    return mnn_data
end