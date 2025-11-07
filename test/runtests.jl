using ACOPF_Extensions
using Test, MathOptInterface
const MOI = MathOptInterface

@testset "ACOPF_Extensions.jl" begin
    system = joinpath(@__DIR__, "case", "garverQ")
    valid_states = [
        MOI.OPTIMAL,
        MOI.LOCALLY_SOLVED,
        MOI.ALMOST_OPTIMAL,
        MOI.ALMOST_LOCALLY_SOLVED
    ]
    @testset "run_acopf_topology: interface tests" begin
        
        topology = zeros(Int64,15,1)

        result, fobj, state, rc_nodes = run_acopf_topology(system, topology;
            rc=true, n1=false, drate=10.0, grate=5.0, yp=1)

        @test isa(result, Dict)
        @test isa(fobj, Real)
        @test isa(state, MOI.TerminationStatusCode)
        @test isa(rc_nodes, Dict)

        @test !isnan(fobj)
        @test !isempty(result)
    end

    @testset "run_acopf_topology: with and without reactive compensation" begin
        
        # without reactive compensation
        topology = zeros(Int64,15,1)
        topology[9,1] = 2
        topology[11,1] = 2
        topology[14,1] = 2
        result1, fobj1, state1, rc1 = run_acopf_topology(system, topology; rc=false)
        @test isa(fobj1, Real)
        @test state1 in valid_states
        @test isapprox(fobj1, 160.0; atol=1e2)

        # with reactive compensation
        topology = zeros(Int64,15,1)
        topology[9,1] = 1
        topology[11,1] = 1
        topology[14,1] = 2
        result2, fobj2, state2, rc2 = run_acopf_topology(system, topology; rc=true)
        @test isa(fobj2, Real)
        @test state1 in valid_states
        @test isapprox(fobj2, 110.44; atol=1e2)
    end

end
