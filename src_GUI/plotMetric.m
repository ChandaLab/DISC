function plotMetric()
% Plot the Metric from agglomerative clustering (rois.Metric)
%
% Authors: Owen Rafferty & David S. White 
% Contact: dwhite7@wisc.edu 

% Updates: 
% --------
% 2019-12       OR      Wrote the code
% 2019-02-20    DSW     Comments and name change to plotMetric 
% 2019-04-09    DSW     Added plotting best value in red. 

% input variables 
global data p

cla(p.h3); 

% draw only if analysis is completed
if isfield(data.rois, 'Metric') && ~isempty(data.rois(p.roiIdx,p.currentChannelIdx).Metric)
    metric = data.rois(p.roiIdx,p.currentChannelIdx).Metric;
    total_states = size(data.rois(p.roiIdx,p.currentChannelIdx).Components,1); 
    
    % plot all values 
    plot(p.h3, metric,'-o','MarkerSize',10); hold on; 
    ylim(p.h3,[-0.1,1.1])
    xlim(p.h3,[0.5, length(metric)+0.5]);
    
    % plot best value in red 
    
    best = size(data.rois(p.roiIdx,p.currentChannelIdx).Components,1); 
    scatter(p.h3, best, metric(best),100,'filled', 'MarkerFaceColor','r', 'MarkerEdgeColor','r');
    hold off 
    
else
    % Hide the metric axes if DISC has not yet been run
    set(p.h3, 'Visible','off');
    cla(p.h3); 
end
xlabel(p.h3, 'Number of States'); set(p.h3,'ytick',[]);
set(p.h3, 'fontsize', p.fontSize);
set(p.h3, 'fontname', p.fontName);


end
