% Test SecretKey6State

%% Test 1: No noise case
assert(SecretKey6State(0,0)==1)
assert(SecretKey6State(zeros(4,1),zeros(4,1))==1)
assert(SecretKey6State(zeros(6,1),zeros(6,1))==1)

%% Test 2: One perfect link others very noisy
assert(SecretKey6State([0;0.3;0.3;0.4],[0;0.5;0.4;0.4])==1/4)
assert(SecretKey6State([0.45;0.3;0.3;0;0.4;0.34],[0.36;0.5;0.4;0;0.4;0.49])==1/6)

%% Test 3: All links very noisy
assert(SecretKey6State([0.4;0.3;0.3;0.4],[0.5;0.5;0.4;0.4])==0)
assert(SecretKey6State([0.45;0.3;0.3;0.5;0.4;0.34],[0.36;0.5;0.4;0;0.4;0.49])==0)