function L = level(topology)
%%%����������DAG��������˽ṹ���зֲ�
L = {};
x = length(topology);
t = zeros(1,x);

i = 1;
current_level = find(sum(topology) == 0); %%%�ҵ�source node����һ��
t(current_level) = i;
while ~isempty(current_level)
    if length(current_level) > 1
        next_level = find(sum(topology(current_level,:) == 1) > 0);
    else
        next_level = find(topology(current_level,:) == 1);
    end
    
    if ~isempty(next_level)
        t(next_level) = i + 1;
        current_level = next_level;
    else
        break;
    end
    i = i + 1;
end

i = 1;
while sum(t == i) ~= 0
    L{i} = find(t == i);
    i = i + 1;
end

end