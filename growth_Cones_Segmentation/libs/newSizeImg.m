function [imgNewSize,angle,xo,yo]=newSizeImg(im,width,height,cr,angle,xo,yo)
%NEWSIZEIMG
% Resizes a binary image with the x, y dimensions provided, 
% the dimensions of the original image must be even.
% To rotate the image, angle = 0
% Rotates the image according to three points
% click on the three points that will be taken as reference, 
% in this order:
% 1st point: base, 
% 2nd point: on the reference plane, 
% 3rd point: plane to be rotated.
%

% VARIABLES: 
%   Inputs:
%       im      = image
%       width   = width of the output image
%       height  = height of the output image
%       cr      = 1 if you want to use the interface for 
%                 find the angle of rotation
%       angle   = rotation angle with origin in xo, y0, 
%                 if 0 is set, it will give the option to search the angle 
%                 and the origin coordinates.
%       xo      = coordinate x origin of the growth cone
%       yo      = coordinate and origin of the growth cone
%   Output:
%         width x height image with the input image centred
%   Nota:
%__________________________________________
% HISTORY:                                                    
%       +Date:      13/07/2016                          
%       +Author:    Saenz Jhon
%       +Version:   1.0                    
%       +Changes:   -               
%       +Description: -                                 
%__________________________________________
im = im(:,:,1);

%% check if the dimensions of the image are even
[ysizeI,xsizeI]=size(im);
if mod(xsizeI,2)
im(:,xsizeI)=[];
xsizeI=xsizeI - 1;
end
if mod(ysizeI,2)
im(1,:)=[];
ysizeI=ysizeI-1;
end
whos im

im(:,1)=1;
im(:,xsizeI)=1;
im(1,:)=1;
im(ysizeI,:)=1;
back=900;% background size,

imgNewSize = true(back);% im2uint8(zeros(400)); %logical(ones(back));
imgNewSize((back-ysizeI+1:back),...
    ((back/2)-(xsizeI/2)+1:(back/2)+(xsizeI/2))) = im;
im = imgNewSize;
[ysize,xsize]=size(im);
%imshow(im)
%% if cr = 1, the interface is executed to indicate the reference point and the rotation

if cr
% Display image with true aspect ratio
fig = figure(5);
fig.NumberTitle='off';
fig.Name='Rotation: 3 points of reference';

imshow(im);
axis on

%image(im); 
axis image
grid on
grid minor
hold on

rx= [];
ry= [];
button=1;
i=1;
% select three points (origin,A,B )
while (button == 1)
[xp,yp,button] = ginputc(1,'Color', 'g', 'LineWidth', 1.5,...
    'LineStyle', ':','ShowPoints', true, 'ConnectPoints', true); 
%[xp,yp,button] = ginputax(1); % does not work well
plot(xp,yp,'rh');
rx(i)=xp; %#ok<*AGROW>
ry(i)=yp;
i=i+1;
plot(rx,ry);
hold on
if (i==4)
    hold off
    break
end

end
% base point
xo= rx(1); 
yo= ry(1);
% 2nd point, reference plane
x1= rx(2); 
y1= ry(2);
% 3rd point
x2= rx(3); 
y2= ry(3);
%% calculate the rotation angle
%  n1= % vector 1
%  n2= % vector 2
%  coseno=abs(dot(n1,n2)/(norm(n1)*norm(n2)));
%  ang=acosd(coseno)
% ma = (y1-yo) / ( x1 - xo);
% mb = (y2-yo) / ( x2 - xo);
% and then the tangent difference formula.
% mo = (ma - mb) / (1 + ma*mb);
angle = atand ( ( ((y1 - yo) / ( x1 - xo)) - ((y2 - yo) / ( x2 - xo)) ) ...
    / (1 + ((y1 - yo) / ( x1 - xo)) * ((y2 - yo) / ( x2 - xo)) ) );
% angle
if xo > x1
angle = 270 - angle;
else
angle = 90 - angle;
end
close(fig);
% else
%     xo=xsizeI/2;
%     yo=ysizeI;
else

if (xo==0)||(yo==0)
% if no parameters are passed, the point centred on the bottom 
% will be taken as a reference
xo=xsize/2;
yo=ysize;
end


end
%% Distance between the base point and the desired position (lower centre)
% if (yo > ysize)|(yo > (ysize*1))
%     yo=ysize;
%     dy = 0;
% else
dy =((ysize/2) - yo) ;
% end
dx= ((xsize/2) - xo);

%% move the base point to the centre
k = imtranslate(im,[dx, dy],'FillValues',255);% ,'OutputView','full'

%% rotate the image
R = imrotate(k,angle,'bicubic','crop');%
%  figure(3);
%  % imshow();
%  image(R); axis image
%% crop the image
xmin= (back-(back/2)-(width/2));
ymin= (back-(back/2)-height);
BW= imcrop(R,[xmin ymin width-1 height-1]);%[xmin ymin width height]        
imgNewSize = BW;

%% Plot the result image
% if g==1 % 
%     fig = figure(2);
%     fig.Name='Rotated and Centred Image';
%     image(imgNewSize); axis image
% end

end

