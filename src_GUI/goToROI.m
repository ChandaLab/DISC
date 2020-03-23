function indices = goToROI(data, indices, axes_array, channel_colors)
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

switch indices(1)
    % open dialog w/ -1 input
    case -1
        answer = inputdlg('Go to ROI:','Custom ROI');
        indices(1) = str2double(answer{1});
    % loop around if index exceeds bounds
    case 0
        indices(1) = size(data.rois, 1);
    case size(data.rois, 1) + 1
        indices(1) = 1;
end

roi = data.rois(indices(1), indices(2));

% Update all 3 plots in GUI

% 1. time series data (and fit)
plotTrajectory(axes_array(1), roi, channel_colors(indices(2),:));
% draw title based on selection or lack thereof
% determine num of selected traces
numsel = uint32(nnz(vertcat(data.rois(:, indices(2)).status)==1)); 
if roi.status == 0
    title_txt = sprintf('ROI # %u of %u - Status: Unselected  (%u selected)',...
        indices(1), size(data.rois,1), numsel);
elseif roi.status == 1
    title_txt = sprintf('ROI # %u of %u - Status: Selected  (%u selected)',...
        indices(1), size(data.rois,1), numsel);
else
    title_txt = sprintf('ROI # %u of %u - Status: null  (%u selected)',...
        indices(1), size(data.rois,1), numsel);
end
title(axes_array(1), title_txt);
%xlabel(axes_array(1), 'Frames'); 
ylabel(axes_array(1), 'Intensity (AU)');
set(axes_array(1), 'fontsize', 12);
set(axes_array(1), 'fontname', 'arial');

% 2. time series histogram (and fit)
plotHistogram(axes_array(2), axes_array(1), roi, channel_colors(indices(2),:))
if isfield(roi,'fcAMP_nM')
    title(axes_array(2), ['fcAMP (nM): ', num2str(roi.fcAMP_nM)]);
end

% 3. information criterion values of the fit
plotMetric(axes_array(3), roi);
if ~isempty(roi.disc_fit)
    title(axes_array(3),['N States: ', num2str(size(roi.disc_fit.components,1))]);
end


% 4. cropped from raw image
plotImageROI(axes_array(4), roi);


