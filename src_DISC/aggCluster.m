function [all_data_fits] = aggCluster(data, data_fit);
%% 1D Hierarchical Agglomerative Clustering (Bottom-up) using Ward's Distance
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
% Bottom-up (agglomerative) clustering iteratively merges clusters until
% only one cluster remains. Clusters are merged based on  minimizing Ward's
% Distance, which is a minimum variance approach.
% Note: this is a 1D variant of agglomerative clustering.
%
% In a 1D Space, Ward's distance is described as:
%
%           (2 * N1 * N2 / (N1 + N2))^0.5 * (mu1 - mu2)
%
%       Where:
%           N1 = number of data points in cluster 1
%           N2 = number of data points in cluster 2
%           mu1 = mean of data points in cluster 1
%           mu2 = mean of data points in cluster 2
%
% On each iteration, the two clusters with the minimal Ward's distance
% are merged
%
%
% Input Variables:
% ----------------
% data = [N,1]; raw data to be analyzed.
%
% data_fit = Assigment of data_points into K labels. Labels are cluster
%   centroid values (mean of cluster) [N,1].
%
% Output Variables:
% ----------------
% all_data_fits = All potential number of states grouped
%   iteratively by aggCluster.m. [N,K] where [N,1] = 1 states, [N,2] = 2
%   states, etc..
%
% References:
% -----------
% Ward, Journal of the American Statistical Associtation, 1963
% See: https://en.wikipedia.org/wiki/Hierarchical_clustering
%
% -------------------------------------------------------------------------
%% Check Input Variables:
% initialize output
all_data_fits = [];

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

%% run aggCluster

centers = unique(data_fit); % unique states in the provided data_fit
n_centers = size(centers,1);        % loop index

% if there is only one state, there is nothing to cluster
if n_centers == 1
    all_data_fits = data_fit;
    return
end

% Store the result of clutering and IC for each iteration
all_data_fits = zeros(size(data,1),n_centers);

% Merge all possible k and k+1 clusters. Evaluate with Ward's distance
while n_centers > 0
    if n_centers == length(centers) % iter 1
        all_data_fits(:,n_centers) = data_fit;
    else
        % Find the mean values and state data_fit of the data
        % [Centers, ~, assignment of centers]
        [centers,~,class] = unique(all_data_fits(:,n_centers+1));
        % number of data points per cluster
        N = accumarray(class,1);
        
        % store copy of previous iteration. Clusters to be merged will be
        % replaced in this iteration
        all_data_fits(:,n_centers) = all_data_fits(:,n_centers+1);
        
        % Compute Ward's distance between each center
        % calculate new means with each iteration to save computation
        % later
        ward_dist = zeros(n_centers,1);
        new_mu = zeros(n_centers,1);
        for n = 1:n_centers
            ward_dist(n) = ((2*N(n)*N(n+1) / (N(n)+N(n+1)))^0.5) * (centers(n)-centers(n+1))^2;
            new_mu(n) = (N(n) * centers(n) + N(n+1) * centers(n+1)) / (N(n) + N(n+1)); 
        end
        
        % Merge clusters with minimal Ward's distance
        [~,min_ward_dist] = min(ward_dist);
        
        % Find data points from each of the two clusters that are going to
        % be merged
        merge_index = find(all_data_fits(:,n_centers) == centers(min_ward_dist) | all_data_fits(:,n_centers) == centers(min_ward_dist+1));
        
        % store new mean value from merge into the locations of the 2
        % clusters that were merged
        all_data_fits(merge_index,n_centers) = new_mu(min_ward_dist); 
    end
    
    % Iterate
    n_centers = n_centers - 1;
    
end



