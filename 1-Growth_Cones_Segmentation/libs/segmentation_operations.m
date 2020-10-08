function segmentation_operations(hObject, ~, handles)
%% Segmentation operations

img=handles.image;
imgNorm = handles.imgNorm;

thr=handles.thr;
thrNorm=handles.thrNorm;
% segmentation H-min without normalization
bw=segmImExtMin( img,roundn(thr,-3),26,0); % ( I,h,conn,figure )
handles.bw=bw;
axes(handles.segImgBox);
imshow(bw);
axes(handles.normImgBox);
imshow(imgNorm);

% segmentation H-min with normalization
bwNorm=segmImExtMin( imgNorm,roundn(thrNorm,-3),26,0);% ( I,h,conn,figure )
handles.bwNorm=bwNorm;
axes(handles.segNormImgBox);
imshow(bwNorm);

% segmentation Gray levels
bwAut = segmGrayLevels( imgNorm,2,0);% (I,levels,figure)
handles.bwAut=bwAut;
axes(handles.autSegImgBox);
imshow(bwAut);

%% compare the relationship between segmentations
BW = comparing(bwAut, bw, bwNorm, 0);

%% connected components
cc = get(handles.connectedComp,'Value');

if cc
    [BW, Mask]= clean_regions(BW,handles.graphic);
    handles.Mask = Mask;
end
handles.BW = BW;

axes(handles.bwImagBox);
imshow(BW);
axes(handles.imgVsSeg);
imshowpair(img,BW);

cr = get(handles.rotCentButton,'Value');
if cr 
%   handles.rotate=1; 
    width=handles.width;
    height= handles.height;
    angle=handles.angle;
    xo=handles.xo;
    yo=handles.yo;   
    [BW,handles.angle, handles.xo,handles.yo]  = newSizeImg( BW,width, height,cr,angle, xo,yo);
    set(handles.rotateCenterBox,'Visible','on');
    axes(handles.rotateCenterBox);
    imshow(BW); axis on
    grid on
    grid minor
    handles.BW = BW;
else
%   handles.rotate=0;
    set(handles.rotateCenterBox,'Visible','off');
    handles.angle=0; 
    handles.xo=0; 
    handles.yo=0;
    
end

set(handles.bussy,'BackgroundColor',[0 1 0]);
guidata(hObject,handles)
