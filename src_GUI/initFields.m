function data = initFields(data)
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

% check for format converions form roi.zproj to roi.ts 
[n_rois,n_channels] = size(data.rois);
if isfield(data.rois,'zproj')
    
    % create new field rois.time_series
    for k = 1:n_channels
        for n = 1:n_rois
            data.rois(n,k).time_series = data.rois(n,k).zproj;
        end
    end
    % remove old field for space saving
    data.rois = rmfield(data.rois,'zproj');
end

% time_series_0 for truncation 
if ~isfield(data.rois,'time_series_0')
    for k = 1:n_channels
        for n = 1:n_rois
            data.rois(n,k).time_series_0 = data.rois(n,k).time_series; 
            if isfield(data.rois,'image')
                frameRate_s = 1/data.rois(n).image.frameRateHz; 
            else
                % assume 100 ms frames for internal use
                 frameRate_s = 0.1; end
             data.rois(n,k).time_s = [frameRate_s:frameRate_s:length(data.rois(n,k).time_series)*frameRate_s]';
        end
    end
end

% output runDISC.m
if ~isfield(data.rois, 'disc_fit') 
    [data.rois.disc_fit] = deal([]); % fit from analysis
end
% roi selection in the GUI 
if ~isfield(data.rois, 'status')
    [data.rois.status] = deal(1); % default is selected
end
% further computation after DISC (see computeSNR.m)
[data.rois.SNR] = deal([]); % clear any values, avoids confusion as SNR 
                            % will otherwise be displayed in title and will
                            % not necessarily be that which is computed in
                            % computeSNR.m

                            