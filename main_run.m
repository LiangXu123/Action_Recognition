%%ultimate version of BOW method(use idt feature)
clc;
clear all;
close all;
%各个分类视频文件夹名字,也就是动作类别的标号
video_dir_name={'brush_hair','cartwheel','catch','chew','clap','climb','climb_stairs',...
    'dive','draw_sword','dribble','drink','eat','fall_floor','fencing',...
    'flic_flac','golf','handstand','hit','hug','jump','kick',...
    'kick_ball','kiss','laugh','pick','pour','pullup','punch',...
    'push','pushup','ride_bike','ride_horse','run','shake_hands','shoot_ball',...
    'shoot_bow','shoot_gun','sit','situp','smile','smoke','somersault',...
    'stand','swing_baseball','sword','sword_exercise','talk','throw','turn',...
    'walk','wave'};
%pre_path='/home/xuliang/hmdb51_hist_fv/';
pre_path='/media/xl/Project_Lab/Action_Dataset/hmdb51';
run('/usr/local/MATLAB/R2015b/toolbox/vlfeat-0.9.20/toolbox/vl_setup.m');
Train_Test_rate=0.5;
loop_num=10;
for i=1:loop_num
    %splite all data to train data and test and respectively
    [all_list,train_list,test_list]=splite_train_test(pre_path,Train_Test_rate);
    %random sample five part of idt,save the sampled data as
    %Tarjectory_for_cluster_All_Dataset.mat .......
    get_cluster_plus(train_list,0);
    
    %sample and cluster use k-means
    sample_number=1000000;
    codebook_size=4000;
    one_by_one_cluster(sample_number,codebook_size);
    %bow for train_data and test respectively
    %save ALL_Hist_features_dataset_train.mat and
    %ALL_Hist_features_dataset_test.mat
    all_hist_hmdb51_plus(train_list,pre_path);
    all_hist_hmdb51_plus(test_list,pre_path);
    %load train data
    save_hist_feature_path=strcat(pre_path,'/','ALL_Hist_features_dataset_train.mat');
    train_data=load(save_hist_feature_path,'ALL_Hist_features_dataset');
    train_data=train_data.ALL_Hist_features_dataset;
    %load test data
    save_hist_feature_path=strcat(pre_path,'/','ALL_Hist_features_dataset_test.mat');
    test_data=load(save_hist_feature_path,'ALL_Hist_features_dataset');
    test_data=test_data.ALL_Hist_features_dataset;
    %remove zeros row and get label
    [train_data,train_label,test_data,test_label]=remove_zero_and_get_label(train_data,test_data,video_dir_name,all_list,train_list,test_list);
    %使用liblinear 1 vs  rest策略
    fprintf('训练样本加载完毕!\n');
    
    options='-s 4 -c 200';
    train_model= train(train_label,sparse(train_data),options);
    fprintf('训练完毕!\n');
    clear train_data;
    
    [predictlabel,accuracy,prob_estimates]= predict(test_label,sparse(test_data),train_model,'-b 1');
    clear test_data;
    acc_times(i,1)=max(accuracy);
    
end
fprintf('训练预测完毕!\n');
mean(acc_times)