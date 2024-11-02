function WCRT = calculate_WCRT_EOI(C,E,EBT,PIS,Des)

EFT = EBT; % earliest finish time
%%%%%%%%%%%%%% ��ʼ�� EBT EFT LBT EFT �ĸ�����





% base_time = toc; %%%%% ��ͬʱ��
%%%%%%%%%%%%%%%%%%%%%%%%% ���濪ʼ�㷨����


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ����MRW %%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% tic

temp_PIS = PIS;  
R1 = EFT; % initialize last finish time (WCRT bound)
%�ð���EBT��С�����˳�����
temp_V = 1:length(C);%%% ������ֻ�����������õ�%%%
temp_EBT = EBT;        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%


while ~isempty(temp_V)
    index = find(temp_EBT == min(temp_EBT));
    index = index(1);
    vi = temp_V(index); % vi���ǵ�ǰEBT��С��������
    temp_V(index) = [];
    temp_EBT(index) = [];
    %%%%%���ҵ����ڦա��ļ���
    I1_vi = 0;
    PIS_vi = find(temp_PIS(vi,:) == 1);
    if ~isempty(PIS_vi)%��PIS�������ж�
        for j = 1:length(PIS_vi)
            vj = PIS_vi(j);
            if (R1(vj) - C(vj) < EBT(vi)) && (R1(vj) > EBT(vi))
                I1_vi = max(I1_vi,min(R1(vj)-EBT(vi),C(vj)));
                temp_PIS(vi,vj) = 0;
            end
        end
    end
    
    %%%%% ��ʼ�� R
    max_pre = max(R1(E(:,vi) == 1));
    if ~isempty(max_pre)
        R = max(R1(E(:,vi) == 1)) + I1_vi + C(vi);
    else
        R = I1_vi + C(vi);
    end
    

    %%%%%%%% ���濪ʼ����
    R_new = 0;
    while R ~= R_new
        R_new = R;
        PIS_vi = find(temp_PIS(vi,:) == 1);
        while ~isempty(PIS_vi)
            vj = PIS_vi(1);
            PIS_vi(1) = [];
            if EBT(vj) <= R - C(vi) && R1(vj) > EBT(vi)%%% ���Ƿ����ڦ�''
                R = R + C(vj);
                
                temp_PIS(vi,vj) = 0;
                %%%%%%���������� des(vi)
                Des_vi = Des{vi};
                Des_vi(Des_vi == vi) = [];
                while ~isempty(Des_vi)
                    vk = Des_vi(1);
                    Des_vi(1) = [];
                    %%%%% ����R1(v_k) �� temp_PIS(vk,vj)
                    pre_vk = find(E(:,vk) == 1);
                    if ~isempty(pre_vk)
                        R1(vk) = max(R1(pre_vk)) + C(vk);
                    end
                   
                    %%%%% ���vj�� vi�����PIS���棬����ɾ������Ϊvj�Ѿ�����vi��
                    temp_PIS(vk,vj) = 0;
                end
            end
        end
    end
    
    R1(vi) = R;
end

%%%%% ���������������˿�ʼ��R(v_sink)
WCRT = max(R1(sum(E,2) == 0));
% Res.Time_MRW = base_time + toc;



end