function [remain_U,processors] = WF(C,types,subtasks_types,T,remain_U,EBT)
 
processors = zeros(1,length(C));

%%%%%%%%%%%% 开始根据EBT的顺序，按照remaining workload进行分配
temp_EBT = EBT;
for i = 1:length(C)
    [~,min_EBT_index] = min(temp_EBT); 
    current_subtask = min_EBT_index(C(min_EBT_index) == max(C(min_EBT_index)));
    current_subtask = current_subtask(1);
    temp_EBT(current_subtask) = inf;
%     current_subtask = i;
    subtask_core_range = sum(types(1:subtasks_types(current_subtask)-1)) + 1 : sum(types(1:subtasks_types(current_subtask)));
    core = subtask_core_range(remain_U(subtask_core_range) == max(remain_U(subtask_core_range)));
    processors(current_subtask) = core(1);
    
    remain_U(processors(current_subtask)) = remain_U(processors(current_subtask)) - C(current_subtask)/T;
  
end


end