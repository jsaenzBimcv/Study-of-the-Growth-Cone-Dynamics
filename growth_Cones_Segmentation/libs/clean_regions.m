function [bw, Mask] = clean_regions(bw,g) 
%CLEAN_REGIONS
% Removes regions of a binary image using connected components. 
% The output image contains the region with the largest area. 
% VARIABLES:
%   Inputs:
%       bw  =   image, logical array of any dimension                              
%   Output:
%       bw  = Image without false positives, returned as a logical matrix 
%             of the same size as bw
%       Mask= Image with the elements to be removed, returned as a logical
%             array the same size as bw
% ________________________________________
% HISTORY:                                                    
%       +Date:      14/07/2016                          
%       +Author:    Saenz Jhon
%       +Version:   1.0                    
%       +Changes:   -               
%       +Description: -                                 
%__________________________________________

%bw = imread('bin_01_01_10-10118.tif');  
bw = not(bw);
%imshow (bw);
%% Label connected components 
[L, ~] = bwlabel(bw,8);

%% Calculate the properties of the objects in the image
property = regionprops(L,'basic');

%%  search for a specific area
%  cla
s=max([property.Area]);%
m=find([property.Area]<s);

%% remove areas
Mask =zeros(size(L));
for n = 1:size(m,2)
 d= round(property(m(n)).BoundingBox);
 bw(d(2):d(2)+d(4),d(1):d(1)+d(3))=0;
 Mask = Mask + (L==(m(n)));    
end 
bw = not(bw);
%% plot   
if g
% plot connected components
fig = figure(4);
fig.Name='Remove False Regions';
fig.NumberTitle='off';
fig.Position=[5,85,560,235];
subplot(121);
imshow(label2rgb(L));
hold on
%% plot the contour boxes of the objects
for n = 1:size(property,1)
    rectangle('Position',property(n).BoundingBox,...
        'EdgeColor','g','LineWidth',2);
    x= property(n).Centroid(1);
    y= property(n).Centroid(2);
    plot(x,y,'*');
end
%% limits 
B=bwboundaries(bw);
for k = 1:length(B)
    boundary = B{k};
    plot(boundary(:,2),boundary(:,1),'b','LineWidth',1)    
end
%%  plot a specific area
for n = 1:size(m,2)
     rectangle('Position',property(m(n)).BoundingBox, ...
         'EdgeColor','r','LineWidth',2);
end 
% Mask 
subplot(122);
imshow (Mask);
end

 
 
 