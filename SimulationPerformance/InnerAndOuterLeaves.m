function [Zerr,Xerr, sTotal] = InnerAndOuterLeaves(L, sigGKP, etad, n, k, v, leaves, N)
%This function calculates the performance of a single elementary link in
%the two-way repeater architecture with inner leaf qubits encoded in the
%concatenated GKP + Steane code while the outer leaves being just GKP
%qubits.

%Inputs:

%L -        repeater separation (distance between repeaters that generate states
%           without counting the BSM stations for fusing outer leaves);
%sigGKP -   standard deviation of an ancilla GKP
%etad -     detector efficiency
%n -        number of GKP channels and GKP corrections before a logical
%           Bell measurement on the inner leaves
%k -        number of multiplexed parallel links
%v -        size of the discard window during steps b and c of the cube state
%           preparation
%leaves -    this parameter specifies whether we run the simulation of both
%           inner and outer leaves, only outer or only inner.
%           0 - only outer leaves
%           1 - full scheme
%           2 - only inner leaves
%N -        number of simulation runs

%Outputs:

%Zerr -     probability of a logical phase flip for the k links ranked from best to worst, count separately for the
%           case when the Steane code gives no error (1st column) and error (2nd column) syndrome
%Xerr -     probability of a logical bit flip for the k links ranked from best to worst, count separately for the
%           case when the Steane code gives no error (1st column) and error (2nd column) syndrome
%sTotal -   vector of dim = 2 with Z and X probabilities of an error syndrome for the Steane code
%           during the logical Bell measurement on the inner leaves.

%The logical error probabilities during steps c), d) and e) of the resource state
%preparation. There are single-qubit errors and two-qubit correlated
%errors.

ErrProb3Sigma = LogErrAfterPost(sqrt(3*sigGKP^2 + (1-etad)/etad),v);
ErrProb2Sigma = LogErrAfterPost(sqrt(2*sigGKP^2 + (1-etad)/etad),0.7*v);


%We count the errors on the inner leaves and outer leaves separately.
%For the outer leaves we simulate k parallel multiplexed links. For the
%inner leaves we can simulate just one Bell measurement as all the links are
%equivalent for the inner leaves.
%For the inner leaves we also count the probabilities that the Steane code
%stabilisers give us a Z or X error.

XerrOuter = zeros(k,1);
ZerrOuter = zeros(k,1);
XerrInner = zeros(1,2);
ZerrInner = zeros(1,2);
sTotal = zeros(1,2);

%Simulate inner leaves
if leaves == 0
    ZerrInner = [0,0];
    XerrInner = [0,0];
    sTotal = [0,0];
else
    parfor i = 1:N
        [logErrInner, s] = InnerLeaves(L, sigGKP, etad, n, ErrProb3Sigma, ErrProb2Sigma);

        tZ = zeros(1,2);
        tX = zeros(1,2);
        %Divide into two groups according to whether the Steane code gave error
        %syndrome or not. Value of 0 = no error, value of 1 = error
        if s(1)==0
            tZ(1) = tZ(1) + logErrInner(1);
        else
            tZ(2) = tZ(2) + logErrInner(1);
        end
        if s(2)==0
            tX(1) = tX(1) + logErrInner(2);
        else
            tX(2) = tX(2) + logErrInner(2);
        end
        %First column = no error, 2nd column = error
        ZerrInner = ZerrInner + tZ;
        XerrInner = XerrInner + tX;

        %Number of times of having an error syndrome for Z and for X
        sTotal = sTotal + s;
    end
    % Normalise the inner leaf simulation results into probabilities
    %conditioned on being in the bin without (with) inner leaf error syndrome
    ZerrInner = ZerrInner./[N-sTotal(1), sTotal(1)];
    XerrInner = XerrInner./[N-sTotal(2), sTotal(2)];
    sTotal = sTotal/N;
end

%Duplicate everything k times for k parallel links.
ZerrInnerMat = ZerrInner.*ones(k,1);
XerrInnerMat = XerrInner.*ones(k,1);

%Simulate outer leaves
if leaves == 2
    ZerrOuter = zeros(k,1);
    XerrOuter = zeros(k,1);
else
    parfor i = 1:N
        logErrOuter = OuterLeaves(L, sigGKP, etad, k, ErrProb3Sigma, ErrProb2Sigma);
        % We have vectors of k errors for Z and X ranked from best to worst
        ZerrOuter = ZerrOuter + logErrOuter(:,1);
        XerrOuter = XerrOuter + logErrOuter(:,2);
    end
    %Normalise the links to obtain probabilities
    ZerrOuter = ZerrOuter/N;
    XerrOuter = XerrOuter/N;
end

%Add inner and outer leaf errors, note that we get an error if there is an
%error either on the inner or outer leaves, but not both (then they cancel)
%Note that the final variable has k rows (for k multiplexed links) and 2
%columns (for the scenario without and with error syndrome for the Steane
%code on the inner leaves).
Zerr = ZerrInnerMat.*(ones(k,1) - ZerrOuter) + ZerrOuter.*(ones(k,1) - ZerrInnerMat);
Xerr = XerrInnerMat.*(ones(k,1) - XerrOuter) + XerrOuter.*(ones(k,1) - XerrInnerMat);