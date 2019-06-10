function initChannels()
% Ensure Channels are Made and Assign Color Schemes
%
% Authors: Owen Rafferty & David S. White
% Contact: dwhite7@wisc.edu

% Updates: 
% --------
% 18-12-02  OR      Wrote the code 
% 19-02-21  DSW     Added data.names check; expanded color option in a loop
%                   Name change to initChannels from init Colors    

% Input Variables 
global data p

% Let's set fontsize and fontname here temporarily 
p.fontSize = 12; 
p.fontName = 'arial';

% Add container for channel colors 
p.channelColors = containers.Map;


% 1. Does data.names exist? 
if ~isfield(data,'names')
    % create empty field 
    data.names = {};
    % check the size of the data.rois. 
    n_channels = size(data.rois,2); 
    for n = 1:n_channels
        % assign arbitrary names
        data.names{n} = ['Channel ', num2str(n)];
    end
end

% 2. Assign colors to each channel 

% MATLAB default colors (Feel free to change out codes as neeed)
color_scheme{1} = [0.4660, 0.6740, 0.1880]; % green
color_scheme{2} = [0, 0.4470, 0.7410];      % blue
color_scheme{3} = [0.6350, 0.0780, 0.1840]; % red
color_scheme{4} = [0.4940, 0.1840, 0.5560]; % purple
color_scheme{5} = [0.3010, 0.7450, 0.9330]; % light blue
color_scheme{6} = [0.8500, 0.3250, 0.0980]; % orange
color_scheme{7} = [0.9290, 0.6940, 0.1250]; % yellow

% assign colors
for i = 1:length(data.names)
    p.channelColors(data.names{i}) = color_scheme{i};
end

