function handles = applyTraceSelection(handles);
% apply trace selection criteria to select and deselect traces
%
% David S. White
% dwhite7@wisc.edu

% updates:
% 2019-08-22 DSW wrote the code

channel_idx = handles.idx(2);

if ~handles.filters.contpr
    handles.text_snr_filt.String = 'any';
    handles.text_numstates_filt.String = 'any';
    return
end

% otherwise, apply filter

if ~handles.filters.enableSNR | isempty(handles.filters.snr_max)
    handles.filters.snr_max = Inf;
end
if  ~handles.filters.enableSNR | isempty(handles.filters.snr_min)
    handles.filters.snr_min = 0;
end
if ~handles.filters.enablenumStates | isempty(handles.filters.numstates_max)
    handles.filters.numstates_max = Inf;
end
if ~handles.filters.enablenumStates | isempty(handles.filters.numstates_min)
    handles.filters.numstates_min = 0;
end

% change GUI handles
handles.text_snr_filt.String = sprintf('%.1f -> %.1f',...
    handles.filters.snr_min, handles.filters.snr_max);

handles.text_numstates_filt.String = sprintf('%.0f -> %.0f',...
    handles.filters.numstates_min, handles.filters.numstates_max);


% go through and apply the filters
for i = 1:size(handles.data.rois(:,channel_idx),1)
    
    % need a DISC fit for this analysis
    if ~isempty(handles.data.rois(i,channel_idx).disc_fit)
        
       % if no SNR, compute SNR for all the trajectories
        if isempty(handles.data.rois(i,channel_idx).SNR)
            handles.data.rois(i,channel_idx).SNR = computeSNR(handles.data.rois(i,channel_idx).disc_fit.components);
        end
        
        roi_snr = handles.data.rois(i,channel_idx).SNR;
        roi_nstates = size(handles.data.rois(i,channel_idx).disc_fit.components, 1);
        if roi_snr >= handles.filters.snr_min & roi_snr <= handles.filters.snr_max...
                & roi_nstates >= handles.filters.numstates_min & roi_nstates <= handles.filters.numstates_max
            
            % select
            handles.data.rois(i,channel_idx).status = 1;
        else
            % do not select
            handles.data.rois(i,channel_idx).status = 0;
        end
    end
end

end