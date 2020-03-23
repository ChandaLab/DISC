function simulation = simulateBinding(duration_s, frame_rate_hz, Q, emission_states,...
    observed_states, signal_to_noise, observed_variation, n_sites)
%% Single Molecule Time Series Simulation
% Author: David S. White
% contact: dwhite7@wisc.edu
%
% Updates:
% --------
% 2018-09-24    DSW    Wrote the code
% 2019-02-07    DSW    added comments and changed variable names for readability
% 2019-10-29    DSW    wrote the code. modified from smSimulateBinding.m
%--------------------------------------------------------------------------
% Overview:
% ---------
% simulationulate a single-molecule binding trajectory from a provided kinetic
% matrix (Q) and other parmaters.
%
% Input Variables:
% ----------------
% duration_s = trajectory length in seconds to simulate.
% frame_rate_hz = frame rate for simulation in hz.
% Q = kinetic matrix. For example, if kon = 0.01 & koff = 0.05,
%       Q = [0, 0.01; 0.05, 0];
% emission_states = state assignment (ie 1,2,3 etc...) for each of the
%       states in Q
% observed_states = intensity values for each unique emissive state.
%       Can be a distribution or matrix.
% singal_to_noise = signal to noise ratio for the simulationulation.
%       computed as: (bound_intensity - unbound_intensity) / std(unbound)
%       Can be a double or a distribution.
% observed_variation = distribution to determine how binding events vary in
%   observed intensity per event.
%
% n_sites = number of binding sites available for the provided kinetics.
%   (binding sites are independent of one another).
%
% Output Variables:
% ----------------
% simulation = structure with simulationulation results.
%   simulation.time_series = [n_data_points,1] observed sequence (Gaussian noise)
%   simulation.Q = input kinetics used in the simulationulation for reference
%   simulation.state_seq = [n_data_points,1] assignment of states (ie 1,2,3...)
%   simulation.ideal_seq = state_seq with assigned intensity values
%   simulation.ideal_seq_var = ideal_seq with the added intensity variations
%   simulation.components = [weight,mean,sd] of each state after noise additon
%   simulation.snr = computed SNR after the addition of noise;

% -------------------------------------------------------------------------

% check emission_states [first state needs to be zero for summing with n_sites]
min_emission_state = min(emission_states);
if min_emission_state ~= 0
    emission_states = emission_states - min_emission_state;
end

% Simuate Kinetics without added noise
state_sequence = zeros(duration_s * frame_rate_hz,n_sites);
for n = 1:n_sites
    state_sequence(:,n) = simulateQ(Q, emission_states, duration_s, frame_rate_hz);
end
states = unique(emission_states);
n_states = length(states);

% Add observed_values to the state sequence
% check if intensites came from a distribution or not
if isa(observed_states, 'double')
    intensities = observed_states;
    % check length
    if length(intensities) < n_states
        mean_state = mean(diff(intensities));
        while length(intensities) < n_states
            intensities = [intensities; intensities(end) + mean_state];
        end
    end
else
    % value is a distribution
    intensities = cumsum(random(observed_states, n_states,1));
end
% create intensity sequence
intensity_sequence = state_sequence;
for n = 1:n_sites
    for i = 1:n_states
        idx = find(state_sequence(:,n) == states(i));
        intensity_sequence(idx,n) = intensities(i);
    end
    % add bound variations
    if exist('observed_variation','var')
        intensity_sequence(:,n) = simulateVariation(intensity_sequence(:,n), observed_variation);
    end
end
% sum across n_sites
state_sequence = sum(state_sequence,2) +1; % state(1) = 1;  
intensity_sequence = sum(intensity_sequence,2) - (intensities(1)*(n_sites-1)); % subtrack extra background

% add gaussian noise to match provided signal to noise. Uniform sigma
if isa(signal_to_noise,'double')
    snr = signal_to_noise;
else
    snr = random(signal_to_noise,1,1);
end
sigma_noise = mean(diff(intensities)) / snr;
observed_sequence = normrnd(intensity_sequence,sigma_noise);

% compute components, ideal_sequence
[components,ideal_sequence]= computeCenters(observed_sequence, state_sequence);

% output structure
simulation.time_series = observed_sequence;
simulation.state_seq = state_sequence;
simulation.ideal_seq = ideal_sequence;
simulation.ideal_seq_var = intensity_sequence;
simulation.components = components;
simulation.snr = snr;
simulation.kinetics = Q; 

end