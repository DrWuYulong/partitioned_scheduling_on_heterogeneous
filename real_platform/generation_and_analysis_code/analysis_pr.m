clear all;
clc;

%%%%%%%%%%%%%%%%% 本函数分析pr变化时 WCRT和schedulability

%%%%%% 读取初始化参数
load('database/config.mat','config');

G_numb = config.G_numb;
default_type_range = config.default_type_range; %默认type变化范围
default_mi_range = config.default_mi_range; %默认每个type的cores数量变化范围
default_v_range = config.default_v_range; %默认子任务数量变化范围
default_u_range = config.default_u_range; %默认利用率变化范围
default_pr_rang = config.default_pr_rang; %默认边生成概率变化范围
default_D = config.default_D; %默认deadline

% U_range = config.U_range;
% S_range = config.S_range;
% V_range = config.V_range;
pr_range = config.pr_range;

%%%%%%% 结果
R_PA_Ben_EOI = zeros(1,length(pr_range)); %WCRT of bound 1 by Ben's allocation strategy
R_PA_MRW_EOI = R_PA_Ben_EOI;
R_PA_Ben_Wu = R_PA_Ben_EOI; %WCRT of bound 1 by Ben's allocation strategy
R_PA_MRW_Wu = R_PA_Ben_EOI;

R_Rand_Ben_EOI = R_PA_Ben_EOI; %WCRT of bound 1 by Ben's allocation strategy
R_Rand_MRW_EOI = R_PA_Ben_EOI;
R_Rand_Ben_Wu = R_PA_Ben_EOI; %WCRT of bound 1 by Ben's allocation strategy
R_Rand_MRW_Wu = R_PA_Ben_EOI;
 
Sched_PA_Ben_EOI = R_PA_Ben_EOI; %Schedulability of bound 1 by Ben's allocation strategy
Sched_PA_MRW_EOI = R_PA_Ben_EOI;
Sched_PA_Ben_Wu = R_PA_Ben_EOI; %WCRT of bound 1 by Ben's allocation strategy
Sched_PA_MRW_Wu = R_PA_Ben_EOI;

Sched_Rand_Ben_EOI = R_PA_Ben_EOI; %Schedulability of bound 1 by Ben's allocation strategy
Sched_Rand_MRW_EOI = R_PA_Ben_EOI;
Sched_Rand_Ben_Wu = R_PA_Ben_EOI; %WCRT of bound 1 by Ben's allocation strategy
Sched_Rand_MRW_Wu = R_PA_Ben_EOI;
% Sched_Rand_Ben = R_PA_Ben; %Schedulability of bound 1 by Ben's allocation strategy
% Sched_Rand_MRW = R_PA_Ben; %Schedulability of bound 1 by Chang's allocation strategy
% Sched_Rand_RRC = R_PA_Ben;
% AnaTime1_Ben = R_PA_Ben; % Analysis Time of bound 1 by Ben's allocation strategy
% AnaTime1_Chang = R_PA_Ben; % Analysis Time of bound 1 by Chang's allocation strategy

% R2_Ben = R_PA_Ben; %WCRT of bound 2 by Ben's allocation strategy
% R2_Chang = R_PA_Ben; %WCRT of bound 2 by Chang's allocation strategy
% Sched2_Ben = R_PA_Ben; %Schedulability of bound 2 by Ben's allocation strategy
% Sched2_Chang = R_PA_Ben; %Schedulability of bound 2 by Chang's allocation strategy
% AnaTime2_Ben = R_PA_Ben; % Analysis Time of bound 2 by Ben's allocation strategy
% AnaTime2_Chang = R_PA_Ben; % Analysis Time of bound 2 by Chang's allocation strategy

all_sched_PA_Ben = R_PA_Ben_EOI;
all_sched_PA_MRW = R_PA_Ben_EOI;
all_sched_Rand_Ben = R_PA_Ben_EOI;
all_sched_Rand_MRW = R_PA_Ben_EOI;
% both_sched_Chang = R1_Ben;

%%%% 路径
path = 'database/pr/pr_';

index = 1;
for pr = pr_range
    pr
    %%%%%% 根据每个pr来计算
    load([path num2str(pr) '/G.mat'],'G');
    
%     Ben_R1 = zeros(1,G_numb);
%     Ben_R2 = Ben_R1;
%     Chang_R1 = Ben_R1;
%     Chang_R2 = Ben_R1;
    
    for i = 1:G_numb
        %当前pr下的所有 G_numb个DAG任务，最后求平均值
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 开始 PA 的计算 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 计算 Wu %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%% Ben
        Res_Ben_Wu = bound_Wu(G(i).PA_C,G(i).PIS_PA_Ben,G(i).PA_path,default_D);
        if Res_Ben_Wu.Sched_Wu ~= 0
            Sched_PA_Ben_Wu(index) = Sched_PA_Ben_Wu(index) + 1;
            R_PA_Ben_Wu(index) = R_PA_Ben_Wu(index) + Res_Ben_Wu.R_Wu;            
        end
        %%%%%%%%%%%%%% MRW
        Res_MRW_Wu = bound_Wu(G(i).PA_C,G(i).PIS_PA_MRW,G(i).PA_path,default_D);
        if Res_MRW_Wu.Sched_Wu ~= 0
            Sched_PA_MRW_Wu(index) = Sched_PA_MRW_Wu(index) + 1;
            R_PA_MRW_Wu(index) = R_PA_MRW_Wu(index) + Res_MRW_Wu.R_Wu;
        end

        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 计算 EOI %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%% Ben
        Res_Ben_EOI = bound_EOI(G(i).PA_C,G(i).PA_E,G(i).PIS_PA_Ben,G(i).PA_Des,default_D);
        if Res_Ben_EOI.Sched_EOI ~= 0
            Sched_PA_Ben_EOI(index) = Sched_PA_Ben_EOI(index) + 1;
            R_PA_Ben_EOI(index) = R_PA_Ben_EOI(index) + Res_Ben_EOI.R_EOI;
        end
        %%%%%%%%%%%%%% MRW
        Res_MRW_EOI = bound_EOI(G(i).PA_C,G(i).PA_E,G(i).PIS_PA_MRW,G(i).PA_Des,default_D);
        if Res_MRW_EOI.Sched_EOI ~= 0
            Sched_PA_MRW_EOI(index) = Sched_PA_MRW_EOI(index) + 1;
            R_PA_MRW_EOI(index) = R_PA_MRW_EOI(index) + Res_MRW_EOI.R_EOI;
        end
        
        %%%%%%%%% 开始统计都可调度的情况下的WCRT
        %%%%% 先是 Ben 策略
%         if Res_Ben_Wu.Sched_Wu && Res_Ben_EOI.Sched_EOI
%             R_PA_Ben_Wu(index) = R_PA_Ben_Wu(index) + Res_Ben_Wu.R_Wu;
%             R_PA_Ben_EOI(index) = R_PA_Ben_EOI(index) + Res_Ben_EOI.R_EOI;            
%             all_sched_PA_Ben(index) = all_sched_PA_Ben(index) + 1;
%         end
% 
%         %%%%% 然后 MRW 策略
%         if Res_MRW_Wu.Sched_Wu && Res_MRW_EOI.Sched_EOI
%             R_PA_MRW_Wu(index) = R_PA_MRW_Wu(index) + Res_MRW_Wu.R_Wu;
%             R_PA_MRW_EOI(index) = R_PA_MRW_EOI(index) + Res_MRW_EOI.R_EOI;       
%             all_sched_PA_MRW(index) = all_sched_PA_MRW(index) + 1;
%         end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 开始 Rand 的计算 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 计算 Wu %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%% Ben
        Res_Ben_Wu = bound_Wu(G(i).Rand_C,G(i).PIS_Rand_Ben,G(i).Rand_path,default_D);
        if Res_Ben_Wu.Sched_Wu ~= 0
            Sched_Rand_Ben_Wu(index) = Sched_Rand_Ben_Wu(index) + 1;
            R_Rand_Ben_Wu(index) = R_Rand_Ben_Wu(index) + Res_Ben_Wu.R_Wu;
        end
        %%%%%%%%%%%%%% MRW
        Res_MRW_Wu = bound_Wu(G(i).Rand_C,G(i).PIS_Rand_MRW,G(i).Rand_path,default_D);
        if Res_MRW_Wu.Sched_Wu ~= 0
            Sched_Rand_MRW_Wu(index) = Sched_Rand_MRW_Wu(index) + 1;            
            R_Rand_MRW_Wu(index) = R_Rand_MRW_Wu(index) + Res_MRW_Wu.R_Wu; 
        end

        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 计算 EOI %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%% Ben
        Res_Ben_EOI = bound_EOI(G(i).Rand_C,G(i).Rand_E,G(i).PIS_Rand_Ben,G(i).Rand_Des,default_D);
        if Res_Ben_EOI.Sched_EOI ~= 0
            Sched_Rand_Ben_EOI(index) = Sched_Rand_Ben_EOI(index) + 1;
            R_Rand_Ben_EOI(index) = R_Rand_Ben_EOI(index) + Res_Ben_EOI.R_EOI;
        end
        %%%%%%%%%%%%%% MRW
        Res_MRW_EOI = bound_EOI(G(i).Rand_C,G(i).Rand_E,G(i).PIS_Rand_MRW,G(i).Rand_Des,default_D);
        if Res_MRW_EOI.Sched_EOI ~= 0
            Sched_Rand_MRW_EOI(index) = Sched_Rand_MRW_EOI(index) + 1;
            R_Rand_MRW_EOI(index) = R_Rand_MRW_EOI(index) + Res_MRW_EOI.R_EOI; 
        end
        
        %%%%%%%%% 开始统计都可调度的情况下的WCRT
        %%%%% 先是 Ben 策略
%         if Res_Ben_Wu.Sched_Wu && Res_Ben_EOI.Sched_EOI
%             R_Rand_Ben_Wu(index) = R_Rand_Ben_Wu(index) + Res_Ben_Wu.R_Wu;
%             R_Rand_Ben_EOI(index) = R_Rand_Ben_EOI(index) + Res_Ben_EOI.R_EOI;      
%             all_sched_Rand_Ben(index) = all_sched_Rand_Ben(index) + 1;
%         end
% 
%         %%%%% 然后 MRW 策略
%         if Res_MRW_Wu.Sched_Wu && Res_MRW_EOI.Sched_EOI
%             R_Rand_MRW_Wu(index) = R_Rand_MRW_Wu(index) + Res_MRW_Wu.R_Wu; 
%             R_Rand_MRW_EOI(index) = R_Rand_MRW_EOI(index) + Res_MRW_EOI.R_EOI;     
%             all_sched_Rand_MRW(index) = all_sched_Rand_MRW(index) + 1;
%         end
        
        
        
        
    end 
    
    
    index = index + 1;
end

Res.R_PA_Ben_Wu = R_PA_Ben_Wu ./ Sched_PA_Ben_Wu;
Res.R_PA_MRW_Wu = R_PA_MRW_Wu ./ Sched_PA_MRW_Wu;
Res.R_PA_Ben_EOI = R_PA_Ben_EOI ./ Sched_PA_Ben_EOI;
Res.R_PA_MRW_EOI = R_PA_MRW_EOI ./ Sched_PA_MRW_EOI;

Res.R_Rand_Ben_Wu = R_Rand_Ben_Wu ./ Sched_Rand_Ben_Wu;
Res.R_Rand_MRW_Wu = R_Rand_MRW_Wu ./ Sched_Rand_MRW_Wu;
Res.R_Rand_Ben_EOI = R_Rand_Ben_EOI ./ Sched_Rand_Ben_EOI;
Res.R_Rand_MRW_EOI = R_Rand_MRW_EOI ./ Sched_Rand_MRW_EOI;
% 
% Res.R_PA_Ben_Wu = R_PA_Ben_Wu ./ all_sched_PA_Ben;
% Res.R_PA_MRW_Wu = R_PA_MRW_Wu ./ all_sched_PA_MRW;
% Res.R_PA_Ben_EOI = R_PA_Ben_EOI ./ all_sched_PA_Ben;
% Res.R_PA_MRW_EOI = R_PA_MRW_EOI ./ all_sched_PA_MRW;
% 
% Res.R_Rand_Ben_Wu = R_Rand_Ben_Wu ./ all_sched_Rand_Ben;
% Res.R_Rand_MRW_Wu = R_Rand_MRW_Wu ./ all_sched_Rand_MRW;
% Res.R_Rand_Ben_EOI = R_Rand_Ben_EOI ./ all_sched_Rand_Ben;
% Res.R_Rand_MRW_EOI = R_Rand_MRW_EOI ./ all_sched_Rand_MRW;

Res.Sched_PA_Ben_Wu = Sched_PA_Ben_Wu / G_numb * 100;
Res.Sched_PA_MRW_Wu = Sched_PA_MRW_Wu / G_numb * 100;
Res.Sched_PA_Ben_EOI = Sched_PA_Ben_EOI / G_numb * 100;
Res.Sched_PA_MRW_EOI = Sched_PA_MRW_EOI / G_numb * 100;

Res.Sched_Rand_Ben_Wu = Sched_Rand_Ben_Wu / G_numb * 100;
Res.Sched_Rand_MRW_Wu = Sched_Rand_MRW_Wu / G_numb * 100;
Res.Sched_Rand_Ben_EOI = Sched_Rand_Ben_EOI / G_numb * 100;
Res.Sched_Rand_MRW_EOI = Sched_Rand_MRW_EOI / G_numb * 100;

% Res.Sched_Rand_RRC = Sched_Rand_RRC / G_numb * 100;
% Res.Sched_Rand_MRW = Sched_Rand_MRW / G_numb * 100;
% Res.Sched_Rand_Ben = Sched_Rand_Ben / G_numb * 100;
% Res.AnaTime1_Ben = AnaTime1_Ben ./ G_numb * 1000;
% Res.AnaTime1_Chang = AnaTime1_Chang ./  G_numb * 1000;

% Res.R2_Ben = R2_Ben ./ all_sched_PA;
% Res.R2_Chang = R2_Chang ./ both_sched_Chang;
% Res.Sched2_Ben = Sched2_Ben / G_numb * 100;
% Res.Sched2_Chang = Sched2_Chang / G_numb * 100;
% Res.AnaTime2_Ben = AnaTime2_Ben ./  G_numb * 1000;
% Res.AnaTime2_Chang = AnaTime2_Chang ./  G_numb * 1000;

path = 'result/change_pr';
mkdir(path);
save([path '/Res.mat'],'Res');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure;
plot(pr_range,Res.R_PA_Ben_Wu,'r:o');
hold on;
plot(pr_range,Res.R_PA_MRW_Wu,'g:*');
hold on;
plot(pr_range,Res.R_PA_Ben_EOI,'b:x');
hold on;
plot(pr_range,Res.R_PA_MRW_EOI,'k:s');
hold on;
plot(pr_range,Res.R_Rand_Ben_Wu,'r-o');
hold on;
plot(pr_range,Res.R_Rand_MRW_Wu,'g-*');
hold on;
plot(pr_range,Res.R_Rand_Ben_EOI,'b-x');
hold on;
plot(pr_range,Res.R_Rand_MRW_EOI,'k-s');
% return

xlim([pr_range(1) pr_range(end)]);
xticks(pr_range);
xlabel('Change pr');
ylabel('Average WCRT');
% gca=legend('Ben-Wu','EBen-Wu','MRW-Wu','MRW-EOI');
gca=legend('PA-Ben-Wu','PA-MRW-Wu','PA-Ben-EOI','PA-MRW-EOI','Rand-Ben-Wu','Rand-MRW-Wu','Rand-Ben-EOI','Rand-MRW-EOI');
set(gca,'Position',[0.2 0.65 0.1 0.2]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure;
plot(pr_range,Res.Sched_PA_Ben_Wu,'r:o');
hold on;
plot(pr_range,Res.Sched_PA_MRW_Wu,'g:*');
hold on;
plot(pr_range,Res.Sched_PA_Ben_EOI,'b:x');
hold on;
plot(pr_range,Res.Sched_PA_MRW_EOI,'k:s');
hold on;
plot(pr_range,Res.Sched_Rand_Ben_Wu,'r-o');
hold on;
plot(pr_range,Res.Sched_Rand_MRW_Wu,'g-*');
hold on;
plot(pr_range,Res.Sched_Rand_Ben_EOI,'b-x');
hold on;
plot(pr_range,Res.Sched_Rand_MRW_EOI,'k-s');
% return

xlim([pr_range(1) pr_range(end)]);
xticks(pr_range);
xlabel('Change pr');
ylabel('Schedulable ratio');
% gca=legend('Ben-Wu','Ben-EOI','MRW-Wu','MRW-EOI');
gca=legend('PA-Ben-Wu','PA-MRW-Wu','PA-Ben-EOI','PA-MRW-EOI','Rand-Ben-Wu','Rand-MRW-Wu','Rand-Ben-EOI','Rand-MRW-EOI');
set(gca,'Position',[0.2 0.65 0.1 0.2]);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure;
% plot(U_range,Res.AnaTime1_Ben,'b:o');
% hold on;
% plot(U_range,Res.AnaTime1_Chang,'r-*');
% hold on;
% plot(U_range,Res.AnaTime2_Ben,'g:x');
% hold on;
% plot(U_range,Res.AnaTime2_Chang,'k-s');
% 
% xlim([U_range(1) U_range(end)]);
% xticks(U_range);
% xlabel('Change U');
% ylabel('Analysis Time');
% gca=legend('Bound1-Ben','Bound1-Chang','Bound2-Ben','Bound2-Chang');
% set(gca,'Position',[0.2 0.65 0.1 0.2]);




