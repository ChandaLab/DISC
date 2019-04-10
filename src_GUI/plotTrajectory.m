function plotTrajectory()
% Plot the Time Series Trajectory data (rois.zproj) with fit (rois.ideal)
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
% figure 1 handle: p.h1
cla(p.h1); 

% plot time series data 
plot(p.h1, data.rois(p.roiIdx, p.currentChannelIdx).zproj, ...
     'color', p.channelColors(data.names{p.currentChannelIdx}))
 
% draw title based on selection or lack thereof  
if data.rois(p.roiIdx,p.currentChannelIdx).status == 1
    title(p.h1, ['ROI # ',num2str(p.roiIdx),' - Status: Selected']);
elseif data.rois(p.roiIdx,p.currentChannelIdx).status == 0
    title(p.h1, ['ROI # ',num2str(p.roiIdx),' - Status: Unselected']);
else
    title(p.h1, ['ROI # ',num2str(p.roiIdx),' - Status: null']);
end
xlabel(p.h1, 'Frames'); 
ylabel(p.h1, 'Intensity (AU)');
set(p.h1, 'fontsize', p.fontSize);
set(p.h1, 'fontname', p.fontName);

% draw fit if analysis is completed for the current ROI
if ~isempty(data.rois(p.roiIdx,p.currentChannelIdx).disc_fit)
    hold(p.h1, 'on')
    plot(p.h1, data.rois(p.roiIdx, p.currentChannelIdx).disc_fit.ideal, ...
         '-k','linewidth',1.7)
    hold(p.h1, 'off') 
end

