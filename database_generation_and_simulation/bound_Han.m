function Res = bound_Han(G,PIS,D)

Res.R_Han = 0;
% Res.R_Chang = 0;
Res.Sche_Han = 1;%%% 1表示可调度，0表示不可调度
% Res.Sche_Chang = 1;%%% 1表示可调度，0表示不可调度
% Res.Time_Han = 0;
% Res.Time_Chang = 0;

len_path = zeros(1,length(G.path));

% tic
for i = 1:length(G.path)
    len_path(i) = sum(G.C(G.path{i}));
    if len_path(i) > D
        Res.R_Han = inf;
        Res.Sche_Han = 0;
        return
    end
end 

temp_V = 1:length(G.path);
temp_len_path = len_path;

% Res.Time_Han = toc;
% Res.Time_Chang = Res.Time_Han;

% while ~isempty(temp_V) && (Res.Sche_PA_Han == 1 || Res.Sche_Chang == 1)
while ~isempty(temp_V) && (Res.Sche_Han == 1)
    index = find(temp_len_path == max(temp_len_path));
    index = index(1);
    vi = temp_V(index);
    temp_len_path(index) = [];
    temp_V(index) = [];
    
    %%%%%% 计算Han分配下的R
    if Res.Sche_Han == 1
%         tic
        I_vi = [];
        for j = 1:length(G.path{vi})
            I_vi = union(I_vi, find(PIS(G.path{vi}(j),:) == 1));
        end
        
        sum_I = 0;
        for i = 1:length(G.types)
            index_i = find(G.T_PA(I_vi) == i);
            if ~isempty(index_i)
                sum_I = sum_I + sum(G.C(I_vi(index_i)))/G.types(i);
            end
        end
        
        R_path = len_path(vi) + sum_I;
        if R_path <= D
            Res.R_Han = max(Res.R_Han,R_path);
        else
            Res.R_Han = inf;
            Res.Sche_Han = 0;
        end
%         Res.Time_Han = Res.Time_Han + toc;
    end

end






