% Test OuterLeafs

LPerfect = 0;
sigGKPPerfect = 0.00001;
etadperfect = 1;
n = 4;
ErrProb3SigmaPerfect = 0;
ErrProb2SigmaPerfect = 0;
ErrProb3SigmaDeterministicError = 1;
ErrProb2SigmaDeterministicError = 1;
k = 10;


%% Test 1: Everything perfect
logErr = OuterLeafs(LPerfect, sigGKPPerfect, etadperfect, k, ErrProb3SigmaPerfect,ErrProb2SigmaPerfect);
assert(all(logErr == zeros(k,2), 'all'))

%% Test 2: Deterministic single qubit Z-errors and perfect channel
%All the single qubit errors cancel since we have deterministic 4 errors
%per GKP qubit
logErr = OuterLeafs(LPerfect, sigGKPPerfect, etadperfect, k, ErrProb3SigmaDeterministicError, ErrProb2SigmaDeterministicError);
assert(all(logErr == zeros(k,2), 'all'))