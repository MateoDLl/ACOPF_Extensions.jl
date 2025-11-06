
"Populate the portion of `refs` for a specific infrastructure type."
function _populate_ref_it!(refs::Dict{Symbol, <:Any}, data_it::Dict{String, <:Any}, global_keys::Set{String}, it::String)
    # Initialize the ref corresponding to the infrastructure type.
    refs[:it][Symbol(it)] = Dict{Symbol, Any}()

    # Build a multinetwork representation of the data.
   
    if _IM.ismultinetwork(data_it)
        nws1_data = data_it["nw"]
    
        for (key, item) in data_it
            if key != "nw"
                refs[:it][Symbol(it)][Symbol(key)] = item
            end
        end
    else
        nws1_data = Dict("0" => data_it)
    end
    nwsN1 = refs[:it][Symbol(it)][:nw] = Dict{Int, Any}()
    nws = Dict{Int, Any}()

    # Populate the specific infrastructure type's ref dictionary.
    for (N1n, nws_data) in nws1_data
        for (n, nw_data) in nws_data["nw"]
            nw_id = parse(Int, n)
            ref = nws[nw_id] = Dict{Symbol, Any}()
        
            for (key, item) in nw_data
                if !(key in global_keys)
                    if isa(item, Dict{String, Any}) && _IM._iscomponentdict(item)
                        item_lookup = Dict{Int, Any}([(parse(Int, k), v) for (k, v) in item])
                        ref[Symbol(key)] = item_lookup
                    else
                        ref[Symbol(key)] = item
                    end
                end
            end
        end
        nwsN1[parse(Int,N1n)] = nws
    end
end


"Populate the portion of `refs` corresponding to global keys."
function _populate_ref_global_keys!(refs::Dict{Symbol, <:Any}, data::Dict{String, <:Any}, global_keys::Set{String} = Set{String}())
    # Populate the global keys section of the refs dictionary.
    for global_key in global_keys
        if haskey(data, global_key)
            refs[Symbol(global_key)] = data[global_key]
        end
    end
end

function ref_initialize(data::Dict{String, <:Any}, it::String, global_keys::Set{String} = Set{String}())
    # Initialize the refs dictionary.
    refs = Dict{Symbol, Any}(:it => Dict{Symbol, Any}())

    # Populate the infrastructure section of the refs dictionary.
    data_it = _IM.ismultiinfrastructure(data) ? data["it"][it] : data
    _populate_ref_it!(refs, data_it, global_keys, it)

    # Populate the global keys section of the refs dictionary.
    _populate_ref_global_keys!(refs[:it][Symbol(it)], data, global_keys)

    # Return the final refs object.
    return refs
end

function _initialize_dict_from_ref(ref::Dict{Symbol, <:Any})
    dict = Dict{Symbol, Any}(:it => Dict{Symbol, Any}(), :dep => Dict{Symbol, Any}())
    dict[:it] = Dict{Symbol, Any}(it => Dict{Symbol, Any}() for it in keys(ref[:it]))
    for it in keys(ref[:it])
        dict[:it][it] = Dict{Symbol, Any}(:nw => Dict{Int, Any}())
        for (nw0,dic0) in ref[:it][it][:nw]
            dict[:it][it][:nw][nw0] = Dict{Int, Any}(nw0 => Dict{Int,Any}())
            for nw in keys(dic0)
                dict[:it][it][:nw][nw0][nw] = Dict{Symbol, Any}()
            end
        end
    end

    return dict
end

function InitializeInfrastructureModel(
    InfrastructureModel::Type, data::Dict{String, <:Any}, global_keys::Set{String},
    it::Symbol; ext = Dict{Symbol, Any}(), setting = Dict{String, Any}(),
    jump_model::JuMP.AbstractModel = JuMP.Model())
    @assert InfrastructureModel <: _IM.AbstractInfrastructureModel

    ref = ref_initialize(data, string(it), global_keys)
    var = _initialize_dict_from_ref(ref)
    con = _initialize_dict_from_ref(ref)
    sol = _initialize_dict_from_ref(ref)
    sol_proc = _initialize_dict_from_ref(ref)

    imo = InfrastructureModel(
        jump_model,
        data,
        setting,
        Dict{String,Any}(), # empty solution data
        ref,
        var,
        con,
        sol,
        sol_proc,
        ext
    )

    return imo
end



function instantiate_model(
    data::Dict{String,<:Any}, model_type::Type, build_method, ref_add_core!,
    global_keys::Set{String}, it::Symbol; ref_extensions=[], kwargs...)
    # NOTE, this model constructor will build the ref dict using the latest info from the data    
    start_time = time()

    imo = InitializeInfrastructureModel(model_type, data, global_keys, it; kwargs...)

    Memento.debug(_LOGGER, "initialize model time: $(time() - start_time)")

    start_time = time()
    ref_add_core!(imo.ref)

    for ref_ext! in ref_extensions
        ref_ext!(imo.ref, imo.data)
    end

    Memento.debug(_LOGGER, "build ref time: $(time() - start_time)")

    start_time = time()
    build_method(imo)
    Memento.debug(_LOGGER, "build method time: $(time() - start_time)")

    return imo
end