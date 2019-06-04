function numStatesHist(histplot)
global data p

% allocate
idx = zeros(length(vertcat(data.rois(:,p.currentChannelIdx).disc_fit)),1);
% find indices of analyzed traces
for ii = 1:size(data.rois,1)
    if ~isempty(data.rois(ii,p.currentChannelIdx).disc_fit)
        idx(ii) = ii;
    end
end
idx = nonzeros(idx); % remove zeros inserted between nonconsecutive roi analyses

numstates_cat = zeros(length(idx),1); % allocate
% find num of states based on rows of 'components' matrix
for ii = idx'
    numstates_cat(ii) = size(data.rois(ii, p.currentChannelIdx).disc_fit.components, 1);
end
% again, remove zeros from gaps in analyses
numstates_cat = nonzeros(numstates_cat);

% make a graphical histogram if the parameter indicates (it almost always
% will)
if histplot == 1
    figure();
    histogram(numstates_cat);
    title('# of States Histogram')
    xlabel('# of States')
    ylabel('Count')
end

end