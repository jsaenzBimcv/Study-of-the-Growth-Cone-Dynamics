    % MORPHOMETRYPCA.M

% Stage 3. Dimensionality Reduction, 
% takes the organized data from stage 2. Feature Extraction for analysis 
% with PCA Principal Component Analysis (PCA)
% Directory with the data: 
%          ./Study-of-the-Growth-Cone-Dynamics/data/segmentation_output/
% contains:
%   *-Matrices with the Temporal series: built from the temporal series 
%       for each growth cone the columns of each matrix are each of the 
%       .tif images contained in each group (120 images), 
%       passing each image from 2D to 1D of 160000 positions 
%       (Height x Width, size of the images 400x400).
%   *- Data Matrix contains the information referring to all the 
%       growth cones ordered in the different groups:
%           Class:  indicated in age group 
%           name:   name of the growth cone
%           NameFiles: image names for a growth cone
%       imageData: matrix .mat file with the time series for each growth cone
%       path: location of the folder containing the growth cone images

%    steps
%    1.-loading the data.
%    2.-analyse with PCA

%   VARIABLES: 
%       Input: Parent directory with image data segmented
%       Output:
%   Note:
%__________________________________________________________________________
%     HISTORY: 
%     Date: revised 2-Jan-2017 14:51:05
%     Author: Sáenz Jhon J
%     Version: 1.0
%     Changes:      
%__________________________________________________________________________

    %   ***** Listing and creating directories ***********
    clc
    clear
    % Current directory path
    diract = cd;
    cpath = uigetdir(cd,...
        'CHOOSE DATA FOLDER TO BE CHARGED');
    if isequal(cpath,0)
        msgbox(...
            'You have not chosen any folders',...
            'MESSAGE',...
            'help')
        return
    end

    cd(cpath)% Directory with study data
    load ('dataClasses.mat')
    nFilesData = size(classes,2); % number of data files
    % data = cell(nFilesData,2);
    wf=[];
    labelObs=[];    % List of observations
    groupsG=[];     % List of groups
    nVar =0;
    % nameFolder ='\';
    % ******** previous settings ******
    % The coordinates are by default ordered 1st nX and then nY
    % if you use the interleaved coordinates [x1,y1,x2,y2....], Order = 0
    % not using order = 0 not yet implemented reorder for is option
    orden =1; 
    %******* Choice of variables/features in the PCA **********************
    % only coordinates       prefix ='C';
    % only angles            prefix ='A';
    % coordinates and angles prefix ='CA';
          prefix ='C';
    %     prefix ='A';
    %     prefix ='CA';
    %******* Organize matrix ************
    %[20:59]%
    for k=1:nFilesData % data group in coordinates (cones)
        pContoursaCones = classes(k).contoursCones; % coordinate path for a cone
        load (pContoursaCones); % load contours
        [nVar,nFrames] = size(contours);
        % nFrames: Number of images per cone (time-lapse)
        % nCoord: Number of coordinates per cone (dimensions), variables

        contoursOrd=[];% ordered contours [x1,y1,x2,y2....]
        for j=1: nFrames
            %**** loop to intercalate XY coordinates in each column vector
            % Position of the x-coordinates [1...250]
            % Position of the Y-coordinates [251...500]
            if orden == 0 % intercalated coordinates
                i2=0;
                for i=1:nVar/2
                    a=i+i2;
                    contoursOrd(a,j)=contours(i,j);
                    contoursOrd(a+1,j)=contours(i+250,j);
                    i2=i;
                end
            end
            % label observations with the name of the file
            labelObs{end+1,1}=strcat(strrep(classes(k).path,...
                '\','_'),'_F',num2str(j));%
        end
        % label the general groups 
        groupsG{end+1,1}=strrep(classes(k).clase,'\','_');
        % wf is a matrix whose columns are aleatory variables and 
        % whose rows are observations
       if orden==1
                wf= [wf;(double(contours))'];
            else
                wf= [wf;(double(contoursOrd))'];
                % save fichero.xls wf1 -ascii -tabs
            end
  
        nFilesData;
        nVar=nVar+nFrames;
        % /////////////////
    end
    % Rearrange to the furthest Y-point
    wf = reorder_coordinates (wf);
    nFilesData;
    nVar;  
    des = 0;
    range_=(1:1:500); 
    wfmin=wf(:,range_);
    switch prefix
%         case 'C'       
        case 'A' 
            angles = coord2angleVec(wfmin);  
%              angles=log10(angles);
            wf = angles(:,des+1:size(angles,2)-des);
            
        case'CA'
            angles = coord2angleVec(wfmin);
%             angles=log10(angles);
            wf= [wf angles(:,des+1:size(angles,2)-des)];            
    end
    [nObs, nVar]=size(wf);% size(score);
    % wf(find(isinf(wf(:,:))==1))=0;
    % The variables are named according to type 
    % (250 X-coordinates, 250 Y-coordinates, or angles) 
    % and give a name to the results directory
    [ labelVar, nameFolder] = tagVar( prefix,nVar,orden); 
      
    %Observations are named only if they have not been named before
    if nObs ~= size(labelObs,1)
        labelObs = cell(1,nObs);
        for  i=1:nObs
            labelObs{1,i}=strcat('O',num2str(i));
        end
    end
    % Modification, we want to evaluate the movement of neurons by sectors, 
    % so we will separate the coordinates by sectors as follows:
    
    %labelVar_base = [labelVar(1:40),labelVar(211:250),labelVar(251:290),labelVar(461:500)];
    %wf_base =[wf(:,1:40),wf(:,211:250),wf(:,251:290),wf(:,461:500)];
    %labelVar_axon =[labelVar(41:80),labelVar(171:210),labelVar(291:330),labelVar(421:460)];
    %wf_axon =[wf(:,41:80),wf(:,171:210),wf(:,291:330),wf(:,421:460)];
    %labelVar_cono =[labelVar(81:170),labelVar(331:420)];
    %wf_cono =[wf(:,81:170),wf(:,331:420)];
    
    %wf = wf_cono;
    %labelVar = labelVar_cono ;
 
    [nObs, nVar]=size(wf);   
    %% * STUDY GROUPS*
    disp(strcat('---',nameFolder,'---'));
    % ***** generate the groups and table 1 with the groups *****
    [groups, T1, listLim] = findGroups(groupsG, labelObs);
    disp(strcat('Number of Files : ',num2str(nFilesData)));
    disp(strcat('Total Observations : ',num2str(nObs)));
    disp(T1)
    t1=table2cell(T1);
    disp(strcat('Total variables : ',num2str(nVar)));
    % ****** Create results directory *****
    % Create the paths for output folders and files
    FolderResult = strcat('\',nameFolder,'_',t1{end,1});
    PathFolderResult = [cpath FolderResult];
    nameFolder=strrep(nameFolder,'_',' ');
    % Create the folders to save the results
    if not(isfolder(PathFolderResult))
        mkdir(PathFolderResult);
    end
    % **** Autovalues and Autovectors ********
    %     Each axis has a eigen value, which is related to the variability 
    %     expressed by each axis (Axis). In gral. it is expressed as a percentage
    %     var(wf(1,:)) % Calculate the variance of the 1st dimensional sample of "wf"
    %     % The covariance is analogous to the variance, 
    %     %except that it is calculated between two vectors, and not a vector and itself.
    %     cov(wf)
    %     
    %     [V, D] = eig(cov(wf));
    %     eigval = diag(D);% Column vector with the values of the diagonal of D
    %     % The eigenvalues are stored in the diagonal of D
    %     % the corresponding eigenvectors are the rows stored in V
    %     [Y,ind] = sort(abs(eigval));
    %     % Autovalues in decreasing order, is the same as the latent variable 
    %     % obtained with the PCA function
    %     eigval  = eigval(flipud(ind));  
    %     % Autovector matrix ordered, it is similar to the coefficients 
    %     % obtained with the PCA function, in some columns the sign
    %     V       = V(:,flipud(ind));    
    %     mx = mean(wf,2);                 
    %     %% cone coordinates  - mean
    % for i=1:nCoord
    %     Xm(:,i) = wf(:,i) - mx;
    % end
    %
    %     %% Autovectors de A*A'
    % u = Xm*V;
    % for i=1:500
    %     eigVectors(:,i) = u(:,i)/norm(u(:,i));   % Normalization of the Eigenvectors
    % end
    %
    cntGr = size(listLim,1);
    cntGr = cntGr-1;

    %%  * PRINCIPAL COMPONENT ANALYSIS (PCA) *
    for cg=1:cntGr

        [coeff,score,latent,tsquared,explained,mu]=pca((wf(listLim(cg,1): ...
            listLim(cg,2),:)));%(zscore(wf));
        % [coeff,score,latent]=princomp((wf));
        % [coeff,score,latent]=princomp(zscore(wf));
        
        % table2 of the contribution of each component
        nCp=24;
        for i=1:nCp
            cp(i,1)=i;
            cp(i,2)=latent(i,1);
            cp(i,3)= explained(i,1);
            cp(i,4)= sum(explained(1:i,1));
        end
        T2=table(cp(:,1),cp(:,2),cp(:,3),cp(:,4),'VariableNames',...
            {'CP' 'Eigenvalores' 'Varianza' 'Acumulativo'});
        
        varz(:,cg)=explained;
        varzAcum(:,cg)=cp(1:7,4);
        %ptsColors = ['w' , 'g',  'w'  ,'g','w' , 'g',  'w'  ,'g'  ]; %parula(cntGr);
        
        ptsColors = [ 0 0.5 0; 0. 0 0. ; 
            0 0.5 0; 0. 0 0. ; 
            0 0.5 0; 0. 0 0. ; 
            0 0.5 0; 0. 0 0. ; 
            ];
        
        for cnt = 1:cntGr
            if numel(strfind(t1{cnt},'Ataxico')) >= 1
                lb=strrep(t1(cnt,1),'2m_Ataxico',' YG8sR');
            elseif numel(strfind(t1{cnt},'Control')) >= 1
                lb=strrep(t1(cnt,1),'2m_Control',' Y47R');
            else
                lb=strrep(t1(cnt,1),'_',' ');
            end
               
            lbls{cnt}= lb{1};
            lbls{cntGr+cnt}= strcat(lb{1},' acc');
        end
        
        
        if cg==cntGr
            %             whitebg([0.8 0.8 0.8])
            
            figure('Name','Variance Explained','Position',[30 60 900 800]);
            b = bar(varz(1:7,:),'DisplayName','varz(1:7,:)','FaceColor','flat');
            set(gca,'FontSize',13)
            
            for m=1:size(varz,2)
                b(m).FaceColor = ptsColors(m,:);
            end
            grid on
            xlabel('Principal Component','FontName', 'Calibri','FontSize',28)
            ylabel('Variance Explained (%)','FontName', 'Calibri','FontSize',28) % , 'FontWeight','bold'
            title(strcat({'Explained and Accumulated';'Variance by Component'}),'FontWeight','normal','FontName', 'Calibri' ,'FontSize',32)%'FontWeight','bold' nameFolder;'Explained and Accumulated Variance by Component'
            hold on
            for k=1:cntGr
                plot([1:1:7],varzAcum(:,k),'Color', ptsColors(k,:) ,'Marker', '.','MarkerEdgeColor',ptsColors(k,:),'LineWidth',2,'MarkerSize',10)
                
            end
            
            legend(lbls)
            legend('Location','east')
            legend('boxoff')
            legend('FontSize',18)
            hold off

            barcolor=['g' , 'r',  'g'  ,'c' , 'm' , 'b', 'k' , 'w'];
            figure(20)
            hold on
            for k=1:cntGr
%                 [f,x]=hist(( wf(listLim(k,1): listLim(k,2),:)),20);%# create histogram from data distribution.
%                 %#METHOD 1: DIVIDE BY SUM
                wn=abs(0.755-(k/cntGr));
%                 bar(x,f/sum(f),wn,'FaceColor',barcolor(k));                 
                histogram(( wf(listLim(k,1): listLim(k,2),nVar)),20,...
                    'FaceAlpha',wn,'Normalization','probability',...
                    'FaceColor',barcolor(k));           
           
            end
            grid on
            switch prefix
                case 'C'
                    xlabel('X, Y coordinates','FontSize',12)
                case 'A';
                    xlabel('Angles (º)','FontSize',12)
                case'CA';
                    xlabel('X, Y coordinates, Angles (º)','FontSize',12)
            end
            legend(strrep(t1(1:cntGr,1),'_',' '))
%             ylabel('-','FontSize',12)
            title(strcat('Histogram -',t1{end,1}),'FontSize',12)            
            hold off
            
            
        end
        % T Hotelling 2 , a statistical measure of the multivariate 
        % distance of each observation from the centre of the data set.
        % This is a form of analysis to find the most extreme points in the data.
        [st2,index] = sort(tsquared,'descend'); % sort in descending order
        extremeMax = index(1)+listLim(cg,1)-1;
        obsMaxDist=labelObs(extremeMax,:); % 
        extremeMin = index(end)+listLim(cg,1)-1;
        obsMinDist=labelObs(extremeMin,:); % 

        %% * OUTPUT DATA *

        disp(strcat('________________Group: ',(t1{cg,1}),'_',nameFolder,'__________________'));
        disp(strcat('Total Observations: ',num2str(t1{cg,3})));
        disp(strcat('Percentage of variance explained. '));
        disp(T2);
        disp(strcat('The Nearest observation of the average observation. '));
        disp(obsMinDist);
        disp(strcat('The Further observation of the average observation. '));
        disp(obsMaxDist);

        %  cluster
        % [idx,C] = kmeans(score,5);

        %   %% * GRAPHICS  *
        % Grupo...
        disp(strcat('________________Group: ',(t1{cg,1}),'_',nameFolder,'__________________'));
                %         strrep(t1(1:cntGr,1),'_',' ')
        graphicPCA( coeff, score,latent, groups(listLim(cg,1): listLim(cg,2),:),...
            labelVar, labelObs(listLim(cg,1): listLim(cg,2),:), strrep(t1{cg,1},...
            '_',' '),prefix);
        
        %% * OUTPUT FILES *
        %
        disp('********** OUTPUT FILES ***************')
        disp(strcat(t1{cg,1},'_',nameFolder))
        disp(' ')
        %         fileScore=strcat(PathFolderResult,'\',t1{cg,1},'Score.mat');
        %         save(fileScore,'score');
        fileScore=strcat(PathFolderResult,'\',prefix,t1{cg,1},'Score.tsv');
        dlmwrite(fileScore,score,'delimiter','\t','precision','%.4f')
        disp(fileScore)
        %         fileCoeff=strcat(PathFolderResult,'\',t1{cg,1},'Coeff.mat');
        %         save(fileCoeff,'coeff');
        fileCoeff=strcat(PathFolderResult,'\',prefix,t1{cg,1},'Coeff.tsv');
        dlmwrite(fileCoeff,coeff,'delimiter','\t')
        disp(fileCoeff)
        %         fileLatent=strcat(PathFolderResult,'\',t1{cg,1},'Latent.mat');
        %         save(fileLatent,'latent');
        fileLatent=strcat(PathFolderResult,'\',prefix,t1{cg,1},'Latent.tsv');
        dlmwrite(fileLatent,latent,'delimiter','\t')
        disp(fileLatent)
        %                 fileLabelObs=strcat(PathFolderResult,'\',t1{cg,1},'LabelObs.tsv');
        %                 labelObsGr=groups(listLim(cg,1): listLim(cg,2),:);
        %                 save(fileLabelObs,'labelObsGr','-ascii');
        fileLabelObs=strcat(PathFolderResult,'\',prefix,t1{cg,1},'LabelObs.tsv');
%         labelObsGr=labelObs(listLim(cg,1): listLim(cg,2),:);
%         dlmwrite(fileLabelObs,labelObsGr,'delimiter','\t')
        fileID = fopen(fileLabelObs,'w');
        formatSpec = '%s\n';      
        for n =listLim(cg,1): listLim(cg,2)
            fprintf(fileID,formatSpec,labelObs{n,1});
        end
        fclose(fileID);
        disp(fileLabelObs)
%           close all
        close(1:20)

    end
    fileLabelGr=strcat(PathFolderResult,'\',prefix,t1{cg+1,1},'_','LabelGr.tsv');
    %      n=size(groups,1);
    %     labelGr=cell(n,1);
    %     for ngr = 1:n
    %         labelGr{ngr,1}=groups{ngr,4};
    %     end   
    fileID = fopen(fileLabelGr,'w');
    formatSpec = '%s\n';
    for n =1:size(groups,1)
        fprintf(fileID,formatSpec,groups{n,4});
    end
    fclose(fileID);
    disp(fileLabelGr)   
    %         fileLabelVar=strcat(PathFolderResult,'\','LabelVar.mat');
    %         save(fileLabelVar,'labelVar');
    %         dlmwrite(fileLabelVar,labelVar,'delimiter','\t')
    fileLabelVar=strcat(PathFolderResult,'\',prefix,t1{cg+1,1},'_','LabelVar.tsv');
    fileID = fopen(fileLabelVar,'w');
    formatSpec = '%s\t';
    fprintf(fileID,formatSpec,labelVar{1,:});
    fclose(fileID);
    disp(fileLabelVar)
    
    disp('********** Definitions ***************')
    disp(' ')
    disp('score, It contains the coordinates of the original data in the new coordinate system defined by the principal components')
    disp('Rows of SCORE correspond to observations and columns to components. ')
    disp(' ')
    disp('Coeff, It contains the coefficients of the principal components. (Ordered autovector matrix)')
    disp('Each column contains the coefficients for a principal component. The columns are in decreasing order of components of the variance. ')
    disp(' ')
    disp('latent,It is a vector that contains the variance explained by the corresponding principal component. (Auto-values in decreasing order)')
    disp(' ')
    disp('LabelVar, It is a vector that contains the names of the variables')
    disp(' ')
    disp('LabelObs,It is a cell array that contains the names of the observations / group')

    cd(diract)
    datestr(now)

