%将每一个文件夹下面的所有特征按类型分割.以每20个为一组,然后开始采样
function get_five_cluster_plus(filename_list,feature_type)

%%对提取得到的IDT特征.mat文件,然后进行单个特征分割,单个特征聚类
%输入:IDT特征,每列是一个IDT特征
%输出:将IDT特征分割为轨迹Tarjectory30,HOG96,HOF108,MBHx96,MBHy96
%%
num_mark=0;
num_mark_for_rand=0;
%标记首次进入
first_Mark=1;
first_Mark_oyther=1;
all_num=length(filename_list);

for j=1:all_num %do for every video
    frature_full_name=filename_list{j}; %every video identity name and full path
    data=load(frature_full_name,'-mat');
    IDT_feature_data=data.IDT_feature_data;  %最后的IDT特征是一列为一个特征
    fprintf('%s文件加载成功！\n',frature_full_name);
    num_of_features=size(IDT_feature_data,2);
    Dim_of_features=size(IDT_feature_data,1);
    %%
    if Dim_of_features<426
        continue;
    end
    num_mark=num_mark+1;
    %%进行特征分割
    switch feature_type
        case 1
            Tarjectory_feature=IDT_feature_data(1:30,:);
        case 2
            HOG_feature=IDT_feature_data(31:126,:);
        case 3
            HOF_feature=IDT_feature_data(127:234,:);
        case 4
            MBHx_feature=IDT_feature_data(235:330,:);
        case 5
            MBHy_feature=IDT_feature_data(331:end,:);
    end
    
    clear IDT_feature_data;
    clear data;
    switch feature_type
        case 1
            %将每个视频随机采样得到的IDT特征保存起来
            if first_Mark==1    %先将各个类别的特征都结合起来,待会再随机采样然后聚类,首次进入
                Tarjectory_for_one_dir(1:size(Tarjectory_feature,1),1:num_of_features)=Tarjectory_feature;
                
                first_Mark=0;
            else    %非首次,累加
                Tarjectory_for_one_dir(:,1+size(Tarjectory_for_one_dir,2):num_of_features+size(Tarjectory_for_one_dir,2))=Tarjectory_feature;
            end
        case 2
            %将每个视频随机采样得到的IDT特征保存起来
            if first_Mark==1    %先将各个类别的特征都结合起来,待会再随机采样然后聚类,首次进入
                HOG_for_one_dir(1:size(HOG_feature,1),1:num_of_features)=HOG_feature;
                
                first_Mark=0;
            else    %非首次,累加
                HOG_for_one_dir(:,1+size(HOG_for_one_dir,2):num_of_features+size(HOG_for_one_dir,2))=HOG_feature;
            end
        case 3
            %将每个视频随机采样得到的IDT特征保存起来
            if first_Mark==1    %先将各个类别的特征都结合起来,待会再随机采样然后聚类,首次进入
                HOF_for_one_dir(1:size(HOF_feature,1),1:num_of_features)=HOF_feature;
                
                first_Mark=0;
            else    %非首次,累加
                HOF_for_one_dir(:,1+size(HOF_for_one_dir,2):num_of_features+size(HOF_for_one_dir,2))=HOF_feature;
            end
        case 4
            %将每个视频随机采样得到的IDT特征保存起来
            if first_Mark==1    %先将各个类别的特征都结合起来,待会再随机采样然后聚类,首次进入
                MBHx_for_one_dir(1:size(MBHx_feature,1),1:num_of_features)=MBHx_feature;
                
                first_Mark=0;
            else    %非首次,累加
                MBHx_for_one_dir(:,1+size(MBHx_for_one_dir,2):num_of_features+size(MBHx_for_one_dir,2))=MBHx_feature;
            end
        case 5
            %将每个视频随机采样得到的IDT特征保存起来
            if first_Mark==1    %先将各个类别的特征都结合起来,待会再随机采样然后聚类,首次进入
                MBHy_for_one_dir(1:size(MBHy_feature,1),1:num_of_features)=MBHy_feature;
                
                first_Mark=0;
            else    %非首次,累加
                MBHy_for_one_dir(:,1+size(MBHy_for_one_dir,2):num_of_features+size(MBHy_for_one_dir,2))=MBHy_feature;
            end
    end
    
    %检测是否达到20个视频,是的话直接进行采样
    if num_mark>=20
        num_mark=0;
        first_Mark=1;
        switch feature_type
            case 1
                feature_one_twenty=Tarjectory_for_one_dir;
                Tarjectory_for_one_dir=0;
            case 2
                feature_one_twenty=HOG_for_one_dir;
                HOG_for_one_dir=0;
            case 3
                feature_one_twenty=HOF_for_one_dir;
                HOF_for_one_dir=0;
            case 4
                feature_one_twenty=MBHx_for_one_dir;
                MBHx_for_one_dir=0;
            case 5
                feature_one_twenty=MBHy_for_one_dir;
                MBHy_for_one_dir=0;
        end
        
        feature_num=size(feature_one_twenty,2);
        quarter_300w=floor(3000000*20/(6766*20));
        one_dir_all_half=floor(feature_num/20);
        if quarter_300w>one_dir_all_half
            mean_point_num=randsample(one_dir_all_half:quarter_300w,1);
        else
            mean_point_num=randsample(quarter_300w:one_dir_all_half,1);
        end
        one_dir_sample_num=randsample(1:feature_num,mean_point_num);
        %%对一个文件夹下的某个特征进行随机采样
        feature_one_twenty_sample=0;
        for k=1:length(one_dir_sample_num)
            feature_one_twenty_sample(1:size(feature_one_twenty,1),k)=feature_one_twenty(:,one_dir_sample_num(k));
        end
        
        %%现在对采样得到的特征进行整合为一个矩阵,数据合起来得到一个该类特征的聚类矩阵
        if first_Mark_oyther==1    %先将各个类别的特征都结合起来,待会再随机采样然后聚类,首次进入
            feature_for_cluster_All_Dataset(1:size(feature_one_twenty_sample,1),1:size(feature_one_twenty_sample,2))=feature_one_twenty_sample;
            first_Mark_oyther=0;
        else    %非首次,累加
            feature_for_cluster_All_Dataset(:,1+size(feature_for_cluster_All_Dataset,2):size(feature_one_twenty_sample,2)+size(feature_for_cluster_All_Dataset,2))=feature_one_twenty_sample;
        end
        
        fprintf('20个IDT特征随机采样完成！\n',frature_full_name);
    end
    
    
    
end
%保存起来,上传到服务器进行随机采样并聚类
switch feature_type
    case 1
        save('Tarjectory_for_cluster_All_Dataset.mat','feature_for_cluster_All_Dataset');
    case 2
        save('HOG_for_cluster_All_Dataset.mat','feature_for_cluster_All_Dataset');
    case 3
        save('HOF_for_cluster_All_Dataset.mat','feature_for_cluster_All_Dataset');
    case 4
        save('MBHx_for_cluster_All_Dataset.mat','feature_for_cluster_All_Dataset');
    case 5
        save('MBHy_for_cluster_All_Dataset.mat','feature_for_cluster_All_Dataset');
end
feature_for_cluster_All_Dataset=0;
end
