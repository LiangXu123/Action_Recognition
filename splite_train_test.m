function [all_list,train_list,test_list]=splite_train_test(pre_path,Train_rate)
%%get the train list and test list
num_mark=0;
dir_pre_path=dir(pre_path);
for i=3:length(dir_pre_path)
    dir_name=strcat(pre_path,'/',dir_pre_path(i).name);
    video_dir=dir([dir_name,'/*.mat']);
    for j=1:length(video_dir) %do for every video
        num_mark=num_mark+1;
        frature_full_name=strcat(dir_name,'/',video_dir(j).name); %every video identity name and full path
        all_list{num_mark}=frature_full_name;
    end
end
%%splite to train and test set
all_num=length(all_list);
idx=randperm(all_num);
train_rate=floor(all_num*Train_rate);
train_list  =all_list(idx(1:train_rate));
test_list=all_list(idx(train_rate+1:end));
save('all_list.mat','all_list');
save('train_list.mat','train_list');
save('test_list.mat','test_list');
end