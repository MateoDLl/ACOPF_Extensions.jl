function ref_add_core_N1!(ref::Dict{Symbol,Any})
    for (keysN1, dictc) in ref[:it][_PM.pm_it_sym][:nw]
        #println(keys(dictc))  ref[:it][_PM.pm_it_sym][:nw][keysN1][nw]
        for (nw, nw_ref) in dictc
            if !haskey(nw_ref, :conductor_ids)
                if !haskey(nw_ref, :conductors)
                    nw_ref[:conductor_ids] = 1
                else
                    nw_ref[:conductor_ids] = nw_ref[:conductors]
                end
            end

            ### filter out inactive components ###
            nw_ref[:bus] = Dict(x for x in nw_ref[:bus] if (x.second["bus_type"] != _PM.pm_component_status_inactive["bus"]))
            nw_ref[:load] = Dict(x for x in nw_ref[:load] if (x.second["status"] != _PM.pm_component_status_inactive["load"] && x.second["load_bus"] in keys(nw_ref[:bus])))
            nw_ref[:shunt] = Dict(x for x in nw_ref[:shunt] if (x.second["status"] != _PM.pm_component_status_inactive["shunt"] && x.second["shunt_bus"] in keys(nw_ref[:bus])))
            nw_ref[:gen] = Dict(x for x in nw_ref[:gen] if (x.second["gen_status"] != _PM.pm_component_status_inactive["gen"] && x.second["gen_bus"] in keys(nw_ref[:bus])))
            nw_ref[:storage] = Dict(x for x in nw_ref[:storage] if (x.second["status"] != _PM.pm_component_status_inactive["storage"] && x.second["storage_bus"] in keys(nw_ref[:bus])))
            nw_ref[:switch] = Dict(x for x in nw_ref[:switch] if (x.second["status"] != _PM.pm_component_status_inactive["switch"] && x.second["f_bus"] in keys(nw_ref[:bus]) && x.second["t_bus"] in keys(nw_ref[:bus])))
            nw_ref[:branch] = Dict(x for x in nw_ref[:branch] if (x.second["br_status"] != _PM.pm_component_status_inactive["branch"] && x.second["f_bus"] in keys(nw_ref[:bus]) && x.second["t_bus"] in keys(nw_ref[:bus])))
            nw_ref[:dcline] = Dict(x for x in nw_ref[:dcline] if (x.second["br_status"] != _PM.pm_component_status_inactive["dcline"] && x.second["f_bus"] in keys(nw_ref[:bus]) && x.second["t_bus"] in keys(nw_ref[:bus])))


            ### setup arcs from edges ###
            nw_ref[:arcs_from] = [(i,branch["f_bus"],branch["t_bus"]) for (i,branch) in nw_ref[:branch]]
            nw_ref[:arcs_to]   = [(i,branch["t_bus"],branch["f_bus"]) for (i,branch) in nw_ref[:branch]]
            nw_ref[:arcs] = [nw_ref[:arcs_from]; nw_ref[:arcs_to]]

            nw_ref[:arcs_from_dc] = [(i,dcline["f_bus"],dcline["t_bus"]) for (i,dcline) in nw_ref[:dcline]]
            nw_ref[:arcs_to_dc]   = [(i,dcline["t_bus"],dcline["f_bus"]) for (i,dcline) in nw_ref[:dcline]]
            nw_ref[:arcs_dc]      = [nw_ref[:arcs_from_dc]; nw_ref[:arcs_to_dc]]

            nw_ref[:arcs_from_sw] = [(i,switch["f_bus"],switch["t_bus"]) for (i,switch) in nw_ref[:switch]]
            nw_ref[:arcs_to_sw]   = [(i,switch["t_bus"],switch["f_bus"]) for (i,switch) in nw_ref[:switch]]
            nw_ref[:arcs_sw] = [nw_ref[:arcs_from_sw]; nw_ref[:arcs_to_sw]]


            ### bus connected component lookups ###
            bus_loads = Dict((i, Int[]) for (i,bus) in nw_ref[:bus])
            for (i, load) in nw_ref[:load]
                push!(bus_loads[load["load_bus"]], i)
            end
            nw_ref[:bus_loads] = bus_loads

            bus_shunts = Dict((i, Int[]) for (i,bus) in nw_ref[:bus])
            for (i,shunt) in nw_ref[:shunt]
                push!(bus_shunts[shunt["shunt_bus"]], i)
            end
            nw_ref[:bus_shunts] = bus_shunts

            bus_gens = Dict((i, Int[]) for (i,bus) in nw_ref[:bus])
            for (i,gen) in nw_ref[:gen]
                push!(bus_gens[gen["gen_bus"]], i)
            end
            nw_ref[:bus_gens] = bus_gens

            bus_storage = Dict((i, Int[]) for (i,bus) in nw_ref[:bus])
            for (i,strg) in nw_ref[:storage]
                push!(bus_storage[strg["storage_bus"]], i)
            end
            nw_ref[:bus_storage] = bus_storage

            bus_arcs = Dict((i, Tuple{Int,Int,Int}[]) for (i,bus) in nw_ref[:bus])
            for (l,i,j) in nw_ref[:arcs]
                push!(bus_arcs[i], (l,i,j))
            end
            nw_ref[:bus_arcs] = bus_arcs

            bus_arcs_dc = Dict((i, Tuple{Int,Int,Int}[]) for (i,bus) in nw_ref[:bus])
            for (l,i,j) in nw_ref[:arcs_dc]
                push!(bus_arcs_dc[i], (l,i,j))
            end
            nw_ref[:bus_arcs_dc] = bus_arcs_dc

            bus_arcs_sw = Dict((i, Tuple{Int,Int,Int}[]) for (i,bus) in nw_ref[:bus])
            for (l,i,j) in nw_ref[:arcs_sw]
                push!(bus_arcs_sw[i], (l,i,j))
            end
            nw_ref[:bus_arcs_sw] = bus_arcs_sw



            ### reference bus lookup (a set to support multiple connected components) ###
            ref_buses = Dict{Int,Any}()
            for (k,v) in nw_ref[:bus]
                if v["bus_type"] == 3
                    ref_buses[k] = v
                end
            end

            nw_ref[:ref_buses] = ref_buses

            if length(ref_buses) > 1
                Memento.warn(_LOGGER, "multiple reference buses found, $(keys(ref_buses)), this can cause infeasibility if they are in the same connected component")
            end

            ### aggregate info for pairs of connected buses ###
            if !haskey(nw_ref, :buspairs)
                nw_ref[:buspairs] = _PM.calc_buspair_parameters(nw_ref[:bus], nw_ref[:branch])
            end
        end
    end
