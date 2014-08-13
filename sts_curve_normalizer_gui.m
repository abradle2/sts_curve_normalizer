function varargout = sts_curve_normalizer_gui(varargin)
% STS_CURVE_NORMALIZER_GUI MATLAB code for sts_curve_normalizer_gui.fig
%      STS_CURVE_NORMALIZER_GUI, by itself, creates a new STS_CURVE_NORMALIZER_GUI or raises the existing
%      singleton*.
%
%      H = STS_CURVE_NORMALIZER_GUI returns the handle to a new STS_CURVE_NORMALIZER_GUI or the handle to
%      the existing singleton*.
%
%      STS_CURVE_NORMALIZER_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STS_CURVE_NORMALIZER_GUI.M with the given input arguments.
%
%      STS_CURVE_NORMALIZER_GUI('Property','Value',...) creates a new STS_CURVE_NORMALIZER_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before sts_curve_normalizer_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to sts_curve_normalizer_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help sts_curve_normalizer_gui

% Last Modified by GUIDE v2.5 18-Nov-2013 10:22:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @sts_curve_normalizer_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @sts_curve_normalizer_gui_OutputFcn, ...
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


% --- Executes just before sts_curve_normalizer_gui is made visible.
function sts_curve_normalizer_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to sts_curve_normalizer_gui (see VARARGIN)

% Choose default command line output for sts_curve_normalizer_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
cla(handles.axes1);
cla(handles.axes2);
clearvars -global

% UIWAIT makes sts_curve_normalizer_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = sts_curve_normalizer_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in file_load_button.
function file_load_button_Callback(hObject, eventdata, handles)
% hObject    handle to file_load_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global header;
global V;
global I_t;
global dIdV;
global dIdV_normalized;
global fileIn;
global cc;
global legend_entries;

[fileIn, pathname] = uigetfile2('*.dat', 'MultiSelect', 'on');
cc = lines(1000);    %Color palette for plots
try
    val = get(handles.smudgeSlider, 'Value');
catch
end
    val = 0;
try
    num_plots = length(V);
catch
    num_plots=0;
end

set(0, 'defaultlinelinewidth', 3);
set(0, 'defaultfigurecolor', 'w');
set(0, 'defaultaxeslinewidth', 2);
set(0, 'defaultaxeslinewidth', 2);
set(0, 'defaulttextfontsize', 20);
pos = get(handles.axes1, 'CurrentPoint')



try     %Try to open multiple files
    set(handles.axes1, 'NextPlot', 'add');
    set(handles.axes2, 'NextPlot', 'add');
    grid(handles.axes1, 'on');
    grid(handles.axes2, 'on');


    for i=1:length(fileIn)
        [V{num_plots+i}, I_t{num_plots+i}, dIdV{num_plots+i}, dIdV_normalized{num_plots+i}, header{num_plots+i}] = sts_curve_normalizer(fullfile(pathname, fileIn{i}));
        dIdV_normalized{num_plots+i} = dIdV{num_plots+i}./(I_t{num_plots+i}./V{num_plots+i} + val*1E-9);
        plot(handles.axes1, V{num_plots+i}, dIdV{num_plots+i}, 'color', cc(num_plots+i,:));
        plot(handles.axes2, V{num_plots+i}, dIdV_normalized{num_plots+i}, 'color', cc(num_plots+i,:));
        set(handles.smudgeSlider, 'BackgroundColor', cc(num_plots+i,:));
        legend_entries{end+1} = fileIn{i};
    end
    legend(handles.axes1, 'off');
    legend(handles.axes1, legend_entries, 'Interpreter', 'none');
    set(handles.plotsPopupMenu, 'String', legend_entries);
    set(handles.plotsPopupMenu, 'Value', numel(get(handles.plotsPopupMenu, 'String')) );
 catch   %If only one file was selected, catch the error here and open that one file
      [V{num_plots+1}, I_t{num_plots+1}, dIdV{num_plots+1}, dIdV_normalized{num_plots+1}, header{num_plots+1}] = sts_curve_normalizer(fullfile(pathname, fileIn));
      dIdV_normalized{num_plots+1} = dIdV{num_plots+1}./(I_t{num_plots+1}./V{num_plots+1} + val*1E-9);
      set(handles.axes1, 'NextPlot', 'add');
      plot(handles.axes1, V{num_plots+1}, dIdV{num_plots+1}, 'color', cc(num_plots+1,:));
      grid(handles.axes1, 'on');
      set(handles.axes2, 'NextPlot', 'add');
      plot(handles.axes2, V{num_plots+1}, dIdV_normalized{num_plots+1}, 'color', cc(num_plots+1,:));
      grid(handles.axes2, 'on');
      set(handles.smudgeSlider, 'BackgroundColor', cc(num_plots+1,:));
      legend_entries{end+1} = fileIn;
      legend(handles.axes1, legend_entries, 'Interpreter', 'none');
      set(handles.plotsPopupMenu, 'String', legend_entries);
      set(handles.plotsPopupMenu, 'Value', numel(get(handles.plotsPopupMenu, 'String')) );
