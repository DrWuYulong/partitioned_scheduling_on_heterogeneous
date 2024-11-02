function T = PA(subtask_numb, types)
%%%% 根据Han提出的比例分配法(proportional allocation PA)将子任务分配个不同的types
%%%% types = [3 5 5]表示一共有3个类型的types，每个type的核心数分别为3,5,5
    T = zeros(1,subtask_numb);
    V_int = round(subtask_numb * types ./ sum(types));  % 保存的每个type对应的子任务个数
    %%% 看看四舍五入后和原来的V_numb 有没有偏差
    diff = sum(V_int) - subtask_numb; %保存子任务数量偏差值
    diff_v = subtask_numb * types ./ sum(types) - V_int; %保存四舍五入变化差值，按比例分的 - 四舍五入后的
    temp_index_diff_v = 1: length(diff_v); %方便定位和操作
    while diff ~= 0 %表示有偏差
        if diff > 0 %%表示四舍五入后比原来子任务的数量多了，需要往下减少。diff_v越小（负的越多）表示之前越不应该进一，现在减下去
            temp_index = find(min(diff_v(temp_index_diff_v)) == diff_v(temp_index_diff_v));
            temp_index = temp_index(1);
            change_index = temp_index_diff_v(temp_index);
            V_int(change_index) = V_int(change_index) - 1;
            temp_index_diff_v(temp_index) = [];
            diff = diff - 1;
        else
            temp_index = find(max(diff_v(temp_index_diff_v)) == diff_v(temp_index_diff_v));
            temp_index = temp_index(1);
            change_index = temp_index_diff_v(temp_index);
            V_int(change_index) = V_int(change_index) + 1;
            temp_index_diff_v(temp_index) = [];
            diff = diff + 1;
        end
        
    end
    %%%%%% 此时V_int 已经按比例选出来了，开始分配子任务以及其对应的处理器
    rest_V = 1:subtask_numb; %%%%%% 表示还没分配的subtasks
    for i = 1:length(types)-1 %%% 按照type的顺序分配
        while V_int(i) ~= 0 % 如果等于0，则表示该type不需要分配子任务了
           %随机从rest_V里面抽取一个子任务分配给当前的type i
           current_subtask_index = randi([1 length(rest_V)],1);
           current_subtask = rest_V(current_subtask_index);
           rest_V(current_subtask_index) = [];
           T(current_subtask) = i;
           V_int(i) = V_int(i) - 1;
        end
    end
    T(rest_V) = length(types);
end

















