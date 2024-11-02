clear all;
clc;

%%%%%%%%%%%%%%%%% 本函数分析V变化时 WCRT和schedulability

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
V_range = config.V_range;
% pr_range = config.pr_range;

%%%%%%% 结果
R_PA_EWF_EOI = zeros(1,length(V_range)); %WCRT of bound 1 by EWF's allocation strategy
R_PA_LWF_EOI = R_PA_EWF_EOI;
R_PA_EWF_Wu = R_PA_EWF_EOI; %WCRT of bound 1 by EWF's allocation strategy
R_PA_LWF_Wu = R_PA_EWF_EOI;

R_Rand_EWF_EOI = R_PA_EWF_EOI; %WCRT of bound 1 by EWF's allocation strategy
R_Rand_LWF_EOI = R_PA_EWF_EOI;
R_Rand_EWF_Wu = R_PA_EWF_EOI; %WCRT of bound 1 by EWF's allocation strategy
R_Rand_LWF_Wu = R_PA_EWF_EOI;
 
Sched_PA_EWF_EOI = R_PA_EWF_EOI; %Schedulability of bound 1 by EWF's allocation strategy
Sched_PA_LWF_EOI = R_PA_EWF_EOI;
Sched_PA_EWF_Wu = R_PA_EWF_EOI; %WCRT of bound 1 by EWF's allocation strategy
Sched_PA_LWF_Wu = R_PA_EWF_EOI;

Sched_Rand_EWF_EOI = R_PA_EWF_EOI; %Schedulability of bound 1 by EWF's allocation strategy
Sched_Rand_LWF_EOI = R_PA_EWF_EOI;
Sched_Rand_EWF_Wu = R_PA_EWF_EOI; %WCRT of bound 1 by EWF's allocation strategy
Sched_Rand_LWF_Wu = R_PA_EWF_EOI;

% Sched_Rand_EWF = R_PA_EWF; %Schedulability of bound 1 by EWF's allocation strategy
% Sched_Rand_MRW = R_PA_EWF; %Schedulability of bound 1 by Chang's allocation strategy
% Sched_Rand_RRC = R_PA_EWF;
% AnaTime1_EWF = R_PA_EWF; % Analysis Time of bound 1 by EWF's allocation strategy
% AnaTime1_Chang = R_PA_EWF; % Analysis Time of bound 1 by Chang's allocation strategy

AnaTime_PA_EWF_EOI = R_PA_EWF_EOI;
AnaTime_PA_LWF_EOI = R_PA_EWF_EOI;
AnaTime_Rand_EWF_EOI = R_PA_EWF_EOI;
AnaTime_Rand_LWF_EOI = R_PA_EWF_EOI;
AnaTime_PA_EWF_Wu = R_PA_EWF_EOI;
AnaTime_PA_LWF_Wu = R_PA_EWF_EOI;
AnaTime_Rand_EWF_Wu = R_PA_EWF_EOI;
AnaTime_Rand_LWF_Wu = R_PA_EWF_EOI;


% R2_EWF = R_PA_EWF; %WCRT of bound 2 by EWF's allocation strategy
% R2_Chang = R_PA_EWF; %WCRT of bound 2 by Chang's allocation strategy
% Sched2_EWF = R_PA_EWF; %Schedulability of bound 2 by EWF's allocation strategy
% Sched2_Chang = R_PA_EWF; %Schedulability of bound 2 by Chang's allocation strategy
% AnaTime2_EWF = R_PA_EWF; % Analysis Time of bound 2 by EWF's allocation strategy
% AnaTime2_Chang = R_PA_EWF; % Analysis Time of bound 2 by Chang's allocation strategy

all_sched_PA_EWF = R_PA_EWF_EOI;
all_sched_PA_LWF = R_PA_EWF_EOI;
all_sched_Rand_EWF = R_PA_EWF_EOI;
all_sched_Rand_LWF = R_PA_EWF_EOI;


%%%% 路径
path = 'database/V/V_';

index = 1;
for V = V_range
    V
    %%%%%% 根据每个V来计算
    load([path num2str(V) '/G.mat'],'G');
    
