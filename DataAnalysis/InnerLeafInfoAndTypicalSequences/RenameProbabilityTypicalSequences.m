%This script calculates the probability of being outside of the typical set in
%at least one of X and Z

z = 40;
ProbabilityOutOfTypicalSet = 1-SumPXArray.*SumPZArray;

newVar1 = sprintf('z%d', z); % Copy to new variable with new and different name.
eval([newVar1 '= ProbabilityOutOfTypicalSet'])
clear('SecretKeyArray', 'SumPXArray', 'SumPZArray', 'Lfix', 'z' , 'ProbabilityOutOfTypicalSet', 'newVar1'); 