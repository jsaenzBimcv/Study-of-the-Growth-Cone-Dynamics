function varargout = conesSegmentation(varargin)
% conesSegmentation MATLAB code for conesSegmentation.fig
%      conesSegmentation, by itself, creates a new conesSegmentation or raises the existing
%      singleton*.
%
%      H = conesSegmentation returns the handle to a new conesSegmentation or the handle to
%      the existing singleton*.
%
%      conesSegmentation('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in conesSegmentation.M with the given input arguments.
%
%      conesSegmentation('Property','Value',...) creates a new conesSegmentation or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before conesSegmentation_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to conesSegmentation_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help conesSegmentation

% Last Modified by GUIDE v2.5 02-Oct-2020 17:15:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @conesSegmentation_OpeningFcn, ...
    'gui_OutputFcn',  @conesSegmentation_OutputFcn, ...
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


% --- Executes just before conesSegmentation is made visible.
function conesSegmentation_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to conesSegmentation (see VARARGIN)

% Choose default command line output for conesSegmentation
handles.output = hObject;
% n = size(varargin)
% if n
%     handles.imgBox=varargin{1};
%     handles.name='none.tif';
%     handles.varargin=1;
%     guidata(hObject,handles);
%     initialization(hObject, eventdata, handles);
% end
% Update handles structure
guidata(hObject, handles);


% UIWAIT makes conesSegmentation wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = conesSegmentation_OutputFcn(~, ~, handles)
varargout{1} = handles.output;


function initialization(hObject, eventdata, handles)
img=handles.image;
axes(handles.imgBox);
imshow(img);
axis off
bw=zeros(size(img));
handles.bw=bw;
handles.bwNorm=bw;
handles.bwAut=bw;
handles.imgNorm=bw;
handles.Mask=bw;
handles.imgRef=bw;
handles.rotate=0;
handles.width=400;
handles.height=400;
handles.graphic=1;
handles.searchAutomatic=0; %turn on/off the automatic search command
handles.angle=0;
handles.xo=0;
handles.yo=0;
thrNorm=get(handles.levelsNorm,'Value');
handles.thrNorm = thrNorm;
set(handles.valueNorm,'String',roundn(thrNorm,-3));
thr=get(handles.levels,'Value');
handles.thr = thr;
set(handles.value,'String',roundn(thr,-3));
handles.ImgRefPath='none';
handles.dirMask='none';
guidata(hObject,handles);
selectNorm_Callback(hObject, eventdata, handles);
%segmentation_operations(hObject, eventdata, handles);

% --- Executes on button press in load.
function load_Callback(hObject, eventdata, handles) %#ok<*DEFNU>
set(handles.bussy,'BackgroundColor',[1 0 0]);
[name, path]=uigetfile('*.tif','Load Image');
if name == 0
    set(handles.bussy,'BackgroundColor',[0 1 0]);
    return
end

img=imread(fullfile(path,name));
handles.name=name;
handles.image=img;
guidata(hObject,handles);
initialization(hObject, eventdata, handles);

function bussyOn(hObject, ~, handles)
set(handles.bussy,'BackgroundColor',[1 0 0]);
guidata(hObject,handles)


% --- Executes on slider movement.
function levels_Callback(hObject, eventdata, handles)
bussyOn(hObject, eventdata, handles); 
handles.searchAutomatic=0;
thr=get(handles.levels,'Value');
set(handles.value,'String',roundn(thr,-3));
handles.thr = thr;
%handles.graphic=0;
guidata(hObject,handles)
segmentation_operations(hObject, eventdata, handles);


% --- Executes during object creation, after setting all properties.
function levels_CreateFcn(hObject, ~, ~) 
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'),...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function levelsNorm_Callback(hObject, eventdata, handles)
bussyOn(hObject, eventdata, handles);
handles.searchAutomatic=0;
thrNorm=get(handles.levelsNorm,'Value');
handles.thrNorm = thrNorm;
set(handles.valueNorm,'String',roundn(thrNorm,-3));
%handles.graphic=0;
guidata(hObject,handles)
segmentation_operations(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function levelsNorm_CreateFcn(hObject, ~, ~)
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), ...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on button press in new_Config.
function new_Config_Callback(~, ~, handles)
v=get(handles.selectNorm,'Value');
compConect=get(handles.connectedComp,'Value');

if compConect
    Mask=handles.Mask;
    imwrite(Mask,'config\Mask.tif');
    handles.dirMask=(strcat(pwd,'\config\Mask.tif'));
end

thr=handles.thr;
thrNorm=handles.thrNorm;
dirImgRef=handles.ImgRefPath;
dirMask=handles.dirMask;
searchAutomatic = handles.searchAutomatic; %will automatically search?
fineV = get(handles.fineMenu,'String');
fine=str2double( fineV{get(handles.fineMenu,'Value'),1});
width=handles.width;
height= handles.height;
angle=handles.angle;
xo=handles.xo;
yo=handles.yo;

imwrite(handles.BW,strcat('output\bin_',handles.name));
%THR = [thr thrNorm v dirImgRef];
fileID =fopen('config\config.dat','w');
fprintf(fileID, '%2s %2s %2s %2s %24s %50s %30s %45s %8s %8s %8s %8s\n',...
    'search','thr','thrNorm','Normalización','img_ref','false_Pos', ...
    'dir_Mask','width','height','angle','xo','yo');
fprintf(fileID,'%1i %1.4f %2.3f %2.3f %4i %15s %5i %50s %8i %8i %8.3f %8.3f %8.3f\n',...
    searchAutomatic,fine, thr, thrNorm, v, dirImgRef, compConect,...
    dirMask,width,height,angle,xo,yo);
fclose(fileID);

% --- Executes on button press in refImageButton.
function refImageButton_Callback(hObject, eventdata, handles)
bussyOn(hObject, eventdata, handles);
[name, path]=uigetfile('*.tif','Load Reference Image');

if name == 0
    set(handles.bussy,'BackgroundColor',[0 1 0]);
    return
end
ImgRefPath = fullfile(path,name);
handles.ImgRefPath = ImgRefPath;
imgRef = imread(ImgRefPath);
axes(handles.refImgBox)
imshow(imgRef);
%axis off
handles.refImgBox=imgRef;

handles.imgRef=imgRef;
handles.graphic=1;
guidata(hObject,handles);
selectNorm_Callback(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function listboxNorm_CreateFcn(hObject, ~, ~)
if ispc && isequal(get(hObject,'BackgroundColor'), ...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in selectNorm.
function selectNorm_Callback(hObject, eventdata, handles)
 bussyOn(hObject, eventdata, handles);

imgNorm=handles.imgNorm;
v=get(handles.selectNorm,'Value');
set(handles.refImageButton,'Visible','off');

img=handles.image;
switch v
    case 1 % Intensity Adjustment to increase the contrast of an image
        % The 1% of data is saturated at low and high intensities of Image 
        imgNorm = imadjust(img, stretchlim (img), []);
    case 2 % Enhance contrast using histogram equalization
        n = 256 ; %n levels
        imgNorm=histeq(img,n);
    case 3 % Histogram Correspondence
        
        set(handles.refImageButton,'Visible','on');
        % Overall standardization technique using Histogram Correspondence
        if any(handles.imgRef)
            imgNorm= HMatch(img, handles.imgRef, 2000,handles.graphic);
        end      
    case 4 % Windowed Histogram Equalization
        imgNorm = normLHE(img,25,25,handles.graphic);
    case 5 % Gamma Correction
        set(handles.refImageButton,'Visible','on');
        if any(handles.imgRef)
            imgNorm = normGIC(img, handles.imgRef,handles.graphic);
        end
end
handles.imgNorm=imgNorm;
guidata(hObject,handles)
segmentation_operations(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function selectNorm_CreateFcn(hObject, ~, ~)

if ispc && isequal(get(hObject,'BackgroundColor'), ...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in connectedComp.
function connectedComp_Callback(hObject, eventdata, handles)
set(handles.bussy,'BackgroundColor',[1 0 0]);
handles.graphic = 1;
guidata(hObject,handles)
segmentation_operations(hObject, eventdata, handles);

% --- Executes during object creation, after setting all properties.
function new_Config_CreateFcn(~, ~, ~)

% --- Executes on button press in rotCentButton.
function rotCentButton_Callback(hObject, eventdata, handles)

set(handles.bussy,'BackgroundColor',[1 0 0]);
guidata(hObject,handles)
segmentation_operations(hObject, eventdata, handles);

% --- Executes on button press in searchH.
function searchH_Callback(hObject, eventdata, handles)
bussyOn(hObject, eventdata, handles);
handles.searchAutomatic=1;
img=handles.image;
imgNorm = handles.imgNorm;
%cntPxB=[];
%fine=0.02380;% determines how fine the search parameter is 
fineV = get(handles.fineMenu,'String');
fine=str2double( fineV{get(handles.fineMenu,'Value'),1});
cnt=1;

x=(0:fine:1);
cntPxB = zeros(1,numel(x)); 
cntPxB1 = zeros(1,numel(x));

for thr = 0:fine:1
    bw=segmImExtMin( img,roundn(thr,-3),26,0); % ( I,h,conn,figure )
    bw1=segmImExtMin( imgNorm,roundn(thr,-3),26,0); % ( I,h,conn,figure )
    imshow(bw);
    cntPxB(cnt)= (nnz(bw)/numel(bw)); 
    cntPxB1(cnt)= (nnz(bw1)/numel(bw1));
    cnt=cnt+1;
end

orden=3;
f1 = diff(cntPxB);       % finding the relative highs and lows
f12 = diff(cntPxB,orden); % finding the turning points
fig = figure(2);
fig.Name = 'Automatic search the  H-min threshold';
fig.NumberTitle='off';
fig.Position=[5,400,560,420];
subplot(211)
plot(x,cntPxB)
hold on;
title('Binarization H-Min')
xlabel('h','FontSize',10,'FontWeight','bold','Color','r');
ylabel('\rho bl(h) ','FontSize',10,'FontWeight','bold','Color','b');
f1(end+1)= 0;

for o = 1:1:orden
    f12(end+1)=0; %#ok<*AGROW>
end
plot (x,f1,'--');   % 1st derivative
plot (x,f12,'g-.'); % derived from higher order
grid on
%[peak_value, peak_location] = findpeaks(f1); % Find spikes
% plot ( x(peak_location),peak_value,'go');   % peaks of the first derivative

[peak_value, peak_location] = findpeaks((f12),'minpeakheight', ...
    max((f12))*0.8);% Look for peaks of a minimum height
%[peak_value, peak_location] = findpeaks(abs(f1),'minpeakdistance',0.05);     % Find peaks separated by a minimum distance
%[peak_value, peak_location] = findpeaks(f1,'threshold',0.5);                 % Find only peaks above a certain limit using the "Threshold" parameter                                                                              
%[peak_value, peak_location] = findpeaks(f1,'npeaks',5);                      % Find only a number of peaks
%[peak_value, peak_location] = findpeaks(f1,'sortstr','ascend');              % returns an ordered list of peaks.
                                                                              % values "ascend", "descend" and "none"
                                                                              % target threshold with the highest value of the higher order derivative
loc=peak_location(find(ismember(peak_value,max(peak_value))));                %#ok<FNDSB> % target location
thr = x(loc);                                                                 % threshold value of the transform H
                                                                              % If the target found is greater than 99% of white pixels 
                                                                              % it means that there is nothing in the segmentation, 
                                                                              % so the next highest value of white pixels is taken
if cntPxB(loc)> 0.997
    [~,c]=size(peak_value);
    if c > 1
        loc=peak_location(find(peak_value==max(peak_value))-1);
        thr = x(loc);
    else                                                                      % if you only find one peak you need to increase the search range
        [peak_value, peak_location] = findpeaks((f12),'minpeakheight',...
            max((f12))*0.1);       
        loc=peak_location(find(peak_value==max(peak_value))-1);
        thr = x(loc);
    end    
end
x(loc)
thr=thr+0.01;
% plot ( x(peak_location),peak_value,'go');                                   % peaks of the higher order derivative
% plot ( x(loc),peak_value,'r*');%
set(handles.value,'String',roundn(thr,-3));
set(handles.levels,'Value',roundn(thr,-3));
handles.thr = thr;                                                            % optimal h value
                                                                              % comparison between derivatives in the imgBox without normalizing
% [lmval,indd]=lmin((f1));
% [lmval2,indd2]=lmin((f12));
% %  plot ( x(indd),lmval,'ro');                                              % minimum of the 1st derivative
% %  plot ( x(indd2),lmval2,'go');                                            % minima of the higher order derivative
% ind=matchVect(indd,indd2);                                                  % find the values that are equal in the two index vectors
% % plot ( x(ind),cntPxB(ind),'b*');                                          % Common minimums for the 1st derivative and the higher order derivative
% lmvalfinal= abs(abs(f1(ind))+ abs(f12(ind)));                               % sum (abs) of the common minimums
% [obj posF]= max(lmvalfinal);                                                % max value of combination of derivatives
x1=[thr thr];
y1=[-1 1];
plot(x1,y1,'r');                                                              % target found
legend('\rho bl(h)','\rho bl´(h)','\rho bl´´´(h)',strcat('h_O_p_t = ',...
    num2str(thr,'%.3f')))

%% Search for maximums and minimums for the normalized imgBox

subplot(212)
plot(x,cntPxB1)
f2=diff(cntPxB1);                                                             % 1st derivative
hold on;
title('Binarization H-Min Normalized image')
xlabel('h','FontSize',10,'FontWeight','bold','Color','r');
ylabel('\rho bl(h) ','FontSize',10,'FontWeight','bold','Color','b');
f2(end+1)=0;
f22=diff(cntPxB1,orden);                                                      % higher order derivative
for o= 1:1:orden
    f22(end+1)=0;                                                             % filled with zeros according to the order of the derivative
end
plot (x,f2,'--');                                                             % 1st derivative
plot (x,f22,'g-.');                                                           % higher order derivative
grid on
[peak_value, peak_location] = findpeaks((f22),'minpeakheight', ...
    max((f22))*0.8);% Look for peaks of a minimum height
                                                                              % target threshold with the highest value of the higher order derivative
loc=peak_location(find(peak_value==max(peak_value)));                         %#ok<FNDSB> % target location
thrNorm = x(loc);                                                             % threshold value of the transform H
                                                                              % if the target found is greater than 99% of white pixels it means
                                                                              % that there is nothing in the segmentation, so the next highest value of white pixels is taken
if cntPxB1(loc)> 0.997 
    [~, c]=size(peak_value);
    if c > 1
        loc=peak_location(find(peak_value==max(peak_value))-1);
        thrNorm= x(loc);
    else % 
        [peak_value, peak_location] = findpeaks((f22),'minpeakheight', ...
            max((f22))*0.1);       
        loc=peak_location(find(peak_value==max(peak_value))-1);
        thrNorm= x(loc);
    end
    
end
thrNorm=thrNorm + 0.02;
% plot ( x(peak_location),peak_value,'go');% 
% plot ( x(loc),peak_value,'r*');% 

set(handles.valueNorm,'String',roundn(thrNorm,-3));
set(handles.levelsNorm,'Value',roundn(thrNorm,-3));
handles.thrNorm = thrNorm;
% % comparison between derivatives in the normalized imgBox
% 
% [lmval,indd]=lmin((f2));
% [lmval2,indd2]=lmin((f22));
% % plot ( x(indd),lmval,'ro')
% % plot ( x(indd2),lmval2,'g*');
% ind=matchVect(indd,indd2);
% plot ( x(ind),cntPxB1(ind),'b*');
% lmvalfinal= abs(abs(f2(ind))+ abs(f22(ind)));
% [obj posF]= max(lmvalfinal) ; 
% plot(x(ind(posF)),obj,'g*'); 

x1=[thrNorm thrNorm];
y1=[-1 1];
plot(x1,y1,'r'); % target found

legend('\rho bl(h)','\rho bl´(h)','\rho bl´´´(h)',strcat('h_O_p_t = ', ...
    num2str(thrNorm,'%.3f')))
%handles.graphic=0;
guidata(hObject,handles);
segmentation_operations(hObject, eventdata, handles);


% --- Executes during object creation, after setting all properties.
function fineMenu_CreateFcn(hObject, ~, ~)
% hObject    handle to fineMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not crehandles)ated until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), ...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
hfig=get(0,'Children');
delete(hfig)

