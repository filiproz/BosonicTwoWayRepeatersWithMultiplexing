function [ErrProb, Ppost] = LogErrAfterPost(sig,v)
%This function evaluates the error probability conditioned on passing the
%postselection test during the GKP correction as well as the probability of
%passing the posselection.
%IMPORTANT: This function only uses the central intervals which is an
%approximation only valid for not too large values of sig. Specifically,
%for sig < 0.36 the relative error on ErrProb < 1% (see paper). For larger
%values of sig the not included tails can start having non-negligible contributions.

%Input:

%sig -              SD of the noise channel
%v -                post-selection window
%
%Output:
%
%ErrProb -          error probability conditioned on passing the post-selection
%Ppost -            probability of passing the post-selection

% We only considder the interval between -3*sqrt(pi)/2+v and 3*sqrt(pi)/2-v
% as the other intervals are negligible

fun = @(x) normpdf(x,0,sig);
E1 = integral(fun,-3*sqrt(pi)/2+v,-sqrt(pi)/2-v) + integral(fun,sqrt(pi)/2+v,3*sqrt(pi)/2-v);
E0 = integral(fun,-sqrt(pi)/2+v,sqrt(pi)/2-v);

Ppost = E0 + E1;
ErrProb = E1/Ppost;