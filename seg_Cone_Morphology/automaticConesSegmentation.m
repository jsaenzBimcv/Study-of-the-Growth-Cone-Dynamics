function [BW, BW1] = automaticConesSegmentation(img)
% automaticConesSegmentation
% Binarize, resize and rotate the image with the parameters provided in the 
% config.dat file
%
% img      - Input image.
% RESULTS - Binary image.

%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
bw=zeros(size(img));
imgNorm=bw;
%% Read config.dat file
[search,fine,thr,thrNorm,Norm,dirImg_ref,false_pos,dirMask,width,height,...
    angle,xo,yo] = textread('config\config.dat',...
    '%s %s %s %s %s %s %s %s %s %s %s %s %s', 2);
%% if the normalization uses a reference image
if (Norm{2,1} == '3')||(Norm{2,1} == '5')
    imgRef=imread(dirImg_ref{2,1});
end

switch str2double(Norm{2,1})
    case 1 % Intensity Adjustment
        imgNorm = imadjust(img, stretchlim (img), []);
    case 2 % Histogram Equalization
        n = 256 ; %n levels
        imgNorm=histeq(img,n);
    case 3 % Histogram Correspondence
        if any(imgRef)
            imgNorm= HMatch(img,imgRef, 2000,0);
        end
    case 4 % Histogram equalization using M x N windows
        imgNorm = normLHE(img,25,25,0);
        
    case 5 % Gamma Intesity Correction
        if any(imgRef)
            imgNorm = normGIC(img,imgRef,0);
        end
end
%% segmentation
% Is the search for thr and thrNorm values normalized?
if (search{2,1} == '1')  % Find the values from the tuning box value
    fineV=str2double(fine{2,1});
    [thr_, thrNorm_] = searchH(img,imgNorm,fineV);
    thr_=thr_+0.01;
    thrNorm_=thrNorm_+0.02;
else
    % Use the values in the config.dat file
    thr_= roundn(str2double(thr{2,1}),-3); %
    thrNorm_=roundn(str2double(thrNorm{2,1}),-3);%
end

% H-min segmentation without  normalized
bw=segmImExtMin( img,thr_,26,0);
% H-min segmentation normalized
bwNorm=segmImExtMin( imgNorm,thrNorm_,26,0);

% segmentation Grey levels
bwAut = segmGrayLevels( imgNorm,2,0);

% Get the intersection between the segmentations
BW = comparing(bwAut, bw, bwNorm, 0);

%% Have connected components been used?
if str2double(false_pos{2,1})
    % mask generated with conesSegmentation.m
    Mask=(imbinarize(imread(dirMask{2,1})));
    Mask=Mask(:,:,1);
    % clean BW using the mask
    BW = (  BW | Mask  ); 
    % Remove small objects using connected components
    [BW, ~]= clean_regions(BW,0); 
end

%% image show
imshowpair(img,BW);
BW1=BW;
%% resize and rotate the image with the parameters provided in the config.dat file
[BW,~,~,~]=newSizeImg( BW,str2double(width{2,1}), ...
    str2double(height{2,1}),0 ,str2double(angle{2,1}), ...
    str2double( xo{2,1}),str2double( yo{2,1}));
