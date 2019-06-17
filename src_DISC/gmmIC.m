function ic_value = gmmIC(data, data_fit, information_criterion)
%% Compute AIC, BIC, or HQC from guassian mixture model 
% Author: David S. White
% Contact dwhite7@wisc.edu
%
% Updates:
% --------
% 2019-03-20 DSW wrote code 
%
% -------------------------------------------------------------------------
% Overview:
% -------------
% Compute a variety of information criterions using gaussian likelihood. 
%
%   Akaike Information Criterion
%       AIC = -2*ln(L) + 2k 
%
%   Bayesian Information Criterion
%       BIC = -2*ln(L) + k * ln(N)
%
%   Hannan-Quinn Information Criterion
%       HQC = -2*ln(L) + 2k*ln(ln(N))
%
%   where: 
%       L = likelihood, k = free parameters, N = number of observations
%
%
% Input Variables:
% ----------------
% data = data to cluster. data is a 1D time series
%
% data_fit = assigment of data into N labels (i.e. ideal sequence) 
%   or [K,3] components array where K is the number of unique states. 
%   (1,:) = weight, mu, sigma of the gaussian
%
% information_criterion = string; Information criterion for determing 
%   penalty. 'AIC','BIC','HQC'
%   
%           
% Output Variables: 
% ----------------
% ic_value = AIC, BIC, or HQC value computed for the gaussian components
%
%
% Note: this script replaces individual scripts 'AIC_GMM.m', 'BIC_GMM.m',
% and 'HQC_GMM.m'
% -------------------------------------------------------------------------
%
% run gmmIC
%
% Check arguments: sequence or components
ic_value = []; % make sure there is an output 
if ~exist('data','var')
    disp('Error in gmmIC: Need Data to Analyze'); 
    return
end
if ~exist('information_criterion','var') || isempty(information_criterion)
    disp('Error in gmmIC: Need an information criterion'); 
    return
end

n_data = length(data);     
[n_rows,n_columns] = size(data_fit); 
if n_data == n_rows && n_columns == 1
    % must have a provided idealized sequence. Compute Components 
    [components] = computeCenters(data,data_fit); 
elseif n_data ~= n_rows && n_columns == 3
    % must have provided matrix of gaussian components
    components = data_fit; 
else
    % too complicated. return error
    disp('Error in gmmIC: Uncertain what data_fit is provided.')
    return
end
 
% Compute Likelihood of gaussian fit of data with components
% P = probability
n_components = size(components,1); 
P = zeros(n_data,n_components); 
for i = 1:n_components
    % or normpdf
    P(:,i) = components(i,1) * exp(-0.5 * ...
        ((data - components(i,2))./components(i,3)).^2) ./ (sqrt(2*pi) .* components(i,3));
end
P = sum(P,2);
P = P(P ~= 0);            % avoid taking log of zero
loglikelihood = sum(log(P));    

degrees_of_freedom = 3 * n_components - 1; 
% 3 for [weight mu sigma] each with -1 since sum(weights) = 1; 

% now lets add penalty from the provided information criterion
switch information_criterion
    case 'AIC'
        penalty = 2;
    case 'BIC'
        penalty = log(n_data);
    case 'HQC'
        penalty = 2*log(log(n_data));
end

% compute ic_value 
ic_value =  -2 * loglikelihood + degrees_of_freedom * penalty; 


end
