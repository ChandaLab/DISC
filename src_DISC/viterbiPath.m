function [path,log_likelihood] = viterbiPath(weights, transitions_matrix, emissions_matrix)
%% Viterbi Path
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
% The Viterbi algorithm aims to find the viterbi_path, which is the most 
% probable sequence of states in the data, espeically in the context of 
% hidden Markov models.
%
% Notations: 
% ----------
% N = number of data points in the data 
% 
% K = number of states in the fit 
%
% Input Variables:
% ----------------
% weights = overall probability a state appears in the time series.
%   [K,1], where K == number of states. sum(weights) = 1; 
%`  > see computeCenters.m
% 
% emissions_matrix = [K,N] where K = number of states and N = length of
%   data used to generate the emissions_matrix. Each [:,Ni] is the 
%   probability that the given data point Ni came from each state. Therefore, 
%   sum(emissions_matrix(:,Ni)) = 1; 
%`  > see computeEM.m
%
% transitions_matrix = [K,K] where K = number of states. For each [i,j] is
%   the probability of Ki transitioning to Kj. Rows and Columns sum to 1.
%`  > see computeTM.m
%
% Output Variables:
% -----------------
% path = [1,N] assignment of each data point to state described by
%   integers 1:K
%
% log_likelihood = log likelihood of the path 
%
% Notes:
% ------
% This code is adapted from PMTK authors Kevin Murphy
% See https://github.com/probml/pmtk3
%
% MIT License Copyright (2010) Kevin Murphy and Matt Dunham
%
% DSW modified the code to make it accesible in the DISC package
% i.e. renamed variables, added comments, removed normalize function 

[K,N] = size(emissions_matrix);  % number of states & data points

delta = zeros(K,N);  % probability of data point belonging to each state        
psi = zeros(K,N);    % State assignment of each data point per state
scale = zeros(1,N);  % 1 / total probabilities of all states

% Initalization: Determine the most likely state of data point 1      
delta(:,1) = weights .* emissions_matrix(:,1);
scale(1) = 1/sum(delta(:,1));
delta(:,1) = delta(:,1) / sum(delta(:,1)); % normalize values to sum to 1
psi(:,1) = 0;   % arbitrary value, since there is no predecessor to n=1

% Forward Loop for data point 2 to end: 
for n = 2:N % For each data point 
    for k = 1:K % For each state
        [delta(k,n), psi(k,n)] = max(delta(:,n-1) .* transitions_matrix(:,k));
        delta(k,n) = delta(k,n) * emissions_matrix(k,n);
    end
    scale(n) = 1/sum(delta(:,n)); 
    delta(:,n) = delta(:,n) / sum(delta(:,n));  % normalize
end

% Find Most probable state path
path = zeros(1,N);   
% loop backwards from data points N-1 to end  
[p, path(N)] = max(delta(:,N)); % Last data point 
for n = N-1:-1:1
    path(n) = psi(path(n+1),n+1);
end
log_likelihood = -sum(log(scale)); 

end

