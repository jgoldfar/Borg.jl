VERSION >= v"0.4.0-dev+6521" && __precompile__()
module BorgC
const depsfile = joinpath(dirname(dirname(@__FILE__)),"deps","deps.jl")
if isfile(depsfile)
  include(depsfile)
else
  error("Borg not properly installed. Please run Pkg.build(\"Borg\")")
end


typealias BORG_Problem Ptr{Void}
typealias BORG_Archive Ptr{Void}

function BORG_Problem_create(numberOfVariables::Int, numberOfObjectives::Int, numberOfConstraints::Int, fn::Function, userParams)
  c_fn = cfunction(fn, Void, (Ptr{Float64}, Ptr{Float64}, Ptr{Float64}, Ptr{Void}))

  ccall(
    (:BORG_Problem_create, libborg),
    BORG_Problem,
    (Int32, Int32, Int32, Ptr{Void}, Ptr{Void}),
    numberOfVariables, numberOfObjectives, numberOfConstraints, c_fn, userParams)
end

function BORG_Problem_set_bounds(problem::BORG_Problem, index::Int, lowerBound::Float64, upperBound::Float64)
  ccall(
    (:BORG_Problem_set_bounds, libborg),
    Void,
    (BORG_Problem, Int32, Float64, Float64),
    problem, index-1, lowerBound, upperBound)
end

function BORG_Problem_set_epsilon(problem::BORG_Problem, index::Int, epsilon::Float64)
  ccall(
    (:BORG_Problem_set_epsilon, libborg),
    Void,
    (BORG_Problem, Int32, Float64),
    problem, index-1, epsilon)
end

function BORG_Algorithm_run(problem::BORG_Problem,maxEvaluations::Int)
  ccall(
    (:BORG_Algorithm_run, libborg),
    BORG_Archive,
    (BORG_Problem, Int32),
    problem, maxEvaluations)
end

function BORG_Archive_print(archive::BORG_Archive, fp = C_NULL)
  ccall(
    (:BORG_Archive_print, libborg),
    Void,
    (BORG_Archive, Ptr{Void}),
    archive, fp)
end

end # module
