%This script takes the data of probability of successfully generating 40
%cubes in a repeater vs number of available GKP qubits and calculates and saves 
%the required resources as a function of distances in steps of Lfix.
%ResourcesVsLtot include a list of resources per repeater for cube preparation 
%ResourcesVsLtotFinal include in the first row a list of resources per repeater 
%for cube preparation + for TEC and in the second row total resources
%end-to-end

%Specify hardware parameters and the threshold probability which we need 
%to reach in terms of required nubmer of GKP qubits, in 
%order to be able to say that we have been able to generate all the
%required resouces in all the repeaters.

sigGKP = 0.12;
etad = 0.99;
thresh = 1-10^(-3);
Lfix = 50;

for L= [0.5,1,2,2.5,5]
    filename = sprintf('PsuccVsGKP_sigGKP%d_etad%d_L%d.mat', round(100*sigGKP), round(100*etad), round(10*L) );
    load(filename)
    Resourcesfilename = sprintf('ResourcesVsLtot_sigGKP%d_etad%d_L%d.mat', round(100*sigGKP), round(100*etad), round(10*L) );
    ResourcesVsLtot = zeros(1,200);
    ResourcesVsLtotFinal = zeros(2,200);
    for Ltot = Lfix:Lfix:10000
        PsuccVsNGKPLtot = PsuccVsNGKP;
        PsuccVsNGKPLtot(2,:) = PsuccVsNGKP(2,:).^(Ltot/L-1);
        ResourcesVsLtot(1,Ltot/Lfix) = PsuccVsNGKPLtot(1,find(PsuccVsNGKPLtot(2,:)>thresh,1));
        ResourcesVsLtotFinal(1,Ltot/Lfix) = ResourcesVsLtot(1,Ltot/Lfix) + 28*20*(4*L-1);
        ResourcesVsLtotFinal(2,Ltot/Lfix) = (Ltot/L-1)*ResourcesVsLtotFinal(1,Ltot/Lfix) + 40;
    end
    save(Resourcesfilename, 'ResourcesVsLtot','ResourcesVsLtotFinal')
end
        
    