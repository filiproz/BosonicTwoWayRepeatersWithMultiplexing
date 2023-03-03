%This script calculates SecretKey/entanglement rate vs distance and the achievable distances
%for all the Data files in the specified parameter intervals. The program starts with
%calculating the rate up to 1000 km and then recalculates for 2000 km if
%the achievable distances have not been reached yet and so on.

%Repeater separation
L=5;

%Range of considered parameters
sigGKPArray = 0.13:0.01:0.13;
nPerkmArray = 4:2:4;
etadArray = 1:0.01:1;
A = allcomb(sigGKPArray,nPerkmArray,etadArray);

%Desired distance resolution of the rate array
Lfix = 50;
%Threshold rate for the achievable distance
thresholdKey = 10^-6;

for i = 1: size(sigGKPArray,2)*size(nPerkmArray,2)*size(etadArray,2)
    sigGKP = A(i,1)
    nPerkm = A(i,2)
    etad = A(i,3)

    %Load the data file:
    filenameLoad = sprintf('Data_sigGKP%d_nPerkm%d_etad%d.mat', round(100*sigGKP), nPerkm, round(100*etad) );
    load(filenameLoad)
    
    %Start with 1000 km
    Lmax = 1000;
    [SecretKeyArray,Lfix] = SecretKeyVsDistArray(Zerr, Xerr, sTotal, L, Lfix, Lmax)
    %Check achievable distances
    MaxDistance = AchievableDistanceRateThreshold(SecretKeyArray, Lfix, thresholdKey)
    [MinDistancePLOB,MaxDistancePLOB] = AchievableDistancePLOB(SecretKeyArray, Lfix)
    %If the achievable distance has not been reached yet, redo for 1000
    %km more
    while (MaxDistance == Lmax || MaxDistancePLOB == Lmax) && Lmax<10000
        Lmax = Lmax + 1000;
        [SecretKeyArray,Lfix] = SecretKeyVsDistArray(Zerr, Xerr, sTotal, L, Lfix, Lmax)
        MaxDistance = AchievableDistanceRateThreshold(SecretKeyArray, Lfix, thresholdKey)
        [MinDistancePLOB,MaxDistancePLOB] = AchievableDistancePLOB(SecretKeyArray, Lfix)
    end
    %Save the rate array and the achievable distances:
    filenameWrite = sprintf('SecretKeyArrayAchievableDistance_sigGKP%d_nPerkm%d_etad%d.mat', round(100*sigGKP), nPerkm, round(100*etad) );
    save(filenameWrite, "SecretKeyArray", "MaxDistance", "MinDistancePLOB", "MaxDistancePLOB", "Lfix")    
end