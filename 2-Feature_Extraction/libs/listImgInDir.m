function [ imgIxJdim, dataCones,contours ,names ] = listImgInDir( path,N)
%revisa en una carpeta si hay archivos .tif para luego crear una matriz con
%ellos y listarlos
% las imagenes representen la serie temporal del crecimiento de los conos
% neuronales
%VARIABLES:   Entrada: Directorio padre de las imagenes
%          Salida:
%               imgIxJdim   Matriz, columnas con las imágenes binarias de Alto*ancho(I*J)dimensiones
%               dataCones   Vector, que almacena'Perimeter', 'area', 'Orientation',
%                           'Centroid','BoundingBox', por cada cono (imagen).
%               countours   Matriz, columnas con las coordenadas X,Y de N
%                           puntos equidistantes en el contorno del cono, la columna es
%                           de tamaño X*Y
%               names       vector columna con los nombres de la imagenes
%                           encontradas
%          Nota:
%__________________________________________
% HISTORIAL:                                                           %
%       +Fecha de realizacion: revisado 18-Nov-2016 14:54:13                         %
%       +Autor: Saenz Jhon J
%       +Version: 1.0                                                  %
%       +Cambios: -                                                    %
%       +Descripcion de los cambios:
% ojo evaluar si se requiere comprobar la existencia de objetos
% pequeños, se podría evitar este paso.
%_______________________________________________________________________________
%%
if ~exist('N','var')
    N = 250; % puntos equidistantes en el contorno
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
%             'No hay ninguna imagen en la carpeta especificada',...
%             'MENSAJE',...
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
        img = not(im2bw(img(:,:,1)));
    end
    [I,J] = size(img);
    %% Limpiar la imagen de pequeños objetos, me quedo con el de mayor tamaño
    % Etiquetar elementos conectados
    [L Ne] = bwlabel(img,8);
    % Calcular las propiedades de los objetos en la imagen
    property = regionprops(L,'basic');
    %  busca una área especifica
    s=max([property.Area]);%
    m=find([property.Area]<s);
    Mask =zeros(size(L));
    for j = 1:size(m,2)
        d= round(property(m(j)).BoundingBox);
        img(d(2):d(2)+d(4),d(1):d(1)+d(3))=0;
        Mask = Mask + (L==(m(j)));
    end
    img = not(img);
    % verificar el tamaño de la imagen
    if (I ~= size(img,1))
        img(end,:) =[];
    end
    if (J ~= size(img,2))
        img(:,end) =[];
    end
    imgInDir{i} = img;
    
    %% transforma la imagen en un vector columna
    imgIxJdim(:,i)=reshape(imgInDir{i},(I*J),1);
    %% obtener el contorno
    nlevels = 1;
    [xsize,ysize]=size(img);
    xv = (1:xsize)-(xsize/2);
    yv = (1:ysize)-(ysize/2);
    [x y] = meshgrid(xv,yv);
    % buscando el perimetro
    bounds = cell(0);
    for t = unique(img(:))'
        bounds{end+1} = bwperimtrace(img == t,[xv(1) xv(end)],[yv(1) yv(end)]);
    end
    % -----coordenadas obtenidas del perimetro del cono--------------
    rawCoordinates = bounds; %
    xx=rawCoordinates{1, 1}{1, 1}(:,1); % coordenadas en el eje x
    yy=rawCoordinates{1, 1}{1, 1}(:,2); % coordenadas en el eje y
    % -----perimetro del cono
    dataCone  = regionprops(~img,'Perimeter','area','Orientation','Centroid','BoundingBox');
    dataCones{i}= dataCone;
    %----------------------------------------------------------------
    %% obtener el contorno espaciado N puntos equidistantes
    
    [pt,dudt,fofthandle] = interparc([0:(1/N):1],xx,yy,'pchip');
    pt(end,:)=[]; % elimina el ultimo punto que coincide con el primero (cierra el arco)
    
    contours(:,i)=reshape(pt,(N*2),1);
    
    %%   **descomente para ver el contorno y los puntos equidistantes
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
    %         rectangle('Position',[dataCone(n).BoundingBox(1)-(xsize/2),dataCone(n).BoundingBox(2)-(ysize/2),dataCone(n).BoundingBox(3),dataCone(n).BoundingBox(4)],'EdgeColor','y','LineWidth',1);
    %         xc= dataCone(n).Centroid(1)-(xsize/2);
    %         yc= dataCone(n).Centroid(2)-(ysize/2);
    %         plot(xc,yc,'*'); %dibuja el centro de masa de los objetos
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

