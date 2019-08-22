function data = getStateOccupancy(data, ch_idx)
% Get the average occupency of each state (i.e. fraction time in each state)
% Plot the resutls in a histrogram
%
% Author: David S. White 
%
% updates: 
% --------
% 2019-08-22 DSW wrote the code


% find indices of analyzed traces and put them into a vector
idx = zeros(length(vertcat(data.rois(:, ch_idx).disc_fit)),1);
for i = 1:size(data.rois, 1)
    if ~isempty(data.rois(i, ch_idx).disc_fit)
        idx(i) = i;
    end
end
idx = nonzeros(idx); % remove zeros inserted between nonconsecutive roi analyses

all_occupencies = zeros(100,1); % allocate space to large number
total_frames = 0;
for i = idx'
    if data.rois(i,ch_idx).status
        frames = length(data.rois(i,ch_idx).time_series);
        per_state = frames * data.rois(i,ch_idx).disc_fit.components(:,1);
        all_occupencies(1:length(per_state)) = all_occupencies(1:length(per_state)) + per_state;
        total_frames = total_frames + frames;
    end
end
% remove the end zeros and sum to total
all_occupencies(all_occupencies == 0) = [];
data.state_occupancy = all_occupencies / total_frames;

% make a histogram
figure();
bar(data.state_occupancy);
title('State Occupancy Histogram')
xlabel('State')
ylabel('Counts')

end