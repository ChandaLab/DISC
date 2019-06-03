function numStatesHist(histplot)
global data p

% allocate
idx = zeros(length(vertcat(data.rois(:,p.currentChannelIdx).disc_fit)),1);
for ii = 1:length(data.rois)
    if ~isempty(data.rois(ii,p.currentChannelIdx).disc_fit)
        idx(ii) = ii;
    end
end
idx = nonzeros(idx); % remove zeros inserted between nonconsecutive roi analyses

numstates_cat = zeros(length(idx),1);
for ii = idx'
    numstates_cat(ii) = size(data.rois(ii, p.currentChannelIdx).disc_fit.components, 1);
end

if histplot == 1
    figure();
    histogram(numstates_cat);
    title('# of States Histogram')
    xlabel('# of States')
    ylabel('Count')
end

end