end





% --- Executes on button press in saveButton.
function saveButton_Callback(hObject, eventdata, handles)
% hObject    handle to saveButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles 

global header;
global V;
global I_t;
global dIdV;
global dIdV_normalized;
global fileIn;

num_plots = length(V);
activePlot = get(handles.plotsPopupMenu, 'Value');
activePlotString = get(handles.plotsPopupMenu, 'String')


temp_filename = strcat( activePlotString, '.norm');
[filename, pathname] = uiputfile2(temp_filename);
file_out = fopen(fullfile(pathname, filename), 'w+');
%output = [V{num_plots}, I_t{num_plots}, dIdV{num_plots}, dIdV_normalized{num_plots}];
output = [V{activePlot}, I_t{activePlot}, dIdV{activePlot}, dIdV_normalized{activePlot}];
fprintf(file_out, '%s\r\n', header{activePlot}{1:end, 1});
fprintf(file_out, 'Sample Bias (V)\tCurrent (A)\tdI/dV (S)\tdI/dV normalized (SV/A)\r\n');
fprintf(file_out, '%d\t%d\t%d\t%d\t\r\n', output');
fclose(file_out);


% --- Executes on slider movement.
function smudgeSlider_Callback(hObject, eventdata, handles)
% hObject    handle to smudgeSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
val = get(hObject, 'Value');
set(handles.smudgeText, 'String', val);

global dIdV;
global dIdV_normalized;
global I_t;
global V;
global cc;

num_plots = length(V);

activePlot = get(handles.plotsPopupMenu, 'Value');

dIdV_normalized{activePlot} = dIdV{activePlot}./(I_t{activePlot}./V{activePlot} + val*1E-9);

%Deletes the last line to be plotted, then replots it with the new
%normalization smudge factor
plot_items = get(handles.axes2, 'children');
%delete(plot_items(1));
delete(plot_items());

%plot(handles.axes2, V{num_plots}, dIdV_normalized{num_plots}, 'color', cc(num_plots,:));
for i=1:num_plots
    plot(handles.axes2, V{i}, dIdV_normalized{i}, 'color', cc(i,:));
end




% --- Executes during object creation, after setting all properties.
function smudgeSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to smudgeSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function smudgeText_Callback(hObject, eventdata, handles)
% hObject    handle to smudgeText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of smudgeText as text
%        str2double(get(hObject,'String')) returns contents of smudgeText as a double
%val = get(handles.smudgeSlider, 'Value');
global dIdV;
global dIdV_normalized;
global I_t;
global V;
global cc;

num_plots = length(V);
activePlot = get(handles.plotsPopupMenu, 'Value');

valText = get(hObject, 'String');

set(handles.smudgeSlider, 'Value', str2num(valText) );


dIdV_normalized{activePlot} = dIdV{activePlot}./(I_t{activePlot}./V{activePlot} + valText*1E-9);

%Deletes the last line to be plotted, then replots it with the new
%normalization smudge factor
plot_items = get(handles.axes2, 'children');
%delete(plot_items(1));
delete(plot_items());

%plot(handles.axes2, V{num_plots}, dIdV_normalized{num_plots}, 'color', cc(num_plots,:));
for i=1:num_plots
    plot(handles.axes2, V{i}, dIdV_normalized{i}, 'color', cc(i,:));
end




% --- Executes during object creation, after setting all properties.
function smudgeText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to smudgeText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on mouse press over axes background.
function axes1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in clearButton.
function clearButton_Callback(hObject, eventdata, handles)
% hObject    handle to clearButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global legend_entries;

cla(handles.axes1);
cla(handles.axes2);
clearvars -global;
legend_entries = {};
legend(handles.axes1, 'off');
set(handles.plotsPopupMenu, 'String', ['--']);




% --- Executes on selection change in plotsPopupMenu.
function plotsPopupMenu_Callback(hObject, eventdata, handles)
% hObject    handle to plotsPopupMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns plotsPopupMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from plotsPopupMenu
global cc;

activePlot = get(hObject, 'Value');
set(handles.smudgeSlider, 'BackgroundColor', cc(activePlot,:) );


% --- Executes during object creation, after setting all properties.
function plotsPopupMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotsPopupMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in clearSingleButton.
function clearSingleButton_Callback(hObject, eventdata, handles)
% hObject    handle to clearSingleButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global legend_entries;

activePlot = get(handles.plotsPopupMenu, 'Value');
legend_entries(activePlot)=[];
plot_items = get(handles.axes2, 'children');
delete(plot_items(activePlot));
