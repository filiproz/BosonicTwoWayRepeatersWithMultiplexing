% Test SecretKey6StateEndToEnd
L = 2;
Ltot = 500;

%% Test 1: No noise case
sTotal1 = [0,0];
sTotal2 = [0.03,0.02];
k = 3;
Zerr = zeros(k,2);
Xerr = zeros(k,2);
assert(SecretKey6StateEndToEnd(L, Ltot, Zerr, Xerr, sTotal1)==1)
assert(round(SecretKey6StateEndToEnd(L, Ltot, Zerr, Xerr, sTotal2),5)==1)

%% Test 2: One perfect link others very noisy
sTotal1 = [0,0];
sTotal2 = [0.3,0.3];
k = 3;
Zerr = 0.5*ones(k,2);
Zerr(1,1) = 0;
Xerr = 0.5*ones(k,2);
Xerr(1,1) = 0;
assert(round(SecretKey6StateEndToEnd(L, Ltot, Zerr, Xerr, sTotal1),10)==round(1/3,10))
assert(round(SecretKey6StateEndToEnd(L, Ltot, Zerr, Xerr, sTotal2),10,"significant")==round(0.7^(2*Ltot/L)/k,10,"significant"))

%% Test 3: All links noisy
sTotal1 = [0,0];
sTotal2 = [0.3,0.3];
k = 3;
Zerr = 0.5*ones(k,2);
Xerr = 0.5*ones(k,2);
assert(SecretKey6StateEndToEnd(L, Ltot, Zerr, Xerr, sTotal1)==0)
assert(SecretKey6StateEndToEnd(L, Ltot, Zerr, Xerr, sTotal2)==0)