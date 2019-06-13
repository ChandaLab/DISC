function [metrics,n_states] = computeIC(data, all_data_fits, information_criterion, normalize)
%% Compute model Information Criteria with a variety of options
% David S. White
% dwhite7@wisc.edu
%
% Updates:
% ---------
% 2019-02-20    DSW version 1.0
% 2019-03-20    DSW Updated to include simplifed script gmmIC
%
% -------------------------------------------------------------------------
% Overview:
% ----------
% This function serves as a wrapper for running a variety of statistical
% information criterions/ objective functions for determining how well a 
% given model fits the data. If more than one models are provided, 
% the best fit of the the provided models is also returned. 
%
% Notes:
% ------
% This is meant to be a living function such that any new metrics you would
% want to use can be easily written as a seperate function and added here.
% While BIC works well for binding data, other information criterias
% likely work better/ worse for different data sets.
%
% Each information cirtieria is coded as a seperate function for simplicity
%
% Input Variables:
% ----------------
% data = [N,1]; raw data. 
%
% all_data_fits = All potential number of states grouped
%   iteratively by aggCluster.m. [N,K] where [N,1] = 1 states, [N,2] = 2
%   states, etc..
%
% information_criterion = which information criteria to use. Determines
%   what is the best fit of the data. 
%   * Default, BIC_GMM.m
%
% normalize = if normalize, metrics values are scaled between 0 and 1
%
% Output Variables:
% -----------------
% metrics = computed values for each of allSequences for IC used
%
% n_states = integer of best metrics. therefore, allSequences(:,K) is the 
%   fit of the provided options

%% Run computeIC
% Check data
if ~exist('data','var') || isempty(data)
    disp('Error in computeIC: No data provided.');
    return;
end
% check all_data_fits
if ~exist('all_data_fits','var') || isempty(all_data_fits)
    disp('Error in computeIC: No all_data_fits provided.');
    return;
end

% check information_criterion
if ~exist('information_criterion','var') || isempty(information_criterion)
    information_criterion = 'BIC_GMM';
end

% check normalize
if ~exist('normalize','var') || isempty(normalize)
    normalize = 1; 
end

% compute number of clusters
n_sequences = size(all_data_fits,2);

% intitalize output 
metrics = zeros(n_sequences,1);

% Run chosen information_criterion on all_data_fits
% feel free to code in any other options that suits your needs
for k = 1:n_sequences
    
    switch information_criterion
        case {'BIC-GMM','BIC_GMM'}
            metric_type = 'min';
            metrics(k) = gmmIC(data,all_data_fits(:,k),'BIC');
            
        case {'BIC-RSS','BIC_RSS'}
            metric_type = 'min';
            metrics(k) = BIC_RSS(data,all_data_fits(:,k));
            
        case {'AIC_GMM','AIC-GMM'}
            metric_type = 'min';
            metrics(k) = gmmIC(data,all_data_fits(:,k),'AIC');
            
        case {'HQC_GMM','HQC-GMM'}
            metric_type = 'min';
            metrics(k) = gmmIC(data,all_data_fits(:,k),'HQC');
            
        case 'MDL'
            metric_type = 'min';
            metrics(k) = MDL(data,all_data_fits(:,k));
            
    end
end

% Determine what is the best value by the given metrics_type for ouput 
if n_sequences > 1
    % is the min or the max value the best for the information_criterion
    switch metric_type
        case 'min'
            [~,n_states] = min(metrics);
            
        case 'max'
            [~,n_states] = max(metrics);
    end
    % Normalize metric values between 0 and 1
    if normalize
        metrics = (metrics - min(metrics)) ./ (max(metrics) - min(metrics));
    end
else
    n_states = 1;
end

end