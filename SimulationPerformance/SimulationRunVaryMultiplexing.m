function []=SimulationRunVaryMultiplexing(index)
%This script/function runs the simulation for the specified amount of GKP
%squeezing, homodyne detector efficiency, repeater separation, frequency
%of GKP correction on the inner leaves and discard window during resource state creation.
% The simulation is run for a range of multiplexing levels which we vary.
%We also specify the error thresholds which determine the maximum
%relative error on the simulated quantities that we can tolerate.
%This script is written as a function in order to easily run it on the
%cluster as a job array. The script generates an array of different
%parameters and an input to the function specifies a single parameter
%configuration.


%Define the fixed repeater separation
L=1;
%Discard window
v = sqrt(pi)/5;

%Build array of different parameters
sigGKPArray = 0.11:0.02:0.17;
nPerkmArray = 2:2:4;
etadArray = 0.96:0.01:0.98;

A = allcomb(sigGKPArray,nPerkmArray,etadArray);

%Choose a single configuration
sigGKP = A(index,1);
nPerkm = A(index,2);
etad = A(index,3);

%The value of the input index now defines the choice of these parameters

%Fibre attenuation length:
L_0 = 22;
%Relative error threshold that we can tolerate:
rel_err_thr = 0.5;
s_Total_rel_err_thr = 0.001;
%Name the file for saving the variable:
filename = sprintf('Data_sigGKP%d_nPerkm%d_etad%d.mat', round(100*sigGKP), nPerkm, round(100*etad) );

%Define the range of multiplexing links that we simulate
kRange = 20;
kStart = 1;
kStep = 1;

%Define the output array - X and Z errors for the k multiplexed links where we
%run simulations from kStart to KRange so for each number of multiplexed
%links we run a separate simulation and for each simulation we get k values
%of X and Z errors where for each k we actually get 2 X errors and 2 Z
%errors because for each we split it into 2 depending on the no-error/error syndrome of
%the inner leaf Steane code correction (that is why the last dimension is
%4 not 2)
Data = ones((kRange-kStart+kStep)/kStep,kRange,4);
% Define the array with probabilities of inner leaf no-error/error case for the Steane code
%for each simulation
sTotalArray = ones((kRange-kStart+kStep)/kStep,2);


for k = kStart:kStep:kRange
    k
    n = nPerkm * L;
    %Start with 10 samples
    N = 10;
    %Run the simulation
    [Zerr,Xerr, sTotal] = InnerAndOuterLeaves(L, sigGKP, etad, n, k, v, 1, N);
    %Estimate the error
    st_err_Z = sqrt( (Zerr .* (1 - Zerr))./[N-N*sTotal(1), N*sTotal(1)] );
    st_err_X = sqrt( (Xerr .* (1 - Xerr))./[N-N*sTotal(2), N*sTotal(2)] );
    st_err_sTotal = sqrt( (sTotal .* (1 - sTotal))/N );
    %
    rel_err_Z = st_err_Z./Zerr;
    rel_err_X = st_err_X./Xerr;
    rel_err_sTotal = st_err_sTotal./sTotal;
    %
    %Test accuracy and whether to increase N, which we do if the
    %relative error was too large or there were exactly zero logical
    %errors or the probability of inner leaf error syndrome is zero.
    while max(rel_err_Z,[],"all") > rel_err_thr || max(rel_err_X,[],"all") > rel_err_thr || max(rel_err_sTotal,[],"all") > s_Total_rel_err_thr || min(Zerr,[],"all") == 0 || min(Xerr,[],"all") == 0 || min(sTotal,[],"all") == 0
        %Rerun the simulation with increased N.
        N = 10*N
        %Run the simulation
        %If the probability of the inner leaf error syndrome is zero then
        %the corresponding error probability for the error syndrome case
        %(2nd column of Zerr or Xerr) will be NaN so rerun everything.
        if min(sTotal,[],"all") == 0
            [Zerr,Xerr, sTotal] = InnerAndOuterLeaves(L, sigGKP, etad, n, k, v, 1, N);
        %If the probability of the inner leaf error syndrome was not zero,
        %then Zerr and Xerr from the previous run are valid and we can reuse the previous
        %runs as the 10% of the new sample.
        else
            [Zerr2,Xerr2, sTotal2] = InnerAndOuterLeaves(L, sigGKP, etad, n, k, v, 1, 0.9*N);
            Zerr = 0.1 * Zerr + 0.9 * Zerr2
            Xerr = 0.1 * Xerr + 0.9 * Xerr2
            sTotal = 0.1 * sTotal + 0.9 * sTotal2
            %If in this new run we got zero probability of the inner leaf
            %error syndrome, then we will again need to rerun everything so
            %set sTotal to zero.
            if min(sTotal2,[],"all") == 0
                sTotal = [0,0];
            end
        end
        %Again error estimate
        %
        st_err_Z = sqrt( (Zerr .* (1 - Zerr))./[N-N*sTotal(1), N*sTotal(1)] );
        st_err_X = sqrt( (Xerr .* (1 - Xerr))./[N-N*sTotal(2), N*sTotal(2)] );
        st_err_sTotal = sqrt( (sTotal .* (1 - sTotal))/N );
        %
        rel_err_Z = st_err_Z./Zerr;
        rel_err_X = st_err_X./Xerr;
        rel_err_sTotal = st_err_sTotal./sTotal;
    %
    end
    Zerr
    Xerr
    %Append 1s to match dimension
    Zerr = cat(1, Zerr,ones(kRange-k,2));
    Xerr = cat(1, Xerr,ones(kRange-k,2));
    Data((k-kStart+kStep)/kStep,:,:) = [Zerr,Xerr];
    sTotalArray((k-kStart+kStep)/kStep,:) = sTotal;
    %Note that changing k only changes the effect on the outer leaves, the
    %inner leaf simulation stays the same so the sTotal estimated for each
    %k is in principle the same sTotal. Therefore by effectively estimating
    %it multiple times we estimate it with much higher accuracy. So we can
    %extract the average over all these simulation runs.
    sTotalAverage = sum(sTotalArray(1:(k-kStart+kStep)/kStep,:),1)/((k-kStart+kStep)/kStep)
    save(filename, 'Data', 'sTotalAverage')
end
save(filename, 'Data', 'sTotalAverage')