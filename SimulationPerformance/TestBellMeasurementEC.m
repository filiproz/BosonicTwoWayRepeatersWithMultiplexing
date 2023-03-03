% Test BellMeasurementEC

%Define the look-up table for single  errors. The table is the same for Z
%and X errors
%Rows are 3 X stabilisers and columns are single Z errors (parity check matrix) or vice versa.

tableSingleErr =    [ 0, 0, 0, 1, 1, 1, 1;
                      0, 1, 1, 0, 0, 1, 1;
                      1, 0, 1, 0, 1, 0, 1]';

%Table with double errors

tableDoubleErr =  zeros(7,3,7);
for i = 1:7
   for j = 1:7
        tableDoubleErr(i,:,j) = mod(tableSingleErr(i,:) + tableSingleErr(j,:), 2);
   end
end
%Define the different possible error cases
%No error
deltasPerfect = zeros(7,1);
%Logical error on all GKP qubits
deltasAllErr = sqrt(pi) * ones(7,1);
%Logical GKP error on qubit 1
deltasSingleErrQ1 = zeros(7,1);
deltasSingleErrQ1(1) = sqrt(pi);
%Logical GKP error on qubit 2
deltasSingleErrQ2 = zeros(7,1);
deltasSingleErrQ2(2) = sqrt(pi);
%Logical GKP error on qubit 3
deltasSingleErrQ3 = zeros(7,1);
deltasSingleErrQ3(3) = sqrt(pi);
%Logical GKP error on qubits 1 and 2
deltasTwoErrQ12 = deltasSingleErrQ1 + deltasSingleErrQ2;
%GKP shift larger than sqrt(pi)/2 on qubit 1
deltasSingleErrQ1OutofGKPSpace = zeros(7,1);
deltasSingleErrQ1OutofGKPSpace(1) = 3*sqrt(pi)/4;
%GKP shift slighlty smaller than sqrt(pi)/2 on qubit 1
deltaNoErrNearBoundaryQ1 = zeros(7,1);
deltaNoErrNearBoundaryQ1(1) = (9/20) * sqrt(pi);

eta = 0.97;
etad = 0.98;
sigGKP = 0.1;
%Analog information
%No error
ZmatrixChPerfect = zeros(7,8);
%Pointing to error on qubit 2 in the channel
ZmatrixChErr2ndQ = zeros(7,8);
ZmatrixChErr2ndQ(2,4) = sqrt(pi)/3;
%Pointing to error on qubit 3 in the channel
ZmatrixChErr3rdQ = zeros(7,8);
ZmatrixChErr3rdQ(3,3) = sqrt(pi)/3;




%% Test 1: No error case, both quads
[MultiqubitErrors,s] = BellMeasurementEC(0, deltasPerfect, eta, sigGKP, etad, ZmatrixChPerfect, tableSingleErr, tableDoubleErr); 
assert(all(MultiqubitErrors == zeros(7,1)))
assert(s==0)
[MultiqubitErrors,s] = BellMeasurementEC(1, deltasPerfect, eta, sigGKP, etad, ZmatrixChPerfect, tableSingleErr, tableDoubleErr); 
assert(all(MultiqubitErrors == zeros(7,1)))
assert(s==0)

%% Test 2: All qubits with error, both quads
[MultiqubitErrors,s] = BellMeasurementEC(0, deltasAllErr, eta, sigGKP, etad, ZmatrixChPerfect, tableSingleErr, tableDoubleErr); 
assert(all(MultiqubitErrors == ones(7,1)))
assert(s==0)
[MultiqubitErrors,s] = BellMeasurementEC(1, deltasAllErr, eta, sigGKP, etad, ZmatrixChPerfect, tableSingleErr, tableDoubleErr); 
assert(all(MultiqubitErrors == ones(7,1)))
assert(s==0)

