function [train_data,train_label]=hist_2_train_test_randsample_plus(Train_Test_rate)
%%将hist矩阵按train:test=7:3的比例进行分割,得到reain的矩阵和test的矩阵(只处理L2Norm过的矩阵)
%%然后将所有直方图矩阵分割为融合为一个train和test,并分别保存其label和data
%各个分类视频文件夹名字,也就是动作类别的标号
video_dir_name={'brush_hair','cartwheel','catch','chew','clap','climb','climb_stairs',...
    'dive','draw_sword','dribble','drink','eat','fall_floor','fencing',...
    'flic_flac','golf','handstand','hit','hug','jump','kick',...
    'kick_ball','kiss','laugh','pick','pour','pullup','punch',...
    'push','pushup','ride_bike','ride_horse','run','shake_hands','shoot_ball',...
    'shoot_bow','shoot_gun','sit','situp','smile','smoke','somersault',...
    'stand','swing_baseball','sword','sword_exercise','talk','throw','turn',...
    'walk','wave'};
%各个文件夹下视频的数目
video_dir_name_video_number=[107,107,102,109,130,108,112,...
    127,103,145,164,108,136,116,...
    107,105,113,127,118,151,130,...
    128,102,128,106,106,104,126,...
    116,103,103,116,232,162,131,...
    112,103,142,105,102,109,140,...
    154,143,127,127,120,102,240,...
    548,104];

%并行计算加速
pre_path='/media/xl/Project_Lab/Action_Dataset/hmdb51/';
first_in_mark=1;
first_in_mark_test=1;
for i=1:length(video_dir_name)
    %%将一个文件夹的IDT保存为一个hist文件
    save_hist_feature_path_L2Norm=strcat(pre_path,video_dir_name{i},'/ALL_Hist_features_one_dir_L2Norm.mat');
    ALL_Hist_features_one_dir_L2Norm=load(save_hist_feature_path_L2Norm);
    ALL_Hist_features_one_dir_L2Norm=ALL_Hist_features_one_dir_L2Norm.ALL_Hist_features_one_dir_L2Norm;
    ALL_Hist_features_one_dir_L2Norm_backup_test=ALL_Hist_features_one_dir_L2Norm;
    
    feature_number=size(ALL_Hist_features_one_dir_L2Norm,1);
    %%随机采样0.8倍作为训练样本
    train_feature_number=floor(feature_number*Train_Test_rate);
    N=randsample(1:feature_number,train_feature_number);
    N=sort(N,'descend');
    TRAIN_Hist_features_one_dir_L2Norm=zeros(length(N),size(ALL_Hist_features_one_dir_L2Norm,2));
    for kk=1:1:train_feature_number
        TRAIN_Hist_features_one_dir_L2Norm(kk,:)=ALL_Hist_features_one_dir_L2Norm(N(kk),:);
        %随机训练样本抽取完毕
        ALL_Hist_features_one_dir_L2Norm_backup_test(N(kk),:)=[];
    end
    
    TRAIN_hist_feature=TRAIN_Hist_features_one_dir_L2Norm;
    if first_in_mark==1 %首次进入
        first_in_mark=0;
        row_num=size(TRAIN_hist_feature,1);
        train_data(1:row_num,:)=TRAIN_hist_feature;
        train_label(1:row_num,1)=i;  %一行为一个特征,动作标签为序号
    else
        start=row_num+1;
        row_num=row_num+size(TRAIN_hist_feature,1);
        train_data(start:row_num,:)=TRAIN_hist_feature;
        train_label(start:row_num,1)=i;  %一行为一个特征,动作标签为序号
    end
    
    TEST_hist_feature=ALL_Hist_features_one_dir_L2Norm_backup_test;
    if first_in_mark_test==1 %首次进入
        first_in_mark_test=0;
        row_num_plus=size(TEST_hist_feature,1);
        test_data(1:row_num_plus,:)=TEST_hist_feature;
        test_label(1:row_num_plus,1)=i;  %一行为一个特征,动作标签为序号
    else
        start_plus=row_num_plus+1;
        row_num_plus=row_num_plus+size(TEST_hist_feature,1);
        test_data(start_plus:row_num_plus,:)=TEST_hist_feature;
        test_label(start_plus:row_num_plus,1)=i;  %一行为一个特征,动作标签为序号
    end
    
    
  %  if i<=10
  %      %%保存test的数据集
  %      list=1:feature_number;
%        for iiii=1:length(N)
 %           list(N(iiii))=0;
  %      end
   %     list(find(list==0))=[];
   %     test_list=strcat(video_dir_name{i},'_testlist.txt');
   %     save(test_list,'list','-ascii' );
   %     clear list;
  %  end
    
end
save('train_data.mat','train_data');
save('train_label.mat','train_label');
save('test_data.mat','test_data');
save('test_label.mat','test_label');
clear test_data;
clear test_label;
end
