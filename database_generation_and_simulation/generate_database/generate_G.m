function G_groups = generate_G(G_numb,type_range,mi_range,v_range,u_range,pr_range,D)
%%%%% G_numb 表示生成多少组G，type_numb表示系统type_range随机区间，mi_range表示type si的core数量
%%%%% v_range 表示子任务变化区间，u_range表示利用率系数的变化区间，pr_range表示并行度变化区间，


G.types = 0;%保存G对应的types，是个矩阵[2 3 4 2]表示有4个types，每个type分别对应2,3,4,2个cores
G.U = 0; %保存DAG任务的利用率
G.PA_C = 0;%保存子任务的WCET
G.Rand_C = 0;
G.T_PA = 0;
G.T_PA_EWF = 0;%保存子任务被分配到的处理器策略based on PA
G.T_PA_LWF = 0; %PA 确定types之后用启发式算法MRW进行allocation
G.T_Rand = 0;
G.T_Rand_EWF = 0;%保存子任务被分配到的处理器策略based on PA
G.T_Rand_LWF = 0; %PA 确定types之后用启发式算法MRW进行allocation

G.PA_E = 0;%保存子任务边的信息（拓扑结构）
G.PA_path = 0; %保存所有路径信息。

G.Rand_E = 0;%保存子任务边的信息（拓扑结构）
G.Rand_path = 0; %保存所有路径信息。

% G.PIS_PA_Han = 0;
G.PIS_PA_EWF = 0;%保存子任务被分配到的处理器策略based on PA
G.PIS_PA_LWF = 0; %PA 确定types之后用启发式算法MRW进行allocation

% G.PIS_Rand_Han = 0;
G.PIS_Rand_EWF = 0;%保存子任务被分配到的处理器策略based on PA
G.PIS_Rand_LWF = 0; %PA 确定types之后用启发式算法MRW进行allocation

G.PA_Des = 0;
G.Rand_Des = 0;
% G.WCRT_PA_MCW = 0;



G_groups = repmat(G,1,G_numb);%%%% DAG任务的结构体

V_numb = randi([v_range(1) v_range(end)],1,G_numb);%子任务数量矩阵 V_numb(i)表示第i个DAG任务有多少个子任务
type_numb = randi([type_range(1) type_range(end)],1,G_numb);%type 矩阵, 每个G有几个type

U_numb = ones(1,G_numb);
% if length(u_range) == 1 %%%  是否生成测试U的数据集
%     U_numb = ones(1,G_numb) * u_range;
% else
%     U_numb = ones(1,G_numb);
% end

if length(pr_range) == 1 %%%  是否生成测试pr的数据集
    pr_numb = ones(1,G_numb) * pr_range;
else
    pr_numb = rand(1,G_numb) * (pr_range(end) - pr_range(1)) + pr_range(1);
end
% U_numb = rand(1,G_numb) * (u_range(end) - u_range(1)) + u_range(1); %利用率矩阵,把0~1随机变成u_range内随机

% pr_numb = rand(1,G_numb) * (pr_range(end) - pr_range(1)) + pr_range(1);%把0~1随机变成pr_range内随机

for i = 1:G_numb
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%% 随机生成每个type的core %%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % i
%     G_groups(i).types = [4 2];
    G_groups(i).types = randi(mi_range,1,type_numb(i));
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%% 初始化总利用率 %%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if length(u_range) == 1 %%%  是否生成测试U的数据集
        U_numb(i) = u_range * sum(G_groups(i).types);
%         U_numb(i) = u_range;
        G_groups(i).U = U_numb(i);
    else
        %%%%%% 用Han的方法 成比例的生成U
        U_numb(i) = sum(G_groups(i).types) * (rand * (u_range(end) - u_range(1)) + u_range(1));
%         U_numb(i) = rand * (u_range(end) - u_range(1)) + u_range(1); %%%%% 使用Chang 方法生成U
        G_groups(i).U = U_numb(i);
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%% 初始化拓扑结构 %%%%%%%%%%%%%%%%%%%%%
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
    %%%%% 按types中cores数量的比例进行分配子任务到不同的type中%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    G_groups(i).T_PA = PA(V_numb(i),G_groups(i).types);
    G_groups(i).T_Rand = randi([1 length(G_groups(i).types)],1,V_numb(i));
    

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%% 开始分配每个子任务对应的WCET%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%首先按比例分配一下U
    current_proportional_U = G_groups(i).U * G_groups(i).types ./ sum(G_groups(i).types);
    current_C = zeros(1,V_numb(i));
    for j = 1:length(current_proportional_U)
        currnt_assign_V = find(G_groups(i).T_PA == j);
        current_C(currnt_assign_V) = randfixedsum(length(currnt_assign_V),1,current_proportional_U(j),0,1)' * D;
    end
    G_groups(i).PA_C = round(current_C);
    
    %%%% Rand 分配C
    G_groups(i).Rand_C = round(randfixedsum(V_numb(i),1,G_groups(i).U,0,1)' * D);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%% 此处需要用启发式算法进行partition%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% MCW生成法 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     EBT = zeros(1,length(G_groups(i).C));
%     EFT = EBT;
%     for t = 1:length(G_groups(i).C)
%         %%%%%% 因为生成的时候就不存在比i大的指向i的边，所以当算到i的时候，i前面的pre都确定算完了
%         EFT(t) = EBT(t) + G_groups(i).C(t);%%%%% 更新当前vi的EFT
% 
%         %接下来，开始更新vi的suc的EBT
%         suc_vi = find(G_groups(i).E(t,:) == 1);%%%找到suc
%         for j = 1:length(suc_vi)
%             vj = suc_vi(j);
%             vk = find(G_groups(i).E(:,vj) == 1);
%             EBT(vj) = max(EFT(vk));
%         end
%     end
%     [Ans,Des] = find_Ans_Des(G_groups(i).E);
%     [G_groups(i).WCRT_PA_MCW,G_groups(i).T_PA_MCW] = MCW(G_groups(i).C,G_groups(i).E,EBT,Ans,Des,G_groups(i).types,G_groups(i).T_PA); %%% minimizing current WCRT (MCW) allocation strategy.
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 不同 allocation 方法 MRW 和 BLM 生成法 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
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