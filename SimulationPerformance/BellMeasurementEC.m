function [MultiqubitErrors,s] = BellMeasurementEC(quad, deltas, eta, sigGKP, etad, ZmatrixCh, tableSingleErr, tableDoubleErr) 
%This function implements the GKP + Steane code encoded measurements for the Bell measurement
%(without the CNOT gate/beamsplitter, that should be applied before)
%with EC

%Inputs:

%quad -                     quadrature for which we model the BSM:
%                               0 - q-quadrature
%                               1 - p-quadrature 
%deltas -                   vector of quadrature shifts
%eta -                      channel transmissivity for the channel acting on each of the two logical qubits just before the BSM 
%sigGKP -                   standard deviation of an ancilla GKP
%etad -                     detector efficiency
%ZmatrixCh -                analog information from the teleportation based
%                           GKP corrections on the inner leafs
%tableDoubleErr -           error look up table for the Steane code for single-qubit
%                           errors
%tableDoubleErr -           error look up table for the Steane code for two-qubit
%                           errors


%Outputs:

%MultiqubitErrors -         vector of 7 bits describing which of the bits
%                           have an errors after the EC for this one
%                           quadrature. Since the state is in the code
%                           space after EC, this must correspond to a
%                           logical error on the [[7,1,3]] code level
%s -                        scalar stating whether Steane code syndrome
%                           measurement signalled that there was an error
%                           or not:
%                               0 - no error, zero syndrome
%                               1 - error, outside of the code space so
%                                   need correction
%

%Define channel SD's for analog info
%The SD before the TEC = preamplification + loss
sigChannel = sqrt(1-eta);
%The final channel just before BSM - use CC-amplification
sigChannelFinalCCAmpWithDet = sqrt((1-eta*etad)/(2*eta*etad));

%Now we do classical correction on both levels - we don't
%need noisy ancillas for that and we have already added the noisy detectors
%in ChannelWithGKPCorr7QubitCode

%GKP correction:
%Measure the GKP stabiliser
ZmatrixPerfect = ReminderMod(deltas,sqrt(pi));
%Correct the error to get to GKP code space in that quadrature
deltas = deltas - ZmatrixPerfect;
%Transform to discrete errors
ns = round(deltas/sqrt(pi));

MultiqubitErrors = zeros(7,1);
for i = 1:7
    if mod(ns(i),2) == 1
        MultiqubitErrors(i) = 1;
    end
end

%Now do higher level correction
%Make the IIIPPPP measurement
parityIIIPPPP = mod(sum(MultiqubitErrors(4:7)), 2);

%Make the IPPIIPP measurement
parityIPPIIPP = mod(sum(MultiqubitErrors([2:3,6:7])), 2);

%Make the PIPIPIP measurement
parityPIPIPIP = mod(sum(MultiqubitErrors([1,3,5,7])), 2);

parityVector = [parityIIIPPPP, parityIPPIIPP, parityPIPIPIP];

