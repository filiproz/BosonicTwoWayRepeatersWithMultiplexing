function SecKeyOptimised = AnalyticSecretKeyPostselectionStrategyOptimised(L, k, Ltot)
%This function optimises the secret key/entanglement rate over the discard
%window $v$ in the interval [0, 2*sqrt(pi)/5] for the case when the inner leaves are perfect and on the outer
%leaves we use post-selection.
%Inputs:

%L -        repeater separation
%k -        number of multiplexed links
%Ltot -     end-to-end distance

%Outputs:
%SecKeyOptimised -   optimised secret key/entanglement rate

SecKeyArray = zeros(100,1);
parfor i = 1:100
    SecKeyArray(i) = AnalyticSecretKeyPostselectionStrategy(L, (i/100) * 2*sqrt(pi)/5, k, Ltot);
end
SecKeyOptimised = max(SecKeyArray);