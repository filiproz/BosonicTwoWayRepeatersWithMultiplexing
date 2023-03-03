% Test ChannelWithGKPCorr7QubitCode

etaPerfect = 1;
sigGKPPerfect = 0;
sig = 0.4;
etadperfect = 1;
n = 4;
NQbit = 7;
DeltasIn = normrnd(0,sig,NQbit,1);
DeltasIn = DeltasIn - ReminderMod(DeltasIn,sqrt(pi));


%% Test 1: Everything perfect
%For any random DeltasIn which are in the code space, perfect channel and
%perfect GKP corrections do nothing
[Zmatrix, DeltasOut] = ChannelWithGKPCorr7QubitCode(DeltasIn, etaPerfect, sigGKPPerfect, etadperfect, n);
assert(all(Zmatrix == zeros(NQbit,n), 'all'))
assert(all(DeltasOut == DeltasIn, 'all'))