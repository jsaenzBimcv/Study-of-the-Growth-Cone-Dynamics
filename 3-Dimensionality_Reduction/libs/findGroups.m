    function [ groups, T, listLim] = findGroups(groupsG, labelObs)
    % Extract from a string list the labels of the existing groups, 
    % the labels will be separated by "_".
    
    %  groups: age_class_frame
    %    input parameters:
    %     groupsG   - Group label
    %     labelObs  - List with the labels of the observations

    %   Output: 
    %    groups     - cell array, Group labels and subdivisions found
    %    T          - uTable with the group and the number of observations
    %      age_class     nFrGr
    %     ____________    _____
    %
    %     '2m_Ataxico'    2287
    %     '2m_Control'    4824
    %
    %    listLim    - list with the initial and final values of the groups 
    %                 in the cell array groups, the last row corresponds 
    %                 to all the observations
    %
    %            1        2287
    %         2288        7111
    %            1        7111

    n=size(labelObs,1);
    groups=cell(n,4);
    for i =1:n
        p=strfind(labelObs{i,1},'_');
        groups{i,1}=labelObs{i,1}(p(1)+1:p(2)-1);% Age
        groups{i,2}=labelObs{i,1}(p(2)+1:p(3)-1);% Class
        groups{i,3}=labelObs{i,1}(max(p)+1:end);%  Frame
        groups{i,4}=labelObs{i,1}(p(1)+1:p(3)-1);% Age_class
        frames{i,1}= labelObs{i,1}(p(1)+1:p(3)-1);%
    end
    %
     edad=unique(groups(:,1));%edades ind
    % ngroups = length(unique(groups(:,2))); % number of groups
    % groupID = unique(groups(:,2)); % age group identifier
    if size(edad,1)==1
        StudyGroup=edad{1,1};
    else
        StudyGroup='All';
    end

    Age_Class=unique(frames(:,1));
    g=unique(groupsG(:,1));
    for i=1:size(Age_Class,1)
        fr2=strcmp(Age_Class(i),frames(:,1));%
        nFrGr(i,1)=length(find(fr2==1)); % Number of frames per group
        iGr=strcmp(g(i),groupsG(:,1));
        nCones_Group(i,1)=length(find(iGr==1)); % number of cones per group 
    end

     Age_Class{end+1,1}=StudyGroup;% study group 

%     ----------
    nCones_Group(end+1,1)=size(groupsG,1);
    nFrGr(end+1,1)= n;

    % Limits in the groups separated into start and end columns 
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

    %Table with the groups evaluated
    T=table(Age_Class,nCones_Group,nFrGr);

    end
  
    
