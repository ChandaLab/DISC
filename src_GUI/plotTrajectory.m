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
% 2020-02-05    DSW     check for data.rois(n,c).time_s;

%plot time series and fit of ROI of GUI-assigned channel
% figure 1 handle: axes (var)
cla(axes);

% does data.rois.time_s exist?
if isfield(roi, 'time_s')
    plot(axes, roi.time_s, roi.time_series, 'color', color)
    xlabel(axes, 'Time (s)');
else
    % plot time series data as frames
    plot(axes, roi.time_series, 'color', color)
    xlabel(axes, 'Frames');
end

% draw fit if analysis is completed for the current ROI
if ~isempty(roi.disc_fit)
    hold(axes, 'on')
    if isfield(roi, 'time_s')
        plot(axes, roi.time_s, roi.disc_fit.ideal,'-k','linewidth',1.7)
        xlabel(axes, 'Time (s)');
    else
        % plot time series data as frames
        plot(axes, roi.disc_fit.ideal,'-k','linewidth',1.7)
        xlabel(axes, 'Frames');
    end
    hold(axes, 'off')
end
grid(axes,'on')
