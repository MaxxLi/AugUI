function varargout = readConductivity(varargin)
% READCONDUCTIVITY MATLAB code for readConductivity.fig
%      READCONDUCTIVITY, by itself, creates a new READCONDUCTIVITY or raises the existing
%      singleton*.
%
%      H = READCONDUCTIVITY returns the handle to a new READCONDUCTIVITY or the handle to
%      the existing singleton*.
%
%      READCONDUCTIVITY('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in READCONDUCTIVITY.M with the given input arguments.
%
%      READCONDUCTIVITY('Property','Value',...) creates a new READCONDUCTIVITY or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before readConductivity_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to readConductivity_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help readConductivity

% Last Modified by GUIDE v2.5 29-Jul-2013 10:22:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @readConductivity_OpeningFcn, ...
                   'gui_OutputFcn',  @readConductivity_OutputFcn, ...
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
end

% --- Executes just before readConductivity is made visible.
function readConductivity_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to readConductivity (see VARARGIN)


%NOTE ON SELECTING SAMPLE RATE AND # SAMPLES:
%The pH and ORP probes experience 60Hz noise (likely due to EM interference
%occurring in the water). Therefore, the amount of time spent collecting
%data must be a multiple of 1/60 seconds to obtain an average reading that
%corresponds to the center of the sinusoidal waveform. This is acheived by 
%having 1k samples at 20kHz, which is 0.05s of read time and corresponds to
%3 periods at 60Hz. This is an imperfect solution.

%Sample rate in Hz
handles.sampleRate = 20000;
%Number of samples
handles.sampleNum = 1000;

%DAQ hardware address
handles.daqAddress = 'Dev4';

%Shunt resistor value in Ohms
handles.shuntRes = 470;

%Shunt resistor channel
handles.chResistor = 0;
%Probe channel
handles.chProbe = 1;
%RTD channel
handles.chRTD = 2;

%temperature
handles.T = 20;

% Choose default command line output for readConductivity
handles.output = hObject;

%NOTE: need to convert this code to the session based DAQ. Otherwise, it
%      won't work on x64 systems.

%DAQ initialization
handles.ai = analoginput('nidaq', handles.daqAddress);
handles.ai.SampleRate = handles.sampleRate;
handles.ai.SamplesPerTrigger = handles.sampleNum;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes readConductivity wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end

% --- Outputs from this function are returned to the command line.
function varargout = readConductivity_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end

function txtProbeChan_Callback(hObject, eventdata, handles)
% hObject    handle to txtProbeChan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtProbeChan as text
%        str2double(get(hObject,'String')) returns contents of txtProbeChan as a double
updateChans(handles);
end

% --- Executes during object creation, after setting all properties.
function txtProbeChan_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtProbeChan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function txtResChan_Callback(hObject, eventdata, handles)
% hObject    handle to txtResChan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtResChan as text
%        str2double(get(hObject,'String')) returns contents of txtResChan as a double
updateChans(handles);
end

% --- Executes during object creation, after setting all properties.
function txtResChan_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtResChan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function txtRTDChan_Callback(hObject, eventdata, handles)
% hObject    handle to txtRTDChan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtRTDChan as text
%        str2double(get(hObject,'String')) returns contents of txtRTDChan as a double
end

% --- Executes during object creation, after setting all properties.
function txtRTDChan_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtRTDChan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function txtCellK_Callback(hObject, eventdata, handles)
% hObject    handle to txtCellK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtCellK as text
%        str2double(get(hObject,'String')) returns contents of txtCellK as a double
end

% --- Executes during object creation, after setting all properties.
function txtCellK_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtCellK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function txtSlope_Callback(hObject, eventdata, handles)
% hObject    handle to txtSlope (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtSlope as text
%        str2double(get(hObject,'String')) returns contents of txtSlope as a double
end

% --- Executes during object creation, after setting all properties.
function txtSlope_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtSlope (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function txtpHChan_Callback(hObject, eventdata, handles)
% hObject    handle to txtpHChan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of txtpHChan as text
%        str2double(get(hObject,'String')) returns contents of txtpHChan as a double
end

% --- Executes during object creation, after setting all properties.
function txtpHChan_CreateFcn(hObject, eventdata, handles)
% hObject    handle to txtpHChan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in btnRead.
function btnRead_Callback(hObject, eventdata, handles)
% hObject    handle to btnRead (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

updateChans(handles);
start(handles.ai);
[d,t] = getdata(handles.ai);

%temperature
VRTD = mean(d(:,3));
T = findTemperature(VRTD);
handles.T = T;

set(handles.txtVRTD, 'String', strcat(num2str(VRTD), ' V'));

findConductivity(d, handles);
end

function findConductivity(d, handles)

%find peak to peak voltages of probe + resistor
VProbe = findVpp(d(:,1));
VRes = findVpp(d(:,2));

%solution resistance
R = handles.shuntRes*VProbe/VRes;

%get cell constant
k = str2num(get(handles.txtCellK, 'String'));

%get temperature correction slope
j = str2num(get(handles.txtSlope, 'String'))/100;

%temperature correction coefficient
a = 1/(1 + j*(handles.T - 25));

%conductivity
C = k * a / R;

%write outputs
set(handles.uitable1, 'Data', d);
set(handles.lblConductivity, 'String', strcat(num2str(C*1000000), ' uS/cm'));
set(handles.lblTemperature, 'String', strcat(num2str(handles.T), ' C'));
set(handles.lblSolutionResistance,'String',strcat(num2str(R), ' Ohms'));
set(handles.lblVProbe, 'String', strcat(num2str(VProbe), ' V'));
set(handles.lblVRes, 'String', strcat(num2str(VRes), ' V'));


end

function updateChans(handles)
%update channel numbers
delete(handles.ai.Channel);
handles.chProbe = str2num(get(handles.txtProbeChan, 'String'));
handles.chResistor = str2num(get(handles.txtResChan, 'String'));
handles.chRTD = str2num(get(handles.txtRTDChan, 'String'));
addchannel(handles.ai, [handles.chProbe, handles.chResistor, handles.chRTD]);
end

function vpp = findVpp(d)
%findVpp(d)
%Inputs:    d - an array of values representing a square wave
%Outputs:   vpp - the peak to peak voltage of the square wave input
%This function takes a list of values d, which represents a square wave
%voltage signal read by a NI DAQ analog input, and returns the peak to peak
%voltage of the signal. This signal must have no envelope features, and be
%centered around 0.

%if the difference in value between two data points is less than THRESHOLD,
%then the two points are considered to be part of the same peak
THRESHOLD = 0.5;

len = length(d);

prev = 'batman';
risingEdge = false;
fallingEdge = false;
onPeak = false;
listOfMax = [];
listOfMin = [];

for i = 1:(len + 1)
    if i ~= 1 && i ~= (len + 1)
        dV = d(i) - prev;
        if d(i) > 0 && prev > 0
            if abs(dV) < THRESHOLD
                listOfMax = [listOfMax prev];
                onPeak = true;
                risingEdge = false;
                fallingEdge = false;
            else
                if onPeak && ~risingEdge && ~fallingEdge
                    listOfMax = [listOfMax prev];
                end
                onPeak = false;
                risingEdge = false;
                fallingEdge = true;
            end
        elseif d(i) < 0 && prev < 0
            if abs(dV) < THRESHOLD
                listOfMin = [listOfMin prev];
                onPeak = true;
                risingEdge = false;
                fallingEdge = false;
            else
                if onPeak && ~risingEdge && ~fallingEdge
                    listOfMin = [listOfMin prev];
                end
                onPeak = false;
                risingEdge = true;
                fallingEdge = false;
            end
        elseif d(i) > 0 && prev < 0
            if onPeak && ~risingEdge && ~fallingEdge
                listOfMin = [listOfMin prev];
            end
            onPeak = false;
            risingEdge = true;
            fallingEdge = false;
        elseif d(i) < 0 && prev > 0
            if onPeak && ~risingEdge && ~fallingEdge
                listOfMax = [listOfMax prev];
            end
            onPeak = false;
            risingEdge = false;
            fallingEdge = true;
        end
                
        prev = d(i);
    elseif i == (len + 1)
        if onPeak && ~risingEdge && ~fallingEdge
            if prev > 0
                listOfMax = [listOfMax prev];
            else
                listOfMin = [listOfMin prev];
            end
        end
    else
        prev = d(i);
    end
end
vpp = mean(listOfMax) - mean(listOfMin);
end

function T = findTemperature(V)

T = 11.351*V - 2.859;

end
