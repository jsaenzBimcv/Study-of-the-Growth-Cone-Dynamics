function [ labelVar, nameFolder] = tagVar( prefix,nVar,orden)
%TAGVAR
    %   Etique las variables a partir del tipo, ya sea coordenadas ordenadas / intercaladas, ángulos o coordenadas y angulos
    %   Variables de entrada
    %*******Elección de variables en el PCA*******************************
    % sólo coordenadas      vpca=0
    % sólo ángulos          vpca=1
    % Coordenadas y angulos vpca=2
    %     nVar = número de variables a etiquetar
    %     orden = 1, coordenadas ordenadas 1ero nX y luego las nY
    %     Orden = 0, coordenadas intercaladas[x1,y1,x2,y2....]
    %   Variables de salida
    %       labelVar = vector con las variables etiquetadas
    %       nameFolder = etiqueta con el nombre del directorio a crear
     %__________________________________________
    % HISTORIAL:                                                           %
    %       +Fecha de realización: revisado 2-Ene-2017 14:51:05                         %
    %       +Autor: Saenz Jhon J
    %       +Versión: 1.0                                                  %
    %       +Cambios: -                                                    %
    %       +Descripción de los cambios:                         %
    %_______________________________________________________________________________

labelVar = cell(1,nVar);
cnt=1;
switch prefix
    case 'C' % sólo coordenadas
        for  i=1:nVar
            if orden == 1 %coord ordenadas
                if i<nVar/2+1
                    labelVar{1,i}=strcat('X',num2str(i));
                else
                    labelVar{1,i}=strcat('Y',num2str(i-nVar/2));
                end
            else         %coord intercaladas
                if mod(i,2)==1
                    labelVar{1,i}=strcat('X',num2str(cnt));
                else
                    labelVar{1,i}=strcat('Y',num2str(cnt));
                    cnt=cnt+1;
                end
            end
        end
        nameFolder= 'PCA_Coordenadas';
    case 'A' %sólo ángulos
        for  i=1:nVar
            labelVar{1,i}=strcat('A',num2str(i));
        end
        nameFolder= 'PCA_Ángulos';
    case 'CA' %Coordenadas y angulos
        for  i=1:nVar
            if orden == 1 %coord ordenadas
                if i>=(2*nVar/3)+1
                    labelVar{1,i}=strcat('A',num2str(i-2*nVar/3));
                else
                    if i<nVar/3+1
                        labelVar{1,i}=strcat('X',num2str(i));
                    else
                        labelVar{1,i}=strcat('Y',num2str(i-nVar/3));
                    end
                end
         
            else         %coord intercaladas
                if i>=(2*nVar/3)+1
                    labelVar{1,i}=strcat('A',num2str(i-2*nVar/3));
                else
                    if mod(i,2)==1
                        labelVar{1,i}=strcat('X',num2str(cnt));
                    else
                        labelVar{1,i}=strcat('Y',num2str(cnt));
                        cnt=cnt+1;
                    end
                end                  
            end
        end
        nameFolder= 'PCA_Coordenadas_Ángulos';
    otherwise
        disp('Error!!!, prefix sólo puede ser C, A, CA ')
end

end

