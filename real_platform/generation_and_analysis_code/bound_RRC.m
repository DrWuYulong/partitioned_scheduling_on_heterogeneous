function Res = bound_RRC(G,PIS,D)
% bound 1 �Ǹ���·��������������Ӧʱ���
% ��Ҫ����õ����� ��Ӧʱ��2�����Ƿ�ɵ���2��������ʱ��2�����ֱ���RRC��Chang



Res.R_RRC = 0;
% Res.R_Chang = 0;
Res.Sche_RRC = 1;%%% 1��ʾ�ɵ��ȣ�0��ʾ���ɵ���
% Res.Sche_Chang = 1;%%% 1��ʾ�ɵ��ȣ�0��ʾ���ɵ���
% Res.Time_RRC = 0;
% Res.Time_Chang = 0;

len_path = zeros(1,length(G.path));

% tic
for i = 1:length(G.path)
    len_path(i) = sum(G.C(G.path{i}));
    if len_path(i) > D
%         Res.Time_RRC = toc;
%         Res.Time_Chang = Res.Time_RRC;
        Res.R_RRC = inf;
%         Res.R_Chang = inf;
        Res.Sche_RRC = 0;
%         Res.Sche_Chang = 0;
        return
    end
end 

temp_V = 1:length(G.path);
temp_len_path = len_path;

% Res.Time_RRC = toc;
% Res.Time_Chang = Res.Time_RRC;

% while ~isempty(temp_V) && (Res.Sche_PA_RRC == 1 || Res.Sche_Chang == 1)
while ~isempty(temp_V) && (Res.Sche_RRC == 1)
    index = find(temp_len_path == max(temp_len_path));
    index = index(1);
    vi = temp_V(index);
    temp_len_path(index) = [];
    temp_V(index) = [];
    
    %%%%%% ����RRC�����µ�R
    if Res.Sche_RRC == 1
%         tic
        I_vi = [];
        for j = 1:length(G.path{vi})
            I_vi = union(I_vi, find(PIS(G.path{vi}(j),:) == 1));
        end
        R_path = len_path(vi) + sum(G.C(I_vi));
        if R_path <= D
            Res.R_RRC = max(Res.R_RRC,R_path);
        else
            Res.R_RRC = inf;
            Res.Sche_RRC = 0;
        end
%         Res.Time_RRC = Res.Time_RRC + toc;
    end
    

    
end


end