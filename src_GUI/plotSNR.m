function data = computeSNR(data, ch_idx, histplot)

% find indices of analyzed traces and put them into a vector
idx = zeros(length(vertcat(data.rois(:, ch_idx).disc_fit)),1);
for i = 1:size(data.rois, 1)
    if ~isempty(data.rois(i, ch_idx).disc_fit)
        idx(i) = i;
    end
end
idx = nonzeros(idx); % remove zeros inserted between nonconsecutive roi analyses

% compute for each component per trace: 
for i = idx'
    data.rois(i, ch_idx).SNR = computeSNR(data.rois(i,ch_idx).disc_fit.components);
end

% make a graphical histogram if given parameter
if histplot
    figure();
    histogram(vertcat(data.rois(:, ch_idx).SNR));
    title('SNR Histogram')
    xlabel('SNR')
    ylabel('Count')
end
end