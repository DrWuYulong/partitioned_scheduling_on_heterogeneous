function partitioned_results = WF(C,types,subtasks_types,T)

U_remain = ones(1,sum(types));
partitioned_results = zeros(1,length(C));

for i = 1:length(C)
    subtask_core_range = sum(types(1:subtasks_types(i)-1)) + 1 : sum(types(1:subtasks_types(i)));
    core = subtask_core_range(U_remain(subtask_core_range) == max(U_remain(subtask_core_range)));
    partitioned_results(i) = core(1);
    
    U_remain(partitioned_results(i)) = U_remain(partitioned_results(i)) - C(i)/T;

end
end