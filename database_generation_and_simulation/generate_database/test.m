clear all;
clc;

%%%%%%%%%% ��ȡ��ʼ������
load('../database/config.mat','config');

G_numb = config.G_numb;
default_type_range = config.default_type_range; %Ĭ��type�仯��Χ
default_mi_range = config.default_mi_range; %Ĭ��ÿ��type��cores�����仯��Χ
default_v_range = config.default_v_range; %Ĭ�������������仯��Χ
default_u_range = config.default_u_range; %Ĭ�������ʱ仯��Χ
default_pr_rang = config.default_pr_rang; %Ĭ�ϱ����ɸ��ʱ仯��Χ
default_D = config.default_D; %Ĭ��deadline

U_range = config.U_range;
% S_range = config.S_range;
V_range = config.V_range;
pr_range = config.pr_range;

%%%% һ����Ҫ�任4��������ʵ�飬�ֱ���type_range��v_range��u_range��pr_rang
%%%% ��S,V,U,p�ֱ��ʾ
base_dir = ['../database/'];

%%%%%%%%%%%%%%%%% �任 U��%%%%%%%%%%%%%%%%%%%
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

%%%%%%%%%%%%%%%%% �任 S��%%%%%%%%%%%%%%%%%%%
% for S = S_range
%     S
%     path_dir = [base_dir 'S/S_' num2str(S)];
%     mkdir(path_dir);
%     G = generate_G(G_numb,S,default_mi_range,default_v_range,default_u_range,default_pr_rang,default_D);
%     save([path_dir '/G.mat'],'G');
% end
% 
% 
% %%%%%%%%%%%%%%%%%%% �任 V��%%%%%%%%%%%%%%%%%%%
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
% %%%%%%%%%%%%%%%%%%%% �任 pr�� %%%%%%%%%%%%%%%%%%%
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