%% Test 3: Single qubit error, corrected, both quads
%Error in the channel
[MultiqubitErrors,s] = BellMeasurementEC(0, deltasSingleErrQ2, eta, sigGKP, etad, ZmatrixChErr2ndQ, tableSingleErr, tableDoubleErr); 
assert(all(MultiqubitErrors == zeros(7,1)))
assert(s==1)
[MultiqubitErrors,s] = BellMeasurementEC(1, deltasSingleErrQ2, eta, sigGKP, etad, ZmatrixChErr2ndQ, tableSingleErr, tableDoubleErr); 
assert(all(MultiqubitErrors == zeros(7,1)))
assert(s==1)
% Error during the last correction in BSM
[MultiqubitErrors,s] = BellMeasurementEC(0, deltasSingleErrQ1OutofGKPSpace, eta, sigGKP, etad, ZmatrixChPerfect, tableSingleErr, tableDoubleErr); 
assert(all(MultiqubitErrors == zeros(7,1)))
assert(s==1)
[MultiqubitErrors,s] = BellMeasurementEC(1, deltasSingleErrQ1OutofGKPSpace, eta, sigGKP, etad, ZmatrixChPerfect, tableSingleErr, tableDoubleErr); 
assert(all(MultiqubitErrors == zeros(7,1)))
assert(s==1)

%% Test 4:Two qubit error, corrected, both quads
%In p quad we consider the error on qubit 2 in the channel and in the BSM
%on qubit 1
[MultiqubitErrors,s] = BellMeasurementEC(1, deltasSingleErrQ2 + deltasSingleErrQ1OutofGKPSpace, eta, sigGKP, etad, ZmatrixChErr2ndQ, tableSingleErr, tableDoubleErr); 
assert(all(MultiqubitErrors == zeros(7,1)))
assert(s==1)
%The same in q-quad
[MultiqubitErrors,s] = BellMeasurementEC(0, deltasSingleErrQ2 + deltasSingleErrQ1OutofGKPSpace, eta, sigGKP, etad, ZmatrixChErr2ndQ, tableSingleErr, tableDoubleErr); 
assert(all(MultiqubitErrors == zeros(7,1)))
assert(s==1)

%% Test 5:Two qubit error, failed correction
%In p-quad we consider an initial logical error on qubit 2 and additional more than sqrt(pi)/2
%displacement on qubit 1 in the BSM
%and the analog information pointing strongly on qubit 3
%[sqrt(pi)/3]. Effectively
%the decoder flips qubit 3 leading to a logical error.
[MultiqubitErrors,s] = BellMeasurementEC(1, deltasSingleErrQ2 + deltasSingleErrQ1OutofGKPSpace, eta, sigGKP, etad, ZmatrixChErr3rdQ, tableSingleErr, tableDoubleErr); 
assert(mod(sum(MultiqubitErrors),2)==1)
assert(s==1)
%The same in q-quad.
[MultiqubitErrors,s] = BellMeasurementEC(0, deltasSingleErrQ2 + deltasSingleErrQ1OutofGKPSpace, eta, sigGKP, etad, ZmatrixChErr3rdQ, tableSingleErr, tableDoubleErr); 
assert(mod(sum(MultiqubitErrors),2)==1)
assert(s==1)

%% Test 6:Single qubit error, failed correction
%In p-quad we consider an initial logical error on qubit 3 with additional
%strong but less than sqrt(pi)/2 displacement on qubit 1. The analog
%information from the channel points to qubit 2 [sqrt(pi)/3] and from BSM on qubit 1.
[MultiqubitErrors,s] = BellMeasurementEC(1, deltasSingleErrQ3 + deltaNoErrNearBoundaryQ1, eta, sigGKP, etad, ZmatrixChErr2ndQ, tableSingleErr, tableDoubleErr); 
assert(mod(sum(MultiqubitErrors),2)==1)
assert(s==1)
%Same in q-quad
[MultiqubitErrors,s] = BellMeasurementEC(0, deltasSingleErrQ3 + deltaNoErrNearBoundaryQ1, eta, sigGKP, etad, ZmatrixChErr2ndQ, tableSingleErr, tableDoubleErr); 
assert(mod(sum(MultiqubitErrors),2)==1)
assert(s==1)