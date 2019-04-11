function saveData()
% Save Data 
%
% Authors: Owen Rafferty & David S. White 
% Contact: dwhite7@wisc.edu 

% Updates: 
% --------
% 2019-12-01    OR      Wrote the code; Adapted from code intially written
%                       by Dr. Marcel Goldschen-Ohm
% 2019-02-20    DSW     Comments added
%

global p data

    [file, path] = uiputfile('*.mat', 'Save data to file.', p.fp);
    if isequal(file, 0) 
        return; 
    end
    disp('Saving Data...');
    p.fp = fullfile(path, file);
    save(p.fp, 'data');
    disp('Data Saved.');
end