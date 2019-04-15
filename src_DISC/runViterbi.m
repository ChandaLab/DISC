function viterbi_data_fit = runViterbi(data,data_fit,max_iter)
%% Run Viterbi from DISC
% David S. White
% dwhite7@wisc.edu
%
% 2019-02-20    DSW    version 1.0
%
%--------------------------------------------------------------------------
% Overview:
% ---------
% Adapt the idea of segmental k-means (SKM) to run a Viterbi algorithm on 
% the results of DISC to find the most optimal state path in the data. 
%
%--------------------------------------------------------------------------
%
% Input Variables:
% ----------------
% data = 1D time series data to idealize;
%
% data_fit = state data_fit from DISC
%
% max_iter = number of times to run Viterbi. 
%    Default = 1 ; Diminishing returns after 2 iterations observed.
%
% Output Variables:
% -----------------
% data_fit = Best State data_fit as intergers, i.e [1,2,3]
%
%% runViterbi
% Check Arguments; set default values
% Check data
if ~exist('data','var') || isempty(data);
    disp('Error in divSegment: No data provided.');
    return;
end

% Check data_fit
if ~exist('data_fit','var') || isempty(data_fit);
    disp('Error in divSegment: No data_fit provided.');
    return;
end

% Make sure data and data_fit are the same length
if length(data) ~= length(data_fit)
    disp('Error in divSegment: data and data_fit are not the same length.');
    return;
end

% Check max_iter
if ~exist('max_iter','var') || isempty(max_iter);
    max_iter = 1;
    return;
end

% intialize variables
log_likelihood = zeros(max_iter,1);
viterbi_path = zeros(max_iter,numel(data));

% main loop 
for iter = 1:max_iter
    if iter == 1
        % start from the provided data 
        seq = data_fit;
    else
        % use the previous viterbi_path as the starting point 
        seq = viterbi_path(iter-1,:);
    end
    
    % Starting probabilities 
    [components,seq] = computeCenters(data,seq); 
    weights = components(:,1); 
    
    % Emissions Matrix (Gaussian Dist)
    emissons_matrix = computeEM(data,components);
    
    % Transitions matrix
    transitions_matrix = computeTM(seq);
    
    % Find viterbi path
    [viterbi_path(iter,:),log_likelihood(iter)] = viterbiPath(weights, transitions_matrix, emissons_matrix);
    
end
% output of best path across all iterations 
[~,best_iter] = max(log_likelihood);
viterbi_data_fit =  viterbi_path(best_iter,:)'; 

end