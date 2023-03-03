function out = ErrorLikelihood(z, sig)
%This function calculates the error likelihood on a single GKP qubit in a square
%lattice GKP error correction for the displacement noise with SD sig and
%for the measured syndrome value in error correction z

%Input:

%z -    vector with the analog syndrome values
%sig -  standard deviation of the error distribution for the
%       noise channel before the GKP correction

%Output:

%out - vector with error likelihoods

out = zeros(size(z));
n1 = -1:1:0;
n2 = -2:1:2;

for idx = 1:numel(z)
    %z is exactly zero either if there was no measurement on the given GKP
    %qubit or if sig = 0
    %In these cases there should be zero error probability assigned. The
    %probability that the measured syndrome will be exactly 0 under normal
    %circumstances is negligible.
    if z(idx) == 0
        out(idx) = 0;
    else
        
        sum1 = sum(exp(-(z(idx) - (2 * n1 + 1) * sqrt(pi)).^2/(2 * sig^2)));
        sum2 = sum(exp(-(z(idx) - n2 * sqrt(pi)).^2/(2 * sig^2)));


        %If there is very little noise:
        if sum2 == 0  & sum1 == 0
            out(idx) = 0;
        else

        out(idx) = (sum1/sum2);

        end
    end
end
