function data = computeSNR(data, ch_idx, histplot)


% find selected traces 
idx = findSelected(data, ch_idx); 

% compute for each component per trace: 
for i = idx'
    data.rois(i, ch_idx).SNR = computeSNR(data.rois(i,ch_idx).disc_fit.components);
end

% make a graphical histogram if given parameter
if histplot
    figure();
    histogram(vertcat(data.rois(idx, ch_idx).SNR));
    title('SNR Histogram')
    xlabel('SNR')
    ylabel('Count')
end
end