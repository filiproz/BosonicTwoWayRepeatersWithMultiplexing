% Test InnerAndOuterLeafs

LPerfect = 0;
LHuge = 1000;
sigGKPPerfect = 0.00001;
sigGKPNormal = 0.12;
etadperfect = 1;
etadnormal = 0.97;
n = 4;
k = 10;
N = 10000;
v = 2*sqrt(pi)/10;
leafs = 1;


%% Test 1: No error case
[Zerr,Xerr, sTotal] = InnerAndOuterLeafs(LPerfect, sigGKPPerfect, etadperfect, n, k, v, leafs, N);
assert(all([Zerr(:,1),Xerr(:,1)]==zeros(k,2),'all'))
assert(all(sTotal == [0,0]))

%% Test 2: Infinitely large error
%If the channel adds infinite amount of noise we get the depolarising
%channel
%Define tolerable error
t = 0.03;
[Zerr,Xerr, sTotal] = InnerAndOuterLeafs(LHuge, sigGKPPerfect, etadperfect, n, k, v, leafs, N);
assert(all(Zerr<0.5 + t, 'all'))
assert(all(Zerr>0.5 - t, 'all'))
assert(all(Xerr<0.5 + t, 'all'))
assert(all(Xerr>0.5 - t, 'all'))
[Zerr,Xerr, sTotal] = InnerAndOuterLeafs(LHuge, sigGKPNormal, etadperfect, n, k, v, leafs, N);
assert(all(Zerr<0.5 + t, 'all'))
assert(all(Zerr>0.5 - t, 'all'))
assert(all(Xerr<0.5 + t, 'all'))
assert(all(Xerr>0.5 - t, 'all'))
[Zerr,Xerr, sTotal] = InnerAndOuterLeafs(LHuge, sigGKPPerfect, etadnormal, n, k, v, leafs, N);
assert(all(Zerr<0.5 + t, 'all'))
assert(all(Zerr>0.5 - t, 'all'))
assert(all(Xerr<0.5 + t, 'all'))
assert(all(Xerr>0.5 - t, 'all'))