function plotTrajectory(axes, roi, color)
% Plot the Time Series Trajectory data (rois.time_series) with fit (rois.ideal)
%
% Authors: Owen Rafferty & David S. White 
% Contact: dwhite7@wisc.edu 

% Updates: 
% --------
% 2019-12       OR      Wrote the code
% 2019-02-20    DSW     comments and name change to plotTrajectory
% 2019-04-10    DSW     updated to new disc_fit structure

%plot time series and fit of ROI of GUI-assigned channel
% figure 1 handle: axes (var)
cla(axes); 

% plot time series data 
plot(axes, roi.time_series, 'color', color)

% draw fit if analysis is completed for the current ROI
if ~isempty(roi.disc_fit)
    hold(axes, 'on')
    plot(axes, roi.disc_fit.ideal,'-k','linewidth',1.7)
    hold(axes, 'off') 
end

