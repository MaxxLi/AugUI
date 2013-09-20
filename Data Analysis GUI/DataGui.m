 function varargout = DataGui(varargin)
% DATAGUI MATLAB code for DataGui.fig
%      DATAGUI, by itself, creates a new DATAGUI or raises the existing
%      singleton*.
%
%      H = DATAGUI returns the handle to a new DATAGUI or the handle to
%      the existing singleton*.
%
%      DATAGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DATAGUI.M with the given input arguments.
%
%      DATAGUI('Property','Value',...) creates a new DATAGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DataGui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DataGui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help DataGui

% Last Modified by GUIDE v2.5 19-Sep-2013 10:52:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @DataGui_OpeningFcn, ...
                   'gui_OutputFcn',  @DataGui_OutputFcn, ...
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

% --- Executes just before DataGui is made visible.
function DataGui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DataGui (see VARARGIN)

% Choose default command line output for DataGui
handles.output = hObject;


load trainingdata;
handles.allAbs = allAbs;
handles.allPPM = allPPM;
handles.allID = allID;
handles.allAbsR = allAbsR;
% Update handles structure
guidata(hObject, handles);

axes(handles.axes1);
cla;
title(' ');
set(handles.groupIDdrop, 'String',' ');
set(handles.concdrop, 'String', ' ');
set(hObject,'toolbar','figure');

% This sets up the initial plot - only do when we are invisible
% so window can get raised using DataGui.
% if strcmp(get(hObject,'Visible'),'off')
%     plot(rand(5));
% end


% UIWAIT makes DataGui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = DataGui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1);
cla;
load signaturesM.mat
index = get(handles.groupIDdrop, 'Value');
groupID = get(handles.groupIDdrop, 'String');
if index > 1
    ID = str2double(groupID(index,:));
    mask1 = handles.allID == ID;
    %plot(wavelengths, handles.allAbs(mask,:),'red');
else
    mask1 = handles.allID > 0;
end

index = get(handles.Contaminants,'Value');


phandles =[];

if index <= 10
    mask2 = (handles.allPPM(:,index) > 0 );
    concentrations = unique(handles.allPPM(:, index));
    colors ='bgrkcmy'; 
    concentrations = concentrations(find(concentrations));


    for i=1:length(concentrations)
        if index<=10
            mask3 = handles.allPPM(:, index) == concentrations(i) ;
        else
            mask3 = sum(aPPM)==0;
        end
        mask = mask1 & mask2 & mask3;
        h = plot(wavelengths,handles.allAbs(mask,:),colors(mod(i-1,7)+1));
        hold on; 
        phandles = [phandles, h(1)];


    end
    hold off;
    grid minor;
    axis([200 900 0 1]);axis('auto y');
    contaminants = {'Nitrate','Nitrite','Copper','Iron','Glycol',...
        'Cyanide', 'Mercury','Acrylamide','24D','Chromate'};
    units = {' ppm',' ppm',' ppm',' ppb',' ppm',' ppm',' ppb',' ppb',' ppb',' ppb'};
    title([contaminants{index},' Training Data']);
    xlabel('Wavelength(nm)');
    ylabel('Absorption');
    text = num2str(concentrations(:));
    text = [text, repmat(units{index},length(concentrations),1)];
    legend(phandles, text);
    
else
    mask2 = sum(handles.allPPM,2) == 0;
    groupID = unique(handles.allID(mask2));
    colors ='bgrkcmy'; 
    phandles =[];
    for i=1:length(groupID)

        mask3 = handles.allID == groupID(i) ;

        mask = mask1 & mask2 & mask3;
        h = plot(wavelengths,handles.allAbs(mask,:),colors(mod(i-1,7)+1));
        hold on; 
        phandles = [phandles, h(1)];


    end
    hold off;
    grid minor;
    axis([200 900 0 1]);axis('auto y');
    title('Tap Training Data');
    xlabel('Wavelength(nm)');
    ylabel('Absorption');
    text = num2str(groupID(:));
    legend(phandles, text);
    
end




% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)


% --- Executes on selection change in groupIDdrop.
function groupIDdrop_Callback(hObject, eventdata, handles)
% hObject    handle to groupIDdrop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns groupIDdrop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from groupIDdrop


% --- Executes during object creation, after setting all properties.
function groupIDdrop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to groupIDdrop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
     set(hObject,'BackgroundColor','white');
end




