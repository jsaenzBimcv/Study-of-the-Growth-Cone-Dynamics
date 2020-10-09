function [ imgIxJdim, dataCones,contours ,names ] = listImgInDir( path,N)
% Lists binary images with a .tif extension contained in a directory.  
% The images represent the time series of the movement of a growth cone. 
% The aim is to extract the morphometric characteristics from 
% the coordinates obtained from a set of equidistant points around 
% the contour of the growth cone.
% To study a population of growth cones it is required that the reference 
% points obtained from the contour are all located in a common point. 
% The base of the cone is taken as the initial point and the rest of 
% the points are numbered clockwise until a closed curve 
% of 250 equidistant points is completed.   

% VARIABLES: 
%   Input: 
%       path  -     Image parent directory
%       N     -     Number of equidistant points 
%  Outputs:
%       imgIxJdim -  Matrix, columns with the binary images of 
%                    Height*Width(I*J)dimensions
%       dataCones -  Vector data, which stores 
%                    'Perimeter', 'area', 'Orientation',
%                    'Centroid', 'BoundingBox', per cone (image).
%       countours -  Matrix, columns with the X,Y coordinates of N
%                    Equidistant points on the cone contour, 
%                    the column is of size X+Y
%       names     -  vector column with the names of the image found
%__________________________________________
%   HISTORY: 
%   Date: revised 18-Nov-2016 14:54:13
%   Author: Sáenz Jhon J
%   Version: 1.0
%   Changes: 
%   Description of the changes:
%_______________ __________________________________________________________
%%
if ~exist('N','var')
    N = 250; % Number of equidistant points
end

dataCones = [];
imgIxJdim = [];
contours = [];
names = [];

dirTemp = cd;
cd(path)
lista = dir('*.tif*');
[n,~] = size(lista);
if isequal(n,0)
%         msgbox(...
%             'There is no image in the specified folder',...
%             'Message',...
%             'help')
    cd(dirTemp)
    return
end
names = cell(n,1);

for i = 1:n
    names{i} = lista(i).name;
end

for i = 1:n
    
    img =imread(names{i});
    if islogical(img)
        img = not(img(:,:,1));
    else
        img = not(imbinarize(img(:,:,1)));
    end
    [I,J] = size(img);
    %% Cleaning up the image of small objects, I stick with the biggest
    % Label connected elements
    [L, ~] = bwlabel(img,8);
    % Calculate the properties of the objects in the image
    property = regionprops(L,'basic');
    %  search for a specific area
    s=max([property.Area]);%
    m=find([property.Area]<s);
    Mask =zeros(size(L));
    for j = 1:size(m,2)
        d= round(property(m(j)).BoundingBox);
        img(d(2):d(2)+d(4),d(1):d(1)+d(3))=0;
        Mask = Mask + (L==(m(j)));
    end
    img = not(img);
    % check image size
    if (I ~= size(img,1))
        img(end,:) =[];
    end
    if (J ~= size(img,2))
        img(:,end) =[];
    end
    imgInDir{i} = img;
    
    %% transforms the image into a column vector
    imgIxJdim(:,i)=reshape(imgInDir{i},(I*J),1);
    %% get the contour
    
    [xsize,ysize]=size(img);
    xv = (1:xsize)-(xsize/2);
    yv = (1:ysize)-(ysize/2);
    
    % searching the perimeter
    bounds = cell(0);
    for t = unique(img(:))'
        bounds{end+1} = bwperimtrace(img == t,...
            [xv(1) xv(end)],[yv(1) yv(end)]); %#ok<*AGROW>
    end
    % ----- coordinates obtained from the perimeter of the cone -----------
    rawCoordinates = bounds; %
    xx=rawCoordinates{1, 1}{1, 1}(:,1); % x-axis coordinates
    yy=rawCoordinates{1, 1}{1, 1}(:,2); % y-axis coordinates
    % -----perimetro del cono
    dataCone  = regionprops(~img,'Perimeter','area','Orientation', ...
        'Centroid','BoundingBox');
    dataCones{i}= dataCone;
    %----------------------------------------------------------------------
    %% obtain the spaced contour N equidistant points
    
    [pt,dudt,fofthandle] = interparc((0:(1/N):1),xx,yy,'pchip');
    % eliminates the last point that coincides with the first one (closes the arc)
    pt(end,:)=[]; 
    
    contours(:,i)=reshape(pt,(N*2),1);
    %%   **decommentary to see the contour and the equidistant points
    %     nlevels = 1;
    %     [x, y] = meshgrid(xv,yv);
    %     figure(1)
    %     subplot(1, 2, 1);
    %     imshow(img,[0 nlevels-1],'Xdata',[xv(1) xv(end)],'Ydata',[yv(1) yv(end)]);
    %     hold on;
    %     colors = jet(nlevels);
    %     for i = 1:nlevels
    %         for j = 1:length(bounds{i})
    %             plot(bounds{i}{j}(:,1),bounds{i}{j}(:,2),'Color',colors(i,:))
    %         end
    %     end
    %     axis image;
    %
    %     for n = 1:size(dataCone,1)
    %         rectangle('Position',[dataCone(n).BoundingBox(1)-(xsize/2),...
    %               dataCone(n).BoundingBox(2)-(ysize/2),...
    %               dataCone(n).BoundingBox(3),...
    %               dataCone(n).BoundingBox(4)],...
    %               'EdgeColor','y','LineWidth',1);
    %         xc= dataCone(n).Centroid(1)-(xsize/2);
    %         yc= dataCone(n).Centroid(2)-(ysize/2);
    %         plot(xc,yc,'*'); %draws the centre of mass of the objects
    %     end
    %     title 'Cone contour'
    %     hold off;
    %
    %     % ***************
    %     subplot(1,2,2);
    %     plot(xx,yy,'r*',pt(:,1),pt(:,2),'b-o')
    %     axis image ij;
    %     grid on
    %     xlabel X
    %     ylabel Y
    %     title 'Points in blue are uniform in arc length around the cone'
    %     %-----------------------------------------------------
    %
    disp(strcat(' files:_ ',num2str(i),'_of_',num2str(n),'_File: ', names{i}));
end
cd(dirTemp)
end

