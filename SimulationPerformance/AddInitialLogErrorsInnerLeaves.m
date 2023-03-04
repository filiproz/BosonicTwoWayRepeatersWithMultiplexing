function pdeltas = AddInitialLogErrorsInnerLeaves(pdeltas,Sampled3Sigma,Sampled2Sigma)
%This function adds initial logical errors from steps b) and c) from cube
%creation

%Inputs:

%pdeltas -              p-quadrature vector that will be updated with the initial
%                       logical errors from steps b) and c) from cube creation.
%Sampled3Sigma -        Vector with samples from Bernoulli distribution for
%                       all the errors where the accumulated GKP variance
%                       was 3*sigmaGKP^2 (this includes correlated and
%                       uncorrelated errors)
%Sampled3Sigma -        Vector with samples from Bernoulli distribution for
%                       all the errors where the accumulated GKP variance
%                       was 2*sigmaGKP^2 (this include only uncorrelated errors)

%Outputs:

%pdeltas -              updated p-quadrature vector after the errors have been
%                       applied

%Firstly the correlated errors:
if Sampled3Sigma(1) == 1
    pdeltas(6) = pdeltas(6) + sqrt(pi);
    pdeltas(7) = pdeltas(7) + sqrt(pi);
end
if Sampled3Sigma(2) == 1
    pdeltas(6) = pdeltas(6) + sqrt(pi);
    pdeltas(5) = pdeltas(5) + sqrt(pi);
end
if Sampled3Sigma(3) == 1
    pdeltas(6) = pdeltas(6) + sqrt(pi);
    pdeltas(5) = pdeltas(5) + sqrt(pi);
end
if Sampled3Sigma(4) == 1
    pdeltas(3) = pdeltas(3) + sqrt(pi);
    pdeltas(2) = pdeltas(2) + sqrt(pi);
end
if Sampled3Sigma(5) == 1
    pdeltas(3) = pdeltas(3) + sqrt(pi);
    pdeltas(1) = pdeltas(1) + sqrt(pi);
end
if Sampled3Sigma(6) == 1
    pdeltas(7) = pdeltas(7) + sqrt(pi);
    pdeltas(5) = pdeltas(5) + sqrt(pi);
end
if Sampled3Sigma(7) == 1
    pdeltas(2) = pdeltas(2) + sqrt(pi);
    pdeltas(1) = pdeltas(1) + sqrt(pi);
end
if Sampled3Sigma(8) == 1
    pdeltas(2) = pdeltas(2) + sqrt(pi);
    pdeltas(1) = pdeltas(1) + sqrt(pi);
end

%Now the uncorrelated errors from Step c)

pdeltas = pdeltas + Sampled3Sigma(9:15) * sqrt(pi);

%Now the uncorrelated errros in steps d) and e) with 3Sigma 
pdeltas([1:3,5:7]) = pdeltas([1:3,5:7]) + Sampled3Sigma(16:21) * sqrt(pi);
pdeltas([3,7]) = pdeltas([3,7]) + Sampled3Sigma(22:23) * sqrt(pi);

%Now the uncorrelated errros in steps d) and e) with 2Sigma
pdeltas = pdeltas + Sampled2Sigma(1:7) * sqrt(pi);
pdeltas([1:2,4:6]) = pdeltas([1:2,4:6]) + Sampled2Sigma(8:12) * sqrt(pi);
pdeltas(4) = pdeltas(4) + Sampled2Sigma(13) * sqrt(pi);
