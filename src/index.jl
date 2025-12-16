function construir_nodos_ramas(data_stg)
    num_buses = length(data_stg["bus"])
    nodes = Dict("N" => Dict(i => crear_nodo_vacio() for i in 1:num_buses))
    branches = Dict{Int,Dict}()
    ndgen = Dict{Int,Int}()

    for (i, br) in data_stg["branch"]
        if br["br_status"] == 1
            f, t = br["f_bus"], br["t_bus"]
            push!(nodes["N"][f]["Nd"], t)
            push!(nodes["N"][t]["Nd"], f)
            push!(nodes["N"][f]["Br"], parse(Int, i))
            push!(nodes["N"][t]["Br"], parse(Int, i))
            branches[parse(Int, i)] = crear_branch_info(f, t, br["rate_a"])
        end
    end

    for (_, l) in data_stg["load"]
        nodes["N"][l["load_bus"]]["Pd"] = l["pd"]
        nodes["N"][l["load_bus"]]["Qd"] = l["qd"]
    end

    for (i, g) in data_stg["gen"]
        ndgen[parse(Int, i)] = g["gen_bus"]
    end

    return nodes, branches, ndgen
end

function crear_nodo_vacio()
    return Dict("Nd" => Int[], "Nd_dir" => Int[], "Br" => Int[], "Pd" => 0.0, "Qd" => 0.0,
                "Pg" => 0.0, "Qg" => 0.0, "Pf" => 0.0, "Qf" => 0.0, "Pt" => 0.0, "Qt" => 0.0,
                "Ptt" => 0.0, "Qtt" => 0.0)
end

function crear_branch_info(f, t, rate)
    return Dict("bf" => f, "bt" => t, "rate" => rate,
                "pf" => 0.0, "pt" => 0.0, "qf" => 0.0, "qt" => 0.0,
                "cty" => 0.0)
end


function actualizar_flujos!(nodes, branches, result_branch)
    for (i, br_result) in result_branch
        br_id = parse(Int, i)
        if !haskey(branches, br_id)
            continue
        end
        br = branches[br_id]
        f, t = br["bf"], br["bt"]

        if br_result["pf"] > 0
            push_unique!(nodes["N"][f]["Nd_dir"], t)
            acumular_flujos!(nodes["N"][f], nodes["N"][t], br_result["pf"], br_result["qf"])
            actualizar_branch!(br, br_result["pf"], br_result["pt"], br_result["qf"], br_result["qt"], t, 0)
        elseif br_result["pt"] > 0
            push_unique!(nodes["N"][t]["Nd_dir"], f)
            acumular_flujos!(nodes["N"][t], nodes["N"][f], br_result["pt"], br_result["qt"])
            actualizar_branch!(br, br_result["pf"], br_result["pt"], br_result["qf"], br_result["qt"], f, 1)
        end
    end
end

function push_unique!(v::Vector{Int}, x::Int)
    push!(v, x)
    sort!(v)
    unique!(v)
end

function acumular_flujos!(n1, n2, p, q)
    n1["Pf"] += p
    n2["Pt"] += p
    n1["Qf"] += q
    n2["Qt"] += q
end

function actualizar_branch!(br, pf, pt, qf, qt, nodo, t)
    br["pf"] = pf
    br["pt"] = pt
    br["qf"] = qf
    br["qt"] = qt
    if t == 0
        br["cty"] = sqrt(pf^2 + qf^2) / br["rate"]
    else
        br["cty"] = sqrt(pt^2 + qt^2) / br["rate"]
    end
    br["node"] = nodo
end

function construir_matrices_adyacencia(nodes, node_N_Is_r, N)
    Mat_ad = zeros(N, N)
    Mat_ad_dir = zeros(N, N)
    Mat_dig = zeros(N, N)

    for (node, data) in nodes["N"]
        if haskey(node_N_Is_r, node)
            a = node_N_Is_r[node]
            for b in data["Nd"]
                Mat_ad[a, node_N_Is_r[b]] = 1
            end
            for b in data["Nd_dir"]
                Mat_ad_dir[a, node_N_Is_r[b]] = 1
            end
            Mat_dig[a, a] = length(data["Nd_dir"])
        end
    end

    return Mat_ad, Mat_ad_dir, Mat_dig
