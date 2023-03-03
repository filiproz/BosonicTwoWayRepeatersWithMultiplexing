% Test SecretKey6StateEndToEndTypicalSequences
L = 5;
Ltot = 500;

%% Test 1: No noise case
sTotal1 = [0,0];
sTotal2 = [0.03,0.02];
k = 3;
Zerr = zeros(k,2);
Xerr = zeros(k,2);
z1 = 0.001;
z2 = 0.01;
%Rate just given by the probability of being in a typical set,
%independently of z and if the error syndrome is always zero, then
%there is only one typical sequence independently of z.
%For z_1
[Rate,SumPZ,SumPX] = SecretKey6StateEndToEndTypicalSequences(L, Ltot, Zerr, Xerr, sTotal1, z1);
assert(round(Rate,10)==round(SumPZ*SumPX,10))
assert(round(SumPZ*SumPX,10) ==1)
%For z_2
[Rate,SumPZ,SumPX] = SecretKey6StateEndToEndTypicalSequences(L, Ltot, Zerr, Xerr, sTotal1, z2);
assert(round(Rate,10)==round(SumPZ*SumPX,10))
assert(round(SumPZ*SumPX,10) ==1)
%Rate just given by the probability of being in a typical set.
%For z_1
[Rate,SumPZ,SumPX] = SecretKey6StateEndToEndTypicalSequences(L, Ltot, Zerr, Xerr, sTotal2, z1);
assert(round(Rate,10)==round(SumPZ*SumPX,10))
%For z_2
[Rate,SumPZ,SumPX] = SecretKey6StateEndToEndTypicalSequences(L, Ltot, Zerr, Xerr, sTotal2, z2);
assert(round(Rate,10)==round(SumPZ*SumPX,10))

%% Test 2: Perfect links for no error syndrome, very noisy for error syndrome
sTotal1 = [0,0];
sTotal2 = [0.1,0.2];
k = 3;
Zerr = 0.5*ones(k,2);
Zerr(:,1) = 0;
Xerr = 0.5*ones(k,2);
Xerr(:,1) = 0;
z1 = 0;
z2 = 0.001;
z3 = 0.1;
z4 = 0.2;
%If the error syndrome is always zero, then
%there is only one typical sequence independently of z as before.
%For z_1
[Rate,SumPZ,SumPX] = SecretKey6StateEndToEndTypicalSequences(L, Ltot, Zerr, Xerr, sTotal1, z1);
assert(round(Rate,10)==round(SumPZ*SumPX,10))
assert(round(SumPZ*SumPX,10) ==1)
%For z_2
[Rate,SumPZ,SumPX] = SecretKey6StateEndToEndTypicalSequences(L, Ltot, Zerr, Xerr, sTotal1, z2);
assert(round(Rate,10)==round(SumPZ*SumPX,10))
assert(round(SumPZ*SumPX,10) ==1)
%If the error syndrome can be non-zero, then positive rate only if the all
%0 sequence is included and then the rate is given by the probability of
%being in that sequence.
%For z_1 we have only the average sequence
[Rate,SumPZ,SumPX] = SecretKey6StateEndToEndTypicalSequences(L, Ltot, Zerr, Xerr, sTotal2, z1);
assert(Rate==0)
assert(round(SumPZ,10) == round(binopdf(sTotal2(1)*(Ltot/L), Ltot/L, sTotal2(1)),10))
assert(round(SumPX,10) == round(binopdf(sTotal2(2)*(Ltot/L), Ltot/L, sTotal2(2)),10))
%For z_2 we still don't get the 0 sequence
[Rate,SumPZ,SumPX] = SecretKey6StateEndToEndTypicalSequences(L, Ltot, Zerr, Xerr, sTotal2, z2);
assert(Rate==0)
%For z_3 we get the zero sequence only in Z so still no rate
[Rate,SumPZ,SumPX] = SecretKey6StateEndToEndTypicalSequences(L, Ltot, Zerr, Xerr, sTotal2, z3);
assert(Rate==0)
%For z_4 we get th zero sequence included in both Z and X so rate is
%given by the probability of that sequence
[Rate,SumPZ,SumPX] = SecretKey6StateEndToEndTypicalSequences(L, Ltot, Zerr, Xerr, sTotal2, z4);
assert(round(Rate,10)==round(sTotal2(1)^(Ltot/L) * sTotal2(2)^(Ltot/L),10))
%% Test 3: All links noisy, the rate is always 0.
sTotal1 = [0,0];
sTotal2 = [0.1,0.2];
k = 3;
Zerr = 0.5*ones(k,2);
Xerr = 0.5*ones(k,2);
z1 = 0;
z2 = 0.001;
z3 = 0.1;
z4 = 0.2;
%If the error syndrome is always zero, then
%there is only one typical sequence independently of z as before.
%For z_1
[Rate,SumPZ,SumPX] = SecretKey6StateEndToEndTypicalSequences(L, Ltot, Zerr, Xerr, sTotal1, z1);
assert(Rate==0)
assert(round(SumPZ*SumPX,10) ==1)
%For z_2
[Rate,SumPZ,SumPX] = SecretKey6StateEndToEndTypicalSequences(L, Ltot, Zerr, Xerr, sTotal1, z2);
assert(Rate==0)
assert(round(SumPZ*SumPX,10) ==1)
%If the error syndrome can be non-zero.
%For z_1 we have only the average sequence
[Rate,SumPZ,SumPX] = SecretKey6StateEndToEndTypicalSequences(L, Ltot, Zerr, Xerr, sTotal2, z1);
assert(Rate==0)
assert(round(SumPZ,10) == round(binopdf(sTotal2(1)*(Ltot/L), Ltot/L, sTotal2(1)),10));
assert(round(SumPX,10) == round(binopdf(sTotal2(2)*(Ltot/L), Ltot/L, sTotal2(2)),10));
%For z_2
[Rate,SumPZ,SumPX] = SecretKey6StateEndToEndTypicalSequences(L, Ltot, Zerr, Xerr, sTotal2, z2);
assert(Rate==0)
%For z_3
[Rate,SumPZ,SumPX] = SecretKey6StateEndToEndTypicalSequences(L, Ltot, Zerr, Xerr, sTotal2, z3);
assert(Rate==0)
%For z_4
[Rate,SumPZ,SumPX] = SecretKey6StateEndToEndTypicalSequences(L, Ltot, Zerr, Xerr, sTotal2, z4);
assert(Rate==0)