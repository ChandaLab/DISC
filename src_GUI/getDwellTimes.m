function getDwellTimes(data, ch_idx)

% find indices of analyzed traces and put them into a vector
idx = zeros(length(vertcat(data.rois(:, ch_idx).disc_fit)), 1);
for ii = 1:size(data.rois, 1)
    if ~isempty(data.rois(ii, ch_idx).disc_fit)
        idx(ii) = ii;
    end
end
% remove zeros inserted between nonconsecutive roi analyses
idx = nonzeros(idx);

events = cell(1, length(idx));
% use DISC function
for ii = idx'
    events{1, ii} = findEvents(data.rois(ii, ch_idx).disc_fit.class);
    % returns events = [start frame, stop frame, duration, label]
end
% concatenate all 'events' matrices. on larger data sets, this will
% create an enormous matrix (and so use lots of memory).
events = vertcat(events{:});

% max # of states on any trace will be the max value in the label column
num_states = max(events(:,4));

durations = cell(1, num_states); % allocate
% store durations in column 3 that correspond to each label in column 4.
% dimensions are generally different, so we're using a cell
for ii = 1:num_states
    durations{ii} = events(events(:,4)==ii,3);
end
clear events

% allocate and create axes depending on num states
f = figure('units','normalized','position',[0 0 0.5 0.7],'Visible','off');
ax = gobjects(round(num_states/2),2);
for ii = 1:round(num_states/2)
    ax(ii,1) = subplot(round(num_states/2), 2, 2*(ii-1) + 1);
    ax(ii,2) = subplot(round(num_states/2), 2, 2*(ii-1) + 2);
end

f.Visible = 'on';

% allocate
muhat = zeros(1, num_states);
muci = zeros(2, num_states);
% declare function
f = @(b,x) b(1).*exp(b(2).*x);
for ii = 1:num_states
    % find mu and convidence interval
    [muhat(ii), muci(:,ii)] = expfit(durations{ii});
    
    % create histograms and extract bar heights and bin locations
    h = histogram(durations{ii}, 'Parent', ax(ii));
    x = h.BinEdges(1:end-1)';
    y = h.Values';
    
    % set xmin to 0
    xlims = xlim(ax(ii)); xmax = xlims(2);
    ylims = ylim(ax(ii)); ymax = ylims(2);
    xlim(ax(ii), [0 xmax]);
    
    % fit by minimizing distance between top of hist bars and function
    % max(y) as estimate for function coefficient, -0.1 as estimate for
    % power coefficient. this fit is only for visual purposes, and will not
    % contribute to the displayed mu and CI values.
    coeffs = fminsearch(@(b) norm(y - f(b,x)), [max(y); -0.1]);
    hold(ax(ii), 'on')
    plot(ax(ii), x, f(coeffs,x), '-r', 'linewidth', 1.7);
    hold(ax(ii), 'off');
    
    % set labels
    title(ax(ii), sprintf('State %u', ii));
    xlabel(ax(ii), 'Duration (Frames)');
    ylabel(ax(ii), 'Counts');
    
    % print fitted mu and CI onto axes
    text(ax(ii), 0.6*xmax, 0.5*ymax, ...
        sprintf("\\mu = %.2f\nCI = %.2f, %.2f", muhat(ii), muci(1,ii), muci(2,ii)))
end

% if the number of states is odd, make the last set of axes invisible
if mod(num_states,2)
    ax(end).Visible = 0;
end

pause(3);
export = dwellTimeExportDialog(); % boolean

% stop here if the user does not wish to export to csv
if ~export
    return
end

% continue to export, pick file
[file, path] = uiputfile({'*.csv','Comma-separated values (*.csv)'},...
    'Export dwell analysis to .csv');
if ~file
    return
end
% store path
fp = [path file];

% allocate (and make padding so arrays of different sizes can be
% vertically concatenated, and so mu and CI can be horizontally
% concatenated)
alldurations = cell(max(cellfun('size', durations, 1)), 1 + 2*size(durations, 2));
for ii = 1:size(durations, 2)
    alldurations(1:length(durations{ii}), ii) = num2cell(durations{ii});
    alldurations(1, size(durations,2) + 1 + ii) = num2cell(muhat(ii));
    alldurations(2:3, size(durations,2) + 1 + ii) = num2cell(muci(:,ii));
end

alldurations{1, size(durations,2) + 1} = 'mu';
alldurations{2, size(durations,2) + 1} = 'CI';
alldurations{3, size(durations,2) + 1} = 'CI';

% equivalent to writecell. keeping this for compatibility with older
% matlabs.
T = table(alldurations);
clear alldurations
writetable(T,fp,'WriteVariableNames', false, 'WriteRowNames', false);

end

function export = dwellTimeExportDialog()
% create dialog
dspyinfo = get(0,'screensize');
dwidth = 280;
dheight = 120;
d = dialog('Position',[0.5*(dspyinfo(3)-dwidth) 0.5*(dspyinfo(4)-dheight) dwidth dheight],...
           'Name','Dwell Time Export');

uicontrol(d,'style','text','string','Would you like to export dwell data to .csv?',...
    'Position',[(dwidth-230) 60 180 40]);
uicontrol(d,'string','No','Position',...
    [0.5*dwidth-115 25 100 30],'callback',@exportDwellNo_callback);
uicontrol(d,'string','Yes','Position',...
    [0.5*dwidth+15 25 100 30],'callback',@exportDwellYes_callback);
uiwait(d);

    function exportDwellNo_callback(~,~)
        export = 0;
        delete(gcf);
    end
    function exportDwellYes_callback(~,~)
        export = 1;
        delete(gcf);
    end
end