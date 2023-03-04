% Test InnerLeaves

LPerfect = 0;
sigGKPPerfect = 0.00001;
etadperfect = 1;
n = 4;
ErrProb3SigmaPerfect = 0;
ErrProb2SigmaPerfect = 0;
ErrProb3SigmaDeterministicError = 1;
ErrProb2SigmaDeterministicError = 1;



%% Test 1: Everything perfect
[logErr,s] = InnerLeaves(LPerfect, sigGKPPerfect, etadperfect, n, ErrProb3SigmaPerfect,ErrProb2SigmaPerfect);
assert(all(logErr == [0,0]))
assert(all(s == [0,0]))

%% Test 2: Deterministic 2Sigma errors
%This leads to errors on qubits 3,4,7. After that we have Hadamard on 1-4
%so the error on qubit 7 remains a Z error while the errors on 3,4 will
%become X errors. However, since the errors happen on both both sides they will
%cancel.
[logErr,s] = InnerLeaves(LPerfect, sigGKPPerfect, etadperfect, n, ErrProb3SigmaPerfect, ErrProb2SigmaDeterministicError);
assert(all(logErr == [0,0]))
assert(all(s == [0,0]))

%% Test 3: Deterministic 3Sigma errors
%Again the errors from the left cancel with the errors from the right.
[logErr,s] = InnerLeaves(LPerfect, sigGKPPerfect, etadperfect, n, ErrProb3SigmaDeterministicError, ErrProb2SigmaPerfect);
assert(all(logErr == [0,0]));
assert(all(s == [0,0]))

%% Test 4: All deterministic errors
%Again errors cancel from both sides.
[logErr,s] = InnerLeaves(LPerfect, sigGKPPerfect, etadperfect, n, ErrProb3SigmaDeterministicError, ErrProb2SigmaDeterministicError);
assert(all(logErr == [0,0]))
assert(all(s == [0,0]))