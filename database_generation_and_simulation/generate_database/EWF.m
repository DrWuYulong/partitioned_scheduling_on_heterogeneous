function processors = EWF(C,topology,types,subtasks_types,T)
%%%%% �������������������񵽴������� remaining workload based (MRW) ����
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

%%%%%%%%%%%% ��ʼ����EBT��˳�򣬰���remaining workload���з���
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

% for i = 1:length(C)
%     subtask_core_range = sum(types(1:subtasks_types(i)-1)) + 1 : sum(types(1:subtasks_types(i)));
%     core = subtask_core_range(U_remain(subtask_core_range) == max(U_remain(subtask_core_range)));
%     partition_EWF(i) = core(1);
%     U_remain(partition_EWF(i)) = U_remain(partition_EWF(i)) - C(i)/T;
% end

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













