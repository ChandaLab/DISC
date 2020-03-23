function simulation = smSimulateBinding(duration_s, dt_s, n_sites, SNR, Q, ...
    Emission_states, Intensities, Intensity_Variation)
%% Simulate Single Molecule Binding Time Series data from a Kinetic Matrix
% Author: David S. White
% contact: dwhite7@wisc.edu
%
% Updates:
% --------
% 2018-09-24 DSW Wrote the code
% 2019-02-07 DSW added comments and changed variable names for readability
%
%--------------------------------------------------------------------------
% Overview:
% ---------
% simulationulate a single-molecule binding trajectory from a provided kinetic
% matrix (Q) and other parmaters. 
%
%
% Input Variables:
% ----------------
% duration_s = trajectory length in seconds to simulationulate. 
%
% dts_s = frame rate for simulationulation in seconds. 
%
% nSitea = number of binding sites available for the provided kinetics 
%   (binding sites are independent of one another)
%
% SNR = signal to noise ratio for the simulationulation, computed as:
%   (bound_intensity - unbound_intensity) / std(unbound)
%
% Q = kinetic matrix. For example, if kon = 0.01 & koff = 0.05, 
%   Q = [0, 0.01; 0.05, 0]; 
%
% Emission_states = state assignment (ie 1,2,3 etc...) for each of the
%   states in Q
%
% Intensities = intensity values for each unique emissive state 
%
% Intensity_Variation = distribution to determine how binding events vary in
%   observed intensity per event. 
%
% Output Variables:
% ----------------
% simulation = structure with simulationulation results. 
%   simulation.time_series = [n_data_points,1] observed sequence (Gaussian noise)
%   simulation.Q = input kinetics used in the simulationulation for reference
%   simulation.state_seq = [n_data_points,1] assignment of states (ie 1,2,3...)
%   simulation.ideal_seq = state_seq with assigned intensity values
%   simulation.ideal_seq_var = ideal_seq with the added intensity variations 
%   simulation.true_components = [weight,mean,sd] of each state after noise additon
%   simulation.n_states = total number of states observed in the simulationulation. 
%   simulation.SNR = computed SNR after the addition of noise;
%
% Note: 
% -----
% Q Matrix used adapted from code written by Dr. Marcel P. Golschen-Ohm 
% (https://github.com/marcel-goldschen-ohm)

%--------------------------------------------------------------------------

% Run simulationulation 

% duration in seconds to durations in frames
duration_f = round(duration_s / dt_s); % duration in frames

% simulationulate state sequence
N = size(Q,1);
simulation.Q = Q;                   % store before modifying
Q = Q - diag(sum(Q,2));             % unitary
S = [Q ones(N,1)];
u = ones(1,N);
p0 = u*inv(S*(S'));                 % equilibrium state probabilities

% exponential distribution
A = ones(N,N) - exp(-Q.*dt_s);      % frames to seconds conversion
for j = 1:N
    A(j,j) = 0;
    A(j,j) = 1 - sum(A(j,:));
end
state_seq = zeros(duration_f,1);
for n= 1:n_sites
    state = [];
    while isempty(state)
        randTransitionProbs = rand(duration_f,1);
        state = find(cumsum(p0) >= randTransitionProbs(1),1);
    end
    state_seq(1,n) = Emission_states(state);
    for k = 2:duration_f
        state = find(cumsum(A(state,:)) >= randTransitionProbs(k),1);
        state_seq(k,n) = Emission_states(state);
    end
end
state_seq = sum(state_seq,2);
if min(state_seq) ~= 1
    state_seq = state_seq - min(state_seq) + 1;  % sate(1) == 1
end

% calculate Events
states = unique(state_seq);
n_states = length(states);
events = findEvents(state_seq,1);

same_value = 1;
intensites = checkVariable(Intensities,n_states,same_value); % bound and unbound
SNR = checkVariable(SNR,1);

ideal_seq = zeros(duration_f,1);
ideal_seq_var = zeros(duration_f,1);
time_series =  zeros(duration_f,1);

% signal to noise ratio
intensites_mu = mean(intensites(2:end));
sigma = [];
sigma(1) = intensites_mu / SNR;
sigma(2) = sigma(1);

for n = 1:size(events,1);
    event_start = events(n,1);
    event_stop = events(n,2);
    EventState = events(n,4);
    
    % Add ideal_seq
    ideal_seq(event_start:event_stop) = sum(intensites(1:EventState));
    
    % Add ideal_seq_var & time_series
    event_dur = event_stop-event_start;
    event_seq = zeros(event_dur,1);
    itensity_var = 1;
    for k = 1:EventState
        if k > 1 % if k > 0, add var in baseline too
            if ~isempty(Intensity_Variation)
                modulation = random(Intensity_Variation,1) / 100;
                % since values are curently absolute values from an exp dist
                if rand(1) < 0.5;
                    modulation = modulation * -1;
                end
            else
                modulation = 0;
            end
            current_intensity_var = (intensites(k) * modulation +  intensites(k));
            itensity_var = itensity_var + current_intensity_var;
        else
            % keep the baseline stable for simplicity
            itensity_var = (intensites(k));
        end
        
    end
    ideal_seq_var(event_start:event_stop) = itensity_var;
end

% Add noise
intensites = unique(ideal_seq);
sigma = (intensites(1)) / SNR;
time_series = normrnd(ideal_seq_var, sigma);

% create components
[components,ideal_seq] = computeCenters(time_series,state_seq);
[~,ideal_seq_var] = computeCenters(time_series,ideal_seq_var);

% Store output output in the simulationulation structure
simulation.time_series = time_series;
simulation.state_seq = state_seq;
simulation.ideal_seq = ideal_seq;
simulation.ideal_seq_var = ideal_seq_var;
simulation.true_snr = SNR; 
simulation.true_components = components;
simulation.n_states = length(states);

end
%% check value
% check the input value type to decide if distribution, matrix, or single
% value

% X = variable to check
% n = how many values to return

function output = checkVariable(X,N,same_value)

varType = class(X);
if varType(1:4) == 'prob'
    % came from some distribution
    if same_value
        output = zeros(N,1) + random(X,1,1); 
    else
    output = random(X,N,1);
    end
else
    output = X;
end

end

