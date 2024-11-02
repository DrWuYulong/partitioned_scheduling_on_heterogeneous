clear all;
clc;


load('database/config.mat','config');
U_range = config.U_range;
S_range = config.S_range;
V_range = config.V_range;
pr_range = config.pr_range;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%  U    %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('result/change_U/Res.mat','Res');

figure;
plot(U_range,Res.R_PA_Ben_Wu,'r:o');
hold on;
plot(U_range,Res.R_PA_MRW_Wu,'g:*');
hold on;
plot(U_range,Res.R_PA_Ben_EOI,'b:x');
hold on;
plot(U_range,Res.R_PA_MRW_EOI,'k:s');
hold on;
plot(U_range,Res.R_Rand_Ben_Wu,'r-o');
hold on;
plot(U_range,Res.R_Rand_MRW_Wu,'g-*');
hold on;
plot(U_range,Res.R_Rand_Ben_EOI,'b-x');
hold on;
plot(U_range,Res.R_Rand_MRW_EOI,'k-s');
% return

xlim([U_range(1) U_range(end)]);
xticks(U_range);
xlabel('Change U');
ylabel('Average WCRT');
% gca=legend('Ben-Wu','EBen-Wu','MRW-Wu','MRW-EOI');
gca=legend('PA-Ben-Wu','PA-MRW-Wu','PA-Ben-EOI','PA-MRW-EOI','Rand-Ben-Wu','Rand-MRW-Wu','Rand-Ben-EOI','Rand-MRW-EOI');
set(gca,'Position',[0.2 0.65 0.1 0.2]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure;
plot(U_range,Res.Sched_PA_Ben_Wu,'r:o');
hold on;
plot(U_range,Res.Sched_PA_MRW_Wu,'g:*');
hold on;
plot(U_range,Res.Sched_PA_Ben_EOI,'b:x');
hold on;
plot(U_range,Res.Sched_PA_MRW_EOI,'k:s');
hold on;
plot(U_range,Res.Sched_Rand_Ben_Wu,'r-o');
hold on;
plot(U_range,Res.Sched_Rand_MRW_Wu,'g-*');
hold on;
plot(U_range,Res.Sched_Rand_Ben_EOI,'b-x');
hold on;
plot(U_range,Res.Sched_Rand_MRW_EOI,'k-s');
% return

xlim([U_range(1) U_range(end)]);
xticks(U_range);
xlabel('Change U');
ylabel('Schedulable ratio');
% gca=legend('Ben-Wu','Ben-EOI','MRW-Wu','MRW-EOI');
gca=legend('PA-Ben-Wu','PA-MRW-Wu','PA-Ben-EOI','PA-MRW-EOI','Rand-Ben-Wu','Rand-MRW-Wu','Rand-Ben-EOI','Rand-MRW-EOI');
set(gca,'Position',[0.2 0.65 0.1 0.2]);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%  S    %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('result/change_S/Res.mat','Res');

figure;
plot(S_range,Res.R_PA_Ben_Wu,'r:o');
hold on;
plot(S_range,Res.R_PA_MRW_Wu,'g:*');
hold on;
plot(S_range,Res.R_PA_Ben_EOI,'b:x');
hold on;
plot(S_range,Res.R_PA_MRW_EOI,'k:s');
hold on;
plot(S_range,Res.R_Rand_Ben_Wu,'r-o');
hold on;
plot(S_range,Res.R_Rand_MRW_Wu,'g-*');
hold on;
plot(S_range,Res.R_Rand_Ben_EOI,'b-x');
hold on;
plot(S_range,Res.R_Rand_MRW_EOI,'k-s');
% return

xlim([S_range(1) S_range(end)]);
xticks(S_range);
xlabel('Change S');
ylabel('Average WCRT');
% gca=legend('Ben-Wu','EBen-Wu','MRW-Wu','MRW-EOI');
gca=legend('PA-Ben-Wu','PA-MRW-Wu','PA-Ben-EOI','PA-MRW-EOI','Rand-Ben-Wu','Rand-MRW-Wu','Rand-Ben-EOI','Rand-MRW-EOI');
set(gca,'Position',[0.2 0.65 0.1 0.2]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure;
plot(S_range,Res.Sched_PA_Ben_Wu,'r:o');
hold on;
plot(S_range,Res.Sched_PA_MRW_Wu,'g:*');
hold on;
plot(S_range,Res.Sched_PA_Ben_EOI,'b:x');
hold on;
plot(S_range,Res.Sched_PA_MRW_EOI,'k:s');
hold on;
plot(S_range,Res.Sched_Rand_Ben_Wu,'r-o');
hold on;
plot(S_range,Res.Sched_Rand_MRW_Wu,'g-*');
hold on;
plot(S_range,Res.Sched_Rand_Ben_EOI,'b-x');
hold on;
plot(S_range,Res.Sched_Rand_MRW_EOI,'k-s');
% return

xlim([S_range(1) S_range(end)]);
xticks(S_range);
xlabel('Change S');
ylabel('Schedulable ratio');
% gca=legend('Ben-Wu','Ben-EOI','MRW-Wu','MRW-EOI');
gca=legend('PA-Ben-Wu','PA-MRW-Wu','PA-Ben-EOI','PA-MRW-EOI','Rand-Ben-Wu','Rand-MRW-Wu','Rand-Ben-EOI','Rand-MRW-EOI');
set(gca,'Position',[0.2 0.65 0.1 0.2]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%  V    %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('result/change_V/Res.mat','Res');

figure;
plot(V_range,Res.R_PA_Ben_Wu,'r:o');
hold on;
plot(V_range,Res.R_PA_MRW_Wu,'g:*');
hold on;
plot(V_range,Res.R_PA_Ben_EOI,'b:x');
hold on;
plot(V_range,Res.R_PA_MRW_EOI,'k:s');
hold on;
plot(V_range,Res.R_Rand_Ben_Wu,'r-o');
hold on;
plot(V_range,Res.R_Rand_MRW_Wu,'g-*');
hold on;
plot(V_range,Res.R_Rand_Ben_EOI,'b-x');
hold on;
plot(V_range,Res.R_Rand_MRW_EOI,'k-s');
% return

xlim([V_range(1) V_range(end)]);
xticks(V_range);
xlabel('Change V');
ylabel('Average WCRT');
% gca=legend('Ben-Wu','EBen-Wu','MRW-Wu','MRW-EOI');
gca=legend('PA-Ben-Wu','PA-MRW-Wu','PA-Ben-EOI','PA-MRW-EOI','Rand-Ben-Wu','Rand-MRW-Wu','Rand-Ben-EOI','Rand-MRW-EOI');
set(gca,'Position',[0.2 0.65 0.1 0.2]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure;
plot(V_range,Res.Sched_PA_Ben_Wu,'r:o');
hold on;
plot(V_range,Res.Sched_PA_MRW_Wu,'g:*');
hold on;
plot(V_range,Res.Sched_PA_Ben_EOI,'b:x');
hold on;
plot(V_range,Res.Sched_PA_MRW_EOI,'k:s');
hold on;
plot(V_range,Res.Sched_Rand_Ben_Wu,'r-o');
hold on;
plot(V_range,Res.Sched_Rand_MRW_Wu,'g-*');
hold on;
plot(V_range,Res.Sched_Rand_Ben_EOI,'b-x');
hold on;
plot(V_range,Res.Sched_Rand_MRW_EOI,'k-s');
% return

xlim([V_range(1) V_range(end)]);
xticks(V_range);
xlabel('Change V');
ylabel('Schedulable ratio');
% gca=legend('Ben-Wu','Ben-EOI','MRW-Wu','MRW-EOI');
gca=legend('PA-Ben-Wu','PA-MRW-Wu','PA-Ben-EOI','PA-MRW-EOI','Rand-Ben-Wu','Rand-MRW-Wu','Rand-Ben-EOI','Rand-MRW-EOI');
set(gca,'Position',[0.2 0.65 0.1 0.2]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%  pr   %%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load('result/change_pr/Res.mat','Res');

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