end


function filtrar_nodos_aislados(nodes)
    node_N_Is = Dict{Int, Int}()
    node_N_Is_r = Dict{Int, Int}()
    ct = 0
    for i in 1:length(nodes["N"])
        if !isempty(nodes["N"][i]["Nd"])
            node_N_Is[i - ct] = i
            node_N_Is_r[i] = i - ct
        else
            ct += 1
        end
    end
    return node_N_Is, node_N_Is_r
end


function calcular_indices_subgrafos(grafo, grafo_dir, Mat_ad_dir, node_N_Is, nodos_inicial)
    subg = Graphs.label_propagation(grafo, 100, seed=1234)
    vectors_subg = [Int[] for i in 1:length(unique(subg[1]))]

    for (nod,i) in enumerate(subg[1])
        push!(vectors_subg[i], nod)
    end

    # Asignar índices a nodos originales
    Pagerank   = ones(Float64,nodos_inicial)
    Eigenvector = ones(Float64,nodos_inicial)
    Betweeness = ones(Float64,nodos_inicial)
    Hubs       = ones(Float64,nodos_inicial)
    Autor      = ones(Float64,nodos_inicial)

    coef_var_bt = Float64[]
    coef_var_ei = Float64[]
    coef_var_pg = Float64[]
    if nodos_inicial > length(node_N_Is)
        push!(coef_var_bt, 1.0)
        push!(coef_var_ei, 1.0)
        push!(coef_var_pg, 1.0)
    end
    for subg_ in vectors_subg
        # nuevos subgrafos
        sub_nod = length(subg_)
        new_subgraph, ver_subgraph = Graphs.induced_subgraph(grafo, subg_)
        new_subdigraph, ver_subdigraph = Graphs.induced_subgraph(grafo_dir, subg_)
        sub_mat_dir = submat_adjacency(Mat_ad_dir, ver_subdigraph)

        # Cálculo de índices
        page = Graphs.pagerank(new_subdigraph, 0.1, 1000, 1e-6)
        page ./= sum(page)
        push!(coef_var_pg, std(page)/mean(page) * (sub_nod/nodos_inicial))

        betw = Graphs.betweenness_centrality(new_subdigraph, endpoints = true)
        betw ./= sum(betw)
        push!(coef_var_bt, std(betw)/mean(betw) * (sub_nod/nodos_inicial))

        eig = Graphs.eigenvector_centrality(new_subgraph)
        eig ./= sum(eig)
        push!(coef_var_ei, std(eig)/mean(eig) * (sub_nod/nodos_inicial))

        auth, hub = Hubs_Authorities(sub_mat_dir)

        # Cálculo de errores relativos
        page = rel_error(page, sub_nod)
        betw = rel_error(betw, sub_nod)
        eig = rel_error(eig, sub_nod)
        auth = rel_error(auth, sub_nod)
        hub = rel_error(hub, sub_nod)
        
        for (i, j) in enumerate(subg_)
            Pagerank[node_N_Is[j]]     = page[i]
            Eigenvector[node_N_Is[j]]  = eig[i]
            Betweeness[node_N_Is[j]]   = betw[i]
            Hubs[node_N_Is[j]]         = hub[i]
            Autor[node_N_Is[j]]        = auth[i]
        end
    end    
    return Pagerank, Eigenvector, Betweeness, Hubs, Autor      
end

