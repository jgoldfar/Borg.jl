using Borg

function dtlz2(vars, objs, consts)
    nvars = length(vars)
    nobjs = length(objs)

    k = nvars - nobjs + 1
    g = 0.0

    for i in (nvars-k):(nvars-1)
        g += (vars[i+1] - 0.5)^2.0
    end

    for i in 0:(nobjs-1)
        objs[i+1] = 1.0 + g

        for j in 0:(nobjs-i-1-1)
            objs[i+1] *= cos(0.5*pi*vars[j+1])
        end

        if i != 0
            objs[i+1] *= sin(0.5*pi*vars[nobjs-i-1+1])
        end
    end
    return 0
end

const nvars = 2
const nobjs = 2

const lowerBounds = ones(nvars) * 0.0
const upperBounds = ones(nvars) * 1.0
const epsilons = ones(nobjs) * 0.01

const obj1 = zeros(nobjs)
dtlz2(lowerBounds, obj1, 0)
const obj2 = zeros(nobjs)
dtlz2(upperBounds, obj2, 0)

const problem = BorgProblem(lowerBounds, upperBounds, epsilons, 0, dtlz2)

const result = solve(problem, 1)
