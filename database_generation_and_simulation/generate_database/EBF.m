function processors = EBF(C,topology,types,subtasks_types,T)
%%%%% 本函数用来分配子任务到处理器上 EBT-order Best Fit
%%%%% 其中C保存所有子任务的WCET，types保存不同类型处理器core的数量，subtasks_type表示每个子任务只能执行的type,D是deadline
processors = zeros(1,length(C));
remain_U = ones(1,sum(types));
% current_time = 0; %用来保存当前时间
% CRW = zeros(1,sum(types));         %current remaining workload
% CRU = ones(1,sum(types));      %current remaining utilization
EBT = zeros(1,length(C));
EFT = EBT;


%%%%%%%%%% 开始计算所有子任务的EBT
for i = 1:length(C)
    %%%%%% 因为生成的时候就不存在比i大的指向i的边，所以当算到i的时候，i前面的pre都确定算完了
    EFT(i) = EBT(i) + C(i);%%%%% 更新当前vi的EFT
    %接下来，开始更新vi的suc的EBT
    suc_vi = find(topology(i,:) == 1);%%%找到suc
    for j = 1:length(suc_vi)
        vj = suc_vi(j);
        vk = find(topology(:,vj) == 1);
        EBT(vj) = max(EFT(vk));
    end
end



temp_EBT = EBT;
for i = 1:length(C)
    [~,min_EBT_index] = min(temp_EBT); 
    current_subtask = min_EBT_index(C(min_EBT_index) == max(C(min_EBT_index)));
    current_subtask = current_subtask(1);
    temp_EBT(current_subtask) = inf;
%     current_subtask = i;
    cores_range = sum(types(1:subtasks_types(current_subtask)-1)) + 1 : sum(types(1:subtasks_types(current_subtask)));
    
    temp_remain_U = remain_U(cores_range); % temp_remain_U = [0.2 0.5 0.6 0.4]
    for j = 1:length(temp_remain_U)-1
        [~,current_core] = min(temp_remain_U);
        current_core = current_core(1);
        if (temp_remain_U(current_core) - C(current_subtask)/T) < 0
            temp_remain_U(current_core) = inf;
            continue;
        end
        processors(current_subtask) = current_core;
        remain_U(processors(current_subtask)) = remain_U(processors(current_subtask)) - C(current_subtask)/T;
        break;
    end
    
    if processors(current_subtask) == 0
        [~,current_core] = max(remain_U(cores_range));
        current_core = current_core(1);
        processors(current_subtask) = cores_range(current_core);
        remain_U(processors(current_subtask)) = remain_U(processors(current_subtask)) -  C(current_subtask)/T;
    end

    
end

end

% C = [1 5 2 3 4 2 5 2 2 3 2 2];
% topology = [0 1 1 1 1 0 0 0 0 0 0 0;
%             0 0 0 0 0 1 0 0 0 0 0 0;
%             0 0 0 0 0 0 1 0 0 0 0 0;
%             0 0 0 0 0 0 0 1 0 0 0 0;
%             0 0 0 0 0 0 0 0 1 0 0 0;
%             0 0 0 0 0 0 0 0 0 0 1 0;
%             0 0 0 0 0 0 0 0 0 1 0 0;
%             0 0 0 0 0 0 0 0 0 0 1 0;
%             0 0 0 0 0 0 0 0 0 0 0 1;
%             0 0 0 0 0 0 0 0 0 0 1 0;
%             0 0 0 0 0 0 0 0 0 0 0 1;
%             0 0 0 0 0 0 0 0 0 0 0 0];













