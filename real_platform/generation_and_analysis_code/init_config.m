clear all;
clc;


%%%%%% ��������
config.G_numb = 500;
config.default_type_range = [4 4]; %Ĭ��type�仯��Χ
config.default_mi_range = [2 6]; %Ĭ��ÿ��type��cores�����仯��Χ
config.default_v_range = [30 30]; %Ĭ�������������仯��Χ
config.default_u_range = [0.25 0.25]; %Ĭ�������ʱ仯��Χ
config.default_pr_rang = [0.2 0.2]; %Ĭ�ϱ����ɸ��ʱ仯��Χ
config.default_D = 1000; %Ĭ��deadline

config.U_range = 0.1:0.03:0.4;
config.S_range = 2:10;
config.V_range = 20:2:40;
config.pr_range = 0.15:0.01:0.25;

mkdir 'database'
save('database/config.mat','config');
mkdir 'result'







