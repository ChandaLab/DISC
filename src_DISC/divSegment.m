function [data_fit,n_states] = divSegment(data, input_type, input_value, information_criterion);
%% Divisive Segmentation
% Author: David S. White
% Contact: dwhite7@wisc.edu
%
% Updates:
% ---------
% 2019-02-19    Version 1.0 Launched. DSW
%
%--------------------------------------------------------------------------
% Overview:
% ---------
% divSegment.m is Step 1 of the DISC alogirthm (runDISC.m)
%
% Divisive Segmentaion merges top-down clustering with change-point
% analysis to determine both significant clusters (states) and transitions.
% On each iteration:
%
%   1. Change-point detection: Perform Binary Segmentaion segment the data
%       in the current cluster (i.e identify signficant shifts of mean
%       amplitudes)
%           > Default is the use of a Student's t-test
%
%   2. Bisecting K-means (top-down). Cluster the idenfited segments by
%       amplitude into 2 clusters.
%
%   3. Decide whether split the cluster into 2 clusters improve the fit.
%       This is determined by the user-provided Information Criteria.
%
%   The alogorithm terminates when no new cluster can be split with an
%   improvement by BIC for that given cluster.
%
%
% Input Variables:
% ----------------
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
% information_criterion = {String}. Information Criterion/objective function
%   to  to determine if splitting a cluster should be accepted. See 
%   computeIC.m for addtional options.
%   * Default = 'BIC_RSS'
%
% Note: Results will depend on both the alpha_value and information_criterion
% used. Vary these knobs to determine what works best for your data
%
% Output Variables:
% ----------------
% data_fit = Cluster assignments descibed by mean values of cluster. [N,1]
%
% n_states = number of clusters found.
%
% References:
% -----------
% ref 1. White, D.S. et al., 2019, In preparation.
%
% -------------------------------------------------------------------------
%% Check Input Variables:

% Check data
if ~exist('data','var') || isempty(data);
    disp('Error in divSegment: No data provided.');
    return;
end

% Input Type
if ~exist('input_type','var') || isempty(input_type);
    input_type = 'critical_value';
end

% Input Value
if ~exist('input_value','var') || isempty(input_value);
    input_value = 1.96; % 95 % confidence interval (alpha_value = 0.05)
end

% Divisive Information Criterion
if ~exist('divisive_IC','var') || isempty(divisive_IC);
    divisive_IC = 'BIC_RSS';
end

%% run divSegment

% Set a minimum number of data points needed in a cluster to prevent the
% identification of spurious noise.
n_min = 5;

% number of data points
n_data = numel(data);

% The most common error in divSegment is that the first split (1 cluster to
% 2 clusters) is not accepted. Therefore we force the split on that iteration
% to give the algorithm another try. If new clusters can still not be
% identifed, the alogorithm will terminate and return a fit of 1 cluster.
force_split = 0;

% Compute some variables for the change-point detection (assuming t-test
% via changePoint.m). Doing so speeds up computation and only has a minor 
% effect on change-point detection vy changing critical values. 
% i.e. for a 95% Confidence interval, CV = 1.96 N > 100, CV = 2.28 N = 10

% convert alpha_value to critical_value
% our use of a t-test is a "two-way" but 'tinv' returns one-way
% critical values. alphaValue/2 converts to two-way critical value
if strcmp(input_type, 'alpha_value')
    input_value = tinv(1-input_value/2,n_data);
end

% Create Centers and data_fit variables
centers = mean(data);               % center 1 is the mean of the data
data_fit(1:n_data,1) = centers;     % create first cluster with mean assignment
k = 1;                              % loop index of centers
% Main loop terminates when all clusters have been checked for splitting.
while k <= length(centers)
    
    % find the data points that belong to the current cluster, where
    % clusters are described the mean values (centers)
    k_index = find(data_fit == centers(k));
    
    % identify the change points in the current cluster
    change_point_data_fit = detectCPs(data(k_index), 'critical_value', input_value);
    
    % report unique amplitudes (segments) discovered
    segments = unique(change_point_data_fit);
    
    % was at least one change-point (two-segments) returned?
    if length(segments) > 1
        
        % Make guesses for k-means of what two states might be by taking
        % the 33 and 66 quantiles of the segment values. This prevents
        % outlier detection by k-means alone.
        center_guesses = quantile(segments,[0.33,0.66]);
        
        % Cluster the segments by amplitude (i.e intensity levels) into 2
        % 2 clusters using K-means.
        
        % kmeansElkan runs much faster than MATLAB's k-means
        % where:
        % split_centers = mean values of each cluser [2,1];
        % split_data_fit = assignment of data points into cluster 1 or 2 [N,1];
        [split_centers, split_data_fit] = ...
            kmeansElkan(change_point_data_fit, center_guesses',1);
        
        % Optional: 
        % if running k-means without center guesses for finding 2 clusters:
        % [k_centers, k_data_fit] = kmeansElkan(change_point_data_fit,2,1);
        
        % count how many data points belong to each cluster [2,1];
        cluster_counts = accumarray(split_data_fit,1);
        
        % Were two clusters returned and both are larger than n_min?
        if size(split_centers,1) == 2 & cluster_counts >= n_min
            
            % Reformat from split_data_fit values (1,2) to split_centers
            split_data_fit(split_data_fit == 1) = split_centers(1);
            split_data_fit(split_data_fit == 2) = split_centers(2);
            
            % Compute information_criterion to assess the local improvment
            % of [no split; split] condtions
            % metric = information_criterion values
            % best_fit = best fit by the provided information_criterion
            compare_fits = [data_fit(k_index), split_data_fit];
            [~,best_fit] = computeIC(data(k_index),compare_fits, information_criterion);
            
            % Does the fit improve by splitting?
            if best_fit == 2
                % Accept new clusters
                data_fit(k_index) = split_data_fit; % update data_fit
                centers = unique(data_fit);          % update centers
                
                % force the first split?
            elseif best_fit == 1 && k == 1 && force_split == 0; % iter 1
                forceSplit = 1;
                data_fit(k_index) = split_data_fit;  % update data_fit
                centers = unique(data_fit);          % update centers
            else
                % Iterate: best_fit == 1
                k = k + 1;
            end
        else
            % Iterate: clusters are too small or only one cluster returned
            k = k + 1;
        end
    else
        % Iterate: no change-points found in the segment
        k = k + 1;
    end
end
n_states = length(centers);
% check for forced split at iteration 1 and remove if needed
if force_split == 1 & n_states == 2
    data_fit(:) = mean(data);
    n_states = 1;
end

end
