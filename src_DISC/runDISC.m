function disc_fit = runDISC(data, disc_input)

%% DISC : Divisive Segmentation and Clustering for Time Series Idealization
% Author: David S. White
% Contact: dwhite7@wisc.edu
%
% Updates:
% ---------
% 2019-02-20    DSW     v1.0.0 version submitted to bioRxiv
%
% 2019-04-10    DSW     v1.1.0 modifcations to input/ output arguments
%
%--------------------------------------------------------------------------
% Overview:
% ---------
% runDISC.m is a wrapper for running the DISC algorithm described in ref 1.
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
% All input variables are contained in the output structue: disc_fit
%
% data = [N,1]; raw data to be analyzed. N must be >= 5
%
% disc_fit is a data structure with the following fields: 
%
% disc_fit.input_type = either 'critical_value' or 'alpha_value' accepted. This
%   parameters controls the sensivity of change-point detection.
%   * Default = 'alpha_value'
%
% disc_fit.input_value = the numerical value of 'input_type'. This
%   parameters controls the sensivity of change-point detection.
%   * Default = '0.05' (input_type = alpha_value)
%
% disc_fit.divisive = {String}. Information Criterion/objective function to use 
%   for divSegmentation. See computeIC for addtional options.
%   * Default = 'BIC_GMM'
%
% disc_fit.agglomerative = {String}. Information Criterion/ objective function to
%   use for aggCluster. See computeIC for addtional options.
%   * Default = 'BIC_GMM'
%
% disc_fit.viterbi = Number of times to run the Viterbi algorithm.
%   % Default = 2 (diminishing returns observed beyond 2)
%
% disc_fit.return_k = return k states regardless of information_criterion
%   result. If return_k_states > total states found by divSegment.m, the
%   max value found will be returned.
%   * Default return_k_states= 0 (Boolean check)
% 
%
% Output Variables:
% -----------------
% All input & output variables are contained in the structue: disc_fit
%
% disc_fit.components = [K,3] where rows are the components of each
%   identified state [weight, mu, sigma] and K = number of states.
%
% disc_fit.ideal = [N,1], idealized data_fit described by the mean of each
%   state.
%
% disc_fit.class = [N,1] state data_fit of the data points by cluster
%   assignment (i.e 1 2 3 etc...).
%
% disc_fit.metrics = Information criterion values obtained during
%   Hierachiacal Agglomerative Clustering. Values are normalized between
%   0 (best) and 1 (worst).
%
% disc_fit.all_ideal = All potential number of states grouped
%   iteratively by aggCluster.m. [N,K] where [N,1] = 1 states, [N,2] = 2
%   states, etc..
%
% -------------------------------------------------------------------------
% References:
% -----------
% 1. White, D., Goldschen-Ohm, M., Goldsmith, R. & Chanda, B. High-Throughput Single-
% Molecule Analysis via Divisive Segmentation and Clustering. bioRxiv, 603761 (2019).
%
% -------------------------------------------------------------------------
%% Check Input 
% Initalize an empty disc_fit output  
disc_fit = struct;
disc_fit.components = []; 
disc_fit.ideal = []; 
disc_fit.class = []; 
disc_fit.metrics = []; 
disc_fit.all_ideal = []; 

% Check data
if ~exist('data','var') || isempty(data)
    disp('Error in runDISC: No data provided');
    return;
end

% check the format of data. Must be N by
[n_data,dim] = size(data);
if dim > 1 || n_data < 5 % need at least 5 data points
    disp('Error in runDISC: Data has too few data points or is wrong format');
    return; 
end

% Does disc_input exist? 
if ~exist('disc_input','var')
    disc_input = struct; 
    disc_input = setDefault(disc_input); 
else
    % Check each field to ensure values are provided. 
    disc_input = setDefault(disc_input); 
end

% Check each field to ensure values are provided. 
% disc_input = checkInput(disc_input); 

% add parameters to the disc_fit structure
disc_fit.parameters = disc_input; 


%% Step 1. Divisive Clustering 
% Determine number of clusters and transitons between them 
if ~strcmp(disc_input.divisive, 'none')
    [data_fit,n_states] = divSegment(data, disc_input.input_type, disc_input.input_value, disc_input.divisive);
else
    % only perform change-point detection. Not recommended!
    [data_fit,n_states] = detectCPs(data, disc_input.input_type, disc_input.input_value);
end

%% Step 2. Hierarchical Agglomerative Clustering
% If at least one cluster was returned, find the ideal number of states
% in bottom-up clustering according to the specified agglomerative_IC. 

if n_states > 1 && ~strcmp(disc_input.agglomerative, 'none')
    
    % Create Hierarchy of all clusters using Ward's Distance.
    disc_fit.all_ideal = aggCluster(data, data_fit);

    % Compute agglomerative_IC for each and take the best_fit number of
    % states
     normalize_values = 1; 
     [disc_fit.metrics, best_fit] = computeIC(data, disc_fit.all_ideal, disc_input.agglomerative, normalize_values);
     
     % store output of best_fit 
     data_fit = disc_fit.all_ideal(:,best_fit); 
end

% Optional: force a best_fit to return_k_states
if disc_input.return_k
    % Cannot return a number of states > total number of states found in
    % divSegment.m 
    if disc_input.return_k > n_states
        disc_input.return_k = n_states;
    end
    data_fit = disc_fit.all_ideal(:,disc_input.return_k);
end

%% Step 3. Viterbi Algorithm
if disc_input.viterbi > 0 && n_states > 1
    data_fit = runViterbi(data, data_fit, disc_input.viterbi);
end

%% Store Final Output
[disc_fit.components, disc_fit.ideal, disc_fit.class] = computeCenters(data, data_fit);

end
