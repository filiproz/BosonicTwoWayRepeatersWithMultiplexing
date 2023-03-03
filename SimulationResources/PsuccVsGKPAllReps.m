%This script is used to go from probability of generating all required cubes in
%a single repeater to the probability of generating all required cubes in
%all repeaters

sigGKP = 0.12
etad = 0.96
Ltot = 850;

for L= [0.5]
    filename = sprintf('PsuccVsGKP_sigGKP%d_etad%d_L%d.mat', round(100*sigGKP), round(100*etad), round(10*L) );
    load(filename)
    PsuccVsGKPAllRepsfilename = sprintf('PsuccVsGKPAllReps_sigGKP%d_etad%d_L%d_Ltot%d.mat', round(100*sigGKP), round(100*etad), round(10*L), Ltot );
    ProbSuccAll = PsuccVsNGKP;
    ProbSuccAll(2,:) = PsuccVsNGKP(2,:).^(Ltot/L-1);
    save(PsuccVsGKPAllRepsfilename, 'ProbSuccAll')
end
        
    