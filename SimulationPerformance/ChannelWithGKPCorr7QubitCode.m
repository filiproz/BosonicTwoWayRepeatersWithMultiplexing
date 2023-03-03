function [Zmatrix, DeltasOut] = ChannelWithGKPCorr7QubitCode(DeltasIn, eta,sigGKP, etad, n)
%This function applies the channel noise followed by GKP error correction (TEC) n
%times for the [[7,1,3]] code scheme followed by a final lossy channel
%(CC-amplficiation) before the Bell measurement which also includes the
%noise due to the detectors at that final BSM.

%quad -         which quadrature
                % 0 - q
                % 1 - p
%DeltasIn -     deltas in the chosen quadrature to which we will apply noise and GKP correction
%eta -          transmissivity of the fibre between 2 consecutive ECs
%sigGKP -       standard deviation of the ancilla GKPs
%etad -         detector efficiency
%n -            number of times we do the channel + GKP correction
%               (followed by the final channel just before the BSM)
%
%Output
%
%Zmatrix -      matrix with analog syndrome information, rows corrspond to
%               qubits, n columns to n times
%DeltasOut -    deltas in the chosen quadrature after the n channel + GKP
%               corrections + final channel for CCAmp
    
    
NQbit = 7;
%Lossy channel variance before each TEC when we use amplification
sigChannel = sqrt(1-eta);
%Lossy channel variance before the final BSM when we use CC-amplification
%(this is variance for just one of the qubits that go into the BSM)
sigChannelFinalCCAmpWithDet = sqrt((1-eta*etad)/(2*eta*etad)); 
%Noise due to a single detector
sigDetector = sqrt((1 - etad)/(2*etad));

%Store qZs and pZs and the errors after the whole chain of n GKP stations:
Zmatrix = zeros(NQbit, n);
%Generate random number for the noise
%For the communication channel between 2 TECs
shiftsChannel = normrnd(0,sigChannel,NQbit,n);
%The final channel before the BSM (the detrctor noise appears only once as
%this is for a single qubit)
shiftsChannelFinalCCAmpWithDet = normrnd(0,sigChannelFinalCCAmpWithDet,NQbit,1);
%Noisy ancillas in the TEC
shiftsAncilla = normrnd(0,sigGKP,NQbit,2*n);
%Noisy detectors for TEC, here the variance is already for 2 detectors as
%we use two detectors for a single data mode in TEC
shiftsDetectors = normrnd(0,sqrt(2*sigDetector^2),NQbit,n);


deltas_temp = DeltasIn;

%Now we will apply and GKP correct the errors with SD sigma n times:
for k = 1:n
    %Channel:
    deltas_temp = deltas_temp + shiftsChannel(:,k);
    %Teleportation-based EC:
    %Firstly ancilla error
    deltas_temp = deltas_temp + shiftsAncilla(:,k);
    %Now both detectors (they both can be bounced onto the input):
    deltas_temp = deltas_temp + shiftsDetectors(:,k);
    %Now correction:
    Zmatrix(:,k) = ReminderMod(deltas_temp,sqrt(pi));
    deltas_temp = deltas_temp - Zmatrix(:,k);
    %Now the ancilla error after correction:
    deltas_temp = deltas_temp + shiftsAncilla(:,n+k);
end
%The last channel (using CC-amplification) which will be followed by perfect correction:
deltas_temp = deltas_temp + shiftsChannelFinalCCAmpWithDet(:,1);

DeltasOut = deltas_temp;



   