%By default we assign the value as if no error syndrome on the higher level
s=0;
%If we got a logical error we will not detect it, so we only proceed with EC if the parity check signals an error: 
if any(parityVector)
    %If the parity vector signals an error we need to update s
    s=1;
    
    %Define full channel SDs we will use for analog info. These SD's are
    %defined with respect to the orginal channels before the Hadamards on
    %qubits 1-4. These Hadamards permute the channels and we need to
    %take that later into account to construct vectors of SDs from these
    %scalar values.
      
    %First the error during the first teleportation based GKP correction.
    %This only applies if there is at least one intermediate TEC on the
    %GKP level.
    %If there is no such TEC and there is directly the BSM on the inner
    %leaf, then the distribution will be different, see below later.
    %The error for this first TEC is:
    %residual error after CZ gate + channel error
    %+ noisy ancilla for teleportation error of sigGKP^2 + detector error
    %during first TEC x2 (note that the noise from lossy detector can be moved through the
    %beamsplitter to before the BSM)
    %The difference between these errors in q and p quadrature is the
    %residual error after CZ in step b) of cube creation.
    sigChFirstOriginallyp = sqrt(sigChannel^2 + 3*sigGKP^2 + (1-etad)/etad);
    sigChFirstOriginallyq = sqrt(sigChannel^2 + 2*sigGKP^2 + (1-etad)/etad);
    %Now the SD for a channel between two consecutive TECs,
    %independent of the quadrature.
    %Residual error after previous TEC of sigGKP^2 + transmission channel, error before TEC
    %from noisy ancilla of sigGKP^2 and lossy detector x2
    %(note that the noise from lossy detector can be moved through the
    %beamsplitter to before the BSM).Then  
    sigCh = sqrt(sigChannel^2 + 2*sigGKP^2 + (1-etad)/etad);
    
    %Now the CC-amplification channel.
    
    %It is the first and at the same time last and at the same time the only
    %channel if there was no intermediate TEC.
    %We have the residual error after the CZ gate in the cube preparation step b),
    %similarly as in sigChFirst, x2, for the communication channel we have the better
    %sigChannelFinal (also x2) and at the end we don't have sigGKP^2 as
    %we perform classical measurement without ancillas but we have detector error also x2. Since the
    %residual error during cube creation differs from q and p quads we
    %need to differentiate them again.
    sigPerfectCCAmpFirstOriginallyp = sqrt(2*sigChannelFinalCCAmpWithDet^2 + 4*sigGKP^2);
    sigPerfectCCAmpFirstOriginallyq = sqrt(2*sigChannelFinalCCAmpWithDet^2 + 2*sigGKP^2);
    
    %If there were intermediate TECs the last CC-amplification channel is
    %as follows:
    %(Residual error after last TEC of sigGKP^2 + transmission channel
    %+ noisy detector just before the measurement) x2 as add from both qubits that are Bell measured:
    sigPerfectCCAmp = sqrt(2*sigChannelFinalCCAmpWithDet^2 + 2*sigGKP^2);
    
    %Establish possible errors consistent with the parity vector
    error_matrix = SyndromeToErrors(parityVector, tableSingleErr, tableDoubleErr, 7);

    matrix_size = size(error_matrix);
    num_errs = matrix_size(1);

    %Establish the error distributions for analog info
    ErrProb = zeros(1,num_errs);
    %Let us describe the errors from cube creation from which we gather analog info
    %FIrstly we have the residual displacement after cube creation (CZ gate) which
    % is different for q and p. This means that the first time we do EC
    % on the inner leafs while storing them, the distributions are
    %slightly different due to these residual errors being different. We
    %also need to take into account the Hadamards on qubits 1-4.
    
    %Firstly if we do EC in p-quadrature:
    if quad == 1       
        %For the case if there is at least one intermediate TEC, that TEC
        %corrects errors that include residual Gaussian shifts after
        %CZ during step b) of the resource step preparation. That
        %residual shift was different in q nad p quadratures. However, as a
        %result of the Hadamards they swap for the qubits 1-4.
        sigChFirstVector = sigChFirstOriginallyp * ones(7,1);
        sigChFirstVector(1:4) = sigChFirstOriginallyq * ones(4,1);
    else
        %Now q-quadrature
        %For the case if there is at least one intermediate TEC, that TEC
        %corrects errors that include residual Gaussian shifts after
        %CZ during step b) of the resource step preparation. That
        %residual shift was different in q nad p quadratures. However, as a
        %result of the Hadamards they swap for the qubits 1-4.
        sigChFirstVector = sigChFirstOriginallyq * ones(7,1);
        sigChFirstVector(1:4) = sigChFirstOriginallyp * ones(4,1);
    end
    %Now the SD for a channel between two consecutive TECs.
    %This channel is symmetric with respect to q and p and it occurs after
    %Hadamard so there are no changes.
    sigChVector = sigCh * ones(7,1);
    %Last channel depends on whether it is the only channel (no
    %intermediate TEC) or whether there were intermediate TEC
    if size(ZmatrixCh,2) == 0
        %For the case if there is no intermediate TEC, that single CC-amplification channel 
        %corrects errors that include residual Gaussian shifts after
        %CZ gate during step b) of the resource step preparation. That
        %residual shift was different in q nad p quadratures. However, as a
        %result of the Hadamards they swap for the qubits 1-4.
        if quad == 1
            sigPerfectCCAmpVector = sigPerfectCCAmpFirstOriginallyp * ones(7,1);
            sigPerfectCCAmpVector(1:4) = sigPerfectCCAmpFirstOriginallyq * ones(4,1);
        else
            sigPerfectCCAmpVector = sigPerfectCCAmpFirstOriginallyq * ones(7,1);
            sigPerfectCCAmpVector(1:4) = sigPerfectCCAmpFirstOriginallyp * ones(4,1);
        end
    else
        %If there were intermediate TECs:
        %This channel is symmetric with respect to q and p and it occurs after
        %Hadamard so there are no changes.
        sigPerfectCCAmpVector = sigPerfectCCAmp * ones(7,1);
    end
   
    %Calculate the error probability for each error configuration    
    for k = 1:num_errs
        ErrProb(1,k) = JointErrorLikelihood(error_matrix(k,:), ZmatrixCh, sigChFirstVector, sigChVector, ZmatrixPerfect, sigPerfectCCAmpVector);
    end
    %Calculate the most probable error index
    [~,indmax] = max(ErrProb); 

    %Correct those errors
    MultiqubitErrors = mod(MultiqubitErrors + transpose(error_matrix(indmax,:)),2);
end

% Certain 4-qubit errors are not errors as they are exactly stabilisers:
if isequal(MultiqubitErrors, [0; 0; 0; 1; 1; 1; 1]) || isequal(MultiqubitErrors, [0; 1; 1; 0; 0; 1; 1])...
  || isequal(MultiqubitErrors, [1; 0; 1; 0; 1; 0; 1]) || isequal(MultiqubitErrors, [0; 1; 1; 1; 1; 0; 0])...
  || isequal(MultiqubitErrors, [1; 0; 1; 1; 0; 1; 0]) || isequal(MultiqubitErrors, [1; 1; 0; 0; 1; 1; 0])...
  || isequal(MultiqubitErrors, [1; 1; 0; 1; 0; 0; 1])

    MultiqubitErrors = zeros(7,1);
end