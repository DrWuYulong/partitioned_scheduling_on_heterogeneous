function topology = IED(topology)
%%%�κ�����topology�������е����ñ߶�ɾ��
%�����ҵ����и��ڵ����1��������
V_b = find(sum(topology) > 1);

for i = 1:length(V_b)
    pre = find(topology(:,V_b(i)) == 1);
    for x = 1:length(pre) - 1
        for y = x+1:length(pre)
            if find_precedence_constraint(topology,pre(x),pre(y))
                topology(pre(x), V_b(i)) = 0;
            elseif find_precedence_constraint(topology,pre(y),pre(x))
                topology(pre(y), V_b(i)) = 0;
            end
        end
    end      
    
end

end