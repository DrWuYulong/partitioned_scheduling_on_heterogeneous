function [WCRT,partition_MCW] = MCW(C,E,EBT,Ans,Des,types,pre_T)
%%%%%%%% minimizing current WCRT (MCW) allocation strategy.
%%%%%%%% E表示拓扑结构，EBT是最早完成时间集合，types是系统types，pre_T是子任务绑定的type


unallocated_subtasks = 1:length(C);
temp_C = zeros(1,length(C));
partition_MCW = temp_C;
WCRT = 0;
PIS = zeros(length(C));



while ~isempty(unallocated_subtasks)
    vi_index = find(EBT(unallocated_subtasks) == min(EBT(unallocated_subtasks))); %%% vi_index是unallocated_subtasks的索引
    if length(vi_index) > 1
        max_C_index = find(C(unallocated_subtasks(vi_index)) == max(C(unallocated_subtasks(vi_index)))); % 是vi_index的索引
        vi_index = vi_index(max_C_index);
    end
    vi_index = vi_index(1);
    vi = unallocated_subtasks(vi_index);
    unallocated_subtasks(vi_index) = [];
    temp_C(vi) = C(vi);     %%%%%%%%%%%% 更新 C(vi)
    
    type_vi = pre_T(vi);
    allocation_range = (1:types(type_vi)) + sum(types(1:type_vi-1)); %%%%%%保存当前vi可分配的所有core
    temp_WCRT = inf;                                %%%% 储存当前vi；
    temp_core = partition_MCW;                %%%% 当前vi分配给那个core使得LFT最小

    for check_core = allocation_range
        %%%%%%%%% 首先初始化 PIS %%%%%%%%%%
        current_PIS = PIS;
        temp_core(vi) = check_core; %%% 分配给当前check的core
        same_cores = find(temp_core == check_core);
        for check_PIS = 1:length(same_cores)
            vj = same_cores(check_PIS);
            %%%%%% 判断是否满足PIS
            if (vi ~= vj)&&(isempty(intersect(union(Ans{vi},Des{vi}),vj)))
                current_PIS(vi,vj) = 1;
                current_PIS(vj,vi) = 1;
            end
        end
        
        %%%%%%%%%%% 开始计算当前的WCRT %%%%%%%%%%%%%%%            
        temp_LFT = calculate_WCRT_EOI(temp_C,E,EBT,current_PIS,Des);        %%%%% 计算当前的
        if temp_LFT < temp_WCRT
            temp_WCRT = temp_LFT;
            partition_MCW(vi) = check_core;
            temp_PIS = current_PIS;
        end
    end
    %%%%%%%%%%%%%%%%% 此时，所有temp_保存的都是最优的了，开始赋值
    PIS = temp_PIS;
    WCRT = max(WCRT,temp_LFT);

end

end














