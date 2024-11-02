function Res = bound_MRW(G,D)
% bound 2 �Ǹ���LFT������������Ӧʱ���
% ��Ҫ����õ����� ��Ӧʱ��2�����Ƿ�ɵ���2��������ʱ��2�����ֱ���MRW��Chang

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
Res.Sche_PA_MRW = 1;%%% 1��ʾ�ɵ��ȣ�0��ʾ���ɵ���
% Res.Sche_Chang = 1;%%% 1��ʾ�ɵ��ȣ�0��ʾ���ɵ���
% Res.Time_MRW = 0;
% Res.Time_Chang = 0;

EBT = zeros(1,length(G.C)); % earliest beginning time
EFT = EBT; % earliest finish time

%%%%%%%%%%%%%% ��ʼ�� EBT EFT LBT LFT �ĸ�����


for i = 1:length(G.C)
    %%%%%% ��Ϊ���ɵ�ʱ��Ͳ����ڱ�i���ָ��i�ıߣ����Ե��㵽i��ʱ��iǰ���pre��ȷ��������
    EFT(i) = EBT(i) + G.C(i);%%%%% ���µ�ǰvi��EFT
    
    %����������ʼ����vi��suc��EBT
    suc_vi = find(G.E(i,:) == 1);%%%�ҵ�suc
    for j = 1:length(suc_vi)
        vj = suc_vi(j);
        vk = find(G.E(:,vj) == 1);
        EBT(vj) = max(EFT(vk));
    end
end


% base_time = toc; %%%%% ��ͬʱ��
%%%%%%%%%%%%%%%%%%%%%%%%% ���濪ʼ�㷨����


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ����MRW %%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% tic

temp_PIS = G.PIS_PA_MRW;  
R1 = EFT; % last finish time (WCRT bound)
%�ð���EBT��С�����˳�����
temp_V = 1:length(G.C);%%% ������ֻ�����������õ�%%%
temp_EBT = EBT;        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%


while ~isempty(temp_V) && Res.Sche_PA_MRW
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
            if (R1(vj) - G.C(vj) < EBT(vi)) && (R1(vj) > EBT(vi))
                I1_vi = max(I1_vi,min(R1(vj)-EBT(vi),G.C(vj)));
                temp_PIS(vi,vj) = 0;
            end
        end
    end
    
    %%%%% ��ʼ�� R
    max_pre = max(R1(G.E(:,vi) == 1));
    if ~isempty(max_pre)
        R = max(R1(G.E(:,vi) == 1)) + I1_vi + G.C(vi);
    else
        R = I1_vi + G.C(vi);
    end
    %%%%%%%%%%%%%%% �жϿɵ�����
    if R > D
        Res.R_PA_MRW = inf;
        Res.Sche_PA_MRW = 0;
        break;
    end

    %%%%%%%% ���濪ʼ����
    R_new = 0;
    while R ~= R_new && Res.Sche_PA_MRW
        R_new = R;
        PIS_vi = find(temp_PIS(vi,:) == 1);
        while ~isempty(PIS_vi) && Res.Sche_PA_MRW
            vj = PIS_vi(1);
            PIS_vi(1) = [];
            if EBT(vj) <= R - G.C(vi) && R1(vj) > EBT(vi)%%% ���Ƿ����ڦ�''
                R = R + G.C(vj);
                if R > D
                    Res.R_PA_MRW = inf;
                    Res.Sche_PA_MRW = 0;
                    break;
                end
                
                temp_PIS(vi,vj) = 0;
                %%%%%%���������� des(vi)
                Des_vi = G.Des_PA{vi};
                Des_vi(Des_vi == vi) = [];
                while ~isempty(Des_vi)
                    vk = Des_vi(1);
                    Des_vi(1) = [];
                    %%%%% ����R1(v_k) �� temp_PIS(vk,vj)
                    pre_vk = find(G.E(:,vk) == 1);
                    if ~isempty(pre_vk)
                        R1(vk) = max(R1(pre_vk)) + G.C(vk);
                    end
                    if R1(vk) > D
                        Res.R_PA_MRW = inf;
                        Res.Sche_PA_MRW = 0;
                        break;
                    end
                    %%%%% ���vj�� vi�����PIS���棬����ɾ������Ϊvj�Ѿ�����vi��
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

%%%%% ���������������˿�ʼ��R(v_sink)
WCRT = max(R1(sum(G.E,2) == 0));
% Res.Time_MRW = base_time + toc;

if WCRT > D
    Res.R_PA_MRW = inf;
    Res.Sche_PA_MRW = 0;
else
    Res.R_PA_MRW = WCRT;
end









end