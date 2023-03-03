% Test AchievableDistancePLOB

%Define the SecretKeyRate table over 100km with step of 10 km with no key
SecretKeyArrayZero = zeros(1,10);
LfixZero = 10;

%Define the SecretKeyRate table over 200 km with step of 20 km with flat
%key of 1
SecretKeyArrayOne = ones(1,10);
LfixOne = 20;

%Define the SecretKeyRate table over 100 km with step of 20 km with flat
%key of 10^-31
SecretKeyArrayTenToMinus31 = 10^(-31)*ones(1,5);
LfixTenToMinus31 = 20;
%% Test 1: No key case
[MinDistance,MaxDistance] = AchievableDistancePLOB(SecretKeyArrayZero, LfixZero);
assert(MinDistance == inf)
assert(MaxDistance == 0)

%% Test 2: Flat 1 bit case
[MinDistance,MaxDistance] = AchievableDistancePLOB(SecretKeyArrayOne, LfixOne);
assert(MinDistance == 20)
assert(MaxDistance == 200)

%% Test 3: 10^-31 key case
[MinDistance,MaxDistance] = AchievableDistancePLOB(SecretKeyArrayTenToMinus31, LfixTenToMinus31);
assert(MinDistance == inf)
assert(MaxDistance == 0)
