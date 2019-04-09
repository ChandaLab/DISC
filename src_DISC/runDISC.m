function [components, ideal, class, metrics, DISC_FIT] = runDISC(data, input_type, input_value, divisive_IC, agglomerative_IC, viterbi_iter, return_k);
%% DISC : Divisive Segmentation and Clustering for Time Series Idealization
% Author: David S. White
% Contact: dwhite7@wisc.edu
%
% Updates:
% ---------
% 2019-02-20    DSW    Version 1.0
%
%--------------------------------------------------------------------------
% Overview:
% ---------
% runDISC.m is a wrapper for running the DISC algorithm descirbed in ref 1.
%
% The goal of DISC is to determine the number of states in a time-series
% and their transitions. The most common application is single-molecule
% data  which can be described as a series of transitions between discrete
% states  approximated by a peicewise constant signal. This is done with
% the following steps:
%
%   1. Divisive Segmentation:
%   Top down change-point analysis with bisecting k-means to determine
%   significant clusters and segments.
%   > divSegment.m
%
%   2. Hierarchical Agglomerative Clustering:
%   Bottom up clustering of divisive segmentation results to find the
%   best number of states to describe the data.
%   > aggCluster.m
%
%   3. Viterbi:
%   Detect the most probable hidden state path from estimates obtained by
%   Steps 1 & 2.
%   > runViterbi.m
%
% Requirements:
% -------------
% MATLAB Stastics and Machine Learning Toolbox required.
%
% Input Variables:
% ----------------
% All input variables are contained in the output structue: DISC_FIT
%
% data = [N,1]; raw data to be analyzed. N must be >= 5
%
% input_type = either 'critical_value' or 'alpha_value' accepted. This
%   parameters controls the sensivity of change-point detection.
%   * Default = 'alpha_value'
%
% input_value = the numerical value of 'input_type'. This
%   parameters controls the sensivity of change-point detection.
%   * Default = '0.05' (input_type = alpha_value)
%
% divisive_IC = {String}. Information Criterion/objective function to use 
%   for divSegmentation. See computeIC for addtional options.
%   * Default = 'BIC_RSS'
%
% agglomerative_IC = {String}. Information Criterion/ objective function to
%   use for aggCluster. See computeIC for addtional options.
%   * Default = 'BIC_GMM'
%
% viterbi_iter = Number of times to run the Viterbi algorithm.
%   % Deault = 2 (diminishing returns observed beyond 2)
%
% return_k = return k states regardless of information_criterion
%   result. If return_k_states > total states found by divSegment.m, the
%   max value found will be returned.
%   * Default return_k_states= 0 (Boolean check)
%
%
% Output Variables:
% -----------------
% All input & output variables are contained in the structue: DISC_FIT
%
% DISC_FIT.components = [K,3] where rows are the components of each
%   identified state [weight, mu, sigma] and K = number of states.
%
% DISC_FIT.ideal = [N,1], idealized data_fit described by the mu of each
%   state.
%
% DISC_FIT.class = [N,1] state data_fit of the data points by cluster
%   assignment (i.e 1 2 3 etc...).
%
% DISC_FIT.metrics = Information criterion values obtained during
%   Hierachiacal Agglomerative Clustering. Values are normalized between
%   0 (best) and 1 (worst).
%
% DISC_fit.all_data_fits = All potential number of states grouped
%   iteratively by aggCluster.m. [N,K] where [N,1] = 1 states, [N,2] = 2
%   states, etc..
%
% -------------------------------------------------------------------------
% References:
% -----------
% ref 1. White, D.S. et al., 2019, In preparation.
% -------------------------------------------------------------------------
%% Check Input 
% Initalize an empty output 
DISC_FIT = struct;

% Check data
if ~exist('data','var') || isempty(data);
    disp('Error in runDISC: No data provided');
    return;
end
% check the format of data. Must be N by
[n_data,dim] = size(data);
if dim == 1 && n_data < 5 % need at least 5 data points
    disp('Error in runDISC: Data has too few data points');
    return; 
end
if dim > 1 && n_data > 1 % too complex to parse to figure out 
    disp('Error in runDISC: Data has needs to be [N,1]');
    return;
end
if dim >= 5 && n_data == 1 % 
    data = data'; %  transpose & continue
end

% Input Type
if ~exist('input_type','var') || isempty(input_type);
    input_type = 'alpha_value'; 
end

% Input Value
if ~exist('input_value','var') || isempty(input_value);
    input_value = 0.05; % 95 % confidence interval
end

% Divisive Information Criterion
if ~exist('divisive_IC','var') || isempty(divisive_IC);
    divisive_IC = 'BIC_RSS';
end

% Agglomerative Information Criterion
if ~exist('agglomerative_IC','var') || isempty(agglomerative_IC);
    agglomerative_IC = 'BIC_GMM';
end

% quick fix from old format that doesn't seem to go away
if strcmp(input_type,'criticalValue')
    input_type = 'critical_value'; 
end
if strcmp(input_type,'alphaValue')
    input_type = 'alpha_value'; 
end


% Viterbi Iterations
if ~exist('viterbi_iter','var') || isempty(viterbi_iter);
    viterbi_iter = 1; % typically find diminishing returns beyond 2
end

% Number of States to return
if ~exist('return_k','var') || isempty(return_k);
    return_k = 0;  % Do not use.
end

% Condense all input into the "DISC_FIT" structure
DISC_FIT.input_type = input_type;
DISC_FIT.input_value = input_value;
DISC_FIT.divisive_IC = divisive_IC;
DISC_FIT.agglomerative_IC = agglomerative_IC;
DISC_FIT.viterbi_iter = viterbi_iter;
DISC_FIT.return_k = return_k; 


%% Step 1. Divisive Clustering 
% Determine number of clusters and transitons between them 
[data_fit,n_states] = divSegment(data, input_type, input_value, divisive_IC);

%% Step 2. Hierarchical Agglomerative Clustering
% If at least one cluster was returned, find the ideal number of states
% in bottom-up clustering according to the specified agglomerative_IC. 

if n_states > 1 && ~strcmp(agglomerative_IC, 'none')
    
    % Create Hierarchy of all clusters using Ward's Distance.
    all_data_fits = aggCluster(data, data_fit);

    % Compute agglomerative_IC for each and take the best_fit number of
    % states
     norm = 1; 
     [metrics, best_fit] = computeIC(data, all_data_fits, agglomerative_IC,norm);
     
     % store output of best_fit 
     data_fit = all_data_fits(:,best_fit); 
     
else
    metrics = []; % need an ouput; 
    all_data_fits = []; 
end

% Optional: force a best_fit to return_k_states
if return_k
    % Cannot return a number of states > total number of states found in
    % divSegment.m 
    if return_k > n_states
        return_k = n_states;
    end
    data_fit = all_data_fits(:,return_k);
end

% Store the computed metric values from agglomerative_IC & all_data_fits 
DISC_FIT.metrics = metrics; 
DISC_FIT.all_data_fits = all_data_fits;

%% Step 3. Viterbi Algorithm
if viterbi_iter > 0 && n_states > 1
    data_fit = runViterbi(data, data_fit, viterbi_iter);
end

%% Store Final Output
[components,ideal,class] = computeCenters(data, data_fit);

end
