function  [posBin,xx,yy]= vectContourImg(Ib)
% calcula el contorno de los elementos de una imagen binaria, para luego
% quedarse con N puntos (coordenadas equidistantes)

%VARIABLES:   Entrada: Ib, imagen binaria
%             Salida: matriz de coordenadas posBin,
%                       vector de coordenadas xx,
%                       vector de coordenadasyy
%             Nota:
%
%__________________________________________
% HISTORIAL:                                                           %
%       +Fecha de realización: revisado 17-Nov-2016 22:26:57                           %
%       +Autor: Saenz Jhon J
%       +Versión: 1.0                                                  %
%       +Cambios: -                                                    %
%       +Descripción de los cambios:                         %
%________________________

% http://www.lcc.uma.es/~munozp/documentos/procesamiento_de_imagenes/temas/pi_cap8.pdf
% https://es.mathworks.com/help/matlab/math/interpolating-gridded-data.html
% http://stackoverflow.com/questions/27429784/equally-spaced-points-in-a-contour

clear
clc
close all

if ~exist('Ib','var')
    Ib = imread('contornotest.tif');
end

nlevels = 1;
[xsize,ysize]=size(Ib);
xv = (1:xsize)-(xsize/2);
yv = (1:ysize)-(ysize/2);
[x y] = meshgrid(xv,yv);

%% busqueda del perímetro
subplot(2, 3, 1);
imshow(Ib,[0 nlevels-1],'Xdata',[xv(1) xv(end)],'Ydata',[yv(1) yv(end)]);
%
bounds = cell(0);
for t = unique(Ib(:))'
    bounds{end+1} = bwperimtrace(Ib == t,[xv(1) xv(end)],[yv(1) yv(end)]);
end

colors = jet(nlevels);
subplot(2,3,2);
imshow(Ib,[0 nlevels-1],'Xdata',[xv(1) xv(end)],'Ydata',[yv(1) yv(end)]);
subplot(2,3,3);
hold on;
for i = 1:nlevels
    for j = 1:length(bounds{i})
        plot(bounds{i}{j}(:,1),bounds{i}{j}(:,2),'Color',colors(i,:))
    end
end
axis image ij;
hold off;
subplot(2,3,4);
hold on;
imshow(Ib,[0 nlevels-1],'Xdata',[xv(1) xv(end)],'Ydata',[yv(1) yv(end)]);
for i = 1:nlevels
    for j = 1:length(bounds{i})
        plot(bounds{i}{j}(:,1),bounds{i}{j}(:,2),'Color',colors(i,:))
    end
end
axis image;
hold off;
posBin=bounds

xx=posBin{1, 1}{1, 1}(:,1);
yy=posBin{1, 1}{1, 1}(:,2);
%% equidistanciar los puntos
% numero de puntos
N= 250;


[pt,dudt,fofthandle] = interparc([0:(1/N):1],xx,yy,'spline');

% Plot the result
subplot(2,3,5);
axis([-1.1 1.1 -1.1 1.1])
plot(xx,yy,'r*',pt(:,1),pt(:,2),'b-o')
axis equal
grid on
xlabel X
ylabel Y
title 'Points in blue are uniform in arclength around the cone'



end