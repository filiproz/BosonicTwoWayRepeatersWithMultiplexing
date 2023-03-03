%This script calculates SecretKey/entanglement rate vs distance and the
%probabilities of belonging to typical sequences for the scenario where we
%only accept runs belonging to the typical set parameterised by z. Here we
%scan over a range of values of z.
%For each z, the program starts with calculating the rate up to 1000 km and then recalculates for 2000 km if
%the achievable distances have not been reached yet and so on.

%Repeater separation
L=0.5;

%Hardware parameters considered
etad = 0.96;
sigGKP = 0.12;
nPerkm = 4;

%Range of considered values of z
zArray = [0, 0.01, 0.02, 0.03, 0.04];

%Desired distance resolution of the rate array
Lfix = 1;
%Threshold rate for the achievable distance
thresholdKey = 10^-6;


for i = 1 : size(zArray,2)
    z = zArray(i)
       
    %Start with 1000 km
    Lmax = 1000;
    [SecretKeyArray,SumPZArray,SumPXArray,Lfix] = SecretKeyVsDistArrayTypicalSequences(Zerr, Xerr, sTotal, z, L, Lfix, Lmax)
    %Check achievable distances
    MaxDistance = AchievableDistanceRateThreshold(SecretKeyArray, Lfix, thresholdKey)
    [MinDistancePLOB,MaxDistancePLOB] = AchievableDistancePLOB(SecretKeyArray, Lfix)
    %If the achievable distance has not been reached yet, redo with 1000
    %km more
    while (MaxDistance == Lmax || MaxDistancePLOB == Lmax) && Lmax<10000
        Lmax = Lmax + 1000;
        [SecretKeyArray,SumPZArray,SumPXArray,Lfix] = SecretKeyVsDistArrayTypicalSequences(Zerr, Xerr, sTotal, z, L, Lfix, Lmax)
        MaxDistance = AchievableDistanceRateThreshold(SecretKeyArray, Lfix, thresholdKey)
        [MinDistancePLOB,MaxDistancePLOB] = AchievableDistancePLOB(SecretKeyArray, Lfix)
    end
    %Save the rate array: and the probabilities of belonging to the typical
    %sets in Z and X.
    filenameWrite = sprintf('SecretKeyArrayTypicalSequencesProbofBins_z%d_sigGKP%d_nPerkm%d_etad%d.mat', round(1000*z), round(100*sigGKP), nPerkm, round(100*etad) );
    save(filenameWrite, "SecretKeyArray", "SumPZArray", "SumPXArray", "Lfix")    
end