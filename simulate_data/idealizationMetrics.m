function [Accuracy, Precision, Recall] = idealizationMetrics...
    (data, data_fit,true_fit, method, state_threshold,event_threshold)

%% compute idealization Accuracy, Precision and Recall 
% Author: David S. White 
% Contact: dwhite7@wisc.edu 
%
% Updates:
% --------
% 2019-03-21 DSW wrote code (old version = modelQuantification.m)
%
% -------------------------------------------------------------------------
% Requirements: 
% -------------
% requires computeCenters.m and findEvents.m (found in DISC)
%
%
% Overview: 
% ---------
% Determine how well the data_fit (i.e idealized trace) matches
% the true_fit of simulated data. This is done by identifying: 
%
%   TP = True Positive
%       states : true state == obtained state within state_threshold
%       events : true event == obtained event ± 1 event_threshold
%       overall: both obtained event and obtained state are TP. 
%
%   FP = False Positive
%       states : extra state obtained  or 
%               obtained state ? true state but within state_threshold
%       events : extra event obtained or 
%               obtained event ? true event ± event_threshold
%       overall: either obtained event and/or state is a FP
%
%   FN = False Negative
%       states : obtained states < true states
%       events : missed event 
%       overall: either obtained event and/or state is a FN
%
% From these values, we compute: 
%
%   Accuracy = sum(TP) / (sum(TP) + sum(FP) + sum(FN))
%
%   Precision = sum(TP) / (sum(TP) + sum(FP))
%
%   Recall = sum(TP) / (sum(TP) + sum(FN))
%
%
% Input Variables: 
% ----------------
% data = [N,1] data sequence
% 
% data_fit = [N,1] obtained sequence of state assignments
%
% true_fit = [N,1] sequence of true state assignments
%
% method = string. What values to compare. Either: 
%       'states', 'events', 'overall' [Default], 'classification'
%
% state_threshold = ± of true value s.d.  for TP determination. 
%       [Default = ± 10% of true value standard deviation]
%
% event_threshold = ± true event duration for TP determination. [Default = 1]
%
% Output Variables: 
% ----------------
% 
% Accuracy = sum(TP) / (sum(TP) + sum(FP) + sum(FN))
%
% Precision = sum(TP) / (sum(TP) + sum(FP))
%
% Recall = sum(TP) / (sum(TP) + sum(FN))
%
% -------------------------------------------------------------------------
%
% run idealizationMetrics
%
% Set default values if not provided 
if ~exist('method','var') | isempty(method)
    method = 'overall'
end
if ~exist('state_threshold','var') | isempty(state_threshold)
    state_threshold = 0.1; 
end
if ~exist('event_threshold','var') | isempty(event_threshold)
    event_threshold = 1; 
end

% Compute TPs, FPs, and FNs for given method 
TP = 0; 
FP = 0; 
FN = 0; 
switch method
    
    case 'states'
        % compute components 
        obtained_components = computeCenters(data,data_fit); 
        true_components = computeCenters(data,true_fit); 
        
        t = 1;  % iterate true values
        o = 1;  % iterate obtained values 
        
        while t <= size(true_components,1) &  o <= size(obtained_components,1)
            
            % Is the obtained state value within the state_threshold of the
            % true value? 
            %state_check =  abs(true_components(t,2) - obtained_components(o,2))...
            %    <= (state_threshold * true_components(t,3));
             state_check =  abs(true_components(t,2) - obtained_components(o,2))...
                <= (1);
            
            if state_check
                TP = TP + 1;
                o = o + 1;
                t = t + 1;
            else
                if size(obtained_components,1) == size(true_components,1)
                    FP = FP + 1;
                    o = o + 1;
                    t = t + 1;
                elseif obtained_components(o,2) > true_components(t,2)
                    t = t + 1;
                elseif obtained_components(o,2) < true_components(t,2)
                    FP = FP + 1;
                    o = o + 1;
                end
            end
        end
        if size(true_components,1) > size(obtained_components,1)
            FN = size(true_components,1) - size(obtained_components,1);
        end
        
     case 'events'
        true_events = findEvents(true_fit);
        obtained_events = findEvents(data_fit);
        t = 1;
        o = 1;
        while t <= size(true_events,1) &  o <= size(obtained_events,1)
            t_event = true_events(t,:); % current true event
            o_event = obtained_events(o,:); % current obtained event
            if  abs(t_event(1)-o_event(1)) + abs(t_event(2)-o_event(2)) <= event_threshold
                TP = TP + 1;
                t = t + 1;
                o = o + 1;
            else
                if t_event(2) == o_event(2)
                    FP = FP + 1;
                    FN = FN +1;
                    o = o + 1;
                    t = t + 1;
                elseif t_event(2) > o_event(2)
                    FP = FP + 1;
                    o = o + 1;
                elseif t_event(2) < o_event(2)
                    FN = FN + 1;
                    t = t + 1 ;
                end
            end
        end
        
        
    case 'overall'
        
        % components for state values 
        obtained_components = computeCenters(data,data_fit);
        true_components = computeCenters(data,true_fit);
        
        % events
        true_events = findEvents(true_fit);
        obtained_events = findEvents(data_fit);
        
        t = 1;  % iterate true values
        o = 1;  % iterate obtained values 
        while t <= size(true_events,1) &  o <= size(obtained_events,1)
            t_event = true_events(t,:); % current true event
            o_event = obtained_events(o,:); % current obtained event
            if  abs(t_event(1)-o_event(1)) + abs(t_event(2)-o_event(2)) <= event_threshold &...
                    abs(obtained_components(o_event(4),2) - true_components(t_event(4),2)) <= state_threshold * true_components(t_event(4),3)
                TP = TP + 1;
                t = t + 1;
                o = o + 1;
                % correct event, state mismatch
            elseif abs(t_event(1)-o_event(1)) + abs(t_event(2)-o_event(2)) <= 1 &...
                    abs(obtained_components(o_event(4),2) - true_components(t_event(4),2)) > state_threshold * true_components(t_event(4),3);
                FP = FP + 1;
                % FN = FN + 1;
                o = o + 1;
                t = t + 1;
                
            elseif t_event(2) == o_event(2)
                FP = FP + 1;
                FN = FN +1;
                o = o + 1;
                t = t + 1;
                
            elseif t_event(2) > o_event(2)
                FP = FP + 1;
                o = o + 1;
                
            elseif t_event(2) < o_event(2)
                FN = FN + 1;
                t = t + 1 ;
                
            end
        end
        
    case 'classification'
        % the simpliest metric to compute, not the most useful 
        % Are data points in the right clusters? 
        % this does not a robust metric since it does not consider whether
        % the states are the right values or if events (i.e dynamics) are
        % correct.
        
        % make interger assignmetns into states
        [~,~,obtained_assignment] = unique(data_fit); 
        [~,~,true_assignment] = unique(true_fit); 
        
        assignment_difference = true_assignment-obtained_assignment; 
        TP = length(find(assignment_difference == 0));
        FN = length(find(assignment_difference > 0));
        FP = length(find(assignment_difference < 0));
          
end


% Compute Accuracy, Precision, and Recall 
Accuracy = TP / (TP + FP + FN);  
Precision = TP / (TP + FP);  
Recall = TP / (TP + FN);  
% check for nan
if isnan(Accuracy)
    Accuracy = 0;
end
if isnan(Precision)
    Precision = 0;
end

if isnan(Recall)
    Recall = 0;
end



if isnan(Accuracy) | isnan(Precision) | isnan(Recall)
    disp('wtf')
end
end

