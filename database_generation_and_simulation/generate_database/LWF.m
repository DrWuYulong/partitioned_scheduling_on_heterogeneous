function processors = LWF(C,topology,types,subtasks_type,D)
%%%%%%%%% level-based worst fit�������

remain_U = ones(1,sum(types)); %���к˵�ǰ��ʣ��������
 
subtask_numb = length(topology);

%%%%%%%%% ��ʼ��
processors = zeros(1,subtask_numb);

L = level(topology); %%%% �ֲ�

%%%%%%%%%%%%% EBT ����ÿ������������翪ʼʱ��
EBT = zeros(1,subtask_numb);
EFT = EBT;

for i = 1:subtask_numb
    % �Ƿ���predecessor
    pre = find(topology(:,i) == 1);
    if ~isempty(pre)
        EBT(i) = max(EFT(pre));
        EFT(i) = EBT(i) + C(i);
    else
        EFT(i) = C(i);
    end
end

%%%%%%%%%%%%% ��ʼ�������
for i = 1:length(L)
    current_level = L{i};
    [remain_U,processors(current_level)] = WF(C(current_level),types,subtasks_type(current_level),D,remain_U,EBT(current_level));
      
end
















