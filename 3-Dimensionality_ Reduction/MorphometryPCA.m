    % MORPHOMETRYPCA.M

    % Etapa 3 toma los datos organizados de la etapa 2 para analizarlos con PCA
    % directorio con los datos
    % ..\Cone_Morphology\Experimento\Etapa_2_DataClasses\DataTest_BinarImg\data
    % contiene:
    % *-Matrices con la serie Temporal: construidas a partir de la serie temporal
    %   por cada cono de crecimiento las columnas de cada matriz son cada una de
    %   las imágenes .tif contenidas en cada grupo (120 imágenes),pasando cada
    %   imagen de 2D a 1D de 160000 posiciones (Alto * Ancho, tamaño de las imágenes 400*400).
    % *- Matriz de Datos  contiene la información referente a todos los conos de crecimiento
    %   ordenados en los diferentes grupos
    %       Clase: indicada en  edad\gruporgb(17,60,49)
    %       name: nombre del cono crecimiento
    %       nameFiles: nombres de las imágenes para un cono de crecimiento
    %       imageData: archivo.mat  de la matriz con la serie Temporal para cada cono de crecimiento
    %       path: ubicaciï¿½n de la carpeta que contiene las imï¿½genes del cono de crecimiento

    % pasos
    %  1.-cargar los datos.
    %  2.-analizar con PCA

    %VARIABLES:   Entrada: Directorio padre con los datos de las imágenes
    %segmentadas

    %             Salida:
    %             Nota:
    %__________________________________________
    % HISTORIAL:                                                           %
    %       +Fecha de realización: revisado 2-Ene-2017 14:51:05                         %
    %       +Autor: Saenz Jhon J
    %       +Versión: 1.0                                                  %
    %       +Cambios: -                                                    %
    %       +Descripción de los cambios:                         %
    %_______________________________________________________________________________

    %***** Listar  y crear directorios ***********
    clc
    clear all
    %Obtener el Path del directorio actual
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

    cd(cpath)% path con el directorio que contiene los datos de estudio
    load ('dataClasses.mat')
    nFilesData = size(classes,2); % número de archivos de datos
    % data = cell(nFilesData,2);
    wf=[];
    labelObs=[];%Lista el nobre de las Observaciones
    groupsG=[];% lista los grupos
    nVar =0;
    nameFolder ='\';
    %******** configuraciones previas ******
    orden =1; % las coordenadas vienen por defecto ordenadas 1ero nX y luego las nY
    % si utiliza las coordenadas intercaladas[x1,y1,x2,y2....], Orden = 0;
    % no utilizar orden = 0 aun no está implementado el reorder para está
    % opción
   
    %*******Elección de variables en el PCA*******************************
    % sólo coordenadas       prefix ='C';
    % sólo ángulos          prefix ='A';
    % Coordenadas y angulos prefix ='CA';
          prefix ='C';