% --- Executes on selection change in Contaminants.
function Contaminants_Callback(hObject, eventdata, handles)
% hObject    handle to Contaminants (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Contaminants contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Contaminants

%%%%%%%%%%%%%%%%%%%%%%%
% ADD Group dropdown update

warning('off','all')
index = get(handles.Contaminants, 'Value');
set(handles.concdrop, 'String', ' ');
set(handles.groupIDdrop, 'String', ' ');
set(handles.groupIDdrop, 'Value', 1);
set(handles.concdrop, 'Value', 1);
if index == 11
    mask = sum(handles.allPPM,2) == 0;
else 
    mask = handles.allPPM(:,index) > 0;
    concentration = unique(handles.allPPM(:, index));
    concentration = concentration(find(concentration));
    
    if ~isempty(concentration)
        set(handles.concdrop, 'String', concentration);
    end
end

groupID = unique(handles.allID(mask));


if ~isempty(groupID)
    groupID = num2str(groupID);
    groupID = strvcat('all', groupID);
    set(handles.groupIDdrop, 'String', groupID);
else 
    msgbox('No ID detected');
end











% --- Executes during object creation, after setting all properties.
function Contaminants_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Contaminants (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in concdrop.
	
% hObject    handle to concdrop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns concdrop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from concdrop
axes(handles.axes1);
cla;
load signaturesM.mat
index = get(handles.concdrop, 'Value');
concentration = get(handles.concdrop, 'String');
conc = str2double(concentration(index,:));
index = get(handles.Contaminants,'Value');
mask1 = handles.allPPM(:,index) == conc;
%plot(wavelengths, handles.allAbs(mask,:),'red');


mask2 = (handles.allPPM(:,index) > 0 );
groupID = unique(handles.allID(mask2));
colors ='bgrkcmy'; 
phandles =[];
for i=1:length(groupID)

	mask3 = handles.allID == groupID(i) ;

	mask = mask1 & mask2 & mask3;
	h = plot(wavelengths,handles.allAbs(mask,:),colors(mod(i-1,7)+1));
	hold on; 
	phandles = [phandles, h(1)];

    
end
hold off;
grid minor;
axis([200 900 0 1]);axis('auto y');
contaminants = {'Nitrate','Nitrite','Copper','Iron','Glycol',...
    'Cyanide', 'Mercury','Acrylamide','24D','Chromate'};
title([contaminants{index},' Training Data']);
xlabel('Wavelength(nm)');
ylabel('Absorption');
text = num2str(groupID(:));

legend(phandles, text);

% --- Executes during object creation, after setting all properties.
function concdrop_CreateFcn(hObject, eventdata, handles)
% hObject    handle to concdrop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in concdrop.
function concdrop_Callback(hObject, eventdata, handles)
% hObject    handle to concdrop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns concdrop contents as cell array
%        contents{get(hObject,'Value')} returns selected item from concdrop


% --- Executes on button press in DeleteButton.
function DeleteButton_Callback(hObject, eventdata, handles)
% hObject    handle to DeleteButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Confirm = questdlg('Are you Sure?',' ','Yes','No','No');
if Confirm == 'Yes'
    h = waitbar(0,'Please wait...');
    allAbs = handles.allAbs;
    allPPM = handles.allPPM;
    allID = handles.allID;
    allAbsR = handles.allAbsR;
    save('trainingdata(backup).mat', 'allAbs', 'allAbsR', 'allPPM', 'allID');
    waitbar(1/6);
    index = get(handles.concdrop, 'Value');
    concentration = get(handles.concdrop, 'String');
    conc = str2double(concentration(index,:));
    index = get(handles.Contaminants,'Value');
    mask = handles.allPPM(:,index) == conc;
    handles.allAbs(mask,:) = [];
    handles.allAbsR(mask,:) = [];
    handles.allPPM(mask,:) = [];
    handles.allID(mask,:) = [];
    allAbs = handles.allAbs;
    allPPM = handles.allPPM;
    allID = handles.allID;
    allAbsR = handles.allAbsR;
    save('trainingdata.mat', 'allAbs', 'allAbsR', 'allPPM', 'allID');
    guidata(hObject, handles);
    waitbar(4/6);

    index = get(handles.Contaminants, 'Value');
    set(handles.concdrop, 'String', ' ');
    set(handles.groupIDdrop, 'String', ' ');
    set(handles.groupIDdrop, 'Value', 1);
    set(handles.concdrop, 'Value', 1);
    waitbar(5/6);
    if index == 11
        mask = sum(handles.allPPM,2) == 0;
    else 
        mask = handles.allPPM(:,index) > 0;
        concentration = unique(handles.allPPM(:, index));
        concentration = concentration(find(concentration));

        if ~isempty(concentration)
            set(handles.concdrop, 'String', concentration);
        end
    end

    groupID = unique(handles.allID(mask));


    if ~isempty(groupID)
        groupID = num2str(groupID);
        groupID = strvcat('all', groupID);
        set(handles.groupIDdrop, 'String', groupID);
    else 
        msgbox('No ID detected');
    end
    pushbutton1_Callback(handles.pushbutton1, eventdata, handles)
    waitbar(6/6);
    close(h);
end

