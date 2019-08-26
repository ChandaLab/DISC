function [all_events] = findEvents(data_fit, first_and_last)
%% Find Events and Dwell Times
% David S. White
% dwhite7@wisc.edu
%
% Updates:
% --------
% 2018-08-22 DSW wrote the code in this version, not sure when original
% code was written. Added in computing dwell times for convenience
% 2018-10-01 DSW added event_start rate as optional variable
% 2019-02-12 Edited a bug that shortened all dwell times by 1, resulting in
% dwells of 0
% 2019-08-26 DSW Full rewrite of the script to use array indexing rather
% than for loops. This makes the code orders of magnitude faster,
% especially for long data_fit. Changed "event_start" variable to
% "first_and_last" for comprehension. 
%
% Input Variables:
% ----------------
% data_fit = data_fit with labels either as states (1,2,3,etc...) or
%       intensity values 
%
% first_and_last = Boolean. Include or exclude first and last events. In
% dwell time analysis, first and last events must be excluded since the
% full event time was not observed. 

% Output Variables:
% ----------------
% all_events = [N by 4] matrix of events where N is the number of events
%   [event_start, event_stop, event_duration, state_label ; ...] 
%
% -------------------------------------------------------------------------
% 
% check for first_and_last. Default is not to include first and last events
if ~exist('first_and_last','var') | isempty(first_and_last)
    first_and_last = 0;
end

% grab all the state labels of "data_fit" as unique integers 
[~,~,state_sequence] = unique(data_fit); 

% Take the difference of the intergers. Values of 0 == no event. 
event_index = find(diff(state_sequence)~=0); 

% Allocate space for output variable. number_of_events by 4;
all_events = zeros(length(event_index)-1,4); 

% assign values into matrix with first and last events dropped. 

% event_start
all_events(:,1) = event_index(1:end-1)+1; 

% event_stop 
all_events(:,2) = event_index(2:end); 

% add in first and last event [optional]
if first_and_last
    first_event = [1,all_events(1,1)-1, 0 ,0]; 
    last_event  = [all_events(end,2)+1, length(state_sequence), 0, 0];
    % add to all_events
    all_events = [first_event; all_events; last_event]; 
end

% Find dwell time of each event
all_events(:,3) = all_events(:,2) - all_events(:,1)+1;

% find the state label of eaach event from "data_fit"
all_events(:,4) = data_fit(all_events(:,1));


end


