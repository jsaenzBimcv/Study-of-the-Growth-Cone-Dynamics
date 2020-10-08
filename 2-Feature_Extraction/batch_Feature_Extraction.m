%% batch_Feature_Extraction.m
% Organiza en lotes las imágenes contenidas en las carpetas de un
% directorio, cojera del directorio padre todas las subcarpetas
% almacenando en grupos hasta encontras las imagenes
% las imágenes se guardarán en filas de dimensiones (X*Y)* t, donde X =
% ancho, Y= altura y t son las imágenes que se encuentran en la última
% carpeta y representan el crecimiento del cono
% pasos
%  1.-Recorrer directorio y seleccionar los directorios y archivos.
%  2.-Recorrer cada directorio y hacer lo mismo que el paso 1




%VARIABLES:   Entrada: Directorio padre de las imágenes
%             Salida:
%             Nota:
%__________________________________________
% HISTORIAL:                                                           %
%       +Fecha de realización: revisado 18-Nov-2016 14:54:13                          %
%       +Autor: Saenz Jhon J
%       +Versión: 1.0                                                  %
%       +Cambios: -                                                    %
%       +Descripción de los cambios:                         %
%_______________________________________________________________________________
%%
clc
clear all
%Obtener el Path del directorio actual
diract = cd;
cpath = uigetdir(cd,...
    'Choose image folder to be charged');
if isequal(cpath,0)
    msgbox(...
        'You have not chosen any folders',...
        'MESSAGE',...
        'help')
    return
end
cd(cpath)

bp=waitbar(0,'GENERATING MATRIX ... WAIT');
tic
% 
% if exist(cpath,'dir') ~=7
%     error('??? Path %s not found.',cpath)
% end

%% lista directorios
D = rdir('**\*','isdir>0');
nD=length(D);% número de directorios
% listDirPath = cell(1,4);%lista de todos los directorios con su path completo
%listDir = []; %lista de todos los directorios
imgIxJdim = [];
imgInDir=[];
names=[];
cont=0;
%% crear directorio de datos
%crear las rutas (Path) para carpetas y archivos de salida
FolderName = '\data';
PathFolder = [cpath FolderName];
% crear las carpetas para guardar los resultados
mkdir(PathFolder);
cd (PathFolder);
%%
N=250;% numero de puntos equidistantes en el contorno del cono
for i = 1:nD
    waitbar(i/nD,bp);
    s = D(i).name;
    path = strcat(cpath,'\',s);
    [ imgIxJdim, dataCones,contours ,names ] = listImgInDir( path,N);
    % ordenar las coordenadas 
    contours = reorder_coordinates(contours);
    if (length(names) ~=0)
        cont=cont+1;
        j = max(strfind(s,filesep))+ 1;% busca el string despues de un '\'
        %         listDir{cont,1} = s(j:end);
        %         listDirPath{cont,1} = s;        %   path
        %         listDirPath{cont,2} = s(j:end); %   name
        %         listDirPath{cont,3} = names;    %   names Files
        %         listDirPath{cont,4} = imgIxJdim; %   image data
        classes(cont).clase = s(1:j-2);  %   sort
        classes(cont).name = s(j:end);   %   name
        classes(cont).namesFiles = names;%   names files
        fileImgs=strcat(strrep(s,'\','_'),'.mat');% data image file
        fileDataCones=strcat('dataCones_',strrep(s,'\','_'),'.mat');% data cones        
        fileContours=strcat('contours_',strrep(s,'\','_'),'.mat');% data cones
        classes(cont).imageData = fileImgs;
        classes(cont).dataCones = fileDataCones;
        classes(cont).contoursCones = fileContours;
        classes(cont).path = s;  %path class 
        save(fileImgs,'imgIxJdim');
        save(fileDataCones,'dataCones');
        save(fileContours,'contours');

        for k=1:size(dataCones,2)
			    T(k,:) = table(dataCones{1,k}.Area,...
                    dataCones{1,k}.Centroid,dataCones{1,k}.BoundingBox,...
                    dataCones{1,k}.Orientation,dataCones{1,k}.Perimeter,...
                    'VariableNames',{'Area','Centroid_x_y',...
                    'BoundingBox','Orientation','Perimeter'});  
        end
        % name file for sort
		filename =strcat(s(1:j-2),'.xlsx');  
        filename = strrep(filename,'\','_');
        % name sheet for names files
		writetable(T,filename,'Sheet',s(j:end),'Range','A1') 

        disp(strcat('Save data files:_ ',s));
    end
    
end
% data to analize
save('dataClasses','classes'); 
disp('Save data classes');
%% descomente para obtener de forma recursiva la la lista de archivos .tif
% cd(cpath)
% f = rdir([cpath filesep '**' filesep '*.tif']); %lista de todos los archivos .tif con caracteristicas
% n = length(f);
% listFile = cell(n,1); %lista de todos los archivos .tif
% listFilePath = cell(n,1);%lista de todos los archivos .tif con su path completo
% 
% for i = 1:n
%     
%     s = f(i).name;
%     j = max(strfind(s,filesep))+ 1;
%     listFile{i} = s(j:end);
%     listFilePath{i} = s;
% end

close(bp); % Una vez que termina el ciclo se borra la barra de progreso
cd(diract)
datestr(now)
toc
disp(strcat('View Ouput Data In: ',PathFolder));

