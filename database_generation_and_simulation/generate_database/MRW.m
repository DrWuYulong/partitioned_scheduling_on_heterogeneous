function partition_MRW = MRW(C,topology,types,subtasks_type,D)
%%%%% �������������������񵽴������� remaining workload based (MRW) ����
%%%%% ����C���������������WCET��types���治ͬ���ʹ�����core��������subtasks_type��ʾÿ��������ֻ��ִ�е�type,D��deadline
partition_MRW = zeros(1,length(C));
current_time = 0; %�������浱ǰʱ��
CRW = zeros(1,sum(types));         %current remaining workload
CRU = ones(1,sum(types));      %current remaining utilization
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
    min_EBT_index = find(temp_EBT == min(temp_EBT)); 
    current_subtask = min_EBT_index(C(min_EBT_index) == max(C(min_EBT_index)));
    current_subtask = current_subtask(1);
    temp_EBT(current_subtask) = inf;
    
    %%%% �ҵ�����������current�ˣ���ʼ�����CRW��С������
    time_interval = EBT(current_subtask) - current_time;
    if time_interval > 0 % ����0��ʾʱ�俪ʼ���������ˣ�����current remaining workload
        current_time = current_time + time_interval;
        CRW = max(CRW - time_interval,0); 
    end
    %%%% ����ǰcurrent_subtask ���������type cores��CRW��С���Ǹ�core
    meet_cores_begin = sum(types(1:subtasks_type(current_subtask)-1));
    meet_cores = meet_cores_begin + (1:types(subtasks_type(current_subtask))); %%%%% ����λ�� [13 17 20]
    %%%% meet_cores��ʾ��ǰ���������ܷ����type���ҵ�CRW��С���Ǹ�core
    allocate_index = find(CRW(meet_cores) == min(CRW(meet_cores))); %%%% meet_cores�����λ�� [2 3]
    if length(allocate_index) > 1
        % �ж��CRW���㣬����CRU���ķ���
        temp_index = find(CRU(meet_cores(allocate_index)) == max(CRU(meet_cores(allocate_index)))); % ���ֵ
        allocate_index = allocate_index(temp_index(1));
    end
%     meet_cores(allocate_index)
    partition_MRW(current_subtask) = meet_cores(allocate_index);
    %%%% ����CRW��CRU
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













