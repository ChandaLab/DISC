function [Accuracy,Precision,Recall] = runIdealizationMetrics(data,metric_option)
%% run Idealization Metrics Example
% Author: David S. White
% Contact: dwhite7@wisc.edu

% updated:
% 2019-05-07    DSW wrote the code
%
% Overview:
% ---------
% This is a wrapper for running idealization Metrics on a sample data set
% used in White et al., 2019

% note: data.rois.zproj == data.rois.times_series. zproj is the old format
% and time_series is the new format. DISCO handles them both

%% USER INPUT: Compute Accuracy values for the following metric options:
%   1. states detection only
%   2. event detection only
%   3. overall: state & event detection (recommended)
%   4. Classification

metric_option = 3; % see above (1-4)
state_threshold = 0.1;  % 10% difference in true state value
event_threshold = 1;    % 1 frame difference in true event

%% Run

% load idealized sample data (need DISC/sample_data in file path)
load('sample_data_idealized.mat');

n_rois = size(data.rois,1);

% initalize Accuracy, Precision, and Recall
Accuracy = zeros(n_rois,1);
Precision = zeros(n_rois,1);
Recall = zeros(n_rois,1);

% compute accuracy
for n = 1:n_rois

    switch metric_option
        
        % 1. state detection only
        case 1
            %             [Accuracy(n,1), Precision(n,1), Recall(n,1)] = idealizationMetrics...
            %                 (data.rois(n,1).time_series, data.rois(n,1).disc_fit.class,data.rois(n,1).state_seq,...
            %                 'states', state_threshold,event_threshold);
            
            [Accuracy(n,1), Precision(n,1), Recall(n,1)] = idealizationMetrics...
                (data.rois(n,1).time_series, data.rois(n,1).disc_fit.class,data.rois(n,2).state_seq,...
                'states', state_threshold,event_threshold);
            
            % 2. event detection ony
        case 2
            %             [Accuracy(n,1), Precision(n,1), Recall(n,1)] = idealizationMetrics...
            %                 (data.rois(n,1).time_series, data.rois(n,1).disc_fit.class,data.rois(n,1).state_seq,...
            %                 'events', state_threshold,event_threshold);
            
            [Accuracy(n,1), Precision(n,1), Recall(n,1)] = idealizationMetrics...
                (data.rois(n,1).time_series, data.rois(n,1).disc_fit.class,data.rois(n,2).state_seq,...
                'events', state_threshold,event_threshold);
            
            % 3. overall: state & event detection
        case 3
            %[Accuracy(n,1), Precision(n,1), Recall(n,1)] = idealizationMetrics...
            %    (data.rois(n,1).time_series, data.rois(n,1).disc_fit.class,data.rois(n,1).state_seq,...
            %    'overall', state_threshold,event_threshold);
            [Accuracy(n,1), Precision(n,1), Recall(n,1)] = idealizationMetrics...
                (data.rois(n,1).time_series, data.rois(n,1).disc_fit.class,data.rois(n,2).state_seq,...
                'overall', state_threshold,event_threshold);
            
            % 4. Classification
        case 4
            [Accuracy(n,1), Precision(n,1), Recall(n,1)] = idealizationMetrics...
                (data.rois(n,1).time_series, data.rois(n,1).disc_fit.class,data.rois(n,1).state_seq,...
                'classification', state_threshold,event_threshold);
            
    end
end

% Display results
disp(' ')
disp('>> DISC Results:')
disp(['Accuracy: ', num2str(round(mean(Accuracy),2)),' ± ', num2str(round(std(Accuracy),2))])
disp(['Precision: ', num2str(round(mean(Precision),2)),' ± ', num2str(round(std(Precision),2))])
disp(['Recall: ', num2str(round(mean(Recall),2)),' ± ', num2str(round(std(Recall),2))])
disp(' ')

end
