function indices = goToROI(data, indices, ax1, ax2, ax3, channel_colors, font)
% Navigate to new ROI
%
% Author: Owen Rafferty
% Contact: dwhite7@wisc.edu
%
% Updates: 
% --------
% 2018-07-11    OR      Wrote the code.     
% 2019-02-21    DSW     Addded comments. Updated plotting with new function
%                       names 

% if input is -1, open dialog
if indices(1) == -1
    answer = inputdlg('Go to ROI:','Custom ROI', 1);
    indices(1) = str2double(answer{1});
% loop around if index exceeds bounds
elseif indices(1) == 0
    indices(1) = size(data.rois, 1);
elseif indices(1) > size(data.rois, 1)
    indices(1) = 1;
end

roi = data.rois(indices(1), indices(2));

% Update all 3 plots in GUI

% 1. time series data (and fit)
plotTrajectory(ax1, roi, channel_colors(indices(2),:));
% draw title based on selection or lack thereof
% determine num of selected traces
numsel = nnz(vertcat(data.rois(:, indices(2)).status)==1); 
if roi.status == 1
    title_txt = sprintf('ROI # %u of %u - Status: Selected  (%u selected)',...
        indices(1), size(data.rois,1), numsel);
elseif roi.status == 0
    title_txt = sprintf('ROI # %u of %u - Status: Unselected  (%u selected)',...
        indices(1), size(data.rois,1), numsel);
else
    title_txt = sprintf('ROI # %u of %u - Status: null  (%u selected)',...
        indices(1), size(data.rois,1), numsel);
end
title(ax1, title_txt);
xlabel(ax1, 'Frames'); 
ylabel(ax1, 'Intensity (AU)');
set(ax1, 'fontsize', font.size);
set(ax1, 'fontname', font.name);

% 2. time series histogram (and fit)
plotHistogram(ax2, ax1, roi, channel_colors(indices(2),:), font)

% 3. information criterion values of the fit
plotMetric(ax3, roi, font);