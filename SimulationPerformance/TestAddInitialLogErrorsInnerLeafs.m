% test AddInitialLogErrorsInnerLeafs
pdeltas = zeros(7,1);
%Vector of errors if all correlated errors happen at once:
pdeltasAllCorrErr = [3*sqrt(pi);3*sqrt(pi);2*sqrt(pi);0;3*sqrt(pi);3*sqrt(pi);2*sqrt(pi)];
%% Test1: only uncorrelated errors 1
Sampled3Sigma = zeros(23,1);
Sampled3Sigma(9:15) = ones(7,1);
Sampled2Sigma = zeros(13,1);

assert(all(AddInitialLogErrorsInnerLeafs(pdeltas,Sampled3Sigma,Sampled2Sigma) == sqrt(pi) * ones(7,1), 'all'))

%% Test2: only uncorrelated errors 2
Sampled3Sigma = zeros(23,1);
Sampled3Sigma(16:23) = ones(8,1);
Sampled2Sigma = zeros(13,1);
ResultingQubitsWithErrors = [1;1;2;0;1;1;2];

assert(all(AddInitialLogErrorsInnerLeafs(pdeltas,Sampled3Sigma,Sampled2Sigma) == sqrt(pi) * ResultingQubitsWithErrors, 'all'))

%% Test3: Correlated errors
Sampled3Sigma = zeros(23,1);
Sampled3Sigma(1:8) = ones(8,1);
Sampled2Sigma = zeros(13,1);

assert(all(AddInitialLogErrorsInnerLeafs(pdeltas,Sampled3Sigma,Sampled2Sigma) == pdeltasAllCorrErr, 'all'))

