function BIC = BIC_RSS(data,data_fit)
%% Compute BIC from Cluster Assigments using RSS and n_change_points 
% David S. White
% dwhite7@wisc.edu
%
% Updates:
% 2018-06-07 DSW wrote code 
% 2018-08-09 DSW rewrote code to make more comprehensive. Comments added. 
%
% -------------------------------------------------------------------------
% Overview: 
% ---------
% Compute BIC from residual sum of squares fit where penalty scales with
% number of changePoints in the sequence. Least Absolute Devitations
% Regresssion (L1) is used rather than Least Squares Regression (L2), as it
% is more robust. 
%
% Input Variables:
% ----------------
% data = data to cluster. data is a 1D time series
%
% data_fit = assigment of data_fit  into N labels descibed by cluster means
%
% sigmaNoise = estimated standard deviation of noise from a gaussian
%   distribution. See "estimateNoise.m" for more information. 
%
% Output Variables:
% ----------------
% BIC = BIC value computed for the cluster assignment

%% Compute BIC_RSS
% initalize and check variables
if ~exist('data','var')
    disp('Error in BIC_RSS: Need Data to Analyze');
    return;
end
if ~exist('data_fit','var') || isempty(data_fit)
    data_fit = ones(length(data),1);
end
if length(data) ~= length(data_fit); disp('Error in BIC_RSS: Inputs must be the same length'); return; end

n_data_points = length(data);
n_change_points = length(find(diff(data_fit) ~= 0));
n_states = length(unique(data_fit));
if data == data_fit
    BIC = (n_change_points + n_states) * log(n_data_points);
else
    BIC = n_data_points * log(sum((data-data_fit).^2)/ n_data_points) +...
        (n_change_points + n_states) * log(n_data_points);
end

