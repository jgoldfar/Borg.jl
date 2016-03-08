using Borg
const nobjs = 2
const objs = Array(Float64, nobjs)
function dtlz2(vars)
  nvars = length(vars)
  k = nvars - nobjs + 1

  # Calclulate g function
  g = 0.0
  for i in (nvars-k):(nvars-1)
    vi = (vars[i+1] - 0.5)
    g += vi * vi
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
  for i in 1:(nobjs - 1)
    @printf "%0.17f " objs[end]
    @printf STDERR "%0.17f " objs[end]
  end
  @printf "%0.17f\n" objs[nobjs]
  @printf STDERR "%0.17f\n" objs[nobjs]
  return 0
end
function main()
  for line in eachline(STDIN)
    splline = map(float, split(line))
    if isempty(splline)
      break
    end
    println(STDERR, splline)
    dtlz2(splline)
  end
end
main()
