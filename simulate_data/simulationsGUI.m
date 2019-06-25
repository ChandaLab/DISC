function varargout = simulationsGUI(varargin)
% SIMULATIONSGUI MATLAB code for simulationsGUI.fig
%      SIMULATIONSGUI, by itself, creates a new SIMULATIONSGUI or raises the existing
%      singleton*.
%
%      H = SIMULATIONSGUI returns the handle to a new SIMULATIONSGUI or the handle to
%      the existing singleton*.
%
%      SIMULATIONSGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SIMULATIONSGUI.M with the given input arguments.
%
%      SIMULATIONSGUI('Property','Value',...) creates a new SIMULATIONSGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before simulationsGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to simulationsGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help simulationsGUI

% Last Modified by GUIDE v2.5 25-Jun-2019 13:14:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @simulationsGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @simulationsGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before simulationsGUI is made visible.
function simulationsGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.

% varargin   command line arguments to simulationsGUI (see VARARGIN)

% init fields
handles.num_states = 2;
handles.kin_mat = [];

% Choose default command line output for simulationsGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = simulationsGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);

% Get default command line output from handles structure
varargout{1} = handles.output;


function edit_kinMat_Callback(obj, evd, h)
% this callback is called by all of the kinetic matrix edit boxes in the
% gui
val = str2double(get(obj, 'String'));
set(obj, 'String', num2str(val));

% update stored matrix upon any change in table values
h.kin_mat = getkinMat(h.figure_main);
no_states = get(h.popupmenu_numstates, 'Value') + 1;

% resize to appropriate dimension (NxN) for number of states (N) chosen
h.kin_mat = h.kin_mat(1:no_states, 1:no_states);
guidata(h.figure_main, h); % store matrix in gui

function kin_mat = getkinMat(fig)
% get handles
h = guidata(fig);

% construct matrix from handles
kin_mat = [str2double(get(h.edit_tab_11,'String')) str2double(get(h.edit_tab_12,'String')) ...
           str2double(get(h.edit_tab_13,'String')) str2double(get(h.edit_tab_14,'String')) ...
           str2double(get(h.edit_tab_15,'String'))
           str2double(get(h.edit_tab_21,'String')) str2double(get(h.edit_tab_22,'String')) ...
           str2double(get(h.edit_tab_23,'String')) str2double(get(h.edit_tab_24,'String')) ...
           str2double(get(h.edit_tab_25,'String'))
           str2double(get(h.edit_tab_31,'String')) str2double(get(h.edit_tab_32,'String')) ...
           str2double(get(h.edit_tab_33,'String')) str2double(get(h.edit_tab_34,'String')) ...
           str2double(get(h.edit_tab_35,'String'))
           str2double(get(h.edit_tab_41,'String')) str2double(get(h.edit_tab_42,'String')) ...
           str2double(get(h.edit_tab_43,'String')) str2double(get(h.edit_tab_44,'String')) ...
           str2double(get(h.edit_tab_45,'String'))
           str2double(get(h.edit_tab_51,'String')) str2double(get(h.edit_tab_52,'String')) ...
           str2double(get(h.edit_tab_53,'String')) str2double(get(h.edit_tab_54,'String')) ...
           str2double(get(h.edit_tab_55,'String'))];

function popupmenu_numstates_Callback(hObject, eventdata, handles)

% in addition to updating the matrix with entered values, we also need it
% to update with the popup
handles.kin_mat = getkinMat(handles.figure_main);
% num states will be one greater than popup index
handles.num_states = get(handles.popupmenu_numstates, 'Value') + 1;

% resize to appropriate dimension (NxN) for number of states (N) chosen
handles.kin_mat = handles.kin_mat(1:handles.num_states, 1:handles.num_states);
guidata(handles.figure_main, handles); % store values in gui

