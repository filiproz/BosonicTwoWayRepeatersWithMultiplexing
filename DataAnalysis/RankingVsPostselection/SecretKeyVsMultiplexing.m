function SecretKey = SecretKeyVsMultiplexing(Data, L, Ltot, leaves, sTotal, kRange)
%This function calculates secret-key/entanglement rate per optical mode vs
%multiplexing k

%Inputs:

%Data -             simulation data containing Z and X
%                   errors for different multiplexing values k 
%L -                repeater separation
%Ltot -             end-to-end distance
%leaves -            whether we consider the full scheme or only outer leaves
%                   0 - only outer leaves
%                   1 - full scheme
%sTotal -           row vector of dimension 2 containing the probabilities
%                   of non-zero error syndrome for Z and X stabilisers of
%                   the [[7,1,3]] - code correction respectively. If leaves = 0
%                   the input sTotal doesn't matter.
%kRange -           the upper limit of the number of multiplexed links we
%                   consider (starting from 1).

%Outputs:

%SecretKey -       rate vs multiplexing k

SecretKey = zeros(kRange,1);
if leaves == 0
    for k = 1:kRange
        k
        Zerr = squeeze(Data(k, :, 1:2));
        Zerr = Zerr(1:k,:);
        Xerr = squeeze(Data(k, :, 3:4));
        Xerr = Xerr(1:k,:);
        SecretKey(k) = SecretKey6StateEndToEndNoInnerLeafInfo(L, Ltot, Zerr, Xerr);
    end
else
    for k = 1:kRange
        k
        Zerr = squeeze(Data(k, :, 1:2));
        Zerr = Zerr(1:k,:);
        Xerr = squeeze(Data(k, :, 3:4));
        Xerr = Xerr(1:k,:);
        SecretKey(k) = SecretKey6StateEndToEnd(L, Ltot, Zerr, Xerr, sTotal);
    end
end