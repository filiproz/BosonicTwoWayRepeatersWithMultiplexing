function MaxDistance = AchievableDistanceRateThreshold(SecretKeyArray, Lfix, thresholdKey)
%This function calculates the maximum distance for which the secret
%key/entanglement rate per mode is larger than certain threshold.

%Inputs:

%SecretKeyArray -       array with Secret key/entanglement vs distance
%Lfix -                 distance step that was used in key calculation
%thresholdKey -         threshold for the achievable distance

%Outputs:

%MaxDistance -          the maximum achievable distance with rate above the
%                       thresholdKey

Dist=find(SecretKeyArray>thresholdKey, 1, 'last');

MaxDistance = Lfix * Dist;

if size(MaxDistance,2)==0
    MaxDistance = 0;
end