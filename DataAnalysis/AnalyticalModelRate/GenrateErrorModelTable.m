%This script is used to obtain an array with the analytical and simulation
%errors for their comparison in FIG. 20

sigmaGKPArray = [0.13,0.14];
etadArray = [0.97,0.99];
LArray = [0.5,1,2,2.5,5];

%AvErrorPerRepeaterModelArray = zeros(1,20);
%AvErrorPerRepeaterDataArray = zeros(1,20);
nPerkm = 4;
i = 16;
t = 2.45;
L=0.5;

for sigGKP = sigmaGKPArray
    for etad = etadArray
        i = i + 1;
        %Load the data file:
        filenameLoad = sprintf('Data_sigGKP%d_nPerkm%d_etad%d.mat', round(100*sigGKP), nPerkm, round(100*etad) );
        load(filenameLoad)
        [AvErrorPerRepeaterModelArray(1,i),AvErrorPerRepeaterDataArray(1,i)]  = AvErrorPerRepeater(sigGKP, etad, L, t, sTotal, Xerr, Zerr)
   end
end
