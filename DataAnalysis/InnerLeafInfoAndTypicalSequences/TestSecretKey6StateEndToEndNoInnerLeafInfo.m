% Test SecretKey6StateEndToEndNoInnerLeafInfo

%Note that SecretKey6StateEndToEndNoInnerLeafInfo takes the full Xerr and Zerr with
%inner leaf info and then erases it. Here we make things simpler and
%specify Xerr and Zerr such that our errors without inner leaf into are
%already in the first column. To do that we simply set sTotal to zero so
%that the function doesn't need to erase the inner leaf info itself.

L = 2;
Ltot = 500;
sTotal = [0,0]

%% Test 1: No noise case
k = 3;
Zerr = zeros(k,2);
Xerr = zeros(k,2);
assert(SecretKey6StateEndToEndNoInnerLeafInfo(L, Ltot, Zerr, Xerr, sTotal)==1)

%% Test 2: One perfect link others very noisy
k = 3;
Zerr = 0.5*ones(k,2);
Zerr(1,1) = 0;
Xerr = 0.5*ones(k,2);
Xerr(1,1) = 0;
assert(round(SecretKey6StateEndToEndNoInnerLeafInfo(L, Ltot, Zerr, Xerr, sTotal),10)==round(1/3,10))

%% Test 3: All links noisy
k = 3;
Zerr = 0.5*ones(k,2);
Xerr = 0.5*ones(k,2);
assert(SecretKey6StateEndToEndNoInnerLeafInfo(L, Ltot, Zerr, Xerr, sTotal)==0)
