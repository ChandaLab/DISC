function data = resetTrace(data, indices, applyToAll)
% reset a truncated and re-fit w/ DISC
% David S. White
% 2020-02-06

roi_idx = indices(1);
ch_idx = indices(2);

if applyToAll
    idx = [1,size(data.rois,1)];
else
    idx = [roi_idx,roi_idx];
end

for  n = idx(1):idx(2)
    data.rois(n, ch_idx).time_series = data.rois(n, ch_idx).time_series_0;
    if isfield(data.rois, 'time_s')
        if isfield(data.rois,'image')
            frameRate_s = data.rois(n,ch_idx).image.frameRateHz; 
        else
            frameRate_s = 0.1;
        end
        data.rois(n,ch_idx).time_s = [1:length(data.rois(n, ch_idx).time_series)] * frameRate_s;
    end
    % refit w/ DISC w/ same parameters
    if ~isempty(data.rois(n, ch_idx).disc_fit)
    data.rois(n, ch_idx).disc_fit = ...
        runDISC(data.rois(n, ch_idx).time_series, data.rois(n, ch_idx).disc_fit.parameters);
    end
end

end