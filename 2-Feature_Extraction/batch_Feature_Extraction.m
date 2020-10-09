%% batch_Feature_Extraction.m
% Organizes the study classes and extracts the coordinates (x,y) 
% of the contours from the binary images chosen in the previous step. 
% When starting the script you must indicate the directory 
% with the segmentations

% When finished, a new folder (/data) is generated with a coordinate file 
% for each Time-lapse, the file name is coded as follows 
%contours_nameClass_nameCone.mat.

% contours_nameClass_nameCone.mat contains a matrix of 
% size (X coordinates + Y coordinates) x frames, for this case 500x120, 
% It is equivalent to 250 equidistant points in a 120-frame time-lapse.

% VARIABLES: Input: Parent image directory
%            Output: contours_nameClass_nameCone.mat
% Note:
% __________________________________________
% HISTORY: 
% 	Date: revised 18-Nov-2016 14:54:13
%   Author: Sáenz Jhon J
%   Version: 1.0
%   Changes: 
%   Description of the changes: %
%__________________________________________
%%
clc
clear
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

% if exist(cpath,'dir') ~=7
%     error('??? Path %s not found.',cpath)
% end

%% Listing Directories
D = rdir('**\*','isdir>0');
nD=length(D);% number of directories
% listDirPath = cell(1,4);
%listDir = [];
imgIxJdim = [];
imgInDir=[];
names=[];
cont=0;
%% create data directory
% create the paths for folders and output files
FolderName = '\extracted_features';
PathFolder = [cpath FolderName];
mkdir(PathFolder);
cd (PathFolder);
%%
% number of equidistant points on the cone contour
N=250;
for i = 1:nD
    waitbar(i/nD,bp);
    s = D(i).name;
    path = strcat(cpath,'\',s);
    [ imgIxJdim, dataCones,contours ,names ] = listImgInDir( path,N);
    % sort the coordinates
    contours = reorder_coordinates(contours);
    if (length(names) ~=0)
        cont=cont+1;
        j = max(strfind(s,filesep))+ 1;% '\'
        %         listDir{cont,1} = s(j:end);
        %         listDirPath{cont,1} = s;        %   path
        %         listDirPath{cont,2} = s(j:end); %   name
        %         listDirPath{cont,3} = names;    %   names Files
        %         listDirPath{cont,4} = imgIxJdim; %   image data
        classes(cont).clase = s(1:j-2);  %#ok<*SAGROW> %   sort
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
%% uncomment to obtain recursively the list of .tif files
% cd(cpath)
% %List of all .tif files with characteristics
% f = rdir([cpath filesep '**' filesep '*.tif']);
% n = length(f);
% listFile = cell(n,1); 
% listFilePath = cell(n,1);
% 
% for i = 1:n
%     
%     s = f(i).name;
%     j = max(strfind(s,filesep))+ 1;
%     listFile{i} = s(j:end);
%     listFilePath{i} = s;
% end
close(bp); 
cd(diract)
datestr(now)
toc
disp(strcat('View Ouput Data In: ',PathFolder));