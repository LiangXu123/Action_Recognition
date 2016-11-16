function all_hist_hmdb51_plus(filename_list,pre_path)
%%加载类心,计算所有视频的BOW直方图并保存
%处理数据库时将每个子文件夹下的视频得到一个idt特征的直方图
%%
%%运行vl_setup配置vlfeat工具包
codebook_size=4000;
%%加载类心,生成直方图
centers_Tarjectory=load('centers_Tarjectory.mat');
centers_Tarjectory=centers_Tarjectory.centers_Tarjectory;
centers_HOG=load('centers_HOG.mat');
centers_HOG=centers_HOG.centers_HOG;
centers_HOF=load('centers_HOF.mat');
centers_HOF=centers_HOF.centers_HOF;
centers_MBHx=load('centers_MBHx.mat');
centers_MBHx=centers_MBHx.centers_MBHx;
centers_MBHy=load('centers_MBHy.mat');
centers_MBHy=centers_MBHy.centers_MBHy;

all_list=load('all_list.mat','all_list');
all_list=all_list.all_list;
train_list=load('train_list.mat','train_list');
train_list=train_list.train_list;
test_list=load('test_list.mat','test_list');
test_list=test_list.test_list;

all_num=length(filename_list);

for j=1:all_num %do for every video
    frature_full_name=filename_list{j}; %every video identity name and full path
    data=load(frature_full_name,'-mat');
    IDT_feature_data=data.IDT_feature_data;  %最后的IDT特征是一列为一个特征
    %初始化直方图
    Hist_of_features=zeros(1,codebook_size*5);
    Hist_of_Traiector = zeros(1,codebook_size);
    Hist_of_HOG=Hist_of_Traiector;
    Hist_of_HOF=Hist_of_Traiector;
    Hist_of_MBHx=Hist_of_Traiector;
    Hist_of_MBHy=Hist_of_Traiector;
    Dim_of_features=size(IDT_feature_data,1);
    if Dim_of_features<426
        ALL_Hist_features_dataset(j,:)=Hist_of_features;
        continue;
    end
    %%进行特征分割
    Tarjectory_feature=IDT_feature_data(1:30,:);
    HOG_feature=IDT_feature_data(31:126,:);
    HOF_feature=IDT_feature_data(127:234,:);
    MBHx_feature=IDT_feature_data(235:330,:);
    MBHy_feature=IDT_feature_data(331:end,:);
    fprintf('%sIDT特征已分解完成！\n',frature_full_name);
    
    
    for jJ=1:size(IDT_feature_data,2)    %计算5个特征的直方图
        [~, k1] = min(vl_alldist(Tarjectory_feature(:,jJ), centers_Tarjectory)) ;
        Hist_of_Traiector(k1) = Hist_of_Traiector(k1) + 1;
        [~, k2] = min(vl_alldist(HOG_feature(:,jJ), centers_HOG)) ;
        Hist_of_HOG(k2) = Hist_of_HOG(k2) + 1;
        [~, k3] = min(vl_alldist(HOF_feature(:,jJ), centers_HOF)) ;
        Hist_of_HOF(k3) = Hist_of_HOF(k3) + 1;
        [~, k4] = min(vl_alldist(MBHx_feature(:,jJ), centers_MBHx)) ;
        Hist_of_MBHx(k4) = Hist_of_MBHx(k4) + 1;
        [~, k5] = min(vl_alldist(MBHy_feature(:,jJ), centers_MBHy)) ;
        Hist_of_MBHy(k5) = Hist_of_MBHy(k5) + 1;
    end
    
    %%下面将5个直方图进行L2归一化
    Hist_of_Traiector = Hist_of_Traiector./repmat(sqrt(sum(Hist_of_Traiector.^2,2)),1,size(Hist_of_Traiector,2));
    Hist_of_HOG = Hist_of_HOG./repmat(sqrt(sum(Hist_of_HOG.^2,2)),1,size(Hist_of_HOG,2));
    Hist_of_HOF = Hist_of_HOF./repmat(sqrt(sum(Hist_of_HOF.^2,2)),1,size(Hist_of_HOF,2));
    Hist_of_MBHx = Hist_of_MBHx./repmat(sqrt(sum(Hist_of_MBHx.^2,2)),1,size(Hist_of_MBHx,2));
    Hist_of_MBHy = Hist_of_MBHy./repmat(sqrt(sum(Hist_of_MBHy.^2,2)),1,size(Hist_of_MBHy,2));
    
    %%
    %将5个直方图串联起来
    Hist_of_features(:,1:codebook_size)=Hist_of_Traiector;
    Hist_of_features(:,codebook_size+1:2*codebook_size)=Hist_of_HOG;
    Hist_of_features(:,2*codebook_size+1:3*codebook_size)=Hist_of_HOF;
    Hist_of_features(:,3*codebook_size+1:4*codebook_size)=Hist_of_MBHx;
    Hist_of_features(:,4*codebook_size+1:5*codebook_size)=Hist_of_MBHy;
    %保存L2 Norm归一化过的直方图
    ALL_Hist_features_dataset(j,:)=Hist_of_features;
    fprintf('对%s文件计算归一化直方图完成！\n',frature_full_name);
    
end
%%将一个文件夹的IDT保存为一个hist文件
%%添加去零代码
%one_row_zero=zeros(1,size(ALL_Hist_features_dataset,2));
%for del_zero_row_num=size(ALL_Hist_features_dataset,1):-1:1
%if ALL_Hist_features_dataset(del_zero_row_num,:)==one_row_zero
%  ALL_Hist_features_dataset(del_zero_row_num,:)=[];
% end
%end
if strcmp(filename_list,'train_list')==1
    save_hist_feature_path=strcat(pre_path,'/','ALL_Hist_features_dataset_train.mat');
elseif strcmp(filename_list,'test_list')==1
    save_hist_feature_path=strcat(pre_path,'/','ALL_Hist_features_dataset_test.mat');
end
save(save_hist_feature_path,'ALL_Hist_features_dataset');

end
