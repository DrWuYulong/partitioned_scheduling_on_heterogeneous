clear all;
clc;


%%%%%% ��������
config.G_numb = 5000;
config.default_type_range = [4 4]; %Ĭ��type�仯��Χ
config.default_mi_range = [2 6]; %Ĭ��ÿ��type��cores�����仯��Χ
config.default_v_range = [50 50]; %Ĭ�������������仯��Χ
config.default_u_range = [0.15 0.15]; %Ĭ�������ʱ仯��Χ
config.default_pr_rang = [0.1 0.1]; %Ĭ�ϱ����ɸ��ʱ仯��Χ
config.default_D = 10000; %Ĭ��deadline

config.U_range = 0.1:0.01:0.2;
config.S_range = 2:10;
config.V_range = 40:2:60;
config.pr_range = 0.1:0.01:0.2;

mkdir 'database'
save('database/config.mat','config');
mkdir 'result'







