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

% Last Modified by GUIDE v2.5 21-Jun-2019 11:28:27

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
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to simulationsGUI (see VARARGIN)

% Choose default command line output for simulationsGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes simulationsGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = simulationsGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit_tab_11_Callback(hObject, eventdata, handles)
% hObject    handle to edit_tab_11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_tab_11 as text
%        str2double(get(hObject,'String')) returns contents of edit_tab_11 as a double


% --- Executes during object creation, after setting all properties.
function edit_tab_11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_tab_11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_tab_12_Callback(hObject, eventdata, handles)
% hObject    handle to edit_tab_12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_tab_12 as text
%        str2double(get(hObject,'String')) returns contents of edit_tab_12 as a double


% --- Executes during object creation, after setting all properties.
function edit_tab_12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_tab_12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_tab_13_Callback(hObject, eventdata, handles)
% hObject    handle to edit_tab_13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_tab_13 as text
%        str2double(get(hObject,'String')) returns contents of edit_tab_13 as a double


% --- Executes during object creation, after setting all properties.
function edit_tab_13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_tab_13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_tab_14_Callback(hObject, eventdata, handles)
% hObject    handle to edit_tab_14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_tab_14 as text
%        str2double(get(hObject,'String')) returns contents of edit_tab_14 as a double


% --- Executes during object creation, after setting all properties.
function edit_tab_14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_tab_14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_tab_21_Callback(hObject, eventdata, handles)
% hObject    handle to edit_tab_21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_tab_21 as text
%        str2double(get(hObject,'String')) returns contents of edit_tab_21 as a double


% --- Executes during object creation, after setting all properties.
function edit_tab_21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_tab_21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_tab_22_Callback(hObject, eventdata, handles)
% hObject    handle to edit_tab_22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_tab_22 as text
%        str2double(get(hObject,'String')) returns contents of edit_tab_22 as a double


% --- Executes during object creation, after setting all properties.
function edit_tab_22_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_tab_22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_tab_23_Callback(hObject, eventdata, handles)
% hObject    handle to edit_tab_23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_tab_23 as text
%        str2double(get(hObject,'String')) returns contents of edit_tab_23 as a double


% --- Executes during object creation, after setting all properties.
function edit_tab_23_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_tab_23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_tab_24_Callback(hObject, eventdata, handles)
% hObject    handle to edit_tab_24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_tab_24 as text
%        str2double(get(hObject,'String')) returns contents of edit_tab_24 as a double


% --- Executes during object creation, after setting all properties.
function edit_tab_24_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_tab_24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_tab_25_Callback(hObject, eventdata, handles)
% hObject    handle to edit_tab_25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_tab_25 as text
%        str2double(get(hObject,'String')) returns contents of edit_tab_25 as a double


% --- Executes during object creation, after setting all properties.
function edit_tab_25_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_tab_25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_tab_31_Callback(hObject, eventdata, handles)
% hObject    handle to edit_tab_31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_tab_31 as text
%        str2double(get(hObject,'String')) returns contents of edit_tab_31 as a double


% --- Executes during object creation, after setting all properties.
function edit_tab_31_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_tab_31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_tab_32_Callback(hObject, eventdata, handles)
% hObject    handle to edit_tab_32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_tab_32 as text
%        str2double(get(hObject,'String')) returns contents of edit_tab_32 as a double


% --- Executes during object creation, after setting all properties.
function edit_tab_32_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_tab_32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_tab_33_Callback(hObject, eventdata, handles)
% hObject    handle to edit_tab_33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_tab_33 as text
%        str2double(get(hObject,'String')) returns contents of edit_tab_33 as a double


% --- Executes during object creation, after setting all properties.
function edit_tab_33_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_tab_33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_tab_34_Callback(hObject, eventdata, handles)
% hObject    handle to edit_tab_34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_tab_34 as text
%        str2double(get(hObject,'String')) returns contents of edit_tab_34 as a double


% --- Executes during object creation, after setting all properties.
function edit_tab_34_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_tab_34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_tab_35_Callback(hObject, eventdata, handles)
% hObject    handle to edit_tab_35 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_tab_35 as text
%        str2double(get(hObject,'String')) returns contents of edit_tab_35 as a double


% --- Executes during object creation, after setting all properties.
function edit_tab_35_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_tab_35 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_tab_15_Callback(hObject, eventdata, handles)
% hObject    handle to edit_tab_15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_tab_15 as text
%        str2double(get(hObject,'String')) returns contents of edit_tab_15 as a double


% --- Executes during object creation, after setting all properties.
function edit_tab_15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_tab_15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_tab_41_Callback(hObject, eventdata, handles)
% hObject    handle to edit_tab_41 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_tab_41 as text
%        str2double(get(hObject,'String')) returns contents of edit_tab_41 as a double


% --- Executes during object creation, after setting all properties.
function edit_tab_41_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_tab_41 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_tab_51_Callback(hObject, eventdata, handles)
% hObject    handle to edit_tab_51 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_tab_51 as text
%        str2double(get(hObject,'String')) returns contents of edit_tab_51 as a double


% --- Executes during object creation, after setting all properties.
function edit_tab_51_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_tab_51 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_tab_42_Callback(hObject, eventdata, handles)
% hObject    handle to edit_tab_42 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_tab_42 as text
%        str2double(get(hObject,'String')) returns contents of edit_tab_42 as a double


% --- Executes during object creation, after setting all properties.
function edit_tab_42_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_tab_42 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_tab_52_Callback(hObject, eventdata, handles)
% hObject    handle to edit_tab_52 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_tab_52 as text
%        str2double(get(hObject,'String')) returns contents of edit_tab_52 as a double


% --- Executes during object creation, after setting all properties.
function edit_tab_52_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_tab_52 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_tab_43_Callback(hObject, eventdata, handles)
% hObject    handle to edit_tab_43 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_tab_43 as text
%        str2double(get(hObject,'String')) returns contents of edit_tab_43 as a double


% --- Executes during object creation, after setting all properties.
function edit_tab_43_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_tab_43 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_tab_53_Callback(hObject, eventdata, handles)
% hObject    handle to edit_tab_53 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_tab_53 as text
%        str2double(get(hObject,'String')) returns contents of edit_tab_53 as a double


% --- Executes during object creation, after setting all properties.
function edit_tab_53_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_tab_53 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_tab_44_Callback(hObject, eventdata, handles)
% hObject    handle to edit_tab_44 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_tab_44 as text
%        str2double(get(hObject,'String')) returns contents of edit_tab_44 as a double


% --- Executes during object creation, after setting all properties.
function edit_tab_44_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_tab_44 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_tab_54_Callback(hObject, eventdata, handles)
% hObject    handle to edit_tab_54 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_tab_54 as text
%        str2double(get(hObject,'String')) returns contents of edit_tab_54 as a double


% --- Executes during object creation, after setting all properties.
function edit_tab_54_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_tab_54 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_tab_45_Callback(hObject, eventdata, handles)
% hObject    handle to edit_tab_45 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_tab_45 as text
%        str2double(get(hObject,'String')) returns contents of edit_tab_45 as a double


% --- Executes during object creation, after setting all properties.
function edit_tab_45_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_tab_45 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_tab_55_Callback(hObject, eventdata, handles)
% hObject    handle to edit_tab_55 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_tab_55 as text
%        str2double(get(hObject,'String')) returns contents of edit_tab_55 as a double


% --- Executes during object creation, after setting all properties.
function edit_tab_55_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_tab_55 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
