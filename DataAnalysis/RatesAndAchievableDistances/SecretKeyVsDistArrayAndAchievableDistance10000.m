%This script calculates secret-key/entanglement rate vs distance as well as
%the achievable distance for the distance range from 0 to 10000 km.

%Repeater separation
L=2;

%Parameters considered
sigGKP=0.11;
nPerkm=4;
etad=0.98;

%Desired distance resolution of the rate array
Lfix = 50;

%Threshold rate for the achievable distance
thresholdKey = 10^-6;

%Load the data file:
filenameLoad = sprintf('Data_sigGKP%d_nPerkm%d_etad%d.mat', round(100*sigGKP), nPerkm, round(100*etad) );
load(filenameLoad)

%Calculate the rate
Lmax = 10000;
[SecretKeyArray,Lfix] = SecretKeyVsDistArray(Zerr, Xerr, sTotal, L, Lfix, Lmax)
MaxDistance = AchievableDistanceRateThreshold(SecretKeyArray, Lfix, thresholdKey)
[MinDistancePLOB,MaxDistancePLOB] = AchievableDistancePLOB(SecretKeyArray, Lfix)

%Save the rate array and the achievable distances:
filenameWrite = sprintf('SecretKeyArrayAchievableDistance_sigGKP%d_nPerkm%d_etad%d.mat', round(100*sigGKP), nPerkm, round(100*etad) );
save(filenameWrite, "SecretKeyArray", "MaxDistance", "MinDistancePLOB", "MaxDistancePLOB", "Lfix")