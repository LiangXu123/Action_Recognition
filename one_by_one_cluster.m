function one_by_one_cluster(sample_number,codebook_size)
%加载未随机采样的数据



HOF_for_cluster_All_Dataset=load('HOF_for_cluster_All_Dataset.mat','-mat');
HOF_for_cluster_All_Dataset=HOF_for_cluster_All_Dataset.feature_for_cluster_All_Dataset;

Tarjectory_for_cluster=HOF_for_cluster_All_Dataset;

%下面开始随机采样
Tarjectory=1:1:size(Tarjectory_for_cluster,2);
N=randsample(Tarjectory(:),sample_number);
for i=1:1:sample_number
    Sample_Tarjectory_for_cluster(:,i)=Tarjectory_for_cluster(:,N(i));
end
fprintf('随机采样完成！\n');

%开始聚类
[centers_HOF,~] = vl_kmeans(Sample_Tarjectory_for_cluster, codebook_size, 'Initialization', 'plusplus') ;
save('centers_HOF.mat','centers_HOF');
clear centers_HOF;
clear Sample_Tarjectory_for_cluster;
clear HOF_for_cluster_All_Dataset;

Tarjectory_for_cluster_All_Dataset=load('Tarjectory_for_cluster_All_Dataset.mat','-mat');
Tarjectory_for_cluster_All_Dataset=Tarjectory_for_cluster_All_Dataset.feature_for_cluster_All_Dataset;

Tarjectory_for_cluster=Tarjectory_for_cluster_All_Dataset;

%下面开始随机采样
Tarjectory=1:1:size(Tarjectory_for_cluster,2);
N=randsample(Tarjectory(:),sample_number);
for i=1:1:sample_number
    Sample_Tarjectory_for_cluster(:,i)=Tarjectory_for_cluster(:,N(i));
end
fprintf('随机采样完成！\n');

%开始聚类
[centers_Tarjectory,~] = vl_kmeans(Sample_Tarjectory_for_cluster, codebook_size, 'Initialization', 'plusplus') ;
save('centers_Tarjectory.mat','centers_Tarjectory');
clear centers_Tarjectory;
clear Sample_Tarjectory_for_cluster;
clear Tarjectory_for_cluster_All_Dataset;

HOG_for_cluster_All_Dataset=load('HOG_for_cluster_All_Dataset.mat','-mat');
HOG_for_cluster_All_Dataset=HOG_for_cluster_All_Dataset.feature_for_cluster_All_Dataset;

Tarjectory_for_cluster=HOG_for_cluster_All_Dataset;

%下面开始随机采样
Tarjectory=1:1:size(Tarjectory_for_cluster,2);
N=randsample(Tarjectory(:),sample_number);
for i=1:1:sample_number
    Sample_Tarjectory_for_cluster(:,i)=Tarjectory_for_cluster(:,N(i));
end
fprintf('随机采样完成！\n');

%开始聚类
[centers_HOG,~] = vl_kmeans(Sample_Tarjectory_for_cluster, codebook_size, 'Initialization', 'plusplus') ;
save('centers_HOG.mat','centers_HOG');
clear centers_HOG;
clear Sample_Tarjectory_for_cluster;
clear HOG_for_cluster_All_Dataset;

MBHx_for_cluster_All_Dataset=load('MBHx_for_cluster_All_Dataset.mat','-mat');
MBHx_for_cluster_All_Dataset=MBHx_for_cluster_All_Dataset.feature_for_cluster_All_Dataset;

Tarjectory_for_cluster=MBHx_for_cluster_All_Dataset;

%下面开始随机采样
Tarjectory=1:1:size(Tarjectory_for_cluster,2);
N=randsample(Tarjectory(:),sample_number);
for i=1:1:sample_number
    Sample_Tarjectory_for_cluster(:,i)=Tarjectory_for_cluster(:,N(i));
end
fprintf('随机采样完成！\n');

%开始聚类
[centers_MBHx,~] = vl_kmeans(Sample_Tarjectory_for_cluster, codebook_size, 'Initialization', 'plusplus') ;
save('centers_MBHx.mat','centers_MBHx');
clear centers_MBHx;
clear Sample_Tarjectory_for_cluster;
clear MBHx_for_cluster_All_Dataset;

MBHy_for_cluster_All_Dataset=load('MBHy_for_cluster_All_Dataset.mat','-mat');
MBHy_for_cluster_All_Dataset=MBHy_for_cluster_All_Dataset.feature_for_cluster_All_Dataset;

Tarjectory_for_cluster=MBHy_for_cluster_All_Dataset;

%下面开始随机采样
Tarjectory=1:1:size(Tarjectory_for_cluster,2);
N=randsample(Tarjectory(:),sample_number);
for i=1:1:sample_number
    Sample_Tarjectory_for_cluster(:,i)=Tarjectory_for_cluster(:,N(i));
end
fprintf('随机采样完成！\n');

%开始聚类
[centers_MBHy,~] = vl_kmeans(Sample_Tarjectory_for_cluster, codebook_size, 'Initialization', 'plusplus') ;
save('centers_MBHy.mat','centers_MBHy');
clear centers_MBHy;
clear Sample_Tarjectory_for_cluster;
clear MBHy_for_cluster_All_Dataset;
end
