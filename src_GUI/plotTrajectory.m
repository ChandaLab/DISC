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
global p data 

%plot time series and fit of ROI of GUI-assigned channel
% figure 1 handle: axes (var)
cla(axes); 

% plot time series data 
plot(axes, data.rois(p.roiIdx, p.currentChannelIdx).time_series, ...
     'color', p.channelColors(data.names{p.currentChannelIdx}))
 
% draw title based on selection or lack thereof  
if data.rois(p.roiIdx,p.currentChannelIdx).status == 1
    title(axes, ['ROI # ',num2str(p.roiIdx),' - Status: Selected']);
elseif data.rois(p.roiIdx,p.currentChannelIdx).status == 0
    title(axes, ['ROI # ',num2str(p.roiIdx),' - Status: Unselected']);
else
    title(axes, ['ROI # ',num2str(p.roiIdx),' - Status: null']);
end
xlabel(axes, 'Frames'); 
ylabel(axes, 'Intensity (AU)');
set(axes, 'fontsize', p.fontSize);
set(axes, 'fontname', p.fontName);

% draw fit if analysis is completed for the current ROI
if ~isempty(data.rois(p.roiIdx,p.currentChannelIdx).disc_fit)
    hold(axes, 'on')
    plot(axes, data.rois(p.roiIdx, p.currentChannelIdx).disc_fit.ideal, ...
         '-k','linewidth',1.7)
    hold(axes, 'off') 
end

