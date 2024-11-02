function [WCRT,partition_MCW] = MCW(C,E,EBT,Ans,Des,types,pre_T)
%%%%%%%% minimizing current WCRT (MCW) allocation strategy.
%%%%%%%% E��ʾ���˽ṹ��EBT���������ʱ�伯�ϣ�types��ϵͳtypes��pre_T��������󶨵�type


unallocated_subtasks = 1:length(C);
temp_C = zeros(1,length(C));
partition_MCW = temp_C;
WCRT = 0;
PIS = zeros(length(C));



while ~isempty(unallocated_subtasks)
    vi_index = find(EBT(unallocated_subtasks) == min(EBT(unallocated_subtasks))); %%% vi_index��unallocated_subtasks������
    if length(vi_index) > 1
        max_C_index = find(C(unallocated_subtasks(vi_index)) == max(C(unallocated_subtasks(vi_index)))); % ��vi_index������
        vi_index = vi_index(max_C_index);
    end
    vi_index = vi_index(1);
    vi = unallocated_subtasks(vi_index);
    unallocated_subtasks(vi_index) = [];
    temp_C(vi) = C(vi);     %%%%%%%%%%%% ���� C(vi)
    
    type_vi = pre_T(vi);
    allocation_range = (1:types(type_vi)) + sum(types(1:type_vi-1)); %%%%%%���浱ǰvi�ɷ��������core
    temp_WCRT = inf;                                %%%% ���浱ǰvi��
    temp_core = partition_MCW;                %%%% ��ǰvi������Ǹ�coreʹ��LFT��С

    for check_core = allocation_range
        %%%%%%%%% ���ȳ�ʼ�� PIS %%%%%%%%%%
        current_PIS = PIS;
        temp_core(vi) = check_core; %%% �������ǰcheck��core
        same_cores = find(temp_core == check_core);
        for check_PIS = 1:length(same_cores)
            vj = same_cores(check_PIS);
            %%%%%% �ж��Ƿ�����PIS
            if (vi ~= vj)&&(isempty(intersect(union(Ans{vi},Des{vi}),vj)))
                current_PIS(vi,vj) = 1;
                current_PIS(vj,vi) = 1;
            end
        end
        
        %%%%%%%%%%% ��ʼ���㵱ǰ��WCRT %%%%%%%%%%%%%%%            
        temp_LFT = calculate_WCRT_EOI(temp_C,E,EBT,current_PIS,Des);        %%%%% ���㵱ǰ��
        if temp_LFT < temp_WCRT
            temp_WCRT = temp_LFT;
            partition_MCW(vi) = check_core;
            temp_PIS = current_PIS;
        end
    end
    %%%%%%%%%%%%%%%%% ��ʱ������temp_����Ķ������ŵ��ˣ���ʼ��ֵ
    PIS = temp_PIS;
    WCRT = max(WCRT,temp_LFT);

end

end














