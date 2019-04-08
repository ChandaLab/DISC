function [MDL] = MDL(data,data_fit)
%% MDL rewrite 
% David S. White
% dwhite7@wisc.edu

% the following is adapted from Shuang et al., 2014 J Phys Chem Letters 
% Overall, 
% MDL = fit + complexity (F +G)

% 0. Compute necessary variables: 
% -------------------------------

% Estimate standard deviation of Gaussian noise
sorted_wavelet = sort(abs( diff(data) / 1.4));
sd = sorted_wavelet(round(0.682 * numel(sorted_wavelet)));

n_data_points = length(data); 
states = unique(data_fit); 
n_states = length(states); 

% % find Events and Dwell Times
[events,dwell_times] = findEvents(data_fit); 

% total time per state
state_time = zeros(1,n_states); 
% total time in each state 
for k  = 1:n_states
    state_time(k) = sum(dwell_times{k});
end
% transition values ^2
transitons = (states(events(1:end-1,3)) - states(events(2:end,3))).^2;
lnDET = sum(log([state_time,transitons'/sd^2])); 


% 1. Compute F: 
% ------------
F = n_data_points*log(sd*sqrt(2*pi)) + 1/2/sd*sum(abs(data-data_fit));

% 2. Compute G:
% -------------
G = n_states/2*log(1/2/pi) + n_states*log((max(data)-min(data))/sd) + (length(transitons))/2*log(n_data_points) + 0.5*lnDET;% the cost of the model

% 3. Compute MDL: 
% ------------
MDL = F+G;

end






