function [AvErrorPerRepeaterModel,AvErrorPerRepeaterData]  = AvErrorPerRepeater(sigGKP, etad, L, c, sTotal, Xerr, Zerr)
%This function evaluates the average error flip probability (same in X and
%Z) both for the analytical mode and numerical simulation

%Input:

%sigGKP -       standard deviation of an ancilla GKP
%etad -         detector efficiency
%L -            repeater separation (distance between repeaters that generate states
%               without counting the BSM stations for fusing outer leafs);
%c -            parameter specifying the suppression of errors of the
%               [7,1,3]] code with analog information, taking values
%               between 2 and 3
%sTotal -       row vector of dimension 2 containing the probabilities
%               of non-zero error syndrome for Z and X stabilisers of
%               the [[7,1,3]] - code correction respectively
%Zerr, Xerr -   probability of Z-flip and X-flip over a single elementary link
%
%Output:
%
%AvErrorPerRepeaterModel -  average error probability (same for X and Z) per
%                           repeater due to our analytical model
%AvErrorPerRepeaterModel -  average error probability (same for X and Z) per
%                           repeater based on the simulation data


%Specify the coeff describing the average weight of sigmaGKP^2 variance
%contribution in all the considered channels.
q = (32*L-2)/(16*L-2);

%No of GKP corrections before the [[7,1,3]] code correction
N = 8*L-1;

%Total SD
sigma = sqrt(q * sigGKP^2 + 1-exp(-1/(4*22)) +  1 - etad);

%Average error from the model
AvErrorPerRepeaterModel = 21*(2*sqrt(2)*sigma*N/pi)^c * exp(-pi*c/(8*sigma^2));

%For the simulation look only on the best link and erase the inner leaf
%info as it doesn't contribute in the regime of high rate anyway
Zerr(1,1) = (1-sTotal(1))*Zerr(1,1) + sTotal(1)*Zerr(1,2);
Xerr(1,1) = (1-sTotal(2))*Xerr(1,1) + sTotal(2)*Xerr(1,2);

%Average simulation error over X and Z
AvErrorPerRepeaterData = 0.5 * (Zerr(1,1) + Xerr(1,1));