%     EWF_R1 = zeros(1,G_numb);
%     EWF_R2 = EWF_R1;
%     Chang_R1 = EWF_R1;
%     Chang_R2 = EWF_R1;
    
    for i = 1:G_numb
        %当前V下的所有 G_numb个DAG任务，最后求平均值
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 开始 PA 的计算 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 计算 Wu %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%% EWF
        tic;
        Res_EWF_Wu = bound_Wu(G(i).PA_C,G(i).PIS_PA_EWF,G(i).PA_path,default_D);
        AnaTime_PA_EWF_Wu(index) = AnaTime_PA_EWF_Wu(index) + toc;
        if Res_EWF_Wu.Sched_Wu ~= 0
            Sched_PA_EWF_Wu(index) = Sched_PA_EWF_Wu(index) + 1;
            R_PA_EWF_Wu(index) = R_PA_EWF_Wu(index) + Res_EWF_Wu.R_Wu;            
        end
        %%%%%%%%%%%%%% LWF
        tic;
        Res_LWF_Wu = bound_Wu(G(i).PA_C,G(i).PIS_PA_LWF,G(i).PA_path,default_D);
        AnaTime_PA_LWF_Wu(index) = AnaTime_PA_LWF_Wu(index) + toc;
        if Res_LWF_Wu.Sched_Wu ~= 0
            Sched_PA_LWF_Wu(index) = Sched_PA_LWF_Wu(index) + 1;
            R_PA_LWF_Wu(index) = R_PA_LWF_Wu(index) + Res_LWF_Wu.R_Wu;            
        end

        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 计算 EOI %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%% EWF
        tic;
        Res_EWF_EOI = bound_EOI(G(i).PA_C,G(i).PA_E,G(i).PIS_PA_EWF,G(i).PA_Des,default_D);
        AnaTime_PA_EWF_EOI(index) = AnaTime_PA_EWF_EOI(index) + toc;
        if Res_EWF_EOI.Sched_EOI ~= 0
            Sched_PA_EWF_EOI(index) = Sched_PA_EWF_EOI(index) + 1;
            R_PA_EWF_EOI(index) = R_PA_EWF_EOI(index) + Res_EWF_EOI.R_EOI;            
        end
        %%%%%%%%%%%%%% LWF
        tic;
        Res_LWF_EOI = bound_EOI(G(i).PA_C,G(i).PA_E,G(i).PIS_PA_LWF,G(i).PA_Des,default_D);
        AnaTime_PA_LWF_EOI(index) = AnaTime_PA_LWF_EOI(index) + toc;
        if Res_LWF_EOI.Sched_EOI ~= 0
            Sched_PA_LWF_EOI(index) = Sched_PA_LWF_EOI(index) + 1;
            R_PA_LWF_EOI(index) = R_PA_LWF_EOI(index) + Res_LWF_EOI.R_EOI;            
        end
        
        %%%%%%%%% 开始统计都可调度的情况下的WCRT
        %%%%% 先是 EWF 策略
%         if Res_EWF_Wu.Sched_Wu && Res_EWF_EOI.Sched_EOI
%             R_PA_EWF_Wu(index) = R_PA_EWF_Wu(index) + Res_EWF_Wu.R_Wu;
%             R_PA_EWF_EOI(index) = R_PA_EWF_EOI(index) + Res_EWF_EOI.R_EOI;            
%             all_sched_PA_EWF(index) = all_sched_PA_EWF(index) + 1;
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
        %%%%%%%%%%%%%%% EWF
        tic;
        Res_EWF_Wu = bound_Wu(G(i).Rand_C,G(i).PIS_Rand_EWF,G(i).Rand_path,default_D);
        AnaTime_Rand_EWF_Wu(index) = AnaTime_Rand_EWF_Wu(index) + toc;
        if Res_EWF_Wu.Sched_Wu ~= 0
            Sched_Rand_EWF_Wu(index) = Sched_Rand_EWF_Wu(index) + 1;
            R_Rand_EWF_Wu(index) = R_Rand_EWF_Wu(index) + Res_EWF_Wu.R_Wu;            
        end
        %%%%%%%%%%%%%% LWF
        tic;
        Res_LWF_Wu = bound_Wu(G(i).Rand_C,G(i).PIS_Rand_LWF,G(i).Rand_path,default_D);
        AnaTime_Rand_LWF_Wu(index) = AnaTime_Rand_LWF_Wu(index) + toc;
        if Res_LWF_Wu.Sched_Wu ~= 0
            Sched_Rand_LWF_Wu(index) = Sched_Rand_LWF_Wu(index) + 1;
            R_Rand_LWF_Wu(index) = R_Rand_LWF_Wu(index) + Res_LWF_Wu.R_Wu;            
        end

        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 计算 EOI %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%% EWF
        tic;
        Res_EWF_EOI = bound_EOI(G(i).Rand_C,G(i).Rand_E,G(i).PIS_Rand_EWF,G(i).Rand_Des,default_D);
        AnaTime_Rand_EWF_EOI(index) = AnaTime_Rand_EWF_EOI(index) + toc;
        if Res_EWF_EOI.Sched_EOI ~= 0
            Sched_Rand_EWF_EOI(index) = Sched_Rand_EWF_EOI(index) + 1;
            R_Rand_EWF_EOI(index) = R_Rand_EWF_EOI(index) + Res_EWF_EOI.R_EOI;            
        end
        %%%%%%%%%%%%%% LWF
        tic;
        Res_LWF_EOI = bound_EOI(G(i).Rand_C,G(i).Rand_E,G(i).PIS_Rand_LWF,G(i).Rand_Des,default_D);
        AnaTime_Rand_LWF_EOI(index) = AnaTime_Rand_LWF_EOI(index) + toc;
        if Res_LWF_EOI.Sched_EOI ~= 0
            Sched_Rand_LWF_EOI(index) = Sched_Rand_LWF_EOI(index) + 1;
            R_Rand_LWF_EOI(index) = R_Rand_LWF_EOI(index) + Res_LWF_EOI.R_EOI;            
        end
        
        %%%%%%%%% 开始统计都可调度的情况下的WCRT
        %%%%% 先是 EWF 策略
