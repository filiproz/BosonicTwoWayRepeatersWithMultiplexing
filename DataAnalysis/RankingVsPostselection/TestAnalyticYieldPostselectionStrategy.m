% Test AnalyticYieldPostselectionStrategy
NoLinks = 10;
k = 10;
%% Test 1: Without probability of link being 1, the yield is k
p = 1;
assert(AnalyticYieldPostselectionStrategy(p, k, NoLinks) == k)

%% Test 2: With probability of link being smaller than 1, the yield is smaller than k
p = 0.5;
assert(AnalyticYieldPostselectionStrategy(p, k, NoLinks) < k)

%% Test 3: The smaller p, the smaller the yield
p1 = 0.5;
p2 = 0.4;
assert(AnalyticYieldPostselectionStrategy(p2, k, NoLinks) < AnalyticYieldPostselectionStrategy(p1, k, NoLinks))

