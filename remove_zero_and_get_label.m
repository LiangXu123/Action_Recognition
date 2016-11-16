function [train_data,train_label,test_data,test_label]=remove_zero_and_get_label(train_data,test_data,video_dir_name,all_list,train_list,test_list)

%%generate train_label and  test_label from list
video_classes=length(video_dir_name);
all_num=length(test_list);
for i=all_num:-1:1
    for j=1:video_classes
        if length(findstr(test_list{i},video_dir_name{j}))==1
            test_label(i)=j;
            continue;
        end
    end
end
all_num=length(train_list);
for i=all_num:-1:1
    for j=1:video_classes
        if length(findstr(train_list{i},video_dir_name{j}))==1
            train_label(i)=j;
            continue;
        end
    end
end

%%
train_label=train_label';
test_label=test_label';
%%添加去零代码
all_num=size(test_data,1);
one_row_zero=zeros(1,size(test_data,2));
for del_zero_row_num=all_num:-1:1
    if test_data(del_zero_row_num,:)==one_row_zero
        test_data(del_zero_row_num,:)=[];
        test_label(del_zero_row_num,:)=[];
    end
end
all_num=size(train_data,1);
one_row_zero=zeros(1,size(train_data,2));
for del_zero_row_num=all_num:-1:1
    if train_data(del_zero_row_num,:)==one_row_zero
        train_data(del_zero_row_num,:)=[];
        train_label(del_zero_row_num,:)=[];
    end
end
save('train_data.mat','train_data');
save('train_label.mat','train_label');
save('test_data.mat','test_data');
save('test_label.mat','test_label');
end