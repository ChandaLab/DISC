function emissions_matrix = computeEM(data,components)
%% Computes a Emission Probability Matrix for data from gaussian components
% David S. White
% dwhite7@wisc.edu
%
% Updates:
% --------
% 2018-02-20    DSW     version 1.0
%
%--------------------------------------------------------------------------
% Notation:
% ---------
% N = number of observations in data; length(data)
% K = number of states in components; size(components,1) 
%
% Input Variables:
% ----------------
% data = [N,1]; raw data to be analyzed
% 
% components = [K,3] , [weight, mu, sigma] of each of the state 
%
% Output Variables:
% ----------------
% emissions_matrix = Emission probability matrix of [K x N] probabilites of 
%   data(i) belonging to each gaussian component

% Check input variables 

% Check data
if ~exist('data','var') || isempty(data);
    disp('Error in computeEM: No data provided.');
    return;
end

% Check components
if ~exist('components','var') || isempty(components);
    disp('Error in computeEM: No components provided.');
    return;
end

% intialize 
n_data_points = length(data); 
n_states = size(components,1);
emissions_matrix = zeros(n_states, n_data_points);

% compute emissions_matrix
for k = 1:n_states
    mu = components(k,2);     % mean of the state
    std = components(k,3);    % standard deviation of the state
    % evalue all data points for the gaussian components of each state (normpdf)
    emissions_matrix(k,:) = exp(-0.5 * ((data-mu)./std).^2) ./ (sqrt(2*pi) .* std);
end
% nomralize to sum to 1 per data point across each state
emissions_matrix = emissions_matrix./ sum(emissions_matrix); 

