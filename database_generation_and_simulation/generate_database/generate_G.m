function G_groups = generate_G(G_numb,type_range,mi_range,v_range,u_range,pr_range,D)
%%%%% G_numb ��ʾ���ɶ�����G��type_numb��ʾϵͳtype_range������䣬mi_range��ʾtype si��core����
%%%%% v_range ��ʾ������仯���䣬u_range��ʾ������ϵ���ı仯���䣬pr_range��ʾ���жȱ仯���䣬


G.types = 0;%����G��Ӧ��types���Ǹ�����[2 3 4 2]��ʾ��4��types��ÿ��type�ֱ��Ӧ2,3,4,2��cores
G.U = 0; %����DAG�����������
G.PA_C = 0;%�����������WCET
G.Rand_C = 0;
G.T_PA = 0;
G.T_PA_EWF = 0;%���������񱻷��䵽�Ĵ���������based on PA
G.T_PA_LWF = 0; %PA ȷ��types֮��������ʽ�㷨MRW����allocation
G.T_Rand = 0;
G.T_Rand_EWF = 0;%���������񱻷��䵽�Ĵ���������based on PA
G.T_Rand_LWF = 0; %PA ȷ��types֮��������ʽ�㷨MRW����allocation

G.PA_E = 0;%����������ߵ���Ϣ�����˽ṹ��
G.PA_path = 0; %��������·����Ϣ��

G.Rand_E = 0;%����������ߵ���Ϣ�����˽ṹ��
G.Rand_path = 0; %��������·����Ϣ��

% G.PIS_PA_Han = 0;
G.PIS_PA_EWF = 0;%���������񱻷��䵽�Ĵ���������based on PA
G.PIS_PA_LWF = 0; %PA ȷ��types֮��������ʽ�㷨MRW����allocation

% G.PIS_Rand_Han = 0;
G.PIS_Rand_EWF = 0;%���������񱻷��䵽�Ĵ���������based on PA
G.PIS_Rand_LWF = 0; %PA ȷ��types֮��������ʽ�㷨MRW����allocation

G.PA_Des = 0;
G.Rand_Des = 0;
% G.WCRT_PA_MCW = 0;



G_groups = repmat(G,1,G_numb);%%%% DAG����Ľṹ��

V_numb = randi([v_range(1) v_range(end)],1,G_numb);%�������������� V_numb(i)��ʾ��i��DAG�����ж��ٸ�������
type_numb = randi([type_range(1) type_range(end)],1,G_numb);%type ����, ÿ��G�м���type

U_numb = ones(1,G_numb);
% if length(u_range) == 1 %%%  �Ƿ����ɲ���U�����ݼ�
%     U_numb = ones(1,G_numb) * u_range;
% else
%     U_numb = ones(1,G_numb);
% end

if length(pr_range) == 1 %%%  �Ƿ����ɲ���pr�����ݼ�
    pr_numb = ones(1,G_numb) * pr_range;
else
    pr_numb = rand(1,G_numb) * (pr_range(end) - pr_range(1)) + pr_range(1);
end
% U_numb = rand(1,G_numb) * (u_range(end) - u_range(1)) + u_range(1); %�����ʾ���,��0~1������u_range�����

% pr_numb = rand(1,G_numb) * (pr_range(end) - pr_range(1)) + pr_range(1);%��0~1������pr_range�����

for i = 1:G_numb
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%% �������ÿ��type��core %%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % i
%     G_groups(i).types = [4 2];
    G_groups(i).types = randi(mi_range,1,type_numb(i));
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%% ��ʼ���������� %%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if length(u_range) == 1 %%%  �Ƿ����ɲ���U�����ݼ�
        U_numb(i) = u_range * sum(G_groups(i).types);
%         U_numb(i) = u_range;
        G_groups(i).U = U_numb(i);
    else
        %%%%%% ��Han�ķ��� �ɱ���������U
        U_numb(i) = sum(G_groups(i).types) * (rand * (u_range(end) - u_range(1)) + u_range(1));
