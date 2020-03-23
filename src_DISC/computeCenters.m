function [components,mu_data_fit,state_data_fit] = computeCenters(data,data_fit)
%% Compute Components, state_data_fit, and clusters from data and state assignment 
% Author: David S. White
% Contact: dwhite7@wisc.edu
%
% Updates:
% --------
% 2018-06-06 DSW wrote the code
% 2019-04-09 DSW simplified code. 2X speed increase
% -------------------------------------------------------------------------
% Overview:
% ---------
% Compute all [weights, mu, sigmas] of each cluster provided in Y from
% data in data. data_fit can be either a state data_fit or clusters. 
%
% Input Variables:
% ----------------
% data = N X 1 data
%
% data_fit = N X 1 cluster labels (i.e 1,2,3 or 100 ,200, 300)
%
% Output Variables:
% ----------------
% components = [weight,mu,sigma] of Gaussian fit [k,3]
%
% mu_data_fit = sorted cluster assigment for datapoints as integers (i.e 1,2,3)
%
% state_data_fit = cluster assignment for datapoints using mean of cluster (i.e 100,200,300)

% Check Input Varables 
if ~exist('data','var') || isempty(data)
    disp('Error in computeCenters: Need Data to Analyze'); 
    return; 
end
if ~exist('data_fit','var') || isempty(data_fit)
    disp('Error in computeCenter: Need data_fit'); 
    return; 
end
if length(data) ~= length(data_fit)
    disp('Error in computeCenters: Inputs must be the same length'); 
    return;
end

% initalize 
n_data_points = numel(data);
labels = unique(data_fit); 
n_labels = length(labels); 
mu_data_fit = zeros(n_data_points,1); 
components = zeros(n_labels,3); % [weight, mu, sigma]

% organize unique values in ascending order 
[~,~,state_data_fit] = unique(data_fit);

% compute all variables
for k = 1:n_labels
    % find data points assigned to cluster == k
    index = state_data_fit == k; 
    [mu,sigma] = normfit(data(index));
    weight = sum(index) / n_data_points;
    
    % store
    mu_data_fit(index) = mu;    % described by mean value
    components(k,1) = weight;   % Proportion of data in the cluster
    components(k,2) = mu;       % mean of the data in the cluster
    components(k,3) = sigma + 1e-6; % avoid zero-valued standard deviations
    
end
    
