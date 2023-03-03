function SecKey = AnalyticSecretKeyPostselectionStrategy(L, v, k, Ltot)
%This function calculcates the secret key/entanglement rate for the case
%when the inner leafs are perfect and on the outer leafs we use
%postselection based on the discard window $v$ rather than ranking.
%Inputs:

%L -        repeater separation
%v -        size of the discard window
%k -        number of multiplexed links
%Ltot -     end-to-end distance

%Outputs:
%SecKey -   secret key/entanglement rate 

%Fibre attenuation length
L0 = 22;

%As we do CC amplification, the channel is over L/2
eta = exp(-L/(2*L0));
sig = sqrt((1-eta)/eta);

%Calculate the elementary link error conditioned on passing post-selection
%(since there is no cube preparation the error is the same for both Z and X flips)
%as well as the probability of passing post-selection
[ErrProb, p] = LogErrAfterPost(sig,v);

%Calculate the end-to-end probability of Z/X flips.
NoLinks = Ltot/L;
EndtoEndErrProb = (1-(1-2*ErrProb)^NoLinks)/2;

%Calculate the yield, note that the probability of passing the post-
%selection for a single link is p^2 because we need to pass post-selection
%in both quadratures.
Yield = AnalyticYieldPostselectionStrategy(p^2, k, NoLinks);
%Calculate secret key fraction/entanglement extractable from a single copy
% of the generated end-to-end state normalised by the number of modes k.
SecFrac = SecretKey6State(EndtoEndErrProb, EndtoEndErrProb);
%Calculate the total secret-key/entanglement rate.
SecKey = Yield*SecFrac/k;
end

