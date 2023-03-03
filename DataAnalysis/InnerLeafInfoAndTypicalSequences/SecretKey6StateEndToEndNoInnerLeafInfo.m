function out = SecretKey6StateEndToEndNoInnerLeafInfo(L, Ltot, Zerr, Xerr, sTotal)
%This function calculates the total end-to-end secret-key/entanglement rate for the scenario when
%there is no inner leaf syndrome information. This can also describe the scenario,
%where the inner leafs are perfect.

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
%k = 1;

%Erase the inner leaf info
Zerr(:,1) = (1-sTotal(1))*Zerr(:,1) + sTotal(1)*Zerr(:,2);
Xerr(:,1) = (1-sTotal(2))*Xerr(:,1) + sTotal(2)*Xerr(:,2);

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

%Now calculate the end-to-end errors for all k multiplexed links.

NoLinks = Ltot/L;

QerrZArray = (1 - (1 - 2 * Zerr(1:k,1)).^NoLinks)/2
QerrXArray = (1 - (1 - 2 * Xerr(1:k,1)).^NoLinks)/2

%Now calculate the key/entanglement rate.
out = SecretKey6State(QerrZArray, QerrXArray);