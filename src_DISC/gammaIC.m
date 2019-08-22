function ic_value = gammaIC(data, data_fit, information_criterion)
%% Compute AIC, BIC, or HQC from Gamma Mixture Model 
% Author: David S. White
% Contact dwhite7@wisc.edu
%
% Updates:
% --------
% 2019-07-02 DSW wrote code 
%
% -------------------------------------------------------------------------
% Overview:
% -------------
% Compute a variety of information criterions using gaussian likelihood. 
%
%   Akaike Information Criterion
%       AIC = -2*ln(L) + 2k 
%
%   Baysesian Information Criterion 
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
% run gammaIC
%
% Check arguments: sequence or components
ic_value = []; % make sure there is an output 
if ~exist('data','var'); 
    disp('Error in gmmIC: Need Data to Analyze'); 
    return; 
end
if ~exist('information_criterion','var') || isempty(information_criterion);
    disp('Error in gmmIC: Need an information criterion'); 
    return; 
end

n_data = length(data);     

% Compute Likelihood of gaussian fit of data with components
% P = probability
states = unique(data_fit); 
n_states = length(states); 
gauss_comps = computeCenters(data,data_fit); 
weights = gauss_comps(:,1); 

P = zeros(n_data,n_states); 
for n = 1:n_states
    [phat] = gamfit(data(data_fit==states(n))); 
    P(:,n) = weights(n) * gampdf(data, phat(1),phat(2)); 
end
P = sum(P,2);
P = P(find(P ~= 0));            % avoid taking log of zero
loglikelihood = sum(log(P));    

degrees_of_freedom = 3 * n_states - 1; 
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
