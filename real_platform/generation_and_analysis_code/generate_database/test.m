clear all;
clc;

%%%%%%%%%% 读取初始化参数
load('../database/config.mat','config');

G_numb = config.G_numb;
default_type_range = config.default_type_range; %默认type变化范围
default_mi_range = config.default_mi_range; %默认每个type的cores数量变化范围
default_v_range = config.default_v_range; %默认子任务数量变化范围
default_u_range = config.default_u_range; %默认利用率变化范围
default_pr_rang = config.default_pr_rang; %默认边生成概率变化范围
default_D = config.default_D; %默认deadline

U_range = config.U_range;
% S_range = config.S_range;
V_range = config.V_range;
pr_range = config.pr_range;

%%%% 一共需要变换4个变量做实验，分别是type_range，v_range，u_range，pr_rang
%%%% 用S,V,U,p分别表示
base_dir = ['../database/'];

%%%%%%%%%%%%%%%%% 变换 U，%%%%%%%%%%%%%%%%%%%
for U = U_range
    U
    path_dir = [base_dir 'U/U_' num2str(U) '/G.mat'];
    load(path_dir,'G');
    for i = 1:G_numb
        G(i).T_PA = PA(length(G(i).C),G(i).types);
        G(i).T_PA_RWB = RWB(G(i).C,G(i).E,G(i).types,G(i).T_PA,default_D);
    end
    save(path_dir,'G');
end

%%%%%%%%%%%%%%%%% 变换 S，%%%%%%%%%%%%%%%%%%%
% for S = S_range
%     S
%     path_dir = [base_dir 'S/S_' num2str(S)];
%     mkdir(path_dir);
%     G = generate_G(G_numb,S,default_mi_range,default_v_range,default_u_range,default_pr_rang,default_D);
%     save([path_dir '/G.mat'],'G');
% end
% 
% 
% %%%%%%%%%%%%%%%%%%% 变换 V，%%%%%%%%%%%%%%%%%%%
for V = V_range
    V
    path_dir = [base_dir 'V/V_' num2str(V) '/G.mat'];
    load(path_dir,'G');
    for i = 1:G_numb
        G(i).T_PA = PA(length(G(i).C),G(i).types);
        G(i).T_PA_RWB = RWB(G(i).C,G(i).E,G(i).types,G(i).T_PA,default_D);
    end
    save(path_dir,'G');
end
% 
% %%%%%%%%%%%%%%%%%%%% 变换 pr， %%%%%%%%%%%%%%%%%%%
for pr = pr_range
    pr
    path_dir = [base_dir 'pr/pr_' num2str(pr) '/G.mat'];
    load(path_dir,'G');
    for i = 1:G_numb
        G(i).T_PA = PA(length(G(i).C),G(i).types);
        G(i).T_PA_RWB = RWB(G(i).C,G(i).E,G(i).types,G(i).T_PA,default_D);
    end
    save(path_dir,'G');
end