end

function add_ref_ARTCOMP_N1!(ref::Dict{Symbol,<:Any}, data::Dict{String,<:Any})
    for (keysN1, dictc) in ref[:it][_PM.pm_it_sym][:nw]
        for (n, nw_ref) in dictc
            bus_comp = Dict((i, Int[]) for (i,bus) in nw_ref[:bus])
            if haskey(nw_ref, :comp_react)
                for (i,dat) in nw_ref[:comp_react]
                    push!(bus_comp[nw_ref[:comp_react][i]["bus_gen"]], i) 
                end
            else
                nw_ref[:comp_react] = Dict{Any,Any}()
            end
            nw_ref[:bus_comp] = bus_comp
            bus_art = Dict((i, Int[]) for (i,bus) in nw_ref[:bus])
            if haskey(nw_ref, :art_act)
                for i in keys(nw_ref[:art_act])
                    push!(bus_art[nw_ref[:art_act][i]["bus_gen"]], i) 
                end
            else
                nw_ref[:art_act] = Dict{Any,Any}()
            end
            nw_ref[:bus_art] = bus_art
            if !haskey(nw_ref, :compcost)
                nw_ref[:compcost] = Dict{Any,Any}()
            end
        end
    end
end

function add_ref_COMP_N1!(ref::Dict{Symbol,<:Any}, data::Dict{String,<:Any})
    for (keysN1, dictc) in ref[:it][_PM.pm_it_sym][:nw]
        for (n, nw_ref) in dictc
            bus_comp = Dict((i, Int[]) for (i,bus) in nw_ref[:bus])
            if haskey(nw_ref, :comp_react)
                for (i,dat) in nw_ref[:comp_react]
                    push!(bus_comp[nw_ref[:comp_react][i]["bus_gen"]], i) 
                end
            else
                nw_ref[:comp_react] = Dict{Any,Any}()
            end
            nw_ref[:bus_comp] = bus_comp
            if !haskey(nw_ref, :compcost)
                nw_ref[:compcost] = Dict{Any,Any}()
            end
        end
    end
