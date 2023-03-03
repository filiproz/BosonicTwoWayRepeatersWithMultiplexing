% Test JointErrorLikelihood

z_matrix_emptyNoTEC = zeros(7,0);
z_matrix_empty = zeros(7,2);
z_matrix_emptyMoreTEC = zeros(7,4);

z_matrix_1 =   [0, 0, 0, 0, sqrt(pi)/3, 0, 0;
                0, 0, 0, sqrt(pi)/3, 0, 0, 0]';
            
z_matrix_2 =   [0, 0, 0, 0, sqrt(pi)/2, 0, 0;
                0, 0, 0, 0, 0, 0, 0;]';
            
z_matrix_1_ErrsecondCh =[0, 0, 0, 0, 0, 0, 0;
                         0, 0, 0, 0, sqrt(pi)/3, 0, 0;
                         0, 0, 0, 0, 0, 0, 0;
                         0, 0, 0, sqrt(pi)/3, 0, 0, 0]';
                     
z_matrix_2_ErrsecondCh =[0, 0, 0, 0, 0, 0, 0;
                         0, 0, 0, 0, sqrt(pi)/2, 0, 0;
                         0, 0, 0, 0, 0, 0, 0;
                         0, 0, 0, 0, 0, 0, 0]'; 
            
z_matrix_Perfect_1 = [0, 0, 0, sqrt(pi)/3, sqrt(pi)/3, 0, 0]';
z_matrix_Perfect_2 = [0, 0, 0, 0, sqrt(pi)/2, 0, 0]';
             
error_vector_1 = [0, 0, 0, 1, 1, 0, 0];
error_vector_2 = [1, 0, 0, 0, 0, 0, 0];              
error_vector_3 = [0, 0, 0, 0, 1, 0, 0];
           

sig_empty = zeros(7,1);
sigCh = 0.3*ones(7,1);
sigChFirst = 0.2*ones(7,1);
sigChPerfect = 0.15*ones(7,1);

                

% For every test case we check two things:
% 1. Firstly, that the two-qubit error on the qubits for which the GKP syndrome somewhere in the chain of
% GKP corrections was non-zero, is more likely than a single qubit error on
% the qubit for which the GKP syndrome was zero everywhere.
% 2. Secondly we check that the error probability of a single-qubit error,
% for the qubit which somewhere in the chain of GKP corrections had a GKP
% syndrome of sqrt(pi)/2 and zero everywhere else should be approximately
% equal to 0.5.

                
%% Test 1: Channel with no intermediate TEC
a = JointErrorLikelihood(error_vector_1,z_matrix_empty,sig_empty,sig_empty,z_matrix_Perfect_1,sigChPerfect);
b = JointErrorLikelihood(error_vector_2,z_matrix_empty,sig_empty,sig_empty,z_matrix_Perfect_1,sigChPerfect);
assert(a > b)

c = JointErrorLikelihood(error_vector_3,z_matrix_empty,sig_empty,sig_empty,z_matrix_Perfect_2,sigChPerfect);
assert(round(c,5) == -1)

%% Test 2: Channel with 1 intermediate TEC, error in the first channel
a = JointErrorLikelihood(error_vector_1,z_matrix_1,sigChFirst,sig_empty,z_matrix_empty,sig_empty);
b = JointErrorLikelihood(error_vector_2,z_matrix_1,sigChFirst,sig_empty,z_matrix_empty,sig_empty);
assert(a > b)

c = JointErrorLikelihood(error_vector_3,z_matrix_2,sigChFirst,sig_empty,z_matrix_empty,sig_empty);
assert(round(c,5) == -1)

%% Test 3: Channel with 2 intermediate TECs, error in the second (middle) channel
a = JointErrorLikelihood(error_vector_1,z_matrix_1_ErrsecondCh,sig_empty,sigCh,z_matrix_empty,sig_empty);
b = JointErrorLikelihood(error_vector_2,z_matrix_1_ErrsecondCh,sig_empty,sigCh,z_matrix_empty,sig_empty);
assert(a > b)

c = JointErrorLikelihood(error_vector_3,z_matrix_2_ErrsecondCh,sig_empty,sigCh,z_matrix_empty,sig_empty);
assert(round(c,5) == -1)


