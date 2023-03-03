function [SecretKeyArray,SumPZArray,SumPXArray,Lfix] = SecretKeyVsDistArrayTypicalSequences(Zerr, Xerr, sTotal, z, L, Lfix, Lmax)
%This script calculates SecretKey/entanglement rate vs distance and the
%probabilities of belonging to typical sets for the scenario where we
%only accept runs belonging to the typical set parameterised by z.

%Inputs
%Zerr, Xerr -   Z and X flip probabilities for a single link
%sTotal -       a 2-entry row vector containing probabilities of having a
%               non-zero error syndrome on the inner leafs for the Z and X
%               errors respectively
%z -            defines the width of the typical set centred at sTotal,
%               such that the fraction of 1's accepted in the set is
%               between sTotal - z and sTotal + z.           
%L -            repeater separation
%Lfix -         resolution of the SecretKeyArray in km
%Lmax -         a total distance up to which we want to calculate the rate


SecretKeyArray = zeros(1,Lmax/Lfix);
SumPZArray = zeros(1,Lmax/Lfix);
SumPXArray = zeros(1,Lmax/Lfix);

for i = 1:Lmax/Lfix
    Ltot = i * Lfix
    [SecretKeyArray(i),SumPZArray(i),SumPXArray(i)] = SecretKey6StateEndToEndTypicalSequences(L, Ltot, Zerr, Xerr, sTotal, z);
end