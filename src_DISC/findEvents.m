function [Events] = findEvents(data_fit, event_start);
%% Find Events and Dwell Times
% David S. White
% dwhite7@wisc.edu
%
% Updates:
% --------
% 2018-08-22 DSW wrote the code in this version, not sure when original
% code was written. Added in computing dwell times for convience
% 2018-10-01 DSW added event_start rate as optional variable
% 2019-02-12 Edited a bug that shortened all dwell times by 1, resulting in
% dwells of 0
%
% Input Variables:
% ----------------
% data_fit = data_fit with labels either as states (1,2,3,etc...) or
%       intensity values 
%
% Output Variables:
% ----------------
% Events = matrix of [event_start, Stop, event_duration, state, state_label] 
%
% -------------------------------------------------------------------------
%
% Init
Events = [];
states = unique(data_fit);
n_states = length(states);
duration = length(data_fit);

% is there more than one state?
if n_states == 1
    Events = [1, duration, duration, states];
    return
end

% find Events
event_start = 1; % event_start 
while event_start < duration
    current_state = data_fit(event_start);
    remaining = find(data_fit(event_start:end) ~= current_state);
    if ~isempty(remaining)
        event_stop = remaining(1) + event_start -2;
    else
        event_stop = length(data_fit);
    end
    event_duration = event_stop - event_start + 1; 
    Events = [Events; event_start, event_stop, event_duration, current_state];
    event_start = event_stop + 1;
end
% stop
Events(end,2) = length(data_fit);


end


