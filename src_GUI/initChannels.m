function [channel_names, channel_colors] = initChannels(data)
% Ensure Channels are Made and Assign Color Schemes
%
% Authors: Owen Rafferty & David S. White
% Contact: dwhite7@wisc.edu

% Updates: 
% --------
% 18-12-02  OR      Wrote the code 
% 19-02-21  DSW     Added data.names check; expanded color option in a loop
%                   Name change to initChannels from init Colors    

% check the size of the data.rois.
n_channels = size(data.rois, 2);

% 1. Does data.names exist? 
if ~isfield(data,'names') || isempty(data.names)
    % create empty field 
    channel_names = cell(1, n_channels); 
    for n = 1:n_channels
        % assign names based on index
        channel_names{n} = sprintf('Channel %u', n);
    end
else
    channel_names = data.names;
end

% 2. Assign colors to each channel 

% MATLAB default colors. Feel free to change out codes and/or extend as
% needed. The index of each row in this matrix corresponds to the channel
% with the same index.
color_scheme = [0.4660, 0.6740, 0.1880   % green
                     0, 0.4470, 0.7410   % blue
                0.6350, 0.0780, 0.1840   % red
                0.4940, 0.1840, 0.5560   % purple
                0.3010, 0.7450, 0.9330   % light blue
                0.8500, 0.3250, 0.0980   % orange
                0.9290, 0.6940, 0.1250]; % yellow
            
% repeat color scheme if n_channels is longer than default colors
if n_channels > size(color_scheme,1)
    while size(color_scheme,1) < n_channels
    color_scheme = [color_scheme;color_scheme]; 
    end
end

% assign colors as needed
channel_colors = color_scheme(1:n_channels,:);

