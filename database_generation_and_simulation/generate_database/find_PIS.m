function [PIS,Des] = find_PIS(topology,T)
%%%%% 该函数寻找DAG中各个子任务的潜在干扰子任务，并返回集合potential interference set PIS
%%%%% topology表示任务的拓扑结构，T表示各个子任务被分配到的处理器的集合
 
Ans = cell(1,length(topology)); %%%祖先集合，Ans(i)  ,表示i的祖先集合
Des = Ans; %%%后辈集合，Des(i)，表示i的后辈集合。
PIS = zeros(length(topology));
%%%%%%%%%%%%%% 开始找Ans %%%%%%%%%%%%%%%

temp_topology = topology;
temp_V = 1:length(topology);

Ans{1} = 1;

while sum(temp_V) ~= 0
    %%%%% 找入度为0的点 %%%%%
    vi = find(sum(temp_topology) == 0);
    vi = vi(1);
    suc_vi = find(temp_topology(vi,:) == 1);
    for j = 1:length(suc_vi)
        vj = suc_vi(j);     % vj是vi的后继
        pre_vj = find(temp_topology(:,vj) == 1);
        for k = 1:length(pre_vj)
            vk = pre_vj(k);     %vk表示vj的前继
            Ans{vj} = union(Ans{vj},Ans{vk});
        end
        Ans{vj} = union(Ans{vj},vj);
        temp_topology(vi,vj) = 0;
    end
    temp_V(vi) = 0;
    temp_topology(:,vi) = 2;
    
end

%%%%%%%%%%%%%% 开始找Des %%%%%%%%%%%%%%%

temp_topology = topology;
temp_V = 1:length(topology);

% Ans(1,1) = 1;
Des{end} = length(topology);

while sum(temp_V) ~= 0
    %%%%% 找出度为0的点 %%%%%
    vi = find(sum(temp_topology,2) == 0);
    vi = vi(1);
    pre_vi = find(temp_topology(:,vi) == 1);
    for j = 1:length(pre_vi)
        vj = pre_vi(j); % vj是vi的后继
        suc_vj = find(temp_topology(vj,:) == 1);
        for k = 1:length(suc_vj)
            vk = suc_vj(k);%vk表示vj的前继
            Des{vj} = union(Des{vj},Des{vk});
        end
        Des{vj} = union(Des{vj},vj);
        temp_topology(vj,vi) = 0;
    end
    temp_topology(vi,:) = 2;
    temp_V(vi) = 0;    
    
end

%%%%%%%%%%%%%%%%%% 合并Ans和Des 成为PIS，potential interference set，
for i = 1:length(topology)
    for j = 1:1:length(topology)
        if (T(i) == T(j))&&(i ~= j)&&(isempty(intersect(union(Ans{i},Des{i}),j)))
            PIS(i,j) = 1;
        end
    end
end

end
















