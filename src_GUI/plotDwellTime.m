function plotDwellTime
global data gui

% use DISC function
events = findEvents(data.rois(gui.roiIdx, gui.channelIdx).disc_fit.class);
% events = [start frame, stop frame, duration, label]
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
% if the number of states is odd, make the last set of axes invisible
if mod(num_states,2)
    ax(end).Visible = 0;
end
% plot histograms. binning is currently automatic, but there may be better
% options
for ii = 1:num_states
    histogram(ax(ii), durations{ii});
    title(ax(ii), ['State ' num2str(ii)]);
    xlabel(ax(ii), 'Duration (Frames)');
    ylabel(ax(ii), 'Counts');
end