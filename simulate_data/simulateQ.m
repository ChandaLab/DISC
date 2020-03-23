function [state_sequence,p0] = simulateQ(Q, emission_states, duration_s, frame_rate_hz)
%% Simulate stateSequence from provided Q matrix.
% David S. White
% dwhite7@wisc.edu
%
% Updates:
% --------
% 2019-07-03    DSW wrote the code
%
% Overview:
% ---------
% Generates a state_sequence over duration_s discretized to frame_rate_hz
%   from the provided Q matrix and with assignments to emission_states
%
% Input Variables
% ---------------
% Q = [k,k] matrix where k is the total number of simulated states
%   and Q(i,j) is the transitionrate from state i to state j
%
% emission_states = emissive assignments for each state in Q.
%
% duration_s = total time (s) of data points to simulate
%
% frame_rate_hz = frame rate to discretize to
%
% Output variables:
% -----------------
% stateSequence = column vector of [n_data_points,1] simulation from Q matrix.
%
% p0 = probability of observing each state
%
% Notes:
% ------
% Adaption of the Q matrix for trajecotry simulation was initally written
%   by Dr. Marcel P. Goldschen-Ohm and follows Single Channel Recording
%   Handbook Chapter 21
%
% -------------------------------------------------------------------------

% --------------------------
% Initialize the Simulation:
% --------------------------

% number of states;
K = size(Q,1);

% unitary
Q = Q-diag(sum(Q,2));
S = [Q ones(K,1)];

% equilibrium state probabilities
p0 = ones(1,K)/(S*(S'));

% Simulate a State Sequence if parameters are provided
if ~exist('emission_states','var') &  ~exist('duration_s','var') & ~exist('frame_rate_hz','var')
    state_sequence = [];
else
    % Discretize to frames from seconds
    A = ones(K,K) - exp(-Q./frame_rate_hz);
    
    % remove transitions from self to self and normalize
    for j = 1:K
        A(j,j) = 0;
        A(j,j) = 1-sum(A(j,:));
    end
    
    % Simulate a State Sequence if parameters are provided
    state_sequence = [];
    % total data points in frames
    duration_f = duration_s * frame_rate_hz;
    
    % empty stateSequence
    state_sequence = zeros(duration_f,1);
    
    % -------------------
    % Run the Simulation:
    % -------------------
    
    % initial state
    state = [];
    while isempty(state)
        rand_transition_probs = rand(duration_f,1);
        state = find(cumsum(p0) >= rand_transition_probs(1),1);
    end
    state_sequence(1) = emission_states(state);
    
    % finish simulation
    for k = 2:duration_f
        state = find(cumsum(A(state,:)) >= rand_transition_probs(k),1);
        state_sequence(k) = emission_states(state);
    end
    
end