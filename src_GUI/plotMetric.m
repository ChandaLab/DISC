function plotMetric(axes, font)
% Plot the Metric from agglomerative clustering (rois.Metric)
%
% Authors: Owen Rafferty & David S. White
% Contact: dwhite7@wisc.edu

% Updates:
% --------
% 2019-12       OR      Wrote the code
% 2019-02-20    DSW     Comments and name change to plotMetric
% 2019-04-09    DSW     Added plotting best value in red. Updated to new
%                       disc_fit strucure;

% input variables
global data gui

cla(axes);

% draw only if analysis is completed
if ~isempty(data.rois(gui.roiIdx, gui.channelIdx).disc_fit) && isfield(data.rois(gui.roiIdx, gui.channelIdx).disc_fit,'metrics')
    metric = data.rois(gui.roiIdx, gui.channelIdx).disc_fit.metrics;
    if ~isempty(metric)
        % plot 
        set(axes, 'Visible','on');
        cla(axes);
        plot(axes, metric,'-o','MarkerSize',10);
        hold(axes, 'on')
        best = size(data.rois(gui.roiIdx, gui.channelIdx).disc_fit.components,1);
        scatter(axes, best, metric(best),100,'filled', 'MarkerFaceColor','r', 'MarkerEdgeColor','r');
        hold(axes, 'off')
        ylim(axes,[-0.1,1.1])
        xlim(axes,[0.5, length(metric)+0.5]);
    else
        % Hide the metric axes if DISC has not yet been run
        set(axes, 'Visible','off');
        cla(axes)
    end
else
    % Hide the metric axes if DISC has not yet been run
    set(axes, 'Visible','off');
    cla(axes);
end

xlabel(axes, 'Number of States'); set(axes,'ytick',[]);
set(axes, 'fontsize', font.size);
set(axes, 'fontname', font.name);

end
