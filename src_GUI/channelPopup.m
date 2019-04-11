function channelPopup(hObject)
% Load the channel selection window in the main GUI
% 
% Authors: Owen Rafferty & David S. White 
% Contact: dwhite7@wisc.edu 

% Updates: 
% --------
% 2019-12-01    OMR     Wrote the code
% 2019-02-20    DSW     Included options for fonts. Name now channelPopup.m
%

global data
% create menu with default colors
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
     set(hObject,'BackgroundColor','white');
end

% set popup values based on channel names
set(hObject, 'String', data.names);
set(hObject, 'Value', 1);
set(hObject, 'fontsize', 12);
set(hObject, 'fontname', 'SansSerif');


