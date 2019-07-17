function data = loadData(fp)
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
% data.rois.time_series = time series data to be analyzed


disp('Loading Data ...')
if ~exist('fp','var')
    [file, path] = uigetfile({'*.mat;*.dat;*.csv','Data files (*.mat,*.dat,*.csv)'},...
        'Open data file.'); % open file picker
    if ~file
        return
    end
    fp = [path file];
end
[~, ~, ext] = fileparts(fp); % get extension, will determine which method
                               % to use for importing
switch lower(ext)
    case {'.dat' '.csv'} % loads if formatted as in HaMMy/vbFRET
        temp = importdata(fp); % load into a convenient cell
        % in case colheaders are not assigned by importdata
        if isfield(temp, 'colheaders')
            names = temp.colheaders;
        else
            names = regexp(temp.textdata, '\S+','match'); % pull from textdata
            names = names{:}; % "pull up" in cell hierarchy
        end
        % pull data
        [data.names, ~, ic] = unique(names);
        roi_counts = accumarray(ic, 1);
        data.rois = struct; % init struct
        % assign each column to a roi, remove NaN elements
        for ii = 1:length(data.names)
            for jj = 1:roi_counts(ii)
                data.rois(jj,ii).time_series = temp.data(:,(ii-1)*roi_counts(ii) + jj);
                data.rois(jj,ii).time_series(any(isnan(data.rois(jj,ii).time_series),2),:) = [];
            end
        end
    case '.mat' % use standard matlab loading
        temp = load(fp, 'data'); % load from path
        data = temp.data;
end
clear temp;
disp('Data Loaded.')

% init and rename fields if necessary
data = initFields(data);

end