%         U_numb(i) = rand * (u_range(end) - u_range(1)) + u_range(1); %%%%% ʹ��Chang ��������U
        G_groups(i).U = U_numb(i);
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%% ��ʼ�����˽ṹ %%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    topology = rand(V_numb(i));
    topology(topology < pr_numb(i)) = 1;
    topology(topology < 1) = 0;
    for j = 1:V_numb(i)
        for k = 1:j
            topology(j,k) = 0;
        end
    end
    G_groups(i).PA_E = IED(topology);
    
    topology = rand(V_numb(i));
    topology(topology < pr_numb(i)) = 1;
    topology(topology < 1) = 0;
    for j = 1:V_numb(i)
        for k = 1:j
            topology(j,k) = 0;
        end
    end
    G_groups(i).Rand_E = IED(topology);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%% ��types��cores�����ı������з��������񵽲�ͬ��type��%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    G_groups(i).T_PA = PA(V_numb(i),G_groups(i).types);
    G_groups(i).T_Rand = randi([1 length(G_groups(i).types)],1,V_numb(i));
    

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%% ��ʼ����ÿ���������Ӧ��WCET%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%���Ȱ���������һ��U
    current_proportional_U = G_groups(i).U * G_groups(i).types ./ sum(G_groups(i).types);
    current_C = zeros(1,V_numb(i));
    for j = 1:length(current_proportional_U)
        currnt_assign_V = find(G_groups(i).T_PA == j);
        current_C(currnt_assign_V) = randfixedsum(length(currnt_assign_V),1,current_proportional_U(j),0,1)' * D;
    end
    G_groups(i).PA_C = round(current_C);
    
    %%%% Rand ����C
    G_groups(i).Rand_C = round(randfixedsum(V_numb(i),1,G_groups(i).U,0,1)' * D);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%% �˴���Ҫ������ʽ�㷨����partition%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MCW���ɷ� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     EBT = zeros(1,length(G_groups(i).C));
%     EFT = EBT;
%     for t = 1:length(G_groups(i).C)
%         %%%%%% ��Ϊ���ɵ�ʱ��Ͳ����ڱ�i���ָ��i�ıߣ����Ե��㵽i��ʱ��iǰ���pre��ȷ��������
%         EFT(t) = EBT(t) + G_groups(i).C(t);%%%%% ���µ�ǰvi��EFT
% 
%         %����������ʼ����vi��suc��EBT
%         suc_vi = find(G_groups(i).E(t,:) == 1);%%%�ҵ�suc
%         for j = 1:length(suc_vi)
%             vj = suc_vi(j);
%             vk = find(G_groups(i).E(:,vj) == 1);
%             EBT(vj) = max(EFT(vk));
%         end
%     end
%     [Ans,Des] = find_Ans_Des(G_groups(i).E);
%     [G_groups(i).WCRT_PA_MCW,G_groups(i).T_PA_MCW] = MCW(G_groups(i).C,G_groups(i).E,EBT,Ans,Des,G_groups(i).types,G_groups(i).T_PA); %%% minimizing current WCRT (MCW) allocation strategy.
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ��ͬ allocation ���� MRW �� BLM ���ɷ� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    G_groups(i).T_PA_EWF = EWF(G_groups(i).PA_C,G_groups(i).PA_E,G_groups(i).types,G_groups(i).T_PA,D);
    G_groups(i).T_PA_LWF = LWF(G_groups(i).PA_C,G_groups(i).PA_E,G_groups(i).types,G_groups(i).T_PA,D);
%     G_groups(i).T_PA_MRW = MRW(G_groups(i).PA_C,G_groups(i).PA_E,G_groups(i).types,G_groups(i).T_PA,D);
    
    G_groups(i).T_Rand_EWF = EWF(G_groups(i).Rand_C,G_groups(i).Rand_E,G_groups(i).types,G_groups(i).T_Rand,D);
    G_groups(i).T_Rand_LWF = LWF(G_groups(i).Rand_C,G_groups(i).Rand_E,G_groups(i).types,G_groups(i).T_Rand,D);
%     G_groups(i).T_Rand_MRW = MRW(G_groups(i).Rand_C,G_groups(i).Rand_E,G_groups(i).types,G_groups(i).T_Rand,D);
       
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     tic
    G_groups(i).PA_path = find_path(G_groups(i).PA_E);
    G_groups(i).Rand_path = find_path(G_groups(i).Rand_E);
%     G_groups(i).path_time = toc;
%     
%     tic
%     [G_groups(i).PIS_PA_MRW,G_groups(i).Des]= find_PIS(G_groups(i).E,G_groups(i).T_PA_MRW);
    [G_groups(i).PIS_PA_EWF,G_groups(i).PA_Des]= find_PIS(G_groups(i).PA_E,G_groups(i).T_PA_EWF);
    [G_groups(i).PIS_PA_LWF,G_groups(i).PA_Des]= find_PIS(G_groups(i).PA_E,G_groups(i).T_PA_LWF);
%     [G_groups(i).PIS_PA_MRW,G_groups(i).PA_Des]= find_PIS(G_groups(i).PA_E,G_groups(i).T_PA_MRW);
    
    [G_groups(i).PIS_Rand_EWF,G_groups(i).Rand_Des]= find_PIS(G_groups(i).Rand_E,G_groups(i).T_Rand_EWF);
    [G_groups(i).PIS_Rand_LWF,G_groups(i).Rand_Des]= find_PIS(G_groups(i).Rand_E,G_groups(i).T_Rand_LWF);
%     [G_groups(i).PIS_Rand_MRW,G_groups(i).Rand_Des]= find_PIS(G_groups(i).Rand_E,G_groups(i).T_Rand_MRW);
%     G_groups(i).PIS_time_PA_MRW = toc;
%     
%     tic
%     [G_groups(i).PIS_PA,G_groups(i).Des]= find_PIS(G_groups(i).E,G_groups(i).T_PA);
%     G_groups(i).PIS_time_PA = toc;
%     [G_groups(i).PIS_Rand,G_groups(i).Des]= find_PIS(G_groups(i).E,G_groups(i).T_Rand);
%     [G_groups(i).PIS_Rand_MRW,G_groups(i).Des]= find_PIS(G_groups(i).E,G_groups(i).T_Rand_MRW);
    
end












end