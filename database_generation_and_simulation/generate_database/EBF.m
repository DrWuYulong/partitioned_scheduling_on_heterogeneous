function processors = EBF(C,topology,types,subtasks_types,T)
%%%%% �������������������񵽴������� EBT-order Best Fit
%%%%% ����C���������������WCET��types���治ͬ���ʹ�����core��������subtasks_type��ʾÿ��������ֻ��ִ�е�type,D��deadline
processors = zeros(1,length(C));
remain_U = ones(1,sum(types));
% current_time = 0; %�������浱ǰʱ��
% CRW = zeros(1,sum(types));         %current remaining workload
% CRU = ones(1,sum(types));      %current remaining utilization
EBT = zeros(1,length(C));
EFT = EBT;


%%%%%%%%%% ��ʼ���������������EBT
for i = 1:length(C)
    %%%%%% ��Ϊ���ɵ�ʱ��Ͳ����ڱ�i���ָ��i�ıߣ����Ե��㵽i��ʱ��iǰ���pre��ȷ��������
    EFT(i) = EBT(i) + C(i);%%%%% ���µ�ǰvi��EFT
    %����������ʼ����vi��suc��EBT
    suc_vi = find(topology(i,:) == 1);%%%�ҵ�suc
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













