    function [ groups T listLim] = findGroups(groupsG, labelObs)
    %busca en una lista de strings los nombres de los grupos separados por '_' y regresa
    %grupos edad estado frame
    %   parametros de entrada:
    %     groupsG, etiqueta de los grupos
    %     labelObs, Lista con las etiquetas delas observaciones

    %   devuelve: grupos: cell array con los grupos y las subdiviciones
    %                       encontradas
    %               T: una tabla con el grupo y el numero de observaciones
    %      Edad_Grupo     nFrGr
    %     ____________    _____
    %
    %     '2m_Ataxico'    2287
    %     '2m_Control'    4824
    %       listLim: es una lista con los valores iniciales y finales de los grupos en el cell array grupos
    %                la ultima fila corresponde a todas las observaciones
    % %           1        2287
    %         2288        7111
    %            1        7111

    n=size(labelObs,1);
    groups=cell(n,4);
    for i =1:n
        p=strfind(labelObs{i,1},'_');
        groups{i,1}=labelObs{i,1}(p(1)+1:p(2)-1);%edad
        groups{i,2}=labelObs{i,1}(p(2)+1:p(3)-1);%estado
        groups{i,3}=labelObs{i,1}(max(p)+1:end);%frame
        groups{i,4}=labelObs{i,1}(p(1)+1:p(3)-1);%edad_estado
        frames{i,1}= labelObs{i,1}(p(1)+1:p(3)-1);%
    end
    %
     edad=unique(groups(:,1));%edades ind
    % ngroups = length(unique(groups(:,2))); % numero de grupos
    % groupID = unique(groups(:,2)); % identificador del grupox edad
    if size(edad,1)==1
        StudyGroup=edad{1,1};
    else
        StudyGroup='Todos';
    end

    Edad_Grupo=unique(frames(:,1));%edad_grupo
    g=unique(groupsG(:,1));
    for i=1:size(Edad_Grupo,1)
        fr2=strcmp(Edad_Grupo(i),frames(:,1));%
        nFrGr(i,1)=length(find(fr2==1)); %numero de frames grupo
        iGr=strcmp(g(i),groupsG(:,1));
        nConos_Grupo(i,1)=length(find(iGr==1)); %numero de de conos por grupo
    end

     Edad_Grupo{end+1,1}=StudyGroup;% grupo estudio

%     ----------
    nConos_Grupo(end+1,1)=size(groupsG,1);
    nFrGr(end+1,1)= n;

    %limites en los grupos separados en columnas inicio fin
    l=size(g,1)+1;
    listLim=zeros(l,2);
    inic=1;
    fin=0;
    for i=1:l
        if i==l
            listLim(i,1)=1;
            listLim(i,2)=n;
        else
            fin=nFrGr(i,1)+fin;
            listLim(i,1)=inic;
            listLim(i,2)=fin;
            inic=listLim(i,2)+1;

        end
    end

    %tabla con los grupos evaluados
    T=table(Edad_Grupo,nConos_Grupo,nFrGr);

    %
    % idx = strmatch((grupos(1,3)),(labelObs))
    % idx = cellfun(@(s) ~isempty(strfind(grupos(1,3), s)),labelObs )
    %
    % idx = strcmp(groupID(i), groups(:,2));%lista los n grupos coloca en "1" los que corresponden la grupo i, los demas en "0"
    %


    end


    %
    % tc=table2cell(T)
    % for i=1:size(tc,1)
    %     nImg=strcmp((i,1),classes.dataCones(:,1));%
    %     nFrGr(i)=length(find(fr2==1)); %numero de frames grupo
    % end

%     x=1:cntGr
%     m = x(mod(x, 3) == 0) % lista los multiplos de 3   [ 3     6     9]
%     m = x(mod(x, 3) ~= 0) % lista los que no son multiplos de 3   [ 1     2     4     5     7     8    10]
    %----------------------------------------------------
%     %descomente si quiere eliminar los grupos con todas las observaciones
%     %                %     cntGr=size(listLim,1); = l
%     x=1:l;
%     listLim(x(mod(x, 3) == 0),:)=[];
    %------------------------------------------------------   
  
    
