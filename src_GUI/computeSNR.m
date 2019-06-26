function data = computeSNR(data, ch_idx, histplot)

% find indices of analyzed traces and put them into a vector
idx = zeros(length(vertcat(data.rois(:, ch_idx).disc_fit)),1);
for ii = 1:size(data.rois, 1)
    if ~isempty(data.rois(ii, ch_idx).disc_fit)
        idx(ii) = ii;
    end
end
idx = nonzeros(idx); % remove zeros inserted between nonconsecutive roi analyses

% compute for each component per trace: 
% (mu_n+1 - mu_n)/sigma_n (all in 'components' matrix)
for ii = idx'
    mu(1) = data.rois(ii, ch_idx).disc_fit.components(1,2);
    st(1) = data.rois(ii, ch_idx).disc_fit.components(1,3);
    for jj = 2:length(data.rois(ii, ch_idx).disc_fit.components(:,2))
        mu(jj) = data.rois(ii, ch_idx).disc_fit.components(jj,2);
        st(jj) = data.rois(ii, ch_idx).disc_fit.components(jj,3);
        snr_comp(jj-1) = (mu(jj) - mu(jj-1))/st(jj-1);
    end
    % set SNR to NaN if only one component is found
    if size(data.rois(ii, ch_idx).disc_fit.components, 1) == 1
        data.rois(ii, ch_idx).SNR = NaN;
    else
        data.rois(ii, ch_idx).SNR = mean(snr_comp);
    end
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