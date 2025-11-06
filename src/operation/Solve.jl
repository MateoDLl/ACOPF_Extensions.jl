#Solve

function solution_preprocessor(pm::_PM.AbstractPowerModel, solution::Dict)
    per_unit = _IM.get_data(x -> x["per_unit"], pm.data, _PM.pm_it_name; apply_to_subnetworks = false)
    solution["it"][_PM.pm_it_name]["per_unit"] = per_unit
    for (km, dictv) in _PM.nws(pm)
        for (nw_id, nw_ref) in dictv
            solution["it"][_PM.pm_it_name]["nw"]["$(km)"]["$(nw_id)"]["baseMVA"] = nw_ref[:baseMVA]
            #println(keys(pm.ref[:it][:pm][:nw]))
            if haskey(pm.ref[:it][:pm][:nw][km][nw_id], :conductors)
                solution["it"][_PM.pm_it_name]["nw"]["$(km)"]["$(nw_id)"]["conductors"] = nw_ref[:conductors]
            end
        end
    end
end

function build_solution(aim::_IM.AbstractInfrastructureModel; post_processors=[])
    sol = Dict{String, Any}("it" => Dict{String, Any}())
    sol["multiinfrastructure"] = true

    for it in _IM.it_ids(aim)
        sol["it"][string(it)] = _IM.build_solution_values(aim.sol[:it][it])
        sol["it"][string(it)]["multinetwork"] = true
    end

    solution_preprocessor(aim, sol)

    for post_processor in post_processors
        post_processor(aim, sol)
    end

    for it in _IM.it_ids(aim)
        it_str = string(it)
        data_it = _IM.ismultiinfrastructure(aim) ? aim.data["it"][it_str] : aim.data

        if _IM.ismultinetwork(data_it)
            sol["it"][it_str]["multinetwork"] = true
        else
            for (k, v) in sol["it"][it_str]["nw"]["$(nw_id_default)"]
                sol["it"][it_str][k] = v
            end

            sol["it"][it_str]["multinetwork"] = false
            delete!(sol["it"][it_str], "nw")
        end

        varISM = _IM.ismultiinfrastructure(aim)
        if varISM == false
            for (k, v) in sol["it"][it_str]
                sol[k] = v
            end

            delete!(sol["it"], it_str)
        end
    end
    varISM = _IM.ismultiinfrastructure(aim)
    if varISM == false
        sol["multiinfrastructure"] = false
        delete!(sol, "it")
    end

    return sol
end


function build_result(aim::_IM.AbstractInfrastructureModel, solve_time; solution_processors=[])
    # try-catch is needed until solvers reliably support ResultCount()
    result_count = 1
    try
        result_count = JuMP.result_count(aim.model)
    catch
        Memento.warn(_LOGGER, "the given optimizer does not provide the ResultCount() attribute, assuming the solver returned a solution which may be incorrect.");
    end

    solution = Dict{String,Any}()

    if result_count > 0
        solution = build_solution(aim, post_processors=solution_processors)
    else
        Memento.warn(_LOGGER, "model has no results, solution cannot be built")
    end

    result = Dict{String,Any}(
        "optimizer" => JuMP.solver_name(aim.model),
        "termination_status" => JuMP.termination_status(aim.model),
        "primal_status" => JuMP.primal_status(aim.model),
        "dual_status" => JuMP.dual_status(aim.model),
        "objective" => _IM._guard_objective_value(aim.model),
        "objective_lb" => _IM._guard_objective_bound(aim.model),
        "solve_time" => solve_time,
        "solution" => solution,
    )

    return result
end




function optimize_model!(aim::_IM.AbstractInfrastructureModel; relax_integrality=false, optimizer=nothing, solution_processors=[])
    start_time = time()

    if relax_integrality
        JuMP.relax_integrality(aim.model)
    end

    if JuMP.mode(aim.model) != JuMP.DIRECT && optimizer !== nothing
        if JuMP.backend(aim.model).optimizer === nothing
            JuMP.set_optimizer(aim.model, optimizer)
        else
            Memento.warn(_LOGGER, "Model already contains optimizer, cannot use optimizer specified in `optimize_model!`")
        end
    end

    if JuMP.mode(aim.model) != JuMP.DIRECT && JuMP.backend(aim.model).optimizer === nothing
        Memento.error(_LOGGER, "No optimizer specified in `optimize_model!` or the given JuMP model.")
    end

    _, solve_time, solve_bytes_alloc, sec_in_gc = @timed JuMP.optimize!(aim.model)

    try
        solve_time = JuMP.solve_time(aim.model)
    catch
        Memento.warn(_LOGGER, "The given optimizer does not provide the SolveTime() attribute, falling back on @timed.  This is not a rigorous timing value.");
    end
    
    Memento.debug(_LOGGER, "JuMP model optimize time: $(time() - start_time)")

    start_time = time()
    result = build_result(aim, solve_time; solution_processors=solution_processors)
    Memento.debug(_LOGGER, "solution build time: $(time() - start_time)")

    aim.solution = result["solution"]

    return result
end