function calcular_indices_globales(grafo, grafo_dir, Mat_ad_dir, node_N_Is, nodos_inicial)
    # Cálculo de índices
    page = Graphs.pagerank(grafo_dir, 0.1, 100, 1e-6)
    page ./= sum(page)

    betw = Graphs.betweenness_centrality(grafo_dir, endpoints = true)
    betw ./= sum(betw)

    eig = Graphs.eigenvector_centrality(grafo)
    eig ./= sum(eig)

    auth, hub = Hubs_Authorities(Mat_ad_dir)

    # Asignar índices a nodos originales
    Pagerank   = zeros(Float64,nodos_inicial)
    Eigenvector = zeros(Float64,nodos_inicial)
    Betweeness = zeros(Float64,nodos_inicial)
    Hubs       = zeros(Float64,nodos_inicial)
    Autor      = zeros(Float64,nodos_inicial)

    PagerankI   = zeros(Float64,nodos_inicial)
    EigenvectorI = zeros(Float64,nodos_inicial)
    BetweenessI = zeros(Float64,nodos_inicial)
    HubsI       = zeros(Float64,nodos_inicial)
    AutorI      = zeros(Float64,nodos_inicial)

    for (i, j) in node_N_Is
        Pagerank[j]     = page[i]
        Eigenvector[j]  = eig[i]
        Betweeness[j]   = betw[i]
        Hubs[j]         = hub[i]
        Autor[j]        = auth[i]
    end
    # Cálculo de errores relativos
    PagerankI = ifelse.(Pagerank .== 0, 1.0, 0.0)
    EigenvectorI = ifelse.(Eigenvector .== 0, 1.0, 0.0)
    BetweenessI = ifelse.(Betweeness .== 0, 1.0, 0.0)
    HubsI       = ifelse.(Hubs .== 0, 1.0, 0.0)
    AutorI      = ifelse.(Autor .== 0, 1.0, 0.0)

    Pagerank = rel_error(Pagerank, nodos_inicial)+PagerankI
    Eigenvector = rel_error(Eigenvector, nodos_inicial)+EigenvectorI
    Betweeness = rel_error(Betweeness, nodos_inicial)+BetweenessI
    Hubs = rel_error(Hubs, nodos_inicial)+HubsI
    Autor = rel_error(Autor, nodos_inicial)+AutorI
    return Pagerank, Eigenvector, Betweeness, Hubs, Autor
end


function extract_idx(data, result, Stage; calcular_subgrafos = false)
    Index_Contingencias = Dict{String, Dict{Int, Matrix}}()

    for (scn, data_scn) in data
        Index_Stage = Dict{Int, Matrix}()

        for (stg, data_stg) in data_scn["nw"]
            nodes, branches, ndgen = construir_nodos_ramas(data_stg)
            actualizar_flujos!(nodes, branches, result[scn][string(stg)]["branch"])

            for (i, gen) in result[scn][string(stg)]["gen"]
                bus = ndgen[parse(Int, i)]
                nodes["N"][bus]["Pg"] += gen["pg"]
                nodes["N"][bus]["Qg"] += gen["qg"]
            end

            node_N_Is, node_N_Is_r = filtrar_nodos_aislados(nodes)
            N = length(node_N_Is)
            Mat_ad, Mat_ad_dir, Mat_dig = construir_matrices_adyacencia(nodes, node_N_Is_r, N)
            gra = Graphs.SimpleGraph(Mat_ad)
            gra_dir = Graphs.SimpleDiGraph(Mat_ad_dir)

            # índices
            if calcular_subgrafos
                Pagerank, Eigenvector, Betweeness, Hubs, Autor = 
                    calcular_indices_subgrafos(gra, gra_dir, Mat_ad_dir, node_N_Is, length(nodes["N"]))
            else
                Pagerank, Eigenvector, Betweeness, Hubs, Autor = 
                    calcular_indices_globales(gra, gra_dir, Mat_ad_dir, node_N_Is, length(nodes["N"]))
            end

            # índice final
            id_pf = powerFlow(nodes["N"])
            id_over = calc_id_overload(branches, [nodes["N"][i]["Nd_dir"] for i in 1:length(nodes["N"])], length(nodes["N"]))
            Index_Mat = hcat(Pagerank, Eigenvector, Betweeness, Autor, Hubs, id_over, id_pf[1])
            Index_Stage[parse(Int, stg)] = Index_Mat
        end

        Index_Contingencias[scn] = Index_Stage
    end

    return Index_Contingencias
end


