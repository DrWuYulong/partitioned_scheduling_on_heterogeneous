function Res = bound_MRW(G,D)
% bound 2 是根据LFT计算最坏情况下响应时间的
% 需要计算得到的有 响应时间2个，是否可调度2个，调度时间2个，分别是MRW和Chang

% tt = [0 1 1 1 1 0 0 0 0 0 0 0;
%       0 0 0 0 0 1 0 0 0 0 0 0;
%       0 0 0 0 0 0 1 0 0 0 0 0;
%       0 0 0 0 0 0 0 1 0 0 0 0;
%       0 0 0 0 0 0 0 0 1 0 0 0;
%       0 0 0 0 0 0 0 0 0 0 1 0;
%       0 0 0 0 0 0 0 0 0 1 0 0;
%       0 0 0 0 0 0 0 0 0 0 1 0;
%       0 0 0 0 0 0 0 0 0 0 0 1;
%       0 0 0 0 0 0 0 0 0 0 1 0;
%       0 0 0 0 0 0 0 0 0 0 0 1;
%       0 0 0 0 0 0 0 0 0 0 0 0];
% tc = [1 5 2 3 4 2 5 2 2 3 2 2];
% tp = [1 1 2 2 3 2 4 3 4 2 4 1];
% pp = [0 0 0 0 0 0 0 0 0 0 0 0;
%       0 0 0 0 0 0 0 0 0 0 0 0;
%       0 0 0 1 0 1 0 0 0 0 0 0;
%       0 0 1 0 0 1 0 0 0 0 0 0;
%       0 0 0 0 0 0 0 1 0 0 0 0;%5
%       0 0 1 1 0 0 0 0 0 1 0 0;
%       0 0 0 0 0 0 0 0 1 0 0 0;
%       0 0 0 0 1 0 0 0 0 0 0 0;
%       0 0 0 0 0 0 1 0 0 0 1 0;
%       0 0 0 1 0 1 0 0 0 0 0 0;%10
%       0 0 0 0 0 0 0 0 1 0 0 0;
%       0 0 0 0 0 0 0 0 0 0 0 0];


% tic

Res.R_PA_MRW = 0;
% Res.R_Chang = 0;
Res.Sche_PA_MRW = 1;%%% 1表示可调度，0表示不可调度
% Res.Sche_Chang = 1;%%% 1表示可调度，0表示不可调度
% Res.Time_MRW = 0;
% Res.Time_Chang = 0;

EBT = zeros(1,length(G.C)); % earliest beginning time
EFT = EBT; % earliest finish time

%%%%%%%%%%%%%% 初始化 EBT EFT LBT LFT 四个参数


for i = 1:length(G.C)
    %%%%%% 因为生成的时候就不存在比i大的指向i的边，所以当算到i的时候，i前面的pre都确定算完了
    EFT(i) = EBT(i) + G.C(i);%%%%% 更新当前vi的EFT
    
    %接下来，开始更新vi的suc的EBT
    suc_vi = find(G.E(i,:) == 1);%%%找到suc
    for j = 1:length(suc_vi)
        vj = suc_vi(j);
        vk = find(G.E(:,vj) == 1);
        EBT(vj) = max(EFT(vk));
    end
end


% base_time = toc; %%%%% 共同时间
%%%%%%%%%%%%%%%%%%%%%%%%% 下面开始算法迭代


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 方法MRW %%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% tic

temp_PIS = G.PIS_PA_MRW;  
R1 = EFT; % last finish time (WCRT bound)
%得按照EBT从小到大的顺序进行
temp_V = 1:length(G.C);%%% 这两行只是用来排序用的%%%
temp_EBT = EBT;        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%


while ~isempty(temp_V) && Res.Sche_PA_MRW
    index = find(temp_EBT == min(temp_EBT));
    index = index(1);
    vi = temp_V(index); % vi就是当前EBT最小的子任务
    temp_V(index) = [];
    temp_EBT(index) = [];
    %%%%%先找到属于φ’的集合
    I1_vi = 0;
    PIS_vi = find(temp_PIS(vi,:) == 1);
    if ~isempty(PIS_vi)%有PIS，接着判断
        for j = 1:length(PIS_vi)
            vj = PIS_vi(j);
            if (R1(vj) - G.C(vj) < EBT(vi)) && (R1(vj) > EBT(vi))
                I1_vi = max(I1_vi,min(R1(vj)-EBT(vi),G.C(vj)));
                temp_PIS(vi,vj) = 0;
            end
        end
    end
    
    %%%%% 初始化 R
    max_pre = max(R1(G.E(:,vi) == 1));
    if ~isempty(max_pre)
        R = max(R1(G.E(:,vi) == 1)) + I1_vi + G.C(vi);
    else
        R = I1_vi + G.C(vi);
    end
    %%%%%%%%%%%%%%% 判断可调度性
    if R > D
        Res.R_PA_MRW = inf;
        Res.Sche_PA_MRW = 0;
        break;
    end

    %%%%%%%% 下面开始迭代
    R_new = 0;
    while R ~= R_new && Res.Sche_PA_MRW
        R_new = R;
        PIS_vi = find(temp_PIS(vi,:) == 1);
        while ~isempty(PIS_vi) && Res.Sche_PA_MRW
            vj = PIS_vi(1);
            PIS_vi(1) = [];
            if EBT(vj) <= R - G.C(vi) && R1(vj) > EBT(vi)%%% 看是否属于φ''
                R = R + G.C(vj);
                if R > D
                    Res.R_PA_MRW = inf;
                    Res.Sche_PA_MRW = 0;
                    break;
                end
                
                temp_PIS(vi,vj) = 0;
                %%%%%%接下来更新 des(vi)
                Des_vi = G.Des_PA{vi};
                Des_vi(Des_vi == vi) = [];
                while ~isempty(Des_vi)
                    vk = Des_vi(1);
                    Des_vi(1) = [];
                    %%%%% 更新R1(v_k) 和 temp_PIS(vk,vj)
                    pre_vk = find(G.E(:,vk) == 1);
                    if ~isempty(pre_vk)
                        R1(vk) = max(R1(pre_vk)) + G.C(vk);
                    end
                    if R1(vk) > D
                        Res.R_PA_MRW = inf;
                        Res.Sche_PA_MRW = 0;
                        break;
                    end
                    %%%%% 如果vj在 vi后代的PIS里面，将其删除，因为vj已经干扰vi了
                    temp_PIS(vk,vj) = 0;
                end
            end
        end
    end
    if R > D
        Res.R_PA_MRW = inf;
        Res.Sche_PA_MRW = 0;
        break;
    else
        R1(vi) = R;
    end
end

%%%%% 所有子任务都算完了开始算R(v_sink)
WCRT = max(R1(sum(G.E,2) == 0));
% Res.Time_MRW = base_time + toc;

if WCRT > D
    Res.R_PA_MRW = inf;
    Res.Sche_PA_MRW = 0;
else
    Res.R_PA_MRW = WCRT;
end









end