function path = find_path(topologies)
%��������DAG���������˽ṹ�ֽ��·����
path = {};
%%%%%%��ʼ��2��ջ��o��ʾδ�����ڵ㣬p��ʾ�Ѿ�����·��

%���ڵ��ʼ����������Դ�ڵ�ѹջo
stack_o = find(sum(topologies) == 0);
stack_p = [];
index_temp = 1;
while ~isempty(stack_o)%ֻҪδ����Ľڵ�ջ��Ϊ��
    %����ջ���ڵ㣬ѹ�뵽·��ջ����
    current_p = stack_o(end);%��ǰ�����ڵ�       
    stack_o(length(stack_o)) = [];
    stack_p = [stack_p current_p];
    %Ȼ�󽫵����ڵ���ӽڵ�ѹջ��δ����Ķ���ջ��
    stack_o = [stack_o find(topologies(current_p,:) == 1)];

    %%%%�ж��Ƿ�·�����˽����ڵ�
    if sum(topologies(stack_p(end),:)) == 0%pջ��Ԫ�ص���ĩβ�ڵ�
        path = [path stack_p];%%%��¼����·��
        stack_p(end) = [];%·��ĩβ�ڵ㵯��
        
        %ֻҪ·��ջ���ǿյģ�����pջ��Ԫ�ز���oջ��Ԫ�صĸ��ڵ�͵��������ݵ��µ�δ������·���ĸ��ڵ�
        while ~isempty(stack_p) && ~isempty(stack_o) && topologies(stack_p(end),stack_o(end)) == 0
            stack_p(end) = [];
        end
    end
end

end