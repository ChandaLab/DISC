function plotTrajectory(axes)
% Plot the Time Series Trajectory data (rois.time_series) with fit (rois.ideal)
%
% Authors: Owen Rafferty & David S. White 
% Contact: dwhite7@wisc.edu 

% Updates: 
% --------
% 2019-12       OR      Wrote the code
% 2019-02-20    DSW     comments and name change to plotTrajectory
% 2019-04-10    DSW     updated to new disc_fit structure

% global variables 
global data gui 

%plot time series and fit of ROI of GUI-assigned channel
% figure 1 handle: axes (var)
cla(axes); 

% plot time series data 
plot(axes, data.rois(gui.roiIdx, gui.channelIdx).time_series, ...
     'color', gui.channelColors(gui.channelIdx, :))
 
% draw title based on selection or lack thereof
% determine num of selected traces
numsel = nnz(vertcat(data.rois(:, gui.channelIdx).status)==1); 
if data.rois(gui.roiIdx, gui.channelIdx).status == 1
    title_txt = sprintf('ROI # %u of %u - Status: Selected  (%u selected)',...
        gui.roiIdx, size(data.rois,1), numsel);
elseif data.rois(gui.roiIdx, gui.channelIdx).status == 0
    title_txt = sprintf('ROI # %u of %u - Status: Unselected  (%u selected)',...
        gui.roiIdx, size(data.rois,1), numsel);
else
    title_txt = sprintf('ROI # %u of %u - Status: null  (%u selected)',...
        gui.roiIdx, size(data.rois,1), numsel);
end
title(axes, title_txt);
xlabel(axes, 'Frames'); 
ylabel(axes, 'Intensity (AU)');
set(axes, 'fontsize', gui.fontSize);
set(axes, 'fontname', gui.fontName);

% draw fit if analysis is completed for the current ROI
if ~isempty(data.rois(gui.roiIdx, gui.channelIdx).disc_fit)
    hold(axes, 'on')
    plot(axes, data.rois(gui.roiIdx, gui.channelIdx).disc_fit.ideal, ...
         '-k','linewidth',1.7)
    hold(axes, 'off') 
end

