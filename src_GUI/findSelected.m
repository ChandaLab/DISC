function idx = findSelected(data, ch_idx); 
% Find the data in the current channel that is both selected and analyzed 
% for further processing. 
%
% David S. White 
% dwhite7@wisc.edu
%
% updates: 
% --------
% 2019-08-22 DSW wrote the code

% allocate space 
idx = zeros(size(data.rois, 1), 1);
for i = 1:size(data.rois, 1)
    if ~isempty(data.rois(i, ch_idx).disc_fit) & data.rois(i, ch_idx).status 
        idx(i) = i;
    end
end
% remove zeros inserted between nonconsecutive roi analyses
idx = nonzeros(idx);