end

function add_ref_Storage_N1!(ref::Dict{Symbol,<:Any}, data::Dict{String,<:Any})
    for (keysN1, dictc) in ref[:it][_PM.pm_it_sym][:nw]
        for (n, nw_ref) in dictc
            if haskey(nw_ref, :storage)
                for k in data["Period_Stage"]
                    nw_ref[Symbol("P$(k)")] = deepcopy(nw_ref[:storage])
                end
            end
        end
    end
end

function add_ref_dcgridN1!(ref::Dict{Symbol,<:Any}, data::Dict{String,<:Any})
    for (keysN1, dictc) in ref[:it][_PM.pm_it_sym][:nw]
        for (n, nw_ref) in dictc
            if haskey(nw_ref, :branchdc)
                nw_ref[:branchdc] = Dict([x for x in nw_ref[:branchdc] if (x.second["status"] == 1 && x.second["fbusdc"] in keys(nw_ref[:busdc]) && x.second["tbusdc"] in keys(nw_ref[:busdc]))])
                # DC grid arcs for DC grid branches
                nw_ref[:arcs_dcgrid_from] = [(i,branch["fbusdc"],branch["tbusdc"]) for (i,branch) in nw_ref[:branchdc]]
                nw_ref[:arcs_dcgrid_to]   = [(i,branch["tbusdc"],branch["fbusdc"]) for (i,branch) in nw_ref[:branchdc]]
                nw_ref[:arcs_dcgrid] = [nw_ref[:arcs_dcgrid_from]; nw_ref[:arcs_dcgrid_to]]
                #bus arcs of the DC grid
                bus_arcs_dcgrid = Dict([(bus["busdc_i"], []) for (i,bus) in nw_ref[:busdc]])
                for (l,i,j) in nw_ref[:arcs_dcgrid]
                    push!(bus_arcs_dcgrid[i], (l,i,j))
                end
                nw_ref[:bus_arcs_dcgrid] = bus_arcs_dcgrid
            else
                nw_ref[:branchdc] = Dict{String, Any}()
                nw_ref[:arcs_dcgrid] = Dict{String, Any}()
                nw_ref[:arcs_dcgrid_from] = Dict{String, Any}()
                nw_ref[:arcs_dcgrid_to] = Dict{String, Any}()
                nw_ref[:arcs_conv_acdc] = Dict{String, Any}()
                if haskey(nw_ref, :busdc)
                    nw_ref[:bus_arcs_dcgrid] = Dict([(bus["busdc_i"], []) for (i,bus) in nw_ref[:busdc]])
                else
                    nw_ref[:bus_arcs_dcgrid] = Dict{String, Any}()
                end

            end
            if haskey(nw_ref, :convdc)
                #Filter converters & DC branches with status 0 as well as wrong bus numbers
                nw_ref[:convdc] = Dict([x for x in nw_ref[:convdc] if (x.second["status"] == 1 && x.second["busdc_i"] in keys(nw_ref[:busdc]) && x.second["busac_i"] in keys(nw_ref[:bus]))])

                nw_ref[:arcs_conv_acdc] = [(i,conv["busac_i"],conv["busdc_i"]) for (i,conv) in nw_ref[:convdc]]


                # Bus converters for existing ac buses
                bus_convs_ac = Dict([(i, []) for (i,bus) in nw_ref[:bus]])
                nw_ref[:bus_convs_ac] = _PMACDC.assign_bus_converters!(nw_ref[:convdc], bus_convs_ac, "busac_i")    

                # Bus converters for existing ac buses
                bus_convs_dc = Dict([(bus["busdc_i"], []) for (i,bus) in nw_ref[:busdc]])
                nw_ref[:bus_convs_dc]= _PMACDC.assign_bus_converters!(nw_ref[:convdc], bus_convs_dc, "busdc_i") 


                # Add DC reference buses
                ref_buses_dc = Dict{String, Any}()
                for (k,v) in nw_ref[:convdc]
                    if v["type_dc"] == 2
                        ref_buses_dc["$k"] = v
                    end
                end

                if length(ref_buses_dc) == 0
                    for (k,v) in nw_ref[:convdc]
                        if v["type_ac"] == 2
                            ref_buses_dc["$k"] = v
                        end
                    end
                    Memento.warn(_PM._LOGGER, "no reference DC bus found, setting reference bus based on AC bus type")
                end

                for (k,conv) in nw_ref[:convdc]
                    conv_id = conv["index"]
                    if conv["type_ac"] == 2 && conv["type_dc"] == 1
                        Memento.warn(_PM._LOGGER, "For converter $conv_id is chosen P is fixed on AC and DC side. This can lead to infeasibility in the PF problem.")
                    elseif conv["type_ac"] == 1 && conv["type_dc"] == 1
                        Memento.warn(_PM._LOGGER, "For converter $conv_id is chosen P is fixed on AC and DC side. This can lead to infeasibility in the PF problem.")
                    end
                    convbus_ac = conv["busac_i"]
                    if conv["Vmmax"] < nw_ref[:bus][convbus_ac]["vmin"]
                        Memento.warn(_PM._LOGGER, "The maximum AC side voltage of converter $conv_id is smaller than the minimum AC bus voltage")
                    end
                    if conv["Vmmin"] > nw_ref[:bus][convbus_ac]["vmax"]
                        Memento.warn(_PM._LOGGER, "The miximum AC side voltage of converter $conv_id is larger than the maximum AC bus voltage")
                    end
                end

                if length(ref_buses_dc) > 1
                    ref_buses_warn = ""
                    for (rb) in keys(ref_buses_dc)
                        ref_buses_warn = ref_buses_warn*rb*", "
                    end
                    Memento.warn(_PM._LOGGER, "multiple reference buses found, i.e. "*ref_buses_warn*"this can cause infeasibility if they are in the same connected component")
                end
                nw_ref[:ref_buses_dc] = ref_buses_dc
                nw_ref[:buspairsdc] = _PMACDC.buspair_parameters_dc(nw_ref[:arcs_dcgrid_from], nw_ref[:branchdc], nw_ref[:busdc])
            else
                nw_ref[:convdc] = Dict{String, Any}()
                nw_ref[:busdc] = Dict{String, Any}()
                nw_ref[:bus_convs_dc] = Dict{String, Any}()
                nw_ref[:ref_buses_dc] = Dict{String, Any}()
                nw_ref[:buspairsdc] = Dict{String, Any}()
                # Bus converters for existing ac buses
                bus_convs_ac = Dict([(i, []) for (i,bus) in nw_ref[:bus]])
                nw_ref[:bus_convs_ac] = _PMACDC.assign_bus_converters!(nw_ref[:convdc], bus_convs_ac, "busac_i")    
            end
        end
    end
end