% Test AchievableDistanceRateThreshold

%Define the first threshold
thresholdKey1 = 10^-6;

%Define the SecretKeyRate table over 100km with step of 10 km with no key
SecretKeyArrayZero = zeros(1,10);
LfixZero = 10;

%Define the SecretKeyRate table over 200 km with step of 20 km with flat
%key of 1
SecretKeyArrayOne = ones(1,10);
LfixOne = 20;

%Define the SecretKeyRate table over 80 km with step of 20 km with key
%[1, 10^-3, 10^-5, 5*10^-7]
SecretKeyArrayDecay = [1, 10^-3, 10^-5, 5*10^-7];
LfixDecay = 20;

%Define the 2nd threshold
thresholdKey2 = 10^-4;

%% Test 1: No key case
MaxDistance = AchievableDistanceRateThreshold(SecretKeyArrayZero, LfixZero, thresholdKey1);
assert(MaxDistance == 0)

%% Test 2: Flat 1 bit case
MaxDistance = AchievableDistanceRateThreshold(SecretKeyArrayOne, LfixOne, thresholdKey1);
assert(MaxDistance == 200)

%% Test 3: Decay key case
MaxDistance1 = AchievableDistanceRateThreshold(SecretKeyArrayDecay, LfixDecay, thresholdKey1);
MaxDistance2 = AchievableDistanceRateThreshold(SecretKeyArrayDecay, LfixDecay, thresholdKey2);
assert(MaxDistance1 == 60)
assert(MaxDistance2 == 40)
