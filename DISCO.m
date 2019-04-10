function DISCO()
% DISC GUI -> DISCO
% Authors: David S. White  & Owen Rafferty
% contact: dwhite7@wisc.edu

% Updates:
% ---------
% 2019-04-07    DSW    v1.0.0
% 2019-04-10    DSW    v1.1.0
%
%--------------------------------------------------------------------------
% Overview:
% ---------
% This program is a graphical front end for the time series idealization 
% algorithm 'DISC' by David S. White.
% Requires MATLAB Statistics and Machine Learning Toolbox
% see src/DISC/runDISC.m for more details. 
%
% Input Variables:
% ----------------
% data = structure to be analyzed. Requires: 
%   data.zproj = observed emission sequence. 
%
% References:
% -----------
% White et al., 2019, (in preparation)

global data p

% Init data and some fields
p.fp = ''; p.guiHandle = ''; p.channelPopupObject = '';
if isempty(data)
    loadData()
end
% check if previous operation cancelled to avoid error msg
if isempty(data)
    disp('Action Aborted.')
    return;
end

% init GUI
p.guiHandle = roiViewerGUI();

% init DISC paramters 
initDISC()

end