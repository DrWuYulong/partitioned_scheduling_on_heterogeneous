function Res = bound_Wu(C,PIS,path,D)
% bound 1 是根据路径计算最坏情况下响应时间的
% 需要计算得到的有 响应时间2个，是否可调度2个，调度时间2个，分别是Wu和Chang



Res.R_Wu = 0;
% Res.R_Chang = 0;
Res.Sched_Wu = 1;%%% 1表示可调度，0表示不可调度
% Res.Sched_Chang = 1;%%% 1表示可调度，0表示不可调度
% Res.Time_Wu = 0;
% Res.Time_Chang = 0;

len_path = zeros(1,length(path));

% tic
for i = 1:length(path)
    len_path(i) = sum(C(path{i}));
    if len_path(i) > D
%         Res.Time_Wu = toc;
%         Res.Time_Chang = Res.Time_Wu;
        Res.R_Wu = inf;
%         Res.R_Chang = inf;
        Res.Sched_Wu = 0;
%         Res.Sched_Chang = 0;
        return
    end
end 

temp_V = 1:length(path);
temp_len_path = len_path;

% Res.Time_Wu = toc;
% Res.Time_Chang = Res.Time_Wu;

% while ~isempty(temp_V) && (Res.Sched_PA_Wu == 1 || Res.Sched_Chang == 1)
while ~isempty(temp_V) && (Res.Sched_Wu == 1)
    index = find(temp_len_path == max(temp_len_path));
    index = index(1);
    vi = temp_V(index);
    temp_len_path(index) = [];
    temp_V(index) = [];
%     Res.R_Wu
%     pause
    %%%%%% 计算Wu分配下的R
    if Res.Sched_Wu == 1
%         tic
        I_vi = [];
        for j = 1:length(path{vi})
            I_vi = union(I_vi, find(PIS(path{vi}(j),:) == 1));
        end
        R_path = len_path(vi) + sum(C(I_vi));
        if R_path <= D
            Res.R_Wu = max(Res.R_Wu,R_path);
        else
            Res.R_Wu = inf;
            Res.Sched_Wu = 0;
        end
%         Res.Time_Wu = Res.Time_Wu + toc;
    end
    

    
end


end