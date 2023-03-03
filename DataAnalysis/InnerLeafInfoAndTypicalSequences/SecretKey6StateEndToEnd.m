function out = SecretKey6StateEndToEnd(L, Ltot, Zerr, Xerr, sTotal)
%This function calculates the total end-to-end secret-key/entanglement rate by puting
%together the rate from all the different inner leaf bins.

%Inputs:

%L -                repeater spacing
%Ltot -             distance over which we want to calculate the key
%Zerr, Xerr -       probability of Z-flip and X-flip over a single
%                   elementary link.
%sTotal -           row vector of dimension 2 containing the probabilities
%                   of non-zero error syndrome for Z and X stabilisers of
%                   the [[7,1,3]] - code correction respectively.

%Outputs

%out -              secret key/entanglement per optical mode

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

%Now consider all the possible NoLinks+1 cases going from the case with
%zero syndrome everywhere to error syndrome everywhere stored in NoLinks+1
%columns of an array. We have a separate array for Z and X flips and each
%array has k rows corresponding to k multiplexed ranked links.

NoLinks = Ltot/L;
QerrZArray = zeros(k, NoLinks+1);
QerrXArray = zeros(k, NoLinks+1);
pZ = zeros(1,NoLinks+1);
pX = zeros(1,NoLinks+1);

%For each bin we calculate the corresponding error and the corresponding
%probability.

for i = 0:NoLinks
    QerrZArray(:,i+1) = (1 - (1 - 2 * Zerr(1:k,1)).^(NoLinks - i) .* (1 - 2 * Zerr(1:k,2)).^i )/2;
    QerrXArray(:,i+1) = (1 - (1 - 2 * Xerr(1:k,1)).^(NoLinks - i) .* (1 - 2 * Xerr(1:k,2)).^i )/2;
    pZ(i+1) = binopdf(i, NoLinks, sTotal(1)); 
    pX(i+1) = binopdf(i, NoLinks, sTotal(2));
end

% Now add the rate from all the bins weighted by the respective
% probabilities. In total we have (NoLinks+1)^2 bins.
SecKeyTotal = 0;
parfor i = 0:NoLinks
    for j = 0:NoLinks
        SecKeyTotal = SecKeyTotal + pZ(i+1)*pX(j+1)*SecretKey6State(QerrZArray(:,i+1), QerrXArray(:,j+1));
    end
end
out = SecKeyTotal;