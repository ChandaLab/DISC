function data = truncateTrace(data, indices, applyToAll)
% truncate a trace using change-point method
% David S. White
% 2020-02-06

roi_idx = indices(1);
ch_idx = indices(2);

if applyToAll
    idx = [1,size(data.rois,1)];
else
    idx = [roi_idx,roi_idx];
end

for n = idx(1):idx(2)
    % auto truncate with change-point method
    if ~isfield(data.rois,'time_series_0')
        data.rois(n, ch_idx).time_series_0 = data.rois(n, ch_idx).time_series;
    end
    % add 10 frames to ensure the next state is included still. Should be
    % chopped off during dwell time analysis
    cpt = findchangepts(data.rois(n, ch_idx).time_series,'Statistic','std');
    if (cpt+2) <  length(data.rois(n, ch_idx).time_series)
        cpt = cpt+10;
    end
    data.rois(n, ch_idx).time_series = data.rois(n, ch_idx).time_series(1:cpt);
    data.rois(n, ch_idx).time_s = data.rois(n, ch_idx).time_s(1:cpt);
    % check disc_fit
    
    if ~isempty(data.rois(n, ch_idx).disc_fit)
        [~,~,data.rois(n, ch_idx).disc_fit.class] = unique(data.rois(n, ch_idx).disc_fit.class(1:cpt));
        [data.rois(n, ch_idx).disc_fit.components,data.rois(n, ch_idx).disc_fit.ideal] = ...
            computeCenters(data.rois(n, ch_idx).time_series,data.rois(n, ch_idx).disc_fit.class);
    end
end
