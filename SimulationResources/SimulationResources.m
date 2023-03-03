function []=SimulationResources(index)
%This script simulates the prbability of being able to generate 40 cube
%states (i.e. for multiplexing k=20) in a single repeater as a function of
%the number of GKP qubits available in the repeater.

%Specify hardware parameters and repeter spacing
sigGKP = 0.12;
etad = 0.96;

LArray = [0.5,1,2,2.5,5];
L = LArray(index)

%We have different values of discard window for different repeater spacings
if L==0.5
    v = 7*sqrt(pi)/20
elseif L==1
    v = 6*sqrt(pi)/20
elseif L==2
    v = 5*sqrt(pi)/20
elseif L==2.5
    v = 4*sqrt(pi)/20
elseif L==5
    v = 3*sqrt(pi)/20
end

%Specify number of simulations
M = 10^6;

%Specify probabilities of passing postselection when measuring GKP qubits
%with variance 3Sigma_{GKP}^2 and 2Sigma_{GKP}^2
[~,Ppost3Sigma] = LogErrAfterPost(sqrt(3*sigGKP^2 + (1-etad)/etad),v);
[~,Ppost2Sigma] = LogErrAfterPost(sqrt(2*sigGKP^2 + (1-etad)/etad),0.7*v);

%Specify probabilities of passing post-selection for the full two-qubit
%fusion measurements
Fusion1  = Ppost3Sigma^2;
Fusion2  = Ppost3Sigma*Ppost2Sigma;
Fusion3  = Ppost2Sigma^2;

%Specify probabilities of passing postselection for fusion sets
FusionSetForG2 = Fusion1;
FusionSetForG3 = Fusion1;
FusionSetForG3Prime = Fusion2;
FusionSetForG4 = Fusion3*Fusion2;
FusionSetForCube = Fusion3^4;

%Define the exponent of the range of available GKP qubits
x = 4.1:0.01:4.9;
PsuccVsNGKP = zeros(2,size(x,2));

%Iterate over available GKP qubits
for i = 1:size(x,2) 
    i
    NGKP = 10^x(i);

    PsuccVsNGKP(1,i) = NGKP;

    Count = 0;

    %In each simulation run, we simulate 10^4 instances at once
    %Start simulation
    parfor j=1:M/10^4

        %Start with N1 3 trees
        N1 = NGKP/3;
        %Hence we do N1/2 fusion attempts to get G2
        N2 = binornd(floor(N1/2),FusionSetForG2,1,10^4);

        %We got N2 G2s. Since we will be fusing G3 with G3', on
        %average we want to get an equal numbero of both. This means that
        %we should take the fraction FusionSetForG3Prime/(FusionSetForG3 +
        %FusionSetForG3Prime) of N2 for generating G3 and the fraction 
        %FusionSetForG3/(FusionSetForG3 + FusionSetForG3Prime) of N2 for
        %generating G3'

        N3 = binornd(floor((FusionSetForG3Prime/(FusionSetForG3 + FusionSetForG3Prime))*N2/2),FusionSetForG3);

        N3Prime= binornd(floor((FusionSetForG3/(FusionSetForG3 + FusionSetForG3Prime))*N2/2),FusionSetForG3Prime);

        %Now combine these for G4

        N4 = binornd(floor(min(N3,N3Prime)),FusionSetForG4);

        %Now for G5:
        N5 = binornd(floor(N4/2),FusionSetForCube);
        
        %Check how many times we managed to generate these 40 cubes and add
        %this number to the total count
        CountArray = sum(N5>=40);
        Count = Count + CountArray;
        
    end
    %Assign the established probability to the array
    ProbSuccPerRepeater = Count/M
    PsuccVsNGKP(2,i) = ProbSuccPerRepeater;
end

filename = sprintf('PsuccVsGKP_sigGKP%d_etad%d_L%d.mat', round(100*sigGKP), round(100*etad), round(10*L) );

save(filename, 'PsuccVsNGKP');