%         if Res_EWF_Wu.Sched_Wu && Res_EWF_EOI.Sched_EOI
%             R_Rand_EWF_Wu(index) = R_Rand_EWF_Wu(index) + Res_EWF_Wu.R_Wu;
%             R_Rand_EWF_EOI(index) = R_Rand_EWF_EOI(index) + Res_EWF_EOI.R_EOI;      
%             all_sched_Rand_EWF(index) = all_sched_Rand_EWF(index) + 1;
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

Res.R_PA_EWF_Wu = R_PA_EWF_Wu ./ Sched_PA_EWF_Wu;
Res.R_PA_LWF_Wu = R_PA_LWF_Wu ./ Sched_PA_LWF_Wu;
Res.R_PA_EWF_EOI = R_PA_EWF_EOI ./ Sched_PA_EWF_EOI;
Res.R_PA_LWF_EOI = R_PA_LWF_EOI ./ Sched_PA_LWF_EOI;

Res.R_Rand_EWF_Wu = R_Rand_EWF_Wu ./ Sched_Rand_EWF_Wu;
Res.R_Rand_LWF_Wu = R_Rand_LWF_Wu ./ Sched_Rand_LWF_Wu;
Res.R_Rand_EWF_EOI = R_Rand_EWF_EOI ./ Sched_Rand_EWF_EOI;
Res.R_Rand_LWF_EOI = R_Rand_LWF_EOI ./ Sched_Rand_LWF_EOI;


% Res.R_PA_EWF_Wu = R_PA_EWF_Wu ./ all_sched_PA_EWF;
% Res.R_PA_MRW_Wu = R_PA_MRW_Wu ./ all_sched_PA_MRW;
% Res.R_PA_EWF_EOI = R_PA_EWF_EOI ./ all_sched_PA_EWF;
% Res.R_PA_MRW_EOI = R_PA_MRW_EOI ./ all_sched_PA_MRW;
% 
% Res.R_Rand_EWF_Wu = R_Rand_EWF_Wu ./ all_sched_Rand_EWF;
% Res.R_Rand_MRW_Wu = R_Rand_MRW_Wu ./ all_sched_Rand_MRW;
% Res.R_Rand_EWF_EOI = R_Rand_EWF_EOI ./ all_sched_Rand_EWF;
% Res.R_Rand_MRW_EOI = R_Rand_MRW_EOI ./ all_sched_Rand_MRW;

Res.Sched_PA_EWF_Wu = Sched_PA_EWF_Wu / G_numb * 100;
Res.Sched_PA_LWF_Wu = Sched_PA_LWF_Wu / G_numb * 100;
Res.Sched_PA_EWF_EOI = Sched_PA_EWF_EOI / G_numb * 100;
Res.Sched_PA_LWF_EOI = Sched_PA_LWF_EOI / G_numb * 100;

Res.Sched_Rand_EWF_Wu = Sched_Rand_EWF_Wu / G_numb * 100;
Res.Sched_Rand_LWF_Wu = Sched_Rand_LWF_Wu / G_numb * 100;
Res.Sched_Rand_EWF_EOI = Sched_Rand_EWF_EOI / G_numb * 100;
Res.Sched_Rand_LWF_EOI = Sched_Rand_LWF_EOI / G_numb * 100;

% Res.Sched_Rand_RRC = Sched_Rand_RRC / G_numb * 100;
% Res.Sched_Rand_MRW = Sched_Rand_MRW / G_numb * 100;
% Res.Sched_Rand_EWF = Sched_Rand_EWF / G_numb * 100;
% Res.AnaTime1_EWF = AnaTime1_EWF ./ G_numb * 1000;
% Res.AnaTime1_Chang = AnaTime1_Chang ./  G_numb * 1000;

