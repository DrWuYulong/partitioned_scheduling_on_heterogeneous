function processors = LWF(C,topology,types,subtasks_type,D)
%%%%%%%%% level-based worst fit分配策略

remain_U = ones(1,sum(types)); %所有核当前的剩余利用率
 
subtask_numb = length(topology);

%%%%%%%%% 初始化
processors = zeros(1,subtask_numb);

L = level(topology); %%%% 分层

%%%%%%%%%%%%% EBT 计算每个子任务的最早开始时间
EBT = zeros(1,subtask_numb);
EFT = EBT;

for i = 1:subtask_numb
    % 是否有predecessor
    pre = find(topology(:,i) == 1);
    if ~isempty(pre)
        EBT(i) = max(EFT(pre));
        EFT(i) = EBT(i) + C(i);
    else
        EFT(i) = C(i);
    end
end

%%%%%%%%%%%%% 开始按层分配
for i = 1:length(L)
    current_level = L{i};
    [remain_U,processors(current_level)] = WF(C(current_level),types,subtasks_type(current_level),D,remain_U,EBT(current_level));
      
end
















