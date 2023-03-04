function logErr = OuterLeaves(L, sigGKP, etad, k, ErrProb3Sigma, ErrProb2Sigma)
%Inputs:

%L -            repeater separation (distance between repeaters that generate states
%               without counting the BSM stations for fusing outer leaves);
%sigGKP -       standard deviation of an ancilla GKP
%etad -         detector efficiency
%k -            number of parallel multiplexed links
%ErrProb3Sigma- probability of error after post-selection where the 
%               accumulated GKP variance was 3*sigmaGKP^2; for the outer leaves 
%               this is only the measurement in step c) leading to
%               uncorrelated errors
%ErrProb2Sigma - probability of error after post-selection for the measurements
%               in steps d) and e) where the accumulated GKP variance was 2*sigmaGKP^2 
%               (this includes only uncorrelated errors)

%Outputs:

%logErr -       k by 2 matrix, stating whether there was a logical Zerr (first column)
%               and Xerr (second column) on any of the k outer leaves. The
%               errors are arranged in the order from the most reliable to
%               the least reliable link.


L0 = 22;
%As we do CC amplification, the lossy channel is over L/2
eta = exp(-L/(2*L0));


%Now we construct the single SD sigma over the entire channel between two
%neighbouring repeaters
%The native error includes the errors from both left side and right side outer leaf
% qubits
%SD for q-quadrature
% Native error of sigGKP^2 x2 + joint channel error of (1-eta*etad)/(eta*etad) 
sigQ = sqrt(2*sigGKP^2 + (1-eta*etad)/(eta*etad));
%SD for the p-quadrature
% 2 times native error of 2*sigGKP^2
%+ joint channel error of (1-eta*etad)/(eta*etad);
sigP = sqrt(4*sigGKP^2 + (1-eta*etad)/(eta*etad));

Xerr = zeros(k,1);
Zerr = zeros(k,1);

%First q -quadrature
qdeltas = normrnd(0,sigQ,k,1);

%Now measure mod root pi:
qZVec = ReminderMod(qdeltas, sqrt(pi));

%Calculate the error likelihoods:
qErrLike = ErrorLikelihood(qZVec, sigQ);

%Now p-quadrature
pdeltas = normrnd(0,sigP,k,1);


%Now measure mod root pi:
pZVec = ReminderMod(pdeltas, sqrt(pi));

%Calculate the error likelihoods:
pErrLike = ErrorLikelihood(pZVec, sigP);

%Calculate likelihoods of no error:
PNoError = (1 - qErrLike) .* (1 - pErrLike);


%Find indesces of PNoError in descending order
[~,IndDesc] = sort(PNoError, 'descend');

%Add logical errors from the cube preparation from steps c), d) and e)
% We add 8 possible errors per each GKP qubits:
%4 from the left and 4 from the right,
% one from 3sigmaGKP^2 case and 3 from 2sigmaGKP^2 from each side
Sampled3Sigma = binornd(1,ErrProb3Sigma,k,2);
Sampled2Sigma = binornd(1,ErrProb2Sigma,k,6);

pdeltas = pdeltas + Sampled3Sigma(:,1)*sqrt(pi);
pdeltas = pdeltas + Sampled3Sigma(:,2)*sqrt(pi);
for i = 1:6
    pdeltas = pdeltas + Sampled2Sigma(:,i)*sqrt(pi);
end

%Now check whether there were X errors on the corresponding qubits
%in descening order according to PNoError:
for i = 1:k
    ns = round((qdeltas(IndDesc(i)) - qZVec(IndDesc(i)))/sqrt(pi));
    
    if mod(ns,2) == 1
        Xerr(i) = 1;
    end
end

%Now check whether there were Z errors on the corresponding qubits
%in descening order according to PNoError:
for i = 1:k
    ns = round((pdeltas(IndDesc(i)) - pZVec(IndDesc(i)))/sqrt(pi));
    
    if mod(ns,2) == 1
        Zerr(i) = 1;
    end
end

%The final error is:
% [0,0] - no error 
% [1,0] - Pauli Z error
% [0,1] - Pauli X error
% [1,1] - Pauli Y error
%Since we have k multiplexed links, we actually have vectors instead of
%scalars for Zerr and Xerr.
logErr = [Zerr, Xerr];