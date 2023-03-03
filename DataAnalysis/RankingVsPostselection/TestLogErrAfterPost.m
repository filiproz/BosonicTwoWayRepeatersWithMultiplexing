% Test LogErrAfterPost
sig = 0.2;
vNoPost = 0;
CDFvNoPost = cdf('Normal',-sqrt(pi)/2 - vNoPost,0,sig);
vPost = 2*sqrt(pi)/10;
CDFvPost = cdf('Normal',-sqrt(pi)/2 - vPost,0,sig);
fun = @(x) normpdf(x,0,sig);
DiscardWindowProb = 2*integral(fun, sqrt(pi)/2 - vPost, sqrt(pi)/2 + vPost);

%% Test 1 No postselection
[ErrProb, Ppost] = LogErrAfterPost(sig,vNoPost);
assert(all(round([ErrProb, Ppost],7) == round([2*CDFvNoPost,1],7), "all"))

%% Test 2 With postselection
[ErrProb, Ppost] = LogErrAfterPost(sig,vPost);
assert(all(round([ErrProb, Ppost],7) == round([2*CDFvPost/(1 - DiscardWindowProb),1 - DiscardWindowProb],7), "all"))
