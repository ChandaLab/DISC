function numStatesHist
global data p

% allocate
numstates_cat = zeros(length(vertcat(data.rois(:,p.currentChannelIdx).disc_fit)),1);
for ii = 1:length(vertcat(data.rois(:,p.currentChannelIdx).disc_fit))
    numstates_cat(ii) = size(data.rois(ii, p.currentChannelIdx).disc_fit.components, 1);
end

figure();
histogram(numstates_cat);
title('# of States Histogram')
xlabel('# of States')
ylabel('Count')

end