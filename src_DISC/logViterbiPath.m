function [viterbi_path,log_p] = logViterbiPath(weights,transitions_matrix, emissions_matrix)
%% Log Viterbi Path
% Author: David S. White
% Contact: dwhite7@wisc.edu
%
% Updates:
% ---------
% 2019-08-26    DSW    Version 1.0
%
%--------------------------------------------------------------------------
% 
% Overview:
% ---------
% The Viterbi algorithm aims to find the viterbi_path, which is the most 
% probable sequence of states in the data, espeically in the context of 
% hidden Markov models.
%
% Note: 
% -----
% This algorithm is uses log probabilities to speed up computations. Also,
% this code has been adapted from the "hmmviterbi" from Matlab's Stastics 
% and Machine Learning Toolbox. This code has been modified to correct for 
% the assumption that the model begins in state 1.  
%
% Notations: 
% ----------
% N = number of data points in the data 
% 
% K = number of states in the fit 
%
% Input Variables:
% ----------------
% weights = overall probability a state appears in the time series.
%   [K,1], where K == number of states. sum(weights) = 1; 
%`  > see computeCenters.m
% 
% emissions_matrix = [K,N] where K = number of states and N = length of
%   data used to generate the emissions_matrix. Each [:,Ni] is the 
%   probability that the given data point Ni came from each state. Therefore, 
%   sum(emissions_matrix(:,Ni)) = 1; 
%`  > see computeEM.m
%
% transitions_matrix = [K,K] where K = number of states. For each [i,j] is
%   the probability of Ki transitioning to Kj. Rows and Columns sum to 1.
%`  > see computeTM.m
%
% Output Variables:
% -----------------
% viterbi_path = [1,N] assignment of each data point to state described by
%   integers 1:K
%
% log_p = log likelihood of the path 
%
% -------------------------------------------------------------------------

% Find  number of data points and states
[n_states,n_data_points] = size(emissions_matrix);

% Allocate space: 
pTR = zeros(n_states,n_data_points);  % probability of transitions 

% work in log space for numerical underflow! 
logTM = log(transitions_matrix); 
logEM = log(emissions_matrix); 
logW = log(weights); 

% find the most probable state for data point 1
v = logW + logEM(:,1);
% store a copy of previous rather than allocating space for all 
vOld = v;

% for each data point 
for n = 1:n_data_points
    % for each state 
    for k = 1:n_states
        % set dummy values 
        bestVal = -inf; 
        bestPTR = 0; 
        % loop through to store the best answer only. This removes the use 
        % of "max" which is slow. 
        for s = 1:n_states
            val = vOld(s) + logTM(s,k);
            % store best
            if val > bestVal
                bestVal = val; 
                bestPTR = s; 
            end
        end
        % find max
        pTR(k,n) = bestPTR; 
        % update v 
        v(k) = logEM(k,n) + bestVal;
    end
    vOld=v; 
end

% find most probable
[log_p, final_state] = max(v); 

% now go back through the model 
viterbi_path = zeros(1,n_data_points); % final ouput
viterbi_path(end) = final_state;
for i = n_data_points-1:-1:1 % itereate backwards
    viterbi_path(i) = pTR(viterbi_path(i+1),i+1);
end

end