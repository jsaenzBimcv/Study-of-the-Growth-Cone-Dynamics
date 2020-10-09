data = importdata('organs_repeats.csv');
expressions = data.data;
organs = data.textdata(1,2:end);
genes = data.textdata(2:end,1);


%% PCA figure
[~,scores,pcvar] = princomp(expressions');

x = zscore(scores(:,1));
y = zscore(scores(:,2));
z = zscore(scores(:,3));

gscatter3(x,y,z,organs,{'b','g','m'},{'.','.','.'},15);

xlabel(['PC-1(' num2str(round(pcvar(1)/sum(pcvar)*100)) '%)'],'fontsize',18);
ylabel(['PC-2(' num2str(round(pcvar(2)/sum(pcvar)*100)) '%)'],'fontsize',18);
zlabel(['PC-3(' num2str(round(pcvar(3)/sum(pcvar)*100)) '%)'],'fontsize',18);

%% clustergram figure
clustergram(expressions,'RowLabels',genes,'ColumnLabels',organs,...
    'Standardize',2,'Colormap',redbluecmap);


%type generate_figures in command window to run the script.