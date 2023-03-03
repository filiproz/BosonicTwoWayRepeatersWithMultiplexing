function [out,SumPZ,SumPX] = SecretKey6StateEndToEndTypicalSequences(L, Ltot, Zerr, Xerr, sTotal, z)
%This function calculates the total end-to-end rate from typical sequences of bit strings
% where bit 0 means no-error syndrome of the [[7,1,3]] code in the given repeater and 
%1 means an error syndrome in that repeater. This is done by puting
%together the rate from all the different inner leaf bins belonging to the
%typical set.

%Inputs:

%L -                repeater spacing
%Ltot -             distance over which we want to calculate the key
%Zerr, Xerr -       probability of Z-flip and X-flip over a single
%                   elementary link.
%sTotal -           row vector of dimension 2 containing the probabilities
%                   of non-zero error syndrome for Z and X stabilisers of
%                   the [[7,1,3]] - code correction respectively.
%z -                defines the width of the typical set centred at sTotal,
%                   such that the fraction of 1's accepted in the set is
%                   between sTotal - z and sTotal + z.
%                   

%Outputs

%out -              secret key/entanglement per optical mode
%SumPZ, SumPX -     probability of belonging to the typical set in Z and X
%                   respectively

%Define number of multiplexed links from the error flip array;
k = size(Zerr,1);

% The maximum flip probability is 0.5, as if the flip probabilities were larger, we would
% just flip all the corresponding bits.
for i = 1:numel(Zerr)
    if Zerr(i) > 0.5
        Zerr(i) = 0.5;
    end

    if Xerr(i) > 0.5
        Xerr(i) = 0.5;
    end
end


%Define the sets of all the possible numbers of X and Z error syndromes
NoLinks = Ltot/L;
TypSeqZ = floor(NoLinks*(max(sTotal(1)-z,0))):ceil(NoLinks*(min(sTotal(1)+z,1)));
TypSeqX = floor(NoLinks*(max(sTotal(2)-z,0))):ceil(NoLinks*(min(sTotal(2)+z,1)));
NoOfDifferentConfigurationsZ = size(TypSeqZ,2);
NoOfDifferentConfigurationsX = size(TypSeqX,2);
QerrZArray = zeros(k, size(TypSeqZ,2));
QerrXArray = zeros(k, size(TypSeqX,2));
pZ = zeros(1,size(TypSeqZ,2));
pX = zeros(1,size(TypSeqX,2));


%Now consider all the possible cases that belong to the typical set.

for i = TypSeqZ
    QerrZArray(:,i-floor(NoLinks*(max(sTotal(1)-z,0)))+1) = (1 - (1 - 2 * Zerr(1:k,1)).^(NoLinks - i) .* (1 - 2 * Zerr(1:k,2)).^i )/2;
    pZ(i-floor(NoLinks*(max(sTotal(1)-z,0)))+1) = binopdf(i, NoLinks, sTotal(1)); 
end

for i = TypSeqX
    QerrXArray(:,i-floor(NoLinks*(max(sTotal(2)-z,0)))+1) = (1 - (1 - 2 * Xerr(1:k,1)).^(NoLinks - i) .* (1 - 2 * Xerr(1:k,2)).^i )/2;
    pX(i-floor(NoLinks*(max(sTotal(2)-z,0)))+1) = binopdf(i, NoLinks, sTotal(2));
end

%Sum up all the included bins to obtain the total key/entanglement rate
SecKeyTimesProb = 0;
parfor i = 1:size(TypSeqZ,2)
    for j = 1:size(TypSeqX,2)
    SecKeyTimesProb = SecKeyTimesProb + pZ(i)*pX(j)*SecretKey6State(QerrZArray(:,i), QerrXArray(:,j));
    end
end

%Probabilities of being in the typical sets for Z and X bit-strings
SumPZ=sum(pZ);
SumPX=sum(pX);
out = SecKeyTimesProb;