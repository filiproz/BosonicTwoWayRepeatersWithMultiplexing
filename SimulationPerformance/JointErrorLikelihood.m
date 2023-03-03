function joint_prob = JointErrorLikelihood(error_vector, z_matrixCh, sigChFirst, sigCh, z_matrixPerfect, sigPerfect)
%This function takes a vector defining location of (qubits with) errors, the
%corresponding z-values (analog syndromes) measured during the GKP correction as well as
%the corresponding sigma of the random displacement distribution for GKP to calculate the
%probability of the error events given by the error_vector (The error_vector
%is obtained by the syndrome measurement of the qubit code, and the errors
%arise from errors in the GKP correction).
%Here we are considering a scenario where there were multiple rounds of
%GKP correction before the multi-qubit correction. Moreover, we perform
%this EC during Bell measurement i.e. after the displacements of qubit i from
%the left and qubit j from the right in each quadrature have been already added on the BS into
%a single displacement that is measured. So there are actually 14 physical
%qubits measured where the measurement is done after the displacements have
%already been added pairwaise into effective 7 measurements in each
%quadrature.
%
%We calculate the probability
%that on the given qubit(s) (error candidates) there was an odd number of errors and even on the others
%(in the chain of GKP error corrections).
%Each row of z_matrix corresponds to a different qubit and each column
%to a different GKP round.
%We distinguish separately the values for the cube preparation, inner leaf storage channels between consecutive TECs,
%and the final channel with CC-amplification before the logical BSM.
%We calculate the log of the probability as the resulting addition keeps
%more accurate track than multiplication

%Input:

%error_vector -     Row vector specifying qubits with errors by 1s, other
%                   entries 0
%z_matrix -         Matrix with measured analog syndromes, rows correspond
%                   to qubits, columns to GKP correction rounds, we
%                   distinguish the cube creation (z_matrixCube), storage channel between the consecutive
%                   TECs (z_matrixCh) and the final channel with
%                   CC-amplification (z_matrixPerfect)
%sig -              Vector of dimension corresponding to the number of qubits in the code
%                   with standard deviations for the corresponding error channels
%                   for which the syndrome was z_matrix. We distinguish the
%                   SD for the cube generation (sigCube), the storage
%                   channel between TECs (sigChFirst for the channel before
%                   first TEC and sigCh between TECs) and the storage
%                   channel with CC-amplification before the final logical
%                   BSM
%
%Output:
%
%joint_prob -       Log of the probability that given all the analog syndromes, the
%                   errors are given by error_vector 
joint_prob_temp = 0;
nqubit = length(error_vector);


%Firstly we foucus on the case if there was no intermediate TEC, then there
%is no z_matrixCh

if size(z_matrixCh,2) == 0
    

    for qubit_index = 1:nqubit
         if(error_vector(qubit_index) == 1)
             % we use the formula (1 - (1-2p1)(1-2p2)...)/2 for the probability
             % of odd number of errors (an error). We take log2 and log2(1/2) = -1
            joint_prob_temp = joint_prob_temp +  log2(ErrorLikelihood(z_matrixPerfect(qubit_index,1), sigPerfect(qubit_index)) );
         else
            % we use the formula (1 + (1-2p1)(1-2p2)...)/2 for the probability
            % of even number of errors (no error). We take log2 and log2(1/2) = -1
            joint_prob_temp = joint_prob_temp +  log2(1 - ErrorLikelihood(z_matrixPerfect(qubit_index,1), sigPerfect(qubit_index))  );

        end

    end

 % Nowe we focus on the case if there was a single intermediate TEC so
 % z_matrixCh will have two entries for a channel sigChFirst, one entry
 % from each side of the BSM
elseif size(z_matrixCh,2) == 2
    for qubit_index = 1:nqubit
         if(error_vector(qubit_index) == 1)
             % we use the formula (1 - (1-2p1)(1-2p2)...)/2 for the probability
             % of odd number of errors (an error). We take log2 and log2(1/2) = -1
            joint_prob_temp = joint_prob_temp - 1 +  log2(1 - prod(1 - 2 * ErrorLikelihood(z_matrixCh(qubit_index,:), sigChFirst(qubit_index))) ...
            * (1 - 2 * ErrorLikelihood(z_matrixPerfect(qubit_index,1), sigPerfect(qubit_index)) ) );
         else
            % we use the formula (1 + (1-2p1)(1-2p2)...)/2 for the probability
            % of even number of errors (no error). We take log2 and log2(1/2) = -1
            joint_prob_temp = joint_prob_temp - 1 +  log2(1 + prod(1 - 2 * ErrorLikelihood(z_matrixCh(qubit_index,:), sigChFirst(qubit_index))) ...
            * (1 - 2 * ErrorLikelihood(z_matrixPerfect(qubit_index,1), sigPerfect(qubit_index)) ) );

        end

    end
    
else
    %Now the case if there were more than one TECs so we have sigChFirst
    %(before the first TEC)
    %one for each side (located at positions z_matrixCh(qubit_index,1) for the left qubits and
    %at z_matrixCh(qubit_index,(end/2) + 1) for the right qubits. All the
    %other entries of z_matricCh are for sigCh (between TECs)
    for qubit_index = 1:nqubit
         if(error_vector(qubit_index) == 1)
             % we use the formula (1 - (1-2p1)(1-2p2)...)/2 for the probability
             % of odd number of errors (an error). We take log2 and log2(1/2) = -1
            joint_prob_temp = joint_prob_temp - 1 +  log2(1 - prod(1 - 2 * ErrorLikelihood(z_matrixCh(qubit_index,[1,(end/2) + 1]), sigChFirst(qubit_index))) ...
            *prod(1 - 2 * ErrorLikelihood(z_matrixCh(qubit_index,[2:end/2, (end/2) + 2:end]), sigCh(qubit_index)) ) ... 
            * (1 - 2 * ErrorLikelihood(z_matrixPerfect(qubit_index,1), sigPerfect(qubit_index)) ) );
         else
            % we use the formula (1 + (1-2p1)(1-2p2)...)/2 for the probability
            % of even number of errors (no error). We take log2 and log2(1/2) = -1
            joint_prob_temp = joint_prob_temp - 1 +  log2(1 + prod(1 - 2 * ErrorLikelihood(z_matrixCh(qubit_index,[1,(end/2) + 1]), sigChFirst(qubit_index))) ...
            *prod(1 - 2 * ErrorLikelihood(z_matrixCh(qubit_index,[2:end/2, (end/2) + 2:end]), sigCh(qubit_index)) ) ... 
            * (1 - 2 * ErrorLikelihood(z_matrixPerfect(qubit_index,1), sigPerfect(qubit_index)) ) );

        end

    end
    
end

joint_prob = joint_prob_temp;