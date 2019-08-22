function numStatesHist(data, ch_idx, histplot)

% find selected traces 
idx = findSelected(data, ch_idx); 

numstates_cat = zeros(length(idx),1); % allocate
% find num of states based on rows of 'components' matrix
for i = idx'
    numstates_cat(i) = size(data.rois(i, ch_idx).disc_fit.components, 1);
end
% again, remove zeros from gaps in analyses
numstates_cat = nonzeros(numstates_cat);

% make a graphical histogram if the parameter indicates (as of present, it
% always will)
if histplot
    figure();
    histogram(numstates_cat);
    title('# of States Histogram')
    xlabel('# of States')
    ylabel('Count')
end

end