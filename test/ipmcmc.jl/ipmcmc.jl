using Turing
using Base.Test
srand(125)

x = [1.5 2.0]

@model pmmhtest(x) = begin
  s ~ InverseGamma(2,3)
  m ~ Normal(0,sqrt(s))
  for i in 1:length(x)
    x[i] ~ Normal(m, sqrt(s))
  end
  s, m
end

check_numerical(
  sample(pmmhtest(x), Gibbs(100, IPMCMC(30, 1, 3, 1, :s), HMC(1, 0.2, 3, :m))),
  [:s, :m], [49/24, 7/6]
)

check_numerical(
  sample(pmmhtest(x), IPMCMC(30, 100, 4, 2)),
  [:s, :m], [49/24, 7/6]
)
