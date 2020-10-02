function BW = segmImExtMin( I,h,conn,n )
%segmImExtMin 
%   computes the extended-minima transform, which is the regional minima 
%   of the H-minima transform and morphological operations. 
%   Configured for the task of growth cone segmentation  
%   Regional minima are connected components of pixels with a constant intensity value, 
%   and whose external boundary pixels all have a higher value
%
%   INPUT      I - Input image nonsparse numeric array of any dimension
%              h - maxima transform (default) | nonnegative scalar
%              conn - Connectivity 8 (default) | 4 | 6 | 18 | 26 | 
%                     3-by-3-by- ...-by-3 matrix of zeroes and ones
%              n - if 1 then generates a figure with the input and output images
%   OUTPUT     BW - Transformed image logical array Transformed image, 
%                   returned as a logical array the same size as I.   
%   NOTE: 
%__________________________________________                             
%  Date: 13/07/2016                         
%  create by: Saenz Jhon                                
%  Changes: -                                         
%  Desccription: -                             
%___________________________________________________________________________
   
  I = im2double(I);
  BW= imextendedmin(I,h,conn);
% BW = bwareaopen(BW,300,4);
  BW = imclose(BW,strel('disk',4,4));
  BW = imfill(BW,8,'holes');

  BW = not(BW);
  if n>0 
    figure(n)
    %imshowpair(I,BW,'montage');
    imshowpair(I,BW);
  end
end

