% Test AnalyticSecretKeyPostselectionStrategyOptimised

L = 4;
Ltot = 3000;
k=10;
%% Test 1: The optimised key needs to be better than the edge cases of v =0, v = 2*sqrt(pi)/5 and some random value in between.
v1 = 0;
v2 = 2 * sqrt(pi)/5;
v3  = rand * v2;
out = AnalyticSecretKeyPostselectionStrategyOptimised(L, k, Ltot);
assert(out > AnalyticSecretKeyPostselectionStrategy(L, v1, k, Ltot))
assert(out > AnalyticSecretKeyPostselectionStrategy(L, v2, k, Ltot))
assert(out > AnalyticSecretKeyPostselectionStrategy(L, v3, k, Ltot))