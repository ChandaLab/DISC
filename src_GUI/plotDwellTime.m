function plotDwellTime
global data gui

% find indices of analyzed traces and put them into a vector
idx = zeros(length(vertcat(data.rois(:, gui.channelIdx).disc_fit)),1);
for ii = 1:size(data.rois, 1)
    if ~isempty(data.rois(ii, gui.channelIdx).disc_fit)
        idx(ii) = ii;
    end
end
% remove zeros inserted between nonconsecutive roi analyses
idx = nonzeros(idx);

events = cell(length(idx), 1);
% use DISC function
for ii = idx'
    events{ii} = findEvents(data.rois(ii, gui.channelIdx).disc_fit.class);
    % events = [start frame, stop frame, duration, label]
end
% concatenate all 'events' matrices. on large data sets, this will likely
% create an enormous matrix (and so use lots of memory).
events = vertcat(events{:});

% max # of states on any trace will be the max value in the label column
num_states = max(events(:,4));

durations = cell(1, num_states); % allocate
% store durations in column 3 that correspond to each label in column 4.
% dimensions are generally different, so a cell is a good choice here.
for ii = 1:num_states
    durations{ii} = events(events(:,4)==ii,3);
end

% allocate and create axes depending on num states
figure();
ax = gobjects(round(num_states/2),2);
for ii = 1:round(num_states/2)
    ax(ii,1) = subplot(round(num_states/2), 2, 2*(ii-1) + 1);
    ax(ii,2) = subplot(round(num_states/2), 2, 2*(ii-1) + 2);
end
% plot histograms. binning is currently fixed at 50, but there may be better
% options
for ii = 1:num_states
    % create histogram and fit
    f = histfit(durations{ii}, 50, 'exponential');
    % reset axes
    f(1).Parent = ax(ii);
    f(2).Parent = ax(ii);
    % set xmin to 0
    xlims = xlim(ax(ii)); xmax = xlims(2);
    xlim(ax(ii), [0 xmax]);
    % set labels
    title(ax(ii), ['State ' num2str(ii)]);
    xlabel(ax(ii), 'Duration (Frames)');
    ylabel(ax(ii), 'Counts');
end
% if the number of states is odd, make the last set of axes invisible
if mod(num_states,2)
    ax(end).Visible = 0;
end
end