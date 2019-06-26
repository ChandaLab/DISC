function saveData(data, selected_reload, hObject)
% Save Data in the .mat format. selected_reload input parameter trims
% unselected traces from the current data set, lets the user save the file,
% and then reloads that file in the GUI.
%
% Authors: Owen Rafferty & David S. White
% Contact: dwhite7@wisc.edu

% Updates:
% --------
% 2019-12-01    OR      Wrote the code; Adapted from code intially written
%                       by Dr. Marcel Goldschen-Ohm
% 2019-02-20    DSW     Comments added

if exist('selected_reload', 'var') && selected_reload
    [file, path] = uiputfile({'*.mat','MATLAB files (*.mat)'},...
        'Save data to file.', 'selected.mat');
    if ~file
        return
    end
    disp('Saving Data ...');
    fp = fullfile(path, file);
    % loop over rois backwards so as to not affect indices
    for ii = fliplr(1:(size(data.rois, 1)))
        if ~data.rois(ii,1).status
           data.rois(ii,:) = [];
        end
    end
    save(fp, 'data');
    disp('Data Saved.');
    roiViewerGUI('menuFile_loadData_Callback', hObject, [], guidata(hObject), fp);
else
    [file, path] = uiputfile({'*.mat','MATLAB files (*.mat)'},...
        'Save data to file.');
    if ~file
        return
    end
    disp('Saving Data ...');
    fp = fullfile(path, file);
    save(fp, 'data');
    disp('Data Saved.');
end

end