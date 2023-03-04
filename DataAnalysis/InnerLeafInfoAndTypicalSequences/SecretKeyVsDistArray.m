function [SecretKeyArray,Lfix] = SecretKeyVsDistArray(Zerr, Xerr, sTotal, innerInfo, L, Lfix, Lmax)
%This function creates the SecretKeyArray for the given data.

%Inputs
%Zerr, Xerr -       Z and X flip probabilities for a single link
%sTotal -           a 2-entry row vector containing probabilities of having a
%                   non-zero error syndrome on the inner leaves for the Z and X
%                   errors respectively
%innerInfo -        whether we use or don't use the inner leaf info
%                   0 - do not use inner leaf info
%                   1 - use inner leaf info
%L -                repeater separation
%Lfix -             resolution of the SecretKeyArray in km
%Lmax -             a total distance up to which we want to calculate the rate

%Outputs
%SecretKeyArray -   array with the rate as a function of distance
%Lfix -             resolution of the SecretKeyArray in km


SecretKeyArray = zeros(1,Lmax/Lfix);

if innerInfo == 0
    
    for i = 1:Lmax/Lfix
        Ltot = i * Lfix
        SecretKeyArray(i) = SecretKey6StateEndToEndNoInnerLeafInfo(L, Ltot, Zerr, Xerr, sTotal);
    end
else
    for i = 1:Lmax/Lfix
        Ltot = i * Lfix
        SecretKeyArray(i) = SecretKey6StateEndToEnd(L, Ltot, Zerr, Xerr, sTotal);
    end
end