Res.AnaTime_PA_EWF_EOI = AnaTime_PA_EWF_EOI / G_numb;
Res.AnaTime_PA_LWF_EOI = AnaTime_PA_LWF_EOI / G_numb;
Res.AnaTime_PA_EWF_Wu = AnaTime_PA_EWF_Wu / G_numb;
Res.AnaTime_PA_LWF_Wu = AnaTime_PA_LWF_Wu / G_numb;

Res.AnaTime_Rand_EWF_EOI = AnaTime_Rand_EWF_EOI / G_numb;
Res.AnaTime_Rand_LWF_EOI = AnaTime_Rand_LWF_EOI / G_numb;
Res.AnaTime_Rand_EWF_Wu = AnaTime_Rand_EWF_Wu / G_numb;
Res.AnaTime_Rand_LWF_Wu = AnaTime_Rand_LWF_Wu / G_numb;



path = 'result/change_V';
mkdir(path);
save([path '/Res.mat'],'Res');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure;
plot(V_range,Res.R_PA_EWF_Wu,'r:o');
hold on;
plot(V_range,Res.R_PA_EWF_EOI,'r-o');
hold on;
plot(V_range,Res.R_PA_LWF_Wu,'k:s');
hold on;
plot(V_range,Res.R_PA_LWF_EOI,'k-s');
hold on;
plot(V_range,Res.R_Rand_EWF_Wu,'g:*');
hold on;
plot(V_range,Res.R_Rand_EWF_EOI,'g-*');
hold on;
plot(V_range,Res.R_Rand_LWF_Wu,'b:x');
hold on;
plot(V_range,Res.R_Rand_LWF_EOI,'b-x');
% return

xlim([V_range(1) V_range(end)]);
xticks(V_range);
xlabel('Change V');
ylabel('Average WCRT');
gca=legend('PA-EWF-Wu','PA-EWF-EOI','PA-LWF-Wu','PA-LWF-EOI','Rand-EWF-Wu','Rand-EWF-EOI','Rand-LWF-Wu','Rand-LWF-EOI');
% gca=legend('PA-EWF-Wu','PA-EWF-EOI','Rand-EWF-Wu','Rand-EWF-EOI');
set(gca,'Position',[0.2 0.65 0.1 0.2]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure;
plot(V_range,Res.Sched_PA_EWF_Wu,'r:o');
hold on;
plot(V_range,Res.Sched_PA_EWF_EOI,'r-o');
hold on;
plot(V_range,Res.Sched_PA_LWF_Wu,'k:s');
hold on;
plot(V_range,Res.Sched_PA_LWF_EOI,'k-s');
hold on;
plot(V_range,Res.Sched_Rand_EWF_Wu,'g:*');
hold on;
plot(V_range,Res.Sched_Rand_EWF_EOI,'g-*');
hold on;
plot(V_range,Res.Sched_Rand_LWF_Wu,'b:x');
hold on;
plot(V_range,Res.Sched_Rand_LWF_EOI,'b-x');
% return

xlim([V_range(1) V_range(end)]);
xticks(V_range);
xlabel('Change V');
ylabel('Schedulable ratio');
gca=legend('PA-EWF-Wu','PA-EWF-EOI','PA-LWF-Wu','PA-LWF-EOI','Rand-EWF-Wu','Rand-EWF-EOI','Rand-LWF-Wu','Rand-LWF-EOI');
% gca=legend('PA-EWF-Wu','PA-EWF-EOI','Rand-EWF-Wu','Rand-EWF-EOI');
set(gca,'Position',[0.2 0.65 0.1 0.2]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure;
plot(V_range,Res.AnaTime_PA_EWF_Wu,'r:o');
hold on;
plot(V_range,Res.AnaTime_PA_EWF_EOI,'r-o');
hold on;
plot(V_range,Res.AnaTime_PA_LWF_Wu,'k:s');
hold on;
plot(V_range,Res.AnaTime_PA_LWF_EOI,'k-s');
hold on;
plot(V_range,Res.AnaTime_Rand_EWF_Wu,'g:*');
hold on;
plot(V_range,Res.AnaTime_Rand_EWF_EOI,'g-*');
hold on;
plot(V_range,Res.AnaTime_Rand_LWF_Wu,'b:x');
hold on;
plot(V_range,Res.AnaTime_Rand_LWF_EOI,'b-x');
% return

xlim([V_range(1) V_range(end)]);
xticks(V_range);
xlabel('Change V');
ylabel('Average anaylsis time');
gca=legend('PA-EWF-Wu','PA-EWF-EOI','PA-LWF-Wu','PA-LWF-EOI','Rand-EWF-Wu','Rand-EWF-EOI','Rand-LWF-Wu','Rand-LWF-EOI');
% gca=legend('PA-EWF-Wu','PA-EWF-EOI','Rand-EWF-Wu','Rand-EWF-EOI');
set(gca,'Position',[0.2 0.65 0.1 0.2]);





