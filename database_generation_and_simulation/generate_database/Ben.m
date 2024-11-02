function allocation_result = Ben(C,types,subtasks_type,T,topology)
%%%%% Ben的分配方法

U = zeros(1,sum(types)); %初始化每个核心的利用率
L = level(topology);
%%%%%% 先根据拓扑结构分层

for i = 1:length(L)
    current_level = L{i};

    for j = 1:length(current_level)
        v_now = current_level(j);
        suit_cores = sum(types(1:subtasks_type(v_now)-1))+1:sum(types(1:subtasks_type(v_now))); % v_now所述类型的核心index
        allocation_result(v_now) = suit_cores(1); %#ok<AGROW>
        min_cost = inf;
        for k = 1:length(suit_cores)
            core_now = suit_cores(k);
            F_cost = C(v_now) / (1-U(core_now));
            if F_cost < min_cost && (U(core_now)+C(v_now)/T) <= 1
                min_cost = F_cost;
                allocation_result(v_now) = core_now;
            end
        end
        U(allocation_result(v_now)) = U(allocation_result(v_now)) + C(v_now)/T;
    end

end





















