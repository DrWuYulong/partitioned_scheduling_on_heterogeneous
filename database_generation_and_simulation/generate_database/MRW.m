function partition_MRW = MRW(C,topology,types,subtasks_type,D)
%%%%% 本函数用来分配子任务到处理器上 remaining workload based (MRW) 方法
%%%%% 其中C保存所有子任务的WCET，types保存不同类型处理器core的数量，subtasks_type表示每个子任务只能执行的type,D是deadline
partition_MRW = zeros(1,length(C));
current_time = 0; %用来保存当前时间
CRW = zeros(1,sum(types));         %current remaining workload
CRU = ones(1,sum(types));      %current remaining utilization
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

%%%%%%%%%%%% 开始根据EBT的顺序，按照remaining workload进行分配
temp_EBT = EBT;
for i = 1:length(C)
    min_EBT_index = find(temp_EBT == min(temp_EBT)); 
    current_subtask = min_EBT_index(C(min_EBT_index) == max(C(min_EBT_index)));
    current_subtask = current_subtask(1);
    temp_EBT(current_subtask) = inf;
    
    %%%% 找到符合条件的current了，开始分配给CRW最小的任务
    time_interval = EBT(current_subtask) - current_time;
    if time_interval > 0 % 大于0表示时间开始往后流逝了，更新current remaining workload
        current_time = current_time + time_interval;
        CRW = max(CRW - time_interval,0); 
    end
    %%%% 将当前current_subtask 分配给符合type cores中CRW最小的那个core
    meet_cores_begin = sum(types(1:subtasks_type(current_subtask)-1));
    meet_cores = meet_cores_begin + (1:types(subtasks_type(current_subtask))); %%%%% 绝对位置 [13 17 20]
    %%%% meet_cores表示当前子任务所能分配的type，找到CRW最小的那个core
    allocate_index = find(CRW(meet_cores) == min(CRW(meet_cores))); %%%% meet_cores的相对位置 [2 3]
    if length(allocate_index) > 1
        % 有多个CRW满足，则找CRU最大的分配
        temp_index = find(CRU(meet_cores(allocate_index)) == max(CRU(meet_cores(allocate_index)))); % 相对值
        allocate_index = allocate_index(temp_index(1));
    end
%     meet_cores(allocate_index)
    partition_MRW(current_subtask) = meet_cores(allocate_index);
    %%%% 更新CRW，CRU
    CRW(partition_MRW(current_subtask)) = CRW(partition_MRW(current_subtask)) + C(current_subtask);
    CRU(partition_MRW(current_subtask)) = CRU(partition_MRW(current_subtask)) - C(current_subtask)/D;
    
    
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













