function [MinDistance,MaxDistance] = AchievableDistancePLOB(SecretKeyArray, Lfix)
%This function calculates the minimum and maximum distance for which the secret
%key/entanglement rate per mode is larger than the PLOB bound and larger
%than 10^-30

%Inputs:

%SecretKeyArray -       array with Secret key/entanglement vs distance
%Lfix -                 distance step that was used in key calculation

%Outputs:

%MinDistance -          the minimum distance with rate above the PLOB bound
%MaxDistance -          the maximum achievable distance with rate above the
%                       PLOB bound and above 10^-30.


PLOBArray = zeros(1,size(SecretKeyArray,2));
for i = 1:size(SecretKeyArray,2)
    Ltot = i * Lfix;
    PLOBArray(i) = -log2(1-exp(-Ltot/22));
end

DifferenceArray = SecretKeyArray-PLOBArray;
for i = 1:size(SecretKeyArray,2)
    if SecretKeyArray(i) < 10^(-30)
        DifferenceArray(i) = 0;
    end
end

Distmax=find(DifferenceArray>0, 1, 'last');
Distmin=find(DifferenceArray>0, 1, 'first');

MaxDistance = Lfix * Distmax;
MinDistance = Lfix * Distmin;

%If the rate never beats the PLOB bound
if size(MaxDistance,2)==0
    MaxDistance = 0;
    MinDistance = inf;
end