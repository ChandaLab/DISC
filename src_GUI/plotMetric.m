function plotMetric(axes, roi)
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

cla(axes);

% draw only if analysis is completed
if ~isempty(roi.disc_fit) && isfield(roi.disc_fit,'metrics')
    metric = roi.disc_fit.metrics;
    if ~isempty(metric)
        % plot 
        set(axes, 'Visible','on');
        cla(axes);
        plot(axes, metric,'-o','MarkerSize',10);
        hold(axes, 'on')
        best = size(roi.disc_fit.components, 1);
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
set(axes, 'fontsize', 12);
set(axes, 'fontname', 'arial');
grid(axes,'on')
end
