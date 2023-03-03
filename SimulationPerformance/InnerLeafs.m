function [logErr,s] = InnerLeafs(L, sigGKP, etad, n, ErrProb3Sigma, ErrProb2Sigma)
%This function performs a single run of the simulation of the inner leafs
%encoded in the concatenation of the GKP and the [[7,1,3]] code.
%It involves storage of the qubits in the fibre with regular GKP TECs and
%the final logical BSM between the two concatenated-coded qubits.

%Inputs:

%L -            repeater separation (distance between repeaters that generate states
%               without counting the BSM stations for fusing outer leafs);
%sigGKP -       standard deviation of an ancilla GKP
%etad -         detector efficiency
%n -            number of GKP channels and GKP corrections before a logical
%               Bell measurement on the inner leafs
%ErrProb3Sigma- probability of error after post-selection for the measurements
%               in steps c), d) and e) where the accumulated GKP variance was 3*sigmaGKP^2 
%               (this includes correlated and uncorrelated errors)
%ErrProb2Sigma - probability of error after post-selection for the measurements
%               in steps d) and e) where the accumulated GKP variance was 2*sigmaGKP^2 
%               (this includes only uncorrelated errors)

%Outputs:

%logErr -       vector of dim = 2, stating whether there was a logical Zerr
%               and Xerr after logical Steane code BSM (0-> no error, 
%               1 -> error)
%s -            vector of dim = 2 stating whether the Zerr and/or Xerr stabilisers
%               of the [[7,1,3]] code were triggered during the logical BSM
%               (0-> zero/no-error syndrome, 1 -> error syndrome)


% The input L is the separation between source repeaters, so the
% total length of local storage is also L because L/2 to send the outer
% qubits to the swap repeaters and L/2 for classical infor to come back.
% As we do GKP correction n times, we split the channel of length L into n,
% L/n long channels.
L0 = 22;
eta = exp(-L/(n*L0));


%Define the look-up table for single  errors. The table is the same for Z
%and X errors.
%Rows are 3 stabilisers and columns are syndromes for the error on the corresponding qubit
%(parity check matrix).
%Then transpose the table.

tableSingleErr =    [ 0, 0, 0, 1, 1, 1, 1;
                      0, 1, 1, 0, 0, 1, 1;
                      1, 0, 1, 0, 1, 0, 1]';

%Table with double errors

tableDoubleErr =  zeros(7,3,7);
for i = 1:7
   for j = 1:7
        tableDoubleErr(i,:,j) = mod(tableSingleErr(i,:) + tableSingleErr(j,:), 2);
   end
end

%Simulation
  
%Initial starting native errors after p-Steane EC in step b) of the
%resource preparation.

%Random numbers for the starting values
NativeErrorsStartQ = normrnd(0,sigGKP,7,2);
NativeErrorsStartP = normrnd(0,sqrt(2)*sigGKP,7,2);

%We simulate two inner leaf logical qubits, one on the left, one on the
%right that are later fused together.

qdeltas1 = NativeErrorsStartQ(:,1);
qdeltas2 = NativeErrorsStartQ(:,2);
pdeltas1 = NativeErrorsStartP(:,1);
pdeltas2 = NativeErrorsStartP(:,2);

%Initial logical errors from cube preparation. These are the
%fusions where we do postselection but don't keep analog info
Sampled3Sigma = binornd(1,ErrProb3Sigma,46,1);
Sampled2Sigma = binornd(1,ErrProb2Sigma,26,1);


pdeltas1 = AddInitialLogErrorsInnerLeafs(pdeltas1,Sampled3Sigma(1:23),Sampled2Sigma(1:13));
pdeltas2 = AddInitialLogErrorsInnerLeafs(pdeltas2,Sampled3Sigma(24:46),Sampled2Sigma(14:26));


%Now the Hadamards on the qubits 1-4 to get to the code space of the Bell pair between
%[[7,1,3]] qubit and a single physical qubit.
%They swap noise between quadratures for those qubits (with an extra minus sign one-way).

[qdeltas1(1:4), pdeltas1(1:4)] = deal(-pdeltas1(1:4), qdeltas1(1:4));
[qdeltas2(1:4), pdeltas2(1:4)] = deal(-pdeltas2(1:4), qdeltas2(1:4));

%Now the communication channels after resource state preparation

%Simulate the q-quadrature - fibre + telep based EC n-1 times + final
%nth channel

[qZmatrixCh1, qdeltas1] = ChannelWithGKPCorr7QubitCode(qdeltas1, eta, sigGKP, etad, n-1);
[qZmatrixCh2, qdeltas2] = ChannelWithGKPCorr7QubitCode(qdeltas2, eta, sigGKP, etad, n-1);

%The last n-nth correction is done on the classical level during the
%logical Steane code BSM
%Firstly we have the beamsplitter/CNOT
qdeltas = qdeltas1 + qdeltas2;
%Now collect analog information:
%Put together analog info for TEC on both logical qubits
qZmatrixCh = [qZmatrixCh1, qZmatrixCh2];
%Do concatenated coded Bell-state measurement with EC
[Xerrors, sX] = BellMeasurementEC(0, qdeltas, eta, sigGKP, etad, qZmatrixCh, tableSingleErr, tableDoubleErr);

%After the EC if any errors remain, since the state is in the code space
%this must be a logical error (We have already taken care of having errors
%being exactly equal to the stabilisers)
if any(Xerrors)
    Xerr = 1;
else
    Xerr = 0;
end

%Simulate the p-quadrature - fibre + telep based EC n-1 times + final
%nth channel
[pZmatrixCh1, pdeltas1] = ChannelWithGKPCorr7QubitCode(pdeltas1, eta, sigGKP, etad, n-1);
[pZmatrixCh2, pdeltas2] = ChannelWithGKPCorr7QubitCode(pdeltas2, eta, sigGKP, etad, n-1);
%The last n-nth correction is done on the classical level during the
%logical Steane BSM.
%Firstly we have the beamsplitter/CNOT

pdeltas = pdeltas1 - pdeltas2;
%Now collect analog information:
%Put together analog info for TEC on both logical qubits
pZmatrixCh = [pZmatrixCh1, pZmatrixCh2];
%Do concatenated coded Bell-state measurement with EC
[Zerrors, sZ] = BellMeasurementEC(1, pdeltas, eta, sigGKP, etad, pZmatrixCh, tableSingleErr, tableDoubleErr);

%After the EC if any errors remain, since the state is in the code space
%this must be a logical error (We have already taken care of having errors
%being exactly equal to the stabilisers).
if any(Zerrors)
    Zerr = 1;
else
    Zerr = 0;
end

%Now logErr effectively describes the final logical Pauli error with
% [0,0] - no error
% [1,0] - Pauli Z error
% [0,1] - Pauli X error
% [1,1] - Pauli Y error
logErr = [Zerr,Xerr];
%s Collects [[7,1,3]] code syndrome information
s = [sZ,sX];