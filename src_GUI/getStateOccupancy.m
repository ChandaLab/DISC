function data = getStateOccupancy(data, ch_idx)
% Get the average occupency of each state (i.e. fraction time in each state)
% Plot the results in a histrogram
%
% Author: David S. White 
%
% updates: 
% --------
% 2019-08-22 DSW wrote the code

nrois = size(data.rois(:,ch_idx),1); 

% find selected traces 
idx = findSelected(data, ch_idx); 

all_occupencies = zeros(100,1); % allocate space to large number rather than resize
total_frames = 0;

for i = idx'
    % check to ensure the trajectory is both selected and analyzed
    if data.rois(i,ch_idx).status & ~isempty(data.rois(i,ch_idx).disc_fit)
        % grab duration and total time in each state
        frames = length(data.rois(i,ch_idx).time_series);
        per_state = frames * data.rois(i,ch_idx).disc_fit.components(:,1);
        all_occupencies(1:length(per_state)) = all_occupencies(1:length(per_state)) + per_state;
        total_frames = total_frames + frames;
    end
end

% remove the end zeros and sum to total
all_occupencies(all_occupencies == 0) = [];
% return the total time in each state 
data.state_occupancy = all_occupencies / total_frames;

% make a histogram
figure();
bar(data.state_occupancy);
title('State Occupancy Histogram')
xlabel('State')
ylabel('Counts')

end