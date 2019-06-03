function initFields()
% Initialize the fields in data.rois for DISC anaysis upon loading 
%
% Authors: Owen Rafferty & David S. White 
% Contact: dwhite7@wisc.edu 

% Updates: 
% --------
% 2019-12-01    OR      Wrote the code; Adapted from code intially written
%                       by Dr. Marcel Goldschen-Ohm (UW-Madison, 2016)
% 2019-02-20    DSW     Comments added
% 2019-04-10    DSW     Updated for DISCO v1.1.0 format changes

global data

% check for format converions form roi.zproj to roi.ts 
if isfield(data.rois,'zproj')
    [n_rois,n_channels] = size(data.rois);
    
    % create new field rois.obs
    for k = 1:n_channels
        for n = 1:n_rois
            data.rois(n,k).time_series = data.rois(n,k).zproj;
        end
    end
    % remove old field for space saving
    data.rois = rmfield(data.rois,'zproj');
end

% output runDISC.m
if ~isfield(data.rois, 'disc_fit') 
    [data.rois.disc_fit] = deal([]); % fit from analysis
end
% roi selection in the GUI 
if ~isfield(data.rois, 'status')
    [data.rois.status] = deal(0); % default is unselected
end
% a further computation after DISC (see computeSNR.m)
[data.rois.SNR] = deal([]); % clear any values

% old format here for reference while debugging 
% if ~isfield(data.rois, 'Ideal') 
%     [data.rois.Ideal] = deal([]); % fit from analysis
% end
% if ~isfield(data.rois, 'Class')
%     [data.rois.Class] = deal([]); 
% end
% if ~isfield(data.rois, 'Components')
%     [data.rois.Components] = deal([]);
% end
% if ~isfield(data.rois, 'Metric')
%     [data.rois.Metric] = deal([]); % number of states
% end
% if ~isfield(data.rois, 'DISC_FIT')
%     [data.rois.DISC_FIT] = deal([]); % input parameters for fitting by DISC
% end
