    function graphicPCA( coeff, score,latent,groups, labelVar, labelObs,name,prefix)
    %graphicPCA
    %     coeff, coeficientes
    %     score, score
    %     latent, varianza
    %     groups,  grupos Observaciones
    %     labelVar, variables
    %     name,    nombre del grupo general
    %     vpca, tipos de variables          sólo coordenadas      vpca=0
    %                                       sólo ángulos          vpca=1
    %                                       Coordenadas y ángulos vpca=2
     %__________________________________________
    % HISTORIAL:                                                           %
    %       +Fecha de realización: revisado 2-Ene-2017 14:51:05                         %
    %       +Autor: Saenz Jhon J
    %       +Versión: 1.0                                                  %
    %       +Cambios: -                                                    %
    %       +Descripción de los cambios:                         %
    %_______________________________________________________________________________

    whitebg([1 1 1])

    [nObs nCoord]=size(score);
    frames=groups(:,3);
    for i = 1:size(frames,1)
        fr(i,1)=str2num(frames{i}(2:end));% obtiene la lista de numeros de la etiqueta de frame
    end
    pc1x100= strcat('PC-1 (',num2str(round(latent(1)/sum(latent)*100)),'%)');
    pc2x100= strcat('PC-2 (',num2str(round(latent(2)/sum(latent)*100)),'%)');
    pc3x100= strcat('PC-3 (',num2str(round(latent(3)/sum(latent)*100)),'%)');
    %% Figura Cantidad de Informació® ¨%)
    figure('Name',strcat('Varianza Explicada para los diferentes componentes principales en_',name),'Position',[10 60 400 400],'Color',[1 1 1])
    disp(strcat('Varianza Explicada para los diferentes componentes principales en ',name));

    porcentaje = 100*latent/sum(latent);
    pareto(porcentaje);
    grid on
    xlabel('Componente Principal','FontSize',12)
    ylabel('Cantidad de Información (%)','FontSize',12)
    title(strcat({'Varianza explicada y acumulada por CP';name}),'FontSize',12)

    %       [H,AX] = pareto(porcentaje);
    % % get(AX(2), 'YColor')
    % set(AX(2),'YColor', [1 0 0]); % Change the right Axis's color to red
    % set(AX(2),'FontSize', 20); % Change the right Axis's font size to 20


    figure('Name',strcat('Biplot de las 3 componentes principales en_',name),'Position',[10 60 600 600],'Color',[1 1 1])
    biplotModif(coeff(1:nCoord,1:3),'Scores',score(:,1:3));%, 'LineStyle','none');%,'varlabels',labelCoord(1:nCoord/2)); %,'MarkerSize',2
    xlabel(pc1x100,'fontsize',12);
    ylabel(pc2x100,'fontsize',12);
    zlabel(pc3x100,'fontsize',12);
    set(get(gca,'YLabel'),'Rotation',-50);
    set(get(gca,'XLabel'),'Rotation',8);
    %     axis([-.1 0.1 -.08 .15 -.08 .15]);
    view([20 50 50])
    title(strcat({'Biplot de variables y observaciones en';name}) ,'FontSize',12)

    % %     hold on
    % %     biplotModif(coeff(nCoord/2+1:nCoord,1:3),'Scores',score(1:2287,1:3),'Color','c','MarkerEdgeColor','b');%,'varlabels',labelCoord(nCoord/2+1:nCoord));
    % %
    % % biplotModif(coeff(1:nCoord,1:3),'Scores',score(2288:7111,1:3),'Color','c','MarkerEdgeColor','r');%,'varlabels',labelCoord(nCoord/2+1:nCoord));
    % %
    % % hold on
    % %     biplotModif(coeff(1:nCoord,1:3),'Scores',score(1:2287,1:3),'Color','c','MarkerEdgeColor','b');%,'varlabels',labelCoord(nCoord/2+1:nCoord));
    % %
    % % hold off


    %some data
    % load carsmall
    % x = [Acceleration Displacement Horsepower MPG Weight]; x = x(all(~isnan(x),2),:);
    % [coefs,score] = pca(zscore(x));
    %
    % %the status vector (here zero or one)
    % class_pt = round(rand(size(score,1),1));
    %
    % vbls = {'Accel','Disp','HP','MPG','Wgt'};
    %
    % figure('Color', 'w');
    % hbi = biplotModif(coefs(:,1:3),'scores',score(:,1:3),'varlabels',vbls,...
    %     'ObsLabels',num2str((1:size(score,1))'));
    %
    % for ii = 1:length(hbi)
    %     userdata = get(hbi(ii), 'UserData');
    %     if ~isempty(userdata)
    %         if class_pt(userdata) == 0
    %             set(hbi(ii), 'Color', 'c', 'Marker', '*','MarkerEdgeColor','g');
    %
    %         elseif class_pt(userdata) == 1
    %             set(hbi(ii), 'Color', 'c', 'Marker', '.','MarkerEdgeColor','r');
    %         end
    %
    %     end
    % end
    %
    %
    % ngroups = length(unique(groups(:,2))); % numero de grupos
    % groupID = unique(groups(:,2)); % identificador del grupo
    % idx = strcmp(groupID(i), groups(:,2));%lista los n grupos coloca en "1" los que corresponden la grupo i, los demas en "0"

% %*********************inicio Figura, descomente si utiliza todas las coordenadas (500) ********* 
%     %% proyeccion de las variables según los coeefcientes
%     % aportes de las componentes en las coordenadas
%     switch prefix
%         case {'C','CA'}% sólo coordenadas  o coordenadas y ángulos
%             pts=[[coeff(1,1),coeff(251,1)];[coeff(50,1),coeff(301,1)];[coeff(100,1),coeff(351,1)];[coeff(150,1),coeff(401,1)];[coeff(200,1),coeff(451,1)]];
%             pts2=[[coeff(1,2),coeff(251,2)];[coeff(50,2),coeff(301,2)];[coeff(100,2),coeff(351,2)];[coeff(150,2),coeff(401,2)];[coeff(200,2),coeff(451,2)]];
%             pts3=[[coeff(1,3),coeff(251,3)];[coeff(50,3),coeff(301,3)];[coeff(100,3),coeff(351,3)];[coeff(150,3),coeff(401,3)];[coeff(200,3),coeff(451,3)]];
% 
%             labelPts={'CP', 'P1','P50','P100','P150','P200'};
%             nPts=size(pts,1);
%             % ptsColors = lines(nPts);
%             ptsColors = hsv(nPts);
%             x=(1:1:250);
%             %----------
%             figure('Name',strcat('Aportes de las CP en las coordenadas en_',name),'Position',[10 10 1000 900],'Color',[1 1 1])
%             disp(strcat('Aportes de las CP en las coordenadas en_',name));
%             %----------
%             ax1=subplot(321);
%             if prefix == 'CA' %#ok<STCMP>
%                 diferencia=(500-nCoord)/2;
%                 plot(x,coeff(1:250,1),x,coeff(251:500,1),[1:1:nCoord-500],coeff(501:nCoord,1))
%                 legend('Coord X', 'Coord Y', 'Ángulos','Location', 'southeast','Orientation','horizontal');%'FontSize',6
%                 legend('boxoff')
%                 title(strcat({'Variables: Coordenadas X,Y, Ángulos';' Componente Principal 1'}))
%             else
%                 plot(x,coeff(1:nCoord/2,1),x,coeff(nCoord/2+1:nCoord,1))
%                 legend('Coord X', 'Coord Y','Location', 'southeast','Orientation','horizontal');%'FontSize',6
%                 legend('boxoff')
%                 title(strcat({'Variables: Coordenadas X,Y';' Componente Principal 1'}))
%                 ylim(ax1,[-0.12 0.12])
%             end
%             xlabel('Punto de referencia','FontSize',12)
%             ylabel('Coeficiente','FontSize',12)
%             grid on
%             grid minor
%             subplot(322)
%             plot(coeff(1:250,1),coeff(251:500,1))
%             hold on
%             for k=1:nPts
%                 plot(pts(k,1),pts(k,2),'Marker', '*', 'MarkerEdgeColor', ...
%                     ptsColors(k,:),'LineStyle','none')
%             end
%             legend(labelPts,'Location', 'southwest','FontSize',6);
%             legend('boxoff')
%             hold off
%             title('Aportes de la CP-1 en las coordenadas')
%             xlabel('Coef. X','FontSize',12)
%             ylabel('Coef. Y','FontSize',12)
%             % axis ij
%             grid on
%             grid minor
%             %----------
%             ax2=subplot(323);
%             if prefix == 'CA' %#ok<STCMP>
%                 plot(x,coeff(1:250,2),x,coeff(251:500,2),[1:1:nCoord-500],coeff(501:nCoord,2))
%             else
%                 plot(x,coeff(1:250,2),x,coeff(251:500,2))
%                 ylim(ax2,[-0.12 0.12])
%             end
% 
%             title('{\bf Componente Principal 2}')
%             xlabel('Punto de referencia','FontSize',12)
%             ylabel('Coeficiente','FontSize',12)
%             grid on
%             grid minor
% 
%             subplot(324)
%             plot(coeff(1:250,2),coeff(251:500,2))
%             hold on
%             for k=1:nPts
%                 plot(pts2(k,1),pts2(k,2),'Marker', '*', 'MarkerEdgeColor', ...
%                     ptsColors(k,:),'LineStyle','none')
%             end
%             hold off
%             title('Aportes de las CP-2 en las coordenadas')
%             xlabel('Coef. X','FontSize',12)
%             ylabel('Coef. Y','FontSize',12)
%             % axis ij
%             grid on
%             grid minor
%             %----------
%             ax3=subplot(325);
%             if prefix == 'CA' %#ok<STCMP>
%                 plot(x,coeff(1:250,3),x,coeff(251:500,3),[1:1:nCoord-500],coeff(501:nCoord,3))
%             else
%                 plot(x,coeff(1:250,3),x,coeff(251:500,3))
%                 ylim(ax3,[-0.12 0.12])
%             end
%             title('{\bf Componente Principal 3}')
%             xlabel('Punto de referencia','FontSize',12)
%             ylabel('Coeficiente','FontSize',12)
%             grid on
%             grid minor
%             subplot(326)
%             plot(coeff(1:250,3),coeff(251:500,3))
%             hold on
%             for k=1:nPts
%                 plot(pts3(k,1),pts3(k,2),'Marker', '*', 'MarkerEdgeColor', ...
%                     ptsColors(k,:),'LineStyle','none')
%             end
%             hold off
%             title('Aportes de la CP-3 en las coordenadas')
%             xlabel('Coef. X','FontSize',12)
%             ylabel('Coef. Y','FontSize',12)
%             grid on
%             grid minor
%         case 'A' %sólo ángulos
%             x=(1:1:nCoord)+((500/2-nCoord)/2);
%             %----------
%             figure('Name',strcat('Aportes de las CP en los ángulos en_',name),'Position',[10 10 500 900],'Color',[1 1 1])
%             disp(strcat('Aportes de las CP en los ángulos en_',name));
%             %----------
%             ax1=subplot(311);
%             plot(x,coeff(1:nCoord,1))
%             legend('Ángulos','Location', 'southeast','Orientation','horizontal');%'FontSize',6
%             legend('boxoff')
%             title(strcat({'Variables: Ángulos';' Componente Principal 1'}))
%             xlabel('Punto de referencia','FontSize',12)
%             ylabel('Coeficiente','FontSize',12)
%             grid on
%             grid minor
%             ylim(ax1,[-0.25 0.35])
%             %----------
%             ax2=subplot(312);
%             plot(x,coeff(1:nCoord,2))
%             title('{\bf Componente Principal 2}')
%             xlabel('Punto de referencia','FontSize',12)
%             ylabel('Coeficiente','FontSize',12)
%             grid on
%             grid minor
%             ylim(ax2,[-0.25 0.35])
%             %----------
%             ax3=subplot(313);
%             plot(x,coeff(1:nCoord,3))
%             title('{\bf Componente Principal 3}')
%             xlabel('Punto de referencia','FontSize',12)
%             ylabel('Coeficiente','FontSize',12)
%             grid on
%             grid minor
%             ylim(ax3,[-0.25 0.35])
%             %------
%             figure('Name',strcat('Aportes de las CP en los ángulos en - ',name))
%             plot(x,coeff(1:nCoord,1))
%             hold on
%             plot(x,coeff(1:nCoord,2),'r')
%             plot(x,coeff(1:nCoord,3),'g')          
%             legend({'CP 1','CP 2','CP 3'},'Location', 'southeast','Orientation','horizontal');%'FontSize',6
%             legend('boxoff')
%             title(strcat({name;'Variables: Ángulos'}))
%             xlabel('Punto de referencia','FontSize',12)
%             ylabel('Coeficiente','FontSize',12)
%             grid on
%             grid minor
%             ylim([-0.25 0.5])
%             hold off
%             
%     end
% %*********************fIN Figura, descomente si utiliza todas las coordenadas (500) *********


% %********************INICIO**********************************************
    %     %% PROYECCION DE LOS DATOS ORIGINALES EN LAS COMPONENTES PRINCIPALES
    %     figure()
    %     %Coeficiente para las cordenadas X en el espacio de las 2 pc
    %     subplot(321)
    %
    %     biplotModif(coeff(1:nCoord/2,1:2),'Color','y','MarkerEdgeColor','r');%,'varlabels',labelCoord(1:nCoord/2)); %,'MarkerSize',2
    %     ylabel('2^{do} Componente Principal','FontSize',12)
    %     xlabel('1^{er} Componente Principal','FontSize',12)
    %     title('Proyección de las coord. X en las CP Edad 2m','FontSize',12)
    %     %Coeficiente para las cordenadas X en el espacio de las pc 1y3
    %     subplot(323)
    %     biplotModif([coeff(1:nCoord/2,1),coeff(1:nCoord/2,3)],'Color','y','MarkerEdgeColor','r');%,'varlabels',labelCoord(1:nCoord/2));%
    %     xlabel('1^{er} Componente Principal','FontSize',12)
    %     ylabel('3^{er} Componente Principal','FontSize',12)
    %
    %     %Coeficiente para las cordenadas X en el espacio de las pc 2y3
    %     subplot(325)
    %     biplotModif(coeff(1:nCoord/2,2:3),'Color','y','MarkerEdgeColor','r');%,'varlabels',labelCoord(1:nCoord/2)); %
    %     ylabel('3^{er} Componente Principal','FontSize',12)
    %     xlabel('2^{do} Componente Principal','FontSize',12)
    %
    %
    %     % Coeficiente para las cordenadas Y en el espacio de las 2 pc
    %     subplot(322)
    %     biplotModif(coeff(nCoord/2+1:nCoord,1:2),'Color','c','MarkerEdgeColor','b');%,'varlabels',labelCoord(nCoord/2+1:nCoord)); %
    %     ylabel('2^{do} Componente Principal','FontSize',12)
    %     xlabel('1^{er} Componente Principal','FontSize',12)
    %     title('Proyección de las coord. Y en las CP Edad 2m','FontSize',12)
    %     %Coeficiente para las cordenadas X en el espacio de las pc 1y3
    %     subplot(324)
    %     biplotModif([coeff(nCoord/2+1:nCoord,1),coeff(nCoord/2+1:nCoord,3)],'Color','c','MarkerEdgeColor','b');%,'varlabels',labelCoord(nCoord/2+1:nCoord));%
    %     xlabel('1^{er} Componente Principal','FontSize',12)
    %     ylabel('3^{er} Componente Principal','FontSize',12)
    %
    %     %Coeficiente para las cordenadas X en el espacio de las pc 2y3
    %     subplot(326)
    %     biplotModif(coeff(nCoord/2+1:nCoord,2:3),'Color','c','MarkerEdgeColor','b');%,'varlabels',labelCoord(nCoord/2+1:nCoord));%
    %     ylabel('3^{er} Componente Principal','FontSize',12)
    %     xlabel('2^{do} Componente Principal','FontSize',12)
    %
    %     %% **************//////proyecciones separadas//////***********
    %     figure()
    %     %Coeficiente para las cordenadas X en el espacio de las 2 pc
    %     subplot(311)
    %
    %     biplotModif(coeff(1:nCoord/2,1:2),'varlabels',labelVar(1:nCoord/2)); %,'MarkerSize',2
    %     ylabel('2^{do} Componente Principal','FontSize',12)
    %     xlabel('1^{er} Componente Principal','FontSize',12)
    %     title('Proyección de las coord. X en las CP Edad 2m','FontSize',12)
    %     %Coeficiente para las cordenadas X en el espacio de las pc 1y3
    %     subplot(312)
    %     biplotModif([coeff(1:nCoord/2,1),coeff(1:nCoord/2,3)],'varlabels',labelVar(1:nCoord/2));%
    %     xlabel('1^{er} Componente Principal','FontSize',12)
    %     ylabel('3^{er} Componente Principal','FontSize',12)
    %
    %     %Coeficiente para las cordenadas X en el espacio de las pc 2y3
    %     subplot(313)
    %     biplotModif(coeff(1:nCoord/2,2:3),'varlabels',labelVar(1:nCoord/2)); %
    %     ylabel('3^{er} Componente Principal','FontSize',12)
    %     xlabel('2^{do} Componente Principal','FontSize',12)
    %
    %     figure()
    %     % Coeficiente para las cordenadas Y en el espacio de las 2 pc
    %     subplot(311)
    %     biplotModif(coeff(nCoord/2+1:nCoord,1:2),'varlabels',labelVar(nCoord/2+1:nCoord)); %
    %     ylabel('2^{do} Componente Principal','FontSize',12)
    %     xlabel('1^{er} Componente Principal','FontSize',12)
    %     title('Proyección de las coord. Y en las CP Edad 2m','FontSize',12)
    %     %Coeficiente para las cordenadas X en el espacio de las pc 1y3
    %     subplot(312)
    %     biplotModif([coeff(nCoord/2+1:nCoord,1),coeff(nCoord/2+1:nCoord,3)],'varlabels',labelVar(nCoord/2+1:nCoord));%
    %     xlabel('1^{er} Componente Principal','FontSize',12)
    %     ylabel('3^{er} Componente Principal','FontSize',12)
    %
    %     %Coeficiente para las cordenadas X en el espacio de las pc 2y3
    %     subplot(313)
    %     biplotModif(coeff(nCoord/2+1:nCoord,2:3),'varlabels',labelVar(nCoord/2+1:nCoord));%
    %     ylabel('3^{er} Componente Principal','FontSize',12)
    %     xlabel('2^{do} Componente Principal','FontSize',12)
    %
    %
    %     %% PROYECCION DE VARIABLES Y OBSERVACIONES EN LAS COMPONENTES PRINCIPALES
    %     figure()
    %     %Coeficiente para las cordenadas X en el espacio de las 2 pc
    %     subplot(321)
    %
    %     biplotModif(coeff(1:nCoord/2,1:2),'Scores',score(:,1:2),'Color','c','MarkerEdgeColor','b');%,'varlabels',labelCoord(1:nCoord/2)); %,'MarkerSize',2
    %     ylabel('2^{do} Componente Principal','FontSize',12)
    %     xlabel('1^{er} Componente Principal','FontSize',12)
    %     title('Proyección de las coord. X en las CP Edad 2m','FontSize',12)
    %     %Coeficiente para las cordenadas X en el espacio de las pc 1y3
    %     subplot(323)
    %     biplotModif([coeff(1:nCoord/2,1),coeff(1:nCoord/2,3)],'Scores',[score(:,1),score(:,3)],'Color','c','MarkerEdgeColor','b');%,'varlabels',labelCoord(1:nCoord/2));%
    %     xlabel('1^{er} Componente Principal','FontSize',12)
    %     ylabel('3^{er} Componente Principal','FontSize',12)
    %
    %     %Coeficiente para las cordenadas X en el espacio de las pc 2y3
    %     subplot(325)
    %     biplotModif(coeff(1:nCoord/2,2:3),'Scores',score(:,2:3),'Color','c','MarkerEdgeColor','b');%,'varlabels',labelCoord(1:nCoord/2)); %
    %     ylabel('3^{er} Componente Principal','FontSize',12)
    %     xlabel('2^{do} Componente Principal','FontSize',12)
    %
    %
    %     % Coeficiente para las cordenadas Y en el espacio de las 2 pc
    %     subplot(322)
    %     biplotModif(coeff(nCoord/2+1:nCoord,1:2),'Scores',score(:,1:2),'Color','c','MarkerEdgeColor','b');%,'varlabels',labelCoord(nCoord/2+1:nCoord)); %
    %     ylabel('2^{do} Componente Principal','FontSize',12)
    %     xlabel('1^{er} Componente Principal','FontSize',12)
    %     title('Proyección de las coord. Y en las CP Edad 2m','FontSize',12)
    %     %Coeficiente para las cordenadas X en el espacio de las pc 1y3
    %     subplot(324)
    %     biplotModif([coeff(nCoord/2+1:nCoord,1),coeff(nCoord/2+1:nCoord,3)],'Scores',[score(:,1),score(:,3)],'Color','c','MarkerEdgeColor','b');%,'varlabels',labelCoord(nCoord/2+1:nCoord));%
    %     xlabel('1^{er} Componente Principal','FontSize',12)
    %     ylabel('3^{er} Componente Principal','FontSize',12)
    %
    %     %Coeficiente para las cordenadas X en el espacio de las pc 2y3
    %     subplot(326)
    %     biplotModif(coeff(nCoord/2+1:nCoord,2:3),'Scores',score(:,2:3),'Color','c','MarkerEdgeColor','b');%,'varlabels',labelCoord(nCoord/2+1:nCoord));%
    %     ylabel('3^{er} Componente Principal','FontSize',12)
    %     xlabel('2^{do} Componente Principal','FontSize',12)
    % gr = groups(:,3);
    
 % %********************fIN**********************************************   
    gr = fr;

    figure('Name',strcat('Variables y observaciones en CP1 y CP2 en_',name),'Position',[30 60 800 800],'Color',[1 1 1])
    disp(strcat({'Variables y observaciones en CP1 y CP2';name})) ;
    format = { {}; {'Marker', '.', 'MarkerSize', 6}; {} };
    biplotG(coeff, score, 'Groups', gr(:,1), 'VarLabels', labelVar, 'Format' , format)
    xlabel(pc1x100,'FontSize',12);
    ylabel(pc2x100,'FontSize',12);
    title(strcat({'Biplot de variables y observaciones en CP1 y CP2';name}) ,'FontSize',12)
    grid on
    
    %*******************************
    if numel(strfind(name,'Ataxico')) >= 1
        lb=strrep(name,'2m Ataxico',' YG8sR');
    elseif numel(strfind(name,'Control')) >= 1
        lb=strrep(name,'2m Control',' Y47R');
    else
        lb=strrep(name,'_',' ');
    end
    
    figure('Name',strcat('Observaciones en CP1 y CP2 en_',lb),'Position',[30 60 950 950],'Color',[1 1 1])
    disp(strcat({'Observaciones en CP1 y CP2';lb})) ;
    format = { {}; {'Marker', '.', 'MarkerSize', 16}; {} };
    plotObs([score(:,2) score(:,1)], 'Groups', gr(:,1), 'VarLabels', labelVar, 'Format' , format)
    ylabel(pc1x100,'FontName', 'Calibri', 'FontSize',35); % 'FontWeight','bold',
    xlabel(pc2x100,'FontName', 'Calibri','FontSize',35);
    title(strcat({lb}), 'FontWeight','normal','FontName', 'Calibri','FontSize',44)%  strcat({lb;' '})
    grid on
    
    
    figure('Name',strcat('Observaciones en_',lb),'Position',[30 60 1550 1550],'Color',[1 1 1])
    disp(strcat({'Observaciones en CP1 y CP2';lb})) ;
    
    labelObs = strrep(labelObs(:,1),'E_2m_Ataxico_','');
    labelObs = strrep(labelObs(:,1),'E_2m_Control_','');
    labelObs = strrep(labelObs(:,1),'_','.');
    
    plotObs([score(:,2) score(:,1)], 'Groups', gr(:,1), 'VarLabels', labelVar,'ObsLabels',labelObs, 'Format' , format)
    ylabel(pc1x100, 'FontSize',20); % 'FontWeight','bold',
    xlabel(pc2x100, 'FontSize',20);
    title(strcat({lb;' '}),'FontSize',26)
    grid on
    
    %*******************************
    
    figure('Name',strcat('Variables y observaciones en CP1 y CP3 en_',name),'Position',[30 60 800 800],'Color',[1 1 1])
    disp(strcat({'Variables y observaciones en CP1 y CP3';name}));
    format = { {}; {'Marker', '.', 'MarkerSize', 6}; {} };
    biplotG([coeff(:,1),coeff(:,3)],[score(:,1),score(:,3)], 'Groups', gr(:,1), 'VarLabels', labelVar, 'Format' , format)
    xlabel(pc1x100,'FontSize',18);
    ylabel(pc3x100,'FontSize',18);
    title(strcat({'Biplot de variables y observaciones en CP1 y CP3';name}) ,'FontSize',14)
    grid on
    
    figure('Name',strcat('Variables y observaciones en CP2 y CP3 en_',name),'Position',[30 60 800 800],'Color',[1 1 1])
    disp(strcat({'Variables y observaciones en CP2 y CP3';name}));
    biplotG([coeff(:,2),coeff(:,3)],[score(:,2),score(:,3)], 'Groups', gr(:,1), 'VarLabels', labelVar, 'Format' , format)
    xlabel(pc2x100,'FontSize',18);
    ylabel(pc3x100,'FontSize',18);
    title(strcat({'Biplot de variables y observaciones en CP2 y CP3';name}) ,'FontSize',12)
    grid on
    
    
    
    


    if size(unique(groups(:,4)),1)> 1
        figure('Name',strcat('Dispersión de las observaciones en las tres primeras componentes_ ',name),'Color',[1 1 1])
        disp(strcat('Dispersión de las observaciones en las tres primeras componentes_ ',name))  ;

        x = zscore(score(:,1));
        y = zscore(score(:,2));
        z = zscore(score(:,3));
        gscatter3(x,y,z,strrep(groups(:,4),'_',' ')','jet',{},3,'jet',1,'NorthEast')
        xlabel(pc1x100,'FontSize',12);
        ylabel(pc2x100,'FontSize',12);
        zlabel(pc3x100,'FontSize',12);
        set(get(gca,'YLabel'),'Rotation',-35);
        set(get(gca,'XLabel'),'Rotation',20);
        view([40 50 70])
%         
% %         
%         gscatter3(x,y,z,strrep(groups(:,4),'_',' ')','lines',{'o','o'},3,'jet',1,'NorthEast')
%         xlabel('CP-1','FontSize',12);
%         ylabel('CP-2','FontSize',12);
%         zlabel('CP-3','FontSize',12);
%         
        
    end


    end


    %% otra forma de graficar la proyeccion de los datos en las compontes
    % principales
    %     edges{1}=[-700:25:700]; %Bin para el eje x
    %     edges{2}=[-700:25.1:700]; %Bin para el eje y
    %     figure(1);
    %     h=hist3(score(:,1:2),edges); %Calcual el histograma 2-D
    %     s=surface(h'); %Visualizar el histograma como una superficie(note h')
    %     set(s,'XData',edges{1}) %etiqueta el eje x
    %     set(s,'YData',edges{2}) %etiqueta el eje y
    %     title('A scatterplot of Coord projected on the PC1 and PC2.');
    %     xlabel('PC1');
    %     ylabel('PC2');
    %     figure(2);
    %     % Figura de las proyecciones en 2 ejes
    %     subplot (1,3,1)
    %     plot(score(:,1),score(:,2),'+')
    %     xlabel('1^{er} Componente Principal','FontSize',12)
    %     ylabel('2^{do} Componente Principal','FontSize',12)
    %     grid on
    %     subplot (1,3,2)
    %     plot(score(:,1),score(:,3),'+')
    %     xlabel('1^{er} Componente Principal','FontSize',12)
    %     ylabel('3^{er} Componente Principal','FontSize',12)
    %     title('PROYECCION DE LOS DATOS ORIGINALES EN LAS COMPONENTES PRINCIPALES'...
    %         ,'FontSize',12)
    %     grid on
    %     subplot (1,3,3)
    %     plot(score(:,2),score(:,3),'+')
    %     xlabel('2^{do} Componente Principal','FontSize',12)
    %     ylabel('3^{er} Componente Principal','FontSize',12)
    %     grid on