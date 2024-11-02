clear all;
clc;


%%%%%% 参数设置
config.G_numb = 500;
config.default_type_range = [4 4]; %默认type变化范围
config.default_mi_range = [2 6]; %默认每个type的cores数量变化范围
config.default_v_range = [30 30]; %默认子任务数量变化范围
config.default_u_range = [0.25 0.25]; %默认利用率变化范围
config.default_pr_rang = [0.2 0.2]; %默认边生成概率变化范围
config.default_D = 1000; %默认deadline

config.U_range = 0.1:0.03:0.4;
config.S_range = 2:10;
config.V_range = 20:2:40;
config.pr_range = 0.15:0.01:0.25;

mkdir 'database'
save('database/config.mat','config');
mkdir 'result'







