function [PIS,Des] = find_PIS(topology,T)
%%%%% �ú���Ѱ��DAG�и����������Ǳ�ڸ��������񣬲����ؼ���potential interference set PIS
%%%%% topology��ʾ��������˽ṹ��T��ʾ���������񱻷��䵽�Ĵ������ļ���
 
Ans = cell(1,length(topology)); %%%���ȼ��ϣ�Ans(i)  ,��ʾi�����ȼ���
Des = Ans; %%%�󱲼��ϣ�Des(i)����ʾi�ĺ󱲼��ϡ�
PIS = zeros(length(topology));
%%%%%%%%%%%%%% ��ʼ��Ans %%%%%%%%%%%%%%%

temp_topology = topology;
temp_V = 1:length(topology);

Ans{1} = 1;

while sum(temp_V) ~= 0
    %%%%% �����Ϊ0�ĵ� %%%%%
    vi = find(sum(temp_topology) == 0);
    vi = vi(1);
    suc_vi = find(temp_topology(vi,:) == 1);
    for j = 1:length(suc_vi)
        vj = suc_vi(j);     % vj��vi�ĺ��
        pre_vj = find(temp_topology(:,vj) == 1);
        for k = 1:length(pre_vj)
            vk = pre_vj(k);     %vk��ʾvj��ǰ��
            Ans{vj} = union(Ans{vj},Ans{vk});
        end
        Ans{vj} = union(Ans{vj},vj);
        temp_topology(vi,vj) = 0;
    end
    temp_V(vi) = 0;
    temp_topology(:,vi) = 2;
    
end

%%%%%%%%%%%%%% ��ʼ��Des %%%%%%%%%%%%%%%

temp_topology = topology;
temp_V = 1:length(topology);

% Ans(1,1) = 1;
Des{end} = length(topology);

while sum(temp_V) ~= 0
    %%%%% �ҳ���Ϊ0�ĵ� %%%%%
    vi = find(sum(temp_topology,2) == 0);
    vi = vi(1);
    pre_vi = find(temp_topology(:,vi) == 1);
    for j = 1:length(pre_vi)
        vj = pre_vi(j); % vj��vi�ĺ��
        suc_vj = find(temp_topology(vj,:) == 1);
        for k = 1:length(suc_vj)
            vk = suc_vj(k);%vk��ʾvj��ǰ��
            Des{vj} = union(Des{vj},Des{vk});
        end
        Des{vj} = union(Des{vj},vj);
        temp_topology(vj,vi) = 0;
    end
    temp_topology(vi,:) = 2;
    temp_V(vi) = 0;    
    
end

%%%%%%%%%%%%%%%%%% �ϲ�Ans��Des ��ΪPIS��potential interference set��
for i = 1:length(topology)
    for j = 1:1:length(topology)
        if (T(i) == T(j))&&(i ~= j)&&(isempty(intersect(union(Ans{i},Des{i}),j)))
            PIS(i,j) = 1;
        end
    end
end

end
