popup_sel_index = get(hObject, 'Value');
% disable certain parts of the table depending on how many states have been
% selected for simulation
switch popup_sel_index
    case 1 % num states = 2
        set(handles.edit_tab_13, 'Enable', 'off')
        set(handles.edit_tab_14, 'Enable', 'off')
        set(handles.edit_tab_15, 'Enable', 'off')
        set(handles.edit_tab_23, 'Enable', 'off')
        set(handles.edit_tab_24, 'Enable', 'off')
        set(handles.edit_tab_25, 'Enable', 'off')
        set(handles.edit_tab_31, 'Enable', 'off')
        set(handles.edit_tab_32, 'Enable', 'off')
        set(handles.edit_tab_34, 'Enable', 'off')
        set(handles.edit_tab_35, 'Enable', 'off')
        set(handles.edit_tab_41, 'Enable', 'off')
        set(handles.edit_tab_42, 'Enable', 'off')
        set(handles.edit_tab_43, 'Enable', 'off')
        set(handles.edit_tab_45, 'Enable', 'off')
        set(handles.edit_tab_51, 'Enable', 'off')
        set(handles.edit_tab_52, 'Enable', 'off')
        set(handles.edit_tab_53, 'Enable', 'off')
        set(handles.edit_tab_54, 'Enable', 'off')
    case 2 % num states = 3
        set(handles.edit_tab_13, 'Enable', 'on')
        set(handles.edit_tab_14, 'Enable', 'off')
        set(handles.edit_tab_15, 'Enable', 'off')
        set(handles.edit_tab_23, 'Enable', 'on')
        set(handles.edit_tab_24, 'Enable', 'off')
        set(handles.edit_tab_25, 'Enable', 'off')
        set(handles.edit_tab_31, 'Enable', 'on')
        set(handles.edit_tab_32, 'Enable', 'on')
        set(handles.edit_tab_34, 'Enable', 'off')
        set(handles.edit_tab_35, 'Enable', 'off')
        set(handles.edit_tab_41, 'Enable', 'off')
        set(handles.edit_tab_42, 'Enable', 'off')
        set(handles.edit_tab_43, 'Enable', 'off')
        set(handles.edit_tab_45, 'Enable', 'off')
        set(handles.edit_tab_51, 'Enable', 'off')
        set(handles.edit_tab_52, 'Enable', 'off')
        set(handles.edit_tab_53, 'Enable', 'off')
        set(handles.edit_tab_54, 'Enable', 'off')
    case 3 % num states = 4
        set(handles.edit_tab_13, 'Enable', 'on')
        set(handles.edit_tab_14, 'Enable', 'on')
        set(handles.edit_tab_15, 'Enable', 'off')
        set(handles.edit_tab_23, 'Enable', 'on')
        set(handles.edit_tab_24, 'Enable', 'on')
        set(handles.edit_tab_25, 'Enable', 'off')
        set(handles.edit_tab_31, 'Enable', 'on')
        set(handles.edit_tab_32, 'Enable', 'on')
        set(handles.edit_tab_34, 'Enable', 'on')
        set(handles.edit_tab_35, 'Enable', 'off')
        set(handles.edit_tab_41, 'Enable', 'on')
        set(handles.edit_tab_42, 'Enable', 'on')
        set(handles.edit_tab_43, 'Enable', 'on')
        set(handles.edit_tab_45, 'Enable', 'off')
        set(handles.edit_tab_51, 'Enable', 'off')
        set(handles.edit_tab_52, 'Enable', 'off')
        set(handles.edit_tab_53, 'Enable', 'off')
        set(handles.edit_tab_54, 'Enable', 'off')
    case 4 % num states = 5
        set(handles.edit_tab_13, 'Enable', 'on')
        set(handles.edit_tab_14, 'Enable', 'on')
        set(handles.edit_tab_15, 'Enable', 'on')
        set(handles.edit_tab_23, 'Enable', 'on')
        set(handles.edit_tab_24, 'Enable', 'on')
        set(handles.edit_tab_25, 'Enable', 'on')
        set(handles.edit_tab_31, 'Enable', 'on')
        set(handles.edit_tab_32, 'Enable', 'on')
        set(handles.edit_tab_34, 'Enable', 'on')
        set(handles.edit_tab_35, 'Enable', 'on')
        set(handles.edit_tab_41, 'Enable', 'on')
        set(handles.edit_tab_42, 'Enable', 'on')
        set(handles.edit_tab_43, 'Enable', 'on')
        set(handles.edit_tab_45, 'Enable', 'on')
        set(handles.edit_tab_51, 'Enable', 'on')
        set(handles.edit_tab_52, 'Enable', 'on')
        set(handles.edit_tab_53, 'Enable', 'on')
        set(handles.edit_tab_54, 'Enable', 'on')
end

function popupmenu_numstates_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