function submat_adjacency(Mat_ad, ver_subgraph)
    idx = sort(ver_subgraph)  # (opcional) para orden consistente
    return Mat_ad[idx, idx]
end

function rel_error(vector, nod)
    # vector_rel = (((((1 / nod) .- vector).^2)./nod).^0.5) ./ (1 / nod)
    vector_rel = nod.*abs.((1 / nod) .- vector)
    vector_rel = tanh.(1*vector_rel)
    return vector_rel
end

function Hubs_Authorities(Mat::Matrix)
    Nodes = size(Mat,1);
    aut = vec(ones(Nodes,1));
    error_aut = 100;
    iter_aut = 0;
    while error_aut > 10^-9 && iter_aut<1000
        iter_aut = iter_aut+1
        aut_aux = transpose(Mat)*Mat*aut
        aut_aux = aut_aux/sum(aut_aux)
        error_aut = maximum(abs.(aut_aux-aut))
        aut = aut_aux
    end
    hubs = Mat*aut
    hubs = hubs/sum(hubs)
    return aut,hubs
end

function calc_id_overload(data_flows, lista_adyacencia_dir, nodes)
    Nodos_Sobrecarga = Vector{Int64}(undef,0)
    Nodos_Sobrecarga_Seg = Vector{Int64}(undef,0)
    overload =  zeros(Float64, nodes)
    for (i, dataLine) in data_flows
        if dataLine["cty"] > 0.95
            nod = dataLine["node"]
            push!(Nodos_Sobrecarga, nod)
            append!(Nodos_Sobrecarga_Seg, lista_adyacencia_dir[nod])
        end
    end
    unique!(Nodos_Sobrecarga)
    unique!(Nodos_Sobrecarga_Seg)
    for el1 in Nodos_Sobrecarga
        overload[el1] += 1.0
    end
    for el2 in Nodos_Sobrecarga_Seg
        overload[el2] += 0.5
    end
    if sum(overload) > 0
        valmax,idxmax = findmax(overload)
        overload = overload./valmax
    end

    return overload
end

function powerFlow(dataflows::Dict)::Dict
    N = length(dataflows)
    #Totales en Nodos
    Pt = zeros(Float64,N)
    Qt = zeros(Float64,N)
    Nd = zeros(Float64,N)
    
    for (i,datanode) in dataflows
        Pt[i] = datanode["Pg"] - datanode["Pd"] + datanode["Pt"] - datanode["Pf"]
        Qt[i] = datanode["Qg"] - datanode["Qd"] + datanode["Qt"] - datanode["Qf"]
        if datanode["Pd"] > 0 || datanode["Qd"] != 0
            Nd[i] = 1
        end
        if round(Pt[i],digits = 5) < 0.0
            Pt[i] = 1.0
        else
            Pt[i] = 0.0
        end
    end
    Data_Nodes = Dict{Int,Vector}(1=>Pt, 2=>Qt, 3=>Nd)
    return Data_Nodes
end



function idx_to_state(
    centralidades::Dict{String, Dict{Int, Matrix}})

    indexsel = [1, 2, 3]
    indexpw  = [6, 7]
    state_max = Dict{Int, Matrix{Float32}}()

    for etapa in 1:Stage
        mat_tot_etapa = nothing

        for (_, dict_etapasCT) in centralidades
            mat = dict_etapasCT[etapa]
            n_node = size(mat, 1)
            mat_red = zeros(Float32, n_node, 3)
            mat_red[:, :] .= mat[:, indexsel]

            # Concatenar con info de potencia
            mat_tot = round.(hcat(mat_red, mat[:, indexpw]), digits = 5)

            # Acumular el máximo por posición
            if mat_tot_etapa === nothing
                mat_tot_etapa = copy(mat_tot)
            else
                mat_tot_etapa = max.(mat_tot_etapa, mat_tot)
            end
        end
        
        state_max[etapa] = mat_tot_etapa
    end

    States = [Vector{Float64}() for _ in 1:Stage]
    # for (st,mat) in state_max
    #     vc = vec(sum(mat,dims=2))
    #     States[st] =vc/maximum(vc)
    # end    
    return state_max
end
