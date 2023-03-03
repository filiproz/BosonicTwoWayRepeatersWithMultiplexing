function ResFactor = RescaleLtottoE(sigGKP, etad, L, c)
%This function calculates the rescaling coefficient that according to our
%analytical model we can use to multiply the total distance Ltot to convert
%it into the estimated error rate

%Inputs:

%sigGKP -       standard deviation of an ancilla GKP
%etad -         detector efficiency
%L -            repeater separation (distance between repeaters that generate states
%               without counting the BSM stations for fusing outer leafs);
%c -            parameter specifying the suppression of errors of the
%               [7,1,3]] code with analog information, taking values
%               between 2 and 3

%Outputs:

%ResFactor -    the rescaling coeff that we can multiply the distance Ltot to
%               convert it into a universal error rate



nperkm = 4;

%Specify the coeff describing the average weight of sigmaGKP^2 variance
%contribution in all the considered channels.
q = (32*L-2)/(16*L-2);
%No of GKP corrections before the [[7,1,3]] code correction
N = 8*L-1;
%Total SD
sigma = sqrt(q * sigGKP^2 + 1-exp(-1/(4*22)) +  1 - etad);

%The final rescaling coefficient
ResFactor = (21/L)*(2*sqrt(2)*sigma*N/pi)^c * exp(-pi*c/(8*sigma^2));