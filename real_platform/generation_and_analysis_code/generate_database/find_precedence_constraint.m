function pc = find_precedence_constraint(topology,a,b)
%%%%%% �ú����жϽڵ�a�ǲ��ǽڵ�b��ǰ�̻���ǰ����������pc=1����pc=0
x = length(topology); 

%%%%���ж�a�Ƿ���b��ֱ��ǰ��������
if topology(a,b) == 1
    pc = 1;
    return
end

%%%�����ж�b��û��ǰ��������
if sum(topology(:,b)) == 0
    pc = 0;
    return
else
    pre = find(topology(:,b) == 1);
    if sum(pre == a) %%a��b��ֱ��ǰ��������
        pc = 1;
        return
    else
        stack_b = pre; %%% ����ѹջ
    end
end

while ~isempty(stack_b) %%%ջ��Ϊ�����ʾb�ļ��ǰ��������û�������꣬��Ҫ��������
    curr_sub = stack_b(1);%����ջ��Ԫ�ز��鿴��ǰ��������
    stack_b(1) = [];
    pre = find(topology(:,curr_sub) == 1); 
    if ~isempty(pre)
        if sum(pre == a) %%a��b�ļ��ǰ��������
            pc = 1;
            return
        else
            stack_b = [stack_b; pre]; %%%%����ѹջ
        end
    end
end

pc = 0; %%%�Ѿ��������ˣ���û��ƥ�䵽��

end
















