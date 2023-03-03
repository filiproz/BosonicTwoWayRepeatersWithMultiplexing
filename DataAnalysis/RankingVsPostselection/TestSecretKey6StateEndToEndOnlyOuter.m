% Test SecretKey6StateEndToEndOnlyOuter
L = 2;
Ltot = 500;

%% Test 1: No noise case
k = 3;
Zerr = zeros(k,2);
Xerr = zeros(k,2);
assert(SecretKey6StateEndToEndOnlyOuter(L, Ltot, Zerr, Xerr)==1)

%% Test 2: One perfect link others very noisy
k = 3;
Zerr = 0.5*ones(k,2);
Zerr(1,1) = 0;
Xerr = 0.5*ones(k,2);
Xerr(1,1) = 0;
assert(round(SecretKey6StateEndToEndOnlyOuter(L, Ltot, Zerr, Xerr),10)==round(1/3,10))

%% Test 3: All links noisy
k = 3;
Zerr = 0.5*ones(k,2);
Xerr = 0.5*ones(k,2);
assert(SecretKey6StateEndToEndOnlyOuter(L, Ltot, Zerr, Xerr)==0)
