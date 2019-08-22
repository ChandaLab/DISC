function [Accuracy,Precision,Recall] = runIdealizationMetrics(data,metric_option)
%% run Idealization Metrics Example
% Author: David S. White
% Contact: dwhite7@wisc.edu

% updated:
% 2019-05-07    DSW wrote the code
% 2019-07-26    DSW updated to include computing over multiple channels
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

metric_option = 1; % see above (1-4)
state_threshold = 0.1;  % 10% difference in true state value
event_threshold = 1;    % 1 frame difference in true event

%% Run

% load idealized sample data (need DISC/sample_data in file path)
% load('sample_data_idealized.mat');

[n_rois,n_channels] = size(data.rois);
n_channels = 1; 
% initalize Accuracy, Precision, and Recall
Accuracy = zeros(n_rois,n_channels);
Precision = zeros(n_rois,n_channels);
Recall = zeros(n_rois,n_channels);

% compute accuracy
for c = 1:n_channels
for n = 1:n_rois

    switch metric_option
        
        % 1. state detection only
        case 1
            
            [Accuracy(n,c), Precision(n,c), Recall(n,c)] = idealizationMetrics...
                (data.rois(n,c).time_series, data.rois(n,c).disc_fit.class,data.rois(n,c).state_seq,...
                'states', state_threshold,event_threshold);
            
            % 2. event detection ony
        case 2
            
            [Accuracy(n,c), Precision(n,c), Recall(n,c)] = idealizationMetrics...
                (data.rois(n,c).time_series, data.rois(n,c).disc_fit.class,data.rois(n,c).state_seq,...
                'events', state_threshold,event_threshold);
            
            % 3. overall: state & event detection
        case 3

            [Accuracy(n,c), Precision(n,c), Recall(n,c)] = idealizationMetrics...
                (data.rois(n,c).time_series, data.rois(n,c).disc_fit.class,data.rois(n,c).state_seq,...
                'overall', state_threshold,event_threshold);
            
            % 4. Classification
        case 4
            [Accuracy(n,c), Precision(n,c), Recall(n,c)] = idealizationMetrics...
                (data.rois(n,c).time_series, data.rois(n,c).disc_fit.class,data.rois(n,c).state_seq,...
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
