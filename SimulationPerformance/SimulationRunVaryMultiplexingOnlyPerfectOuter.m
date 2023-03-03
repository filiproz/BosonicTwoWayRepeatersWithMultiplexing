%This script runs the simulation of the outer leafs for perfect
%parameters, i.e. perfect GKP squeezing and homodyne detection efficiency
%where the only source of noise is the loss in the communication channel.
%The inner leafs are perfect.
% The simulation is run for a range of multiplexing levels which we vary.
%We also specify the error thresholds which determine the maximum
%relative error on the simulated quantities that we can tolerate.

%Define the fixed repeater separation
L=4;
%Discard window doesn't matter as simulate only outer leafs
v = 0;

%Perfect configuration
sigGKP = 0;
nPerkm = 1;
etad = 1;

%Fibre attenuation length:
L_0 = 22;
%Relative error threshold that we can tolerate:
rel_err_thr = 0.3;
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
%errors because in principle for each we split it into 2 depending on the no-error/error syndrome of
%the inner leaf Steane code correction (that is why the last dimension is
%4 not 2). As here we are running only the outer leafs, the first and the
%second two columns will be the same.
Data = ones((kRange-kStart+kStep)/kStep,kRange,4);

for k = kStart:kStep:kRange
    k
    n = nPerkm * L;
    %Start with 10 samples
    N = 10;
    %Run the simulation
    [Zerr,Xerr] = InnerAndOuterLeafs(L, sigGKP, etad, n, k, v, 0, N);
    %Estimate the error
    st_err_Z = sqrt( (Zerr .* (1 - Zerr))/N );
    st_err_X = sqrt( (Xerr .* (1 - Xerr))/N );
    %
    rel_err_Z = st_err_Z./Zerr;
    rel_err_X = st_err_X./Xerr;
    %
    %Test accuracy and whether to increase N, which we do if the
    %relative error was too large or there were exactly zero logical
    %errors.
    while max(rel_err_Z,[],"all") > rel_err_thr || max(rel_err_X,[],"all") > rel_err_thr || min(Zerr,[],"all") == 0 || min(Xerr,[],"all") == 0       %Rerun the simulation with increased N.
        N = 10*N
        %Run the simulation. We can reuse the previous
        %runs as the 10% of the new sample.
        [Zerr2,Xerr2] = InnerAndOuterLeafs(L, sigGKP, etad, n, k, v, 0, 0.9*N);
        Zerr = 0.1 * Zerr + 0.9 * Zerr2;
        Xerr = 0.1 * Xerr + 0.9 * Xerr2;
        %Again error estimate
        %
        st_err_Z = sqrt( (Zerr .* (1 - Zerr))/N );
        st_err_X = sqrt( (Xerr .* (1 - Xerr))/N );
        %
        rel_err_Z = st_err_Z./Zerr;
        rel_err_X = st_err_X./Xerr;
    %
    end
    Zerr
    Xerr
    %Append 1s to match dimension
    Zerr = cat(1, Zerr,ones(kRange-k,2));
    Xerr = cat(1, Xerr,ones(kRange-k,2));
    Data((k-kStart+kStep)/kStep,:,:) = [Zerr,Xerr];
    save(filename, 'Data')
end
save(filename, 'Data')