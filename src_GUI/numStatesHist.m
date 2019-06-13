function numStatesHist(histplot)
global data gui

% allocate
idx = zeros(length(vertcat(data.rois(:,gui.channelIdx).disc_fit)),1);
% find indices of analyzed traces
for ii = 1:size(data.rois,1)
    if ~isempty(data.rois(ii,gui.channelIdx).disc_fit)
        idx(ii) = ii;
    end
end
idx = nonzeros(idx); % remove zeros inserted between nonconsecutive roi analyses

numstates_cat = zeros(length(idx),1); % allocate
% find num of states based on rows of 'components' matrix
for ii = idx'
    numstates_cat(ii) = size(data.rois(ii, gui.channelIdx).disc_fit.components, 1);
end
% again, remove zeros from gaps in analyses
numstates_cat = nonzeros(numstates_cat);

% make a graphical histogram if the parameter indicates (it almost always
% will)
if histplot
    figure();
    histogram(numstates_cat);
    title('# of States Histogram')
    xlabel('# of States')
    ylabel('Count')
end

end