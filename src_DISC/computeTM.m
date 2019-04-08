function transitions_matrix = computeTM(data_fit)
%% Computes a Transitons Matrix for a given State data_fit
% David S. White
% dwhite7@wisc.edu
%
% Updates:
% --------
% 2018-02-20    DSW     version 1.0
%
%--------------------------------------------------------------------------
% Notation:
% ---------
% N = number of observations in data; length(data)
% K = number of states in components; size(components,1) 
%
% Input Variables:
% ----------------
% data_fit = [N,1] data_fit of state assignments 
%
% Output Variables:
% ----------------
% transitions_matrix = transitions porbability matrix of [K x K] probabilites 
%  i.e. transitions_matrix(1,2) = probability of state_1 to  state_2


% Check data
if ~exist('data_fit','var') || isempty(data_fit);
    disp('Error in computeEM: No data_fit provided.');
    return;
end

states = unique(data_fit); 
n_states = length(states);
n_data_points = length(data_fit);

% check for one cluster 
if n_states == 1
    transitions_matrix = 1; 
    return; 
end

% assign by integer values if not already done so. Simplier for the loop
[~,~,data_fit] = unique(data_fit); 

% create empty transitions_matrix
transitions_matrix = zeros(n_states,n_states);
for n = 1:n_data_points-1;
    % Add 1 for each transition between data_fit(n) and data_fit(n+1)
    transitions_matrix(data_fit(n),data_fit(n+1)) = transitions_matrix(data_fit(n),data_fit(n+1)) + 1;
end
% avoid non zero numbers
transitions_matrix = transitions_matrix + 1e-6; 
% noramlize for final output. All rows and columns sum to 1
transitions_matrix = transitions_matrix ./ repmat(sum(transitions_matrix,2),1,size(transitions_matrix,2));

