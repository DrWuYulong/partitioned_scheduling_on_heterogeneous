clear all;
clc;


%%%%%% 参数设置
config.G_numb = 5000;
config.default_type_range = [4 4]; %默认type变化范围
config.default_mi_range = [2 6]; %默认每个type的cores数量变化范围
config.default_v_range = [50 50]; %默认子任务数量变化范围
config.default_u_range = [0.15 0.15]; %默认利用率变化范围
config.default_pr_rang = [0.1 0.1]; %默认边生成概率变化范围
config.default_D = 10000; %默认deadline

config.U_range = 0.1:0.01:0.2;
config.S_range = 2:10;
config.V_range = 40:2:60;
config.pr_range = 0.1:0.01:0.2;

mkdir 'database'
save('database/config.mat','config');
mkdir 'result'







