function BW = segmGrayLevels( I,nlevels,n )
%SEGMLEVELS 
    % Segments the image into n color/gray levels additionally performs  
    % some morphological operations on the logical image obtained 
    % INPUT      I - Input image nonsparse numeric array of any dimension
    %            nlevels - number of levels of segmentation
    %            n  - if 1 then generates a figure with the input and output images
    % OUTPUT     BW - Transformed image logical array Transformed image, 
    %                 returned as a logical array the same size as I.   
    % NOTE       It is recommended to standardize the image beforehand 
    %__________________________________________
    % Date: 13/07/2016                               %
    % create by: Saenz Jhon                                 
    % Changes: -                                         
    % Desccription: -                                %
%___________________________________________________________________________

    BW = round((nlevels-1)*(I-min(I(:)))/(max(I(:))-min(I(:))));
    BW = bwareaopen(BW,300,4);
    BW = imfill(BW,8,'holes');%Fill image regions and holes
    BW = imopen(BW,strel('disk',6));
    BW = imdilate(BW,strel('disk',1));
    BW = imclose(BW,strel('disk',2));
    BW = imopen(BW,strel('disk',8));

    %BW = imclose(BW,strel('disk',2));

    if n>0
        figure(n)
        imshowpair(I,BW);
        %imshowpair(I,BW,'montage');
    end

end

