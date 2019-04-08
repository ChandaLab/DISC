function loadData()
% Load Data 
%
% Authors: Owen Rafferty & David S. White 
% Contact: dwhite7@wisc.edu 

% Updates: 
% --------
% 2019-12-01    OR      Wrote the code; Adapted from code intially written
%                       by Dr. Marcel Goldschen-Ohm
% 2019-02-20    DSW     Comments added
%
% Note: To understand how the data needs to be formated for loadData to
% function, see 'sample_data.mat'. In brief, the minimal requirements are: 
%
% data = struct; 
% data.rois = region of interests; 
%    [number of rois, number of channels] = size(data.rois)
% data.rois.zproj = time series data to be analyzed


% input variables 
global data p

disp('Loading Data...')
    [path, ~, ~] = fileparts(p.fp);
    [file, path] = uigetfile('*.mat', 'Open data file.', fullfile(path, '*.mat')); % open file picker
    if isequal(file, 0) 
        return; 
    end
    p.fp = fullfile(path, file);
    temp = load(p.fp, 'data'); % load from path
    data = temp.data;
    clear temp;
    disp('Data Loaded.')

% Init fields in data and rois for DISC analysis 
initChannels();
initFields();

if ~isempty(p.guiHandle) && ishghandle(p.guiHandle) % if the GUI has a handle stored and is open, begin plotting
    p.currentChannelIdx = 1;
    goToROI(1);
    channelPopup(p.channelPopupObject);
end

% start at roi 1; 
p.roiIdx = 1; 
p.currentChannelIdx = 1;