function [ labelVar, nameFolder] = tagVar( prefix,nVar,orden)
%TAGVAR
    % Label variables by type, either ordered/interleaved coordinates, angles or coordinates and angles
    % Input variables
    %******* Choice of variables in the PCA *******************************
    % Coordinates only          vpca=0
    % Angles only               vpca=1
    % Coordinates and angles    vpca=2
    %     nVar = number of variables to be labelled
    %     orden = 1, Coordinates ordered first nX and then nY
    %     Orden = 0, intercalated coordinates [x1,y1,x2,y2....]
    %   Ouputs
    %       labelVar = Vector with the labelled variables
    %       nameFolder = Label with the name of the directory to be created
    %__________________________________________
    % HISTORY: 
    %     Date: revised 2-Jan-2017 14:51:05
    %     Author: Sáenz Jhon J
    %     Version: 1.0
    %     Changes:  
    % _____________________________________________________________________
labelVar = cell(1,nVar);
cnt=1;
switch prefix
    case 'C' % Coordinates only 
        for  i=1:nVar
            if orden == 1 %
                if i<nVar/2+1
                    labelVar{1,i}=strcat('X',num2str(i));
                else
                    labelVar{1,i}=strcat('Y',num2str(i-nVar/2));
                end
            else         %intercalated coordinates
                if mod(i,2)==1
                    labelVar{1,i}=strcat('X',num2str(cnt));
                else
                    labelVar{1,i}=strcat('Y',num2str(cnt));
                    cnt=cnt+1;
                end
            end
        end
        nameFolder= 'PCA_Coordinates';
    case 'A' % Angles only  
        for  i=1:nVar
            labelVar{1,i}=strcat('A',num2str(i));
        end
        nameFolder= 'PCA_Angles';
    case 'CA' % Coordinates and angles
        for  i=1:nVar
            if orden == 1 %
                if i>=(2*nVar/3)+1
                    labelVar{1,i}=strcat('A',num2str(i-2*nVar/3));
                else
                    if i<nVar/3+1
                        labelVar{1,i}=strcat('X',num2str(i));
                    else
                        labelVar{1,i}=strcat('Y',num2str(i-nVar/3));
                    end
                end
         
            else         % intercalated coordinates
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
        nameFolder= 'PCA_Coordinates_Angles';
    otherwise
        disp('Error!!!, prefix only C, A, CA ')
end

end

