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

global data
if ~isfield(data.rois, 'status')
    [data.rois.status] = deal(0); % default is unselected
end
% All the follwing fields are generated from runDISC.m
if ~isfield(data.rois, 'Ideal') 
    [data.rois.Ideal] = deal([]); % fit from analysis
end
if ~isfield(data.rois, 'Class')
    [data.rois.Class] = deal([]); 
end
if ~isfield(data.rois, 'Components')
    [data.rois.Components] = deal([]);
end
if ~isfield(data.rois, 'Metric')
    [data.rois.Metric] = deal([]); % number of states
end
if ~isfield(data.rois, 'DISC_FIT')
    [data.rois.DISC_FIT] = deal([]); % input parameters for fitting by DISC
end
