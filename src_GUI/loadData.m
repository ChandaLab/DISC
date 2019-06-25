function loadData(fp)
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


% input variables
global data gui

disp('Loading Data ...')
if ~exist('fp','var')
    [file, path] = uigetfile({'*.mat;*.dat;*.csv','Data files (*.mat,*.dat,*.csv)'},...
        'Open data file.'); % open file picker
    if ~file
        return
    end
    fp = fullfile(path, file);
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
initFields();

% if the GUI is open and has a handle stored, init GUI-only vars and begin
% plotting.
if isfield(gui, 'figure')
    [channel_names, channel_colors] = initChannels();
    if ~isempty(gui.figure) && ishghandle(gui.figure)
        gui.channelIdx = 1;
        % adjust popup labels to new channels and reset filter strings
        gui_objects = guidata(gui.figure);
        gui_objects.popupmenu_channelSelect.String = channel_names;
        gui_objects.popupmenu_channelSelect.Value = 1;
        gui_objects.text_snr_filt.String = 'any';
        gui_objects.text_numstates_filt.String = 'any';
        gui_objects.vars.channel_names = channel_names;
        gui_objects.vars.channel_colors = channel_colors;
        % recall font and axes from gui to send to goToROI
        font = gui_objects.font;
        ax1 = gui_objects.axes1; ax2 = gui_objects.axes2; ax3 = gui_objects.axes3;
        guidata(gui_objects.figure_main, gui_objects);
        goToROI(1, ax1, ax2, ax3, channel_colors, font);
    end
    % make sure we start at roi 1
    gui.roiIdx = 1;
    gui.channelIdx = 1;
end
