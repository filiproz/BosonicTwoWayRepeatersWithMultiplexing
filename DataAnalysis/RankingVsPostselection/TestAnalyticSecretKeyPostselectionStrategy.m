% Test AnalyticSecretKeyPostselectionStrategy

L = 4;
Ltot = 10000;
k=10;
%% Test 1: Without postselection, this strategy cannot generate any key over 10000 km. 
v = 0;
assert(AnalyticSecretKeyPostselectionStrategy(L, v, k, Ltot) == 0)

%% Test 2: With strong postselection, we can generate some key over 10000 km.
v = sqrt(pi)/5;
assert(AnalyticSecretKeyPostselectionStrategy(L, v, k, Ltot) > 0)