%         prefix ='A';
%           prefix ='CA';
    %******* Organizar matrix ************
    %[20:59]%
    for k=1:nFilesData %grupo de datos en coordenadas (conos)
        pContoursaCones = classes(k).contoursCones; % path de coordenadas para un cono
        load (pContoursaCones); %cargo todos los contornos
        [nVar,nFrames] = size(contours);% nFrames: numero de imágenes por cono (secuencia temporal)
        % nCoord: numero de coordenadas por cono (dimensiones), variables

        contoursOrd=[];%% contornos ordenados [x1,y1,x2,y2....]
        for j=1: nFrames
            %**** bucle para intercalar las coordenadas XY en cada vector
            %columna****
            %recordar que las coordenadas x van de la poscición[1...250]y las
            %coordenadas Y  poscición[251...500]
            if orden == 0 %%coord intercaladas
                i2=0;
                for i=1:nVar/2
                    a=i+i2;
                    contoursOrd(a,j)=contours(i,j);
                    contoursOrd(a+1,j)=contours(i+250,j);
                    i2=i;
                end
            end
            %etiquetar las observaciones con el nombre del archivo
            labelObs{end+1,1}=strcat(strrep(classes(k).path,'\','_'),'_F',num2str(j));%
        end
        %etiquetar los grupos generales
        groupsG{end+1,1}=strrep(classes(k).clase,'\','_');
        % wf es una matriz cuyas columnas son variables aleatorias
        % y cuyas filas son observaciones
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
    wf = reorder_coordinates ( wf);% reorganiza teniendo en cuenta el pto mas lejano en Y
    nFilesData;
    nVar;  
    des = 0;
    eliminar=[1:1:500]; %lo utilizo para disminur el numero de variables
    wfmin=wf(:,eliminar);
    switch prefix
%         case 'C'       
        case 'A'; 
            angles = coord2angleVec(wfmin);  
%              angles=log10(angles);
            wf = angles(:,des+1:size(angles,2)-des);
            
        case'CA';
            angles = coord2angleVec(wfmin);
%             angles=log10(angles);
             wf= [wf angles(:,des+1:size(angles,2)-des)];            
    end
    [nObs, nVar]=size(wf);%size(score);
%      wf(find(isinf(wf(:,:))==1))=0;
    % Se nombran las variables deacuerdo al tipo(250 coordenadas X, 250 coordemnadad Y, o, ángulos )
    % y da nombre al directorio de resultados
    [ labelVar, nameFolder] = tagVar( prefix,nVar,orden); 
      
    %Se nombran las observaciones solo si no se han nombrado antes
    if nObs ~= size(labelObs,1)
        labelObs = cell(1,nObs);
        for  i=1:nObs
            labelObs{1,i}=strcat('O',num2str(i));
        end
    end
    % modificación, se quiere evaluar el movimiento de las de neuronas por
    % sectores, con lo cual separaremos la coordenadas por sectores de la
    % siguiente manera:
    
    %labelVar_base = [labelVar(1:40),labelVar(211:250),labelVar(251:290),labelVar(461:500)];
    %wf_base =[wf(:,1:40),wf(:,211:250),wf(:,251:290),wf(:,461:500)];
    %labelVar_axon =[labelVar(41:80),labelVar(171:210),labelVar(291:330),labelVar(421:460)];
    %wf_axon =[wf(:,41:80),wf(:,171:210),wf(:,291:330),wf(:,421:460)];
    %labelVar_cono =[labelVar(81:170),labelVar(331:420)];
    %wf_cono =[wf(:,81:170),wf(:,331:420)];
    
    %wf = wf_cono;
    %labelVar = labelVar_cono ;
 
    [nObs, nVar]=size(wf);
    
    %% *GRUPOS DE ESTUDIO*
    disp(strcat('---',nameFolder,'---'));
    % *****generar los grupos y la tabla 1 con los grupos
    [groups, T1, listLim] = findGroups(groupsG, labelObs);
    disp(strcat('Numero de Archivos: ',num2str(nFilesData)));
    disp(strcat('Total Observaciones : ',num2str(nObs)));
    disp(T1)
    t1=table2cell(T1);
    disp(strcat('Total Variables : ',num2str(nVar)));
    %****** crear directorio de Resultados
    %crear las rutas (Path) para carpetas y archivos de salida
    FolderResult = strcat('\',nameFolder,'_',t1{end,1});
    PathFolderResult = [cpath FolderResult];
    nameFolder=strrep(nameFolder,'_',' ');
    % crear las carpetas para guardar los resultados
    if not(isdir (PathFolderResult))
        mkdir(PathFolderResult);
    end
    %**** Autovalores y Autovectores ********
    %Cada eje tiene un eigen valor, Estos estan relacionados con la variabilidad expresada por
    % cada eje (Axis). En gral. se expresa como porcentaje

    %     var(wf(1,:)) %calcular la varianza de la muestra de 1era dimensión de "wf"
    %     %% La covarianza es análoga a la varianza, excepto que se calcula entre dos vectores, y no un vector y en sí.
    %     cov(wf)
    %     %
    %     [V, D] = eig(cov(wf));
    %     eigval = diag(D);%vector columna con los valores de la diagonal de D
    %     % % Los valores propios se almacenan en la diagonal de D,
    %     % % los vectores propios correspondientes son las filas almacenados en V.
    %     [Y,ind] = sort(abs(eigval));
    %     eigval  = eigval(flipud(ind));  % Autovalores en orden decreciente, es igua que la variable latent obtenida con la funcion PCA
    %     V       = V(:,flipud(ind));    % Matriz de autovectores ordenada, es similar a los coeff obtenidas con la funcion PCA, en algunas columnas cambia el signo
    %   mx = mean(wf,2);                 % Media Columnas
    %     %% coordendas cono - media
    % for i=1:nCoord
    %     Xm(:,i) = wf(:,i) - mx;
    % end
    %
    %     %% Autovectores de A*A'
    % u = Xm*V;
    % for i=1:500
    %     eigVectors(:,i) = u(:,i)/norm(u(:,i));   % Normalizaci?n de los Eigenvectores
    % end
    %
    cntGr = size(listLim,1);
    cntGr = cntGr-1;

    %%  *ANÁLISIS DE COMPONENTES PRINCIPALES (ACP)*
    for cg=1:cntGr
        
        % Calcular PCA
        [coeff,score,latent,tsquared,explained,mu]=pca(( wf(listLim(cg,1): listLim(cg,2),:)));%(zscore(wf));
        % [coeff,score,latent]=princomp((wf));
        % [coeff,score,latent]=princomp(zscore(wf));
        
        % tabla2 del aporte de cada componente
        nCp=24;
        for i=1:nCp
            cp(i,1)=i;
            cp(i,2)=latent(i,1);
            cp(i,3)= explained(i,1);
            cp(i,4)= sum(explained(1:i,1));
        end
        T2=table(cp(:,1),cp(:,2),cp(:,3),cp(:,4),'VariableNames',{'CP' 'Eigenvalores' 'Varianza' 'Acumulativo'});
        
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
                histogram(( wf(listLim(k,1): listLim(k,2),nVar)),20,'FaceAlpha',wn,'Normalization','probability','FaceColor',barcolor(k));           
           
            end
            grid on
            switch prefix
                case 'C'
                    xlabel('Coordenadas X, Y','FontSize',12)
                case 'A';
                    xlabel('Ángulos (º)','FontSize',12)
                case'CA';
                    xlabel('Coordenadas X, Y, Ángulos (º)','FontSize',12)
            end
            legend(strrep(t1(1:cntGr,1),'_',' '))
%             ylabel('-','FontSize',12)
            title(strcat('Histograma-',t1{end,1}),'FontSize',12)            
            hold off
            
            
        end
        % T de Hotelling 2 , una medida estadística de la distancia multivariante de cada observación del centro del conjunto de datos.
        % Esta es una forma de análisis para encontrar los puntos más extremos en los datos.
        [st2,index] = sort(tsquared,'descend'); % sort in descending order
        extremeMax = index(1)+listLim(cg,1)-1;
        obsMaxDist=labelObs(extremeMax,:); % Las notas de está observación son los más lejos están de la observacion promedio.
        extremeMin = index(end)+listLim(cg,1)-1;
        obsMinDist=labelObs(extremeMin,:); % Las notas de está observación son los más cerca están de la observacion promedio.

        %% *DATOS DE SALIDA*

        disp(strcat('________________Grupo: ',(t1{cg,1}),'_',nameFolder,'__________________'));
        disp(strcat('Total Observaciones: ',num2str(t1{cg,3})));
        disp(strcat('Porcentaje de varianza explicada. '));
        disp(T2);
        disp(strcat('Observación más cercana de la observación promedio. '));
        disp(obsMinDist);
        disp(strcat('Observación más lejana de la observación promedio. '));
        disp(obsMaxDist);

        %  cluster
        % [idx,C] = kmeans(score,5);

        %   %% *GRÁFICOS ACP*
        % Grupo...
        disp(strcat('________________Grupo: ',(t1{cg,1}),'_',nameFolder,'__________________'));
                %         strrep(t1(1:cntGr,1),'_',' ')
        graphicPCA( coeff, score,latent, groups(listLim(cg,1): listLim(cg,2),:), labelVar, labelObs(listLim(cg,1): listLim(cg,2),:), strrep(t1{cg,1},'_',' '),prefix);
        
        %% *ARCHIVOS DE SALIDA*
        %
        disp('**********Archivos de salida***************')
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
    
    disp('**********Definiciones***************')
    disp(' ')
    disp('score, contiene las coordenadas de los datos originales en el nuevo sistema de coordenadas definido por los componentes principales')
    disp('Filas de SCORE corresponden a las observaciones, las columnas a los componentes. ')
    disp(' ')
    disp('Coeff, contiene los coeficientes de los componentes principales. (Matriz de autovectores ordenada)')
    disp('cada columna contiene los coeficientes para un componente principal. Las columnas son en orden decreciente de componentes de la varianza. ')
    disp(' ')
    disp('latent,es un vector que contiene la varianza explicada por el componente principal correspondiente.( Autovalores en orden decreciente) ')
    disp(' ')
    disp('LabelVar,es un vector que contiene los nombres de las variables  ')
    disp(' ')
    disp('LabelObs,es un cell array que contiene los nombres de las observaciones / grupos ')

    cd(diract)
    datestr(now)

