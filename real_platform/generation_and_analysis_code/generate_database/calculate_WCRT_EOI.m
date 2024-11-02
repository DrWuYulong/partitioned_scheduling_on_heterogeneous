function WCRT = calculate_WCRT_EOI(C,E,EBT,PIS,Des)

EFT = EBT; % earliest finish time
%%%%%%%%%%%%%% 初始化 EBT EFT LBT EFT 四个参数





% base_time = toc; %%%%% 共同时间
%%%%%%%%%%%%%%%%%%%%%%%%% 下面开始算法迭代


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 方法MRW %%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% tic

temp_PIS = PIS;  
R1 = EFT; % initialize last finish time (WCRT bound)
%得按照EBT从小到大的顺序进行
temp_V = 1:length(C);%%% 这两行只是用来排序用的%%%
temp_EBT = EBT;        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%


while ~isempty(temp_V)
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
            if (R1(vj) - C(vj) < EBT(vi)) && (R1(vj) > EBT(vi))
                I1_vi = max(I1_vi,min(R1(vj)-EBT(vi),C(vj)));
                temp_PIS(vi,vj) = 0;
            end
        end
    end
    
    %%%%% 初始化 R
    max_pre = max(R1(E(:,vi) == 1));
    if ~isempty(max_pre)
        R = max(R1(E(:,vi) == 1)) + I1_vi + C(vi);
    else
        R = I1_vi + C(vi);
    end
    

    %%%%%%%% 下面开始迭代
    R_new = 0;
    while R ~= R_new
        R_new = R;
        PIS_vi = find(temp_PIS(vi,:) == 1);
        while ~isempty(PIS_vi)
            vj = PIS_vi(1);
            PIS_vi(1) = [];
            if EBT(vj) <= R - C(vi) && R1(vj) > EBT(vi)%%% 看是否属于φ''
                R = R + C(vj);
                
                temp_PIS(vi,vj) = 0;
                %%%%%%接下来更新 des(vi)
                Des_vi = Des{vi};
                Des_vi(Des_vi == vi) = [];
                while ~isempty(Des_vi)
                    vk = Des_vi(1);
                    Des_vi(1) = [];
                    %%%%% 更新R1(v_k) 和 temp_PIS(vk,vj)
                    pre_vk = find(E(:,vk) == 1);
                    if ~isempty(pre_vk)
                        R1(vk) = max(R1(pre_vk)) + C(vk);
                    end
                   
                    %%%%% 如果vj在 vi后代的PIS里面，将其删除，因为vj已经干扰vi了
                    temp_PIS(vk,vj) = 0;
                end
            end
        end
    end
    
    R1(vi) = R;
end

%%%%% 所有子任务都算完了开始算R(v_sink)
WCRT = max(R1(sum(E,2) == 0));
% Res.Time_MRW = base_time + toc;



end