VERSION >= v"0.4.0-dev+6521" && __precompile__()
module Borg

include("BorgC.jl")

export BorgProblem, solve

immutable BorgProblemData
  numberOfVariables::Int64
  numberOfObjectives::Int64
  numberOfConstraints::Int64
  eval_fn::Function
end
immutable BorgProblem
  ref::BORG_Problem
  data::BorgProblemData
end
function BorgProblem(
  varLowerBounds::Vector{Float64},
  varUpperBounds::Vector{Float64},
  objEpsilons::Vector{Float64},
  numberOfConstraints::Int,
  eval_fn::Function)

  numberOfVariables = length(varLowerBounds)
  if numberOfVariables != length(varUpperBounds)
    error("varLowerBounds and varUpperBounds must be of same length.")
  end

  numberOfObjectives = length(objEpsilons)

  problem = BorgProblemData(numberOfVariables, numberOfObjectives, numberOfConstraints, eval_fn)

  function eval_wrapper(vars_raw::Ptr{Float64}, objs_raw::Ptr{Float64}, consts_raw::Ptr{Float64}, userParams::Ptr{Void})
    vars = pointer_to_array(vars_raw, numberOfVariables)
    objs = pointer_to_array(objs_raw, numberOfObjectives)
    consts = pointer_to_array(consts_raw, numberOfConstraints)
    eval_fn(vars, objs, consts)
    return nothing
  end
  problem_ref = BORG_Problem_create(numberOfVariables, numberOfObjectives, numberOfConstraints, eval_wrapper, Ptr{Void})

  for i in 1:numberOfVariables
    BORG_Problem_set_bounds(problem_ref, i, varLowerBounds[i], varUpperBounds[i])
  end

  for i in 1:numberOfObjectives
    BORG_Problem_set_epsilon(problem_ref, i, objEpsilons[i])
  end

  BorgProblem(problem_ref, problem)
end

function solve(problem::BorgProblem, maxIt::Int)
  BORG_Algorithm_run(problem.ref, maxIt)
end

end
