clear all;
clc;
%%%%%%%%%%% Sched %%%%%%%%%%%%%%

%%%%%%%%%%%% EOI-Wu
load('result/change_U/Res.mat','Res');
a = mean(Res.Sched_PA_MRW_EOI - Res.Sched_PA_MRW_Wu) + mean(Res.Sched_PA_Ben_EOI - Res.Sched_PA_Ben_Wu) +...
    mean(Res.Sched_Rand_MRW_EOI - Res.Sched_Rand_MRW_Wu) + mean(Res.Sched_Rand_Ben_EOI - Res.Sched_Rand_Ben_Wu);
a = a/4;

load('result/change_S/Res.mat','Res');
b = mean(Res.Sched_PA_MRW_EOI - Res.Sched_PA_MRW_Wu) + mean(Res.Sched_PA_Ben_EOI - Res.Sched_PA_Ben_Wu) +...
    mean(Res.Sched_Rand_MRW_EOI - Res.Sched_Rand_MRW_Wu) + mean(Res.Sched_Rand_Ben_EOI - Res.Sched_Rand_Ben_Wu);
b = b/4;

load('result/change_V/Res.mat','Res');
c = mean(Res.Sched_PA_MRW_EOI - Res.Sched_PA_MRW_Wu) + mean(Res.Sched_PA_Ben_EOI - Res.Sched_PA_Ben_Wu) +...
    mean(Res.Sched_Rand_MRW_EOI - Res.Sched_Rand_MRW_Wu) + mean(Res.Sched_Rand_Ben_EOI - Res.Sched_Rand_Ben_Wu);
c = c/4;

load('result/change_pr/Res.mat','Res');
d = mean(Res.Sched_PA_MRW_EOI - Res.Sched_PA_MRW_Wu) + mean(Res.Sched_PA_Ben_EOI - Res.Sched_PA_Ben_Wu) +...
    mean(Res.Sched_Rand_MRW_EOI - Res.Sched_Rand_MRW_Wu) + mean(Res.Sched_Rand_Ben_EOI - Res.Sched_Rand_Ben_Wu);
d = d/4;


average_Sched_EOI_Wu = (a+b+c+d)/4

%%%%%%%%%%%%%% MRW_Ben

load('result/change_U/Res.mat','Res');
a = mean(Res.Sched_PA_MRW_EOI - Res.Sched_PA_Ben_EOI) + mean(Res.Sched_PA_MRW_Wu - Res.Sched_PA_Ben_Wu) +...
    mean(Res.Sched_Rand_MRW_EOI - Res.Sched_Rand_Ben_EOI) + mean(Res.Sched_Rand_MRW_Wu - Res.Sched_Rand_Ben_Wu);
a = a/4;

load('result/change_S/Res.mat','Res');
b = mean(Res.Sched_PA_MRW_EOI - Res.Sched_PA_Ben_EOI) + mean(Res.Sched_PA_MRW_Wu - Res.Sched_PA_Ben_Wu) +...
    mean(Res.Sched_Rand_MRW_EOI - Res.Sched_Rand_Ben_EOI) + mean(Res.Sched_Rand_MRW_Wu - Res.Sched_Rand_Ben_Wu);
b = b/4;

load('result/change_V/Res.mat','Res');
c = mean(Res.Sched_PA_MRW_EOI - Res.Sched_PA_Ben_EOI) + mean(Res.Sched_PA_MRW_Wu - Res.Sched_PA_Ben_Wu) +...
    mean(Res.Sched_Rand_MRW_EOI - Res.Sched_Rand_Ben_EOI) + mean(Res.Sched_Rand_MRW_Wu - Res.Sched_Rand_Ben_Wu);
c = c/4;

load('result/change_pr/Res.mat','Res');
d = mean(Res.Sched_PA_MRW_EOI - Res.Sched_PA_Ben_EOI) + mean(Res.Sched_PA_MRW_Wu - Res.Sched_PA_Ben_Wu) +...
    mean(Res.Sched_Rand_MRW_EOI - Res.Sched_Rand_Ben_EOI) + mean(Res.Sched_Rand_MRW_Wu - Res.Sched_Rand_Ben_Wu);
d = d/4;


average_Sched_MRW_Ben = (a+b+c+d)/4


%%%%%%%%%%% R %%%%%%%%%%%%%%

%%%%%%%%% EOI-Wu
b = 0;

load('result/change_U/Res.mat','Res');
a = (Res.R_PA_MRW_Wu - Res.R_PA_MRW_EOI)./Res.R_PA_MRW_Wu;
a(isnan(a)) = [];
b = b + mean(a);

a = (Res.R_PA_Ben_Wu - Res.R_PA_Ben_EOI)./Res.R_PA_Ben_Wu;
a(isnan(a)) = [];
b = b + mean(a);

a = (Res.R_Rand_MRW_Wu - Res.R_Rand_MRW_EOI)./Res.R_Rand_MRW_Wu;
a(isnan(a)) = [];
b = b + mean(a);

a = (Res.R_Rand_Ben_Wu - Res.R_Rand_Ben_EOI)./Res.R_Rand_Ben_Wu;
a(isnan(a)) = [];
b = b + mean(a);

load('result/change_S/Res.mat','Res');
a = (Res.R_PA_MRW_Wu - Res.R_PA_MRW_EOI)./Res.R_PA_MRW_Wu;
a(isnan(a)) = [];
b = b + mean(a);

a = (Res.R_PA_Ben_Wu - Res.R_PA_Ben_EOI)./Res.R_PA_Ben_Wu;
a(isnan(a)) = [];
b = b + mean(a);

a = (Res.R_Rand_MRW_Wu - Res.R_Rand_MRW_EOI)./Res.R_Rand_MRW_Wu;
a(isnan(a)) = [];
b = b + mean(a);

a = (Res.R_Rand_Ben_Wu - Res.R_Rand_Ben_EOI)./Res.R_Rand_Ben_Wu;
a(isnan(a)) = [];
b = b + mean(a);

load('result/change_V/Res.mat','Res');
a = (Res.R_PA_MRW_Wu - Res.R_PA_MRW_EOI)./Res.R_PA_MRW_Wu;
a(isnan(a)) = [];
b = b + mean(a);

a = (Res.R_PA_Ben_Wu - Res.R_PA_Ben_EOI)./Res.R_PA_Ben_Wu;
a(isnan(a)) = [];
b = b + mean(a);

a = (Res.R_Rand_MRW_Wu - Res.R_Rand_MRW_EOI)./Res.R_Rand_MRW_Wu;
a(isnan(a)) = [];
b = b + mean(a);

a = (Res.R_Rand_Ben_Wu - Res.R_Rand_Ben_EOI)./Res.R_Rand_Ben_Wu;
a(isnan(a)) = [];
b = b + mean(a);

load('result/change_pr/Res.mat','Res');
a = (Res.R_PA_MRW_Wu - Res.R_PA_MRW_EOI)./Res.R_PA_MRW_Wu;
a(isnan(a)) = [];
b = b + mean(a);

a = (Res.R_PA_Ben_Wu - Res.R_PA_Ben_EOI)./Res.R_PA_Ben_Wu;
a(isnan(a)) = [];
b = b + mean(a);

a = (Res.R_Rand_MRW_Wu - Res.R_Rand_MRW_EOI)./Res.R_Rand_MRW_Wu;
a(isnan(a)) = [];
b = b + mean(a);

a = (Res.R_Rand_Ben_Wu - Res.R_Rand_Ben_EOI)./Res.R_Rand_Ben_Wu;
a(isnan(a)) = [];
b = b + mean(a);

average_R_EOI_Wu = b / 16 * 100

%%%%%%%%% MRW-Ben
b = 0;

load('result/change_U/Res.mat','Res');
a = (Res.R_PA_Ben_EOI - Res.R_PA_MRW_EOI)./Res.R_PA_Ben_EOI;
a(isnan(a)) = [];
b = b + mean(a);

a = (Res.R_PA_Ben_Wu - Res.R_PA_MRW_Wu)./Res.R_PA_Ben_Wu;
a(isnan(a)) = [];
b = b + mean(a);

a = (Res.R_Rand_Ben_EOI - Res.R_Rand_MRW_EOI)./Res.R_Rand_Ben_EOI;
a(isnan(a)) = [];
b = b + mean(a);

a = (Res.R_Rand_Ben_Wu - Res.R_Rand_MRW_Wu)./Res.R_Rand_Ben_Wu;
a(isnan(a)) = [];
b = b + mean(a);

load('result/change_S/Res.mat','Res');
a = (Res.R_PA_Ben_EOI - Res.R_PA_MRW_EOI)./Res.R_PA_Ben_EOI;
a(isnan(a)) = [];
b = b + mean(a);

a = (Res.R_PA_Ben_Wu - Res.R_PA_MRW_Wu)./Res.R_PA_Ben_Wu;
a(isnan(a)) = [];
b = b + mean(a);

a = (Res.R_Rand_Ben_EOI - Res.R_Rand_MRW_EOI)./Res.R_Rand_Ben_EOI;
a(isnan(a)) = [];
b = b + mean(a);

a = (Res.R_Rand_Ben_Wu - Res.R_Rand_MRW_Wu)./Res.R_Rand_Ben_Wu;
a(isnan(a)) = [];
b = b + mean(a);

load('result/change_V/Res.mat','Res');
a = (Res.R_PA_Ben_EOI - Res.R_PA_MRW_EOI)./Res.R_PA_Ben_EOI;
a(isnan(a)) = [];
b = b + mean(a);

a = (Res.R_PA_Ben_Wu - Res.R_PA_MRW_Wu)./Res.R_PA_Ben_Wu;
a(isnan(a)) = [];
b = b + mean(a);

a = (Res.R_Rand_Ben_EOI - Res.R_Rand_MRW_EOI)./Res.R_Rand_Ben_EOI;
a(isnan(a)) = [];
b = b + mean(a);

a = (Res.R_Rand_Ben_Wu - Res.R_Rand_MRW_Wu)./Res.R_Rand_Ben_Wu;
a(isnan(a)) = [];
b = b + mean(a);

load('result/change_pr/Res.mat','Res');
a = (Res.R_PA_Ben_EOI - Res.R_PA_MRW_EOI)./Res.R_PA_Ben_EOI;
a(isnan(a)) = [];
b = b + mean(a);

a = (Res.R_PA_Ben_Wu - Res.R_PA_MRW_Wu)./Res.R_PA_Ben_Wu;
a(isnan(a)) = [];
b = b + mean(a);

a = (Res.R_Rand_Ben_EOI - Res.R_Rand_MRW_EOI)./Res.R_Rand_Ben_EOI;
a(isnan(a)) = [];
b = b + mean(a);

a = (Res.R_Rand_Ben_Wu - Res.R_Rand_MRW_Wu)./Res.R_Rand_Ben_Wu;
a(isnan(a)) = [];
b = b + mean(a);

average_R_MRW_Ben = b / 16 * 100


% load('result/change_S/Res.mat','Res');
% b = mean((Res.R_PA_MRW_Wu - Res.R_PA_MRW_EOI)./Res.R_PA_MRW_Wu) + mean((Res.R_PA_Ben_Wu - Res.R_PA_Ben_EOI)./Res.R_PA_Ben_Wu) +...
%     mean((Res.R_Rand_MRW_Wu - Res.R_Rand_MRW_EOI)./Res.R_Rand_MRW_Wu) + mean((Res.R_Rand_Ben_Wu - Res.R_Rand_Ben_EOI)./Res.R_Rand_Ben_Wu);
% b = b/4;
% 
% load('result/change_V/Res.mat','Res');
% c = mean((Res.R_PA_MRW_Wu - Res.R_PA_MRW_EOI)./Res.R_PA_MRW_Wu) + mean((Res.R_PA_Ben_Wu - Res.R_PA_Ben_EOI)./Res.R_PA_Ben_Wu) +...
%     mean((Res.R_Rand_MRW_Wu - Res.R_Rand_MRW_EOI)./Res.R_Rand_MRW_Wu) + mean((Res.R_Rand_Ben_Wu - Res.R_Rand_Ben_EOI)./Res.R_Rand_Ben_Wu);
% c = c/4;
% 
% load('result/change_pr/Res.mat','Res');
% d = mean((Res.R_PA_MRW_Wu - Res.R_PA_MRW_EOI)./Res.R_PA_MRW_Wu) + mean((Res.R_PA_Ben_Wu - Res.R_PA_Ben_EOI)./Res.R_PA_Ben_Wu) +...
%     mean((Res.R_Rand_MRW_Wu - Res.R_Rand_MRW_EOI)./Res.R_Rand_MRW_Wu) + mean((Res.R_Rand_Ben_Wu - Res.R_Rand_Ben_EOI)./Res.R_Rand_Ben_Wu);
% d = d/4;


% average_R = (a+b+c+d)/4*100

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%% MRW-EOI 与 Ben-Wu 比较 %%%%%%%%%%%%%%%%

%%%%%%%% Sched

load('result/change_U/Res.mat','Res');
a = mean(Res.Sched_PA_MRW_EOI - Res.Sched_PA_Ben_Wu) + mean(Res.Sched_Rand_MRW_EOI - Res.Sched_Rand_Ben_Wu);
a = a / 2;

load('result/change_S/Res.mat','Res');
b = mean(Res.Sched_PA_MRW_EOI - Res.Sched_PA_Ben_Wu) + mean(Res.Sched_Rand_MRW_EOI - Res.Sched_Rand_Ben_Wu);
b = b / 2;

load('result/change_V/Res.mat','Res');
c = mean(Res.Sched_PA_MRW_EOI - Res.Sched_PA_Ben_Wu) + mean(Res.Sched_Rand_MRW_EOI - Res.Sched_Rand_Ben_Wu);
c = c / 2;

load('result/change_pr/Res.mat','Res');
d = mean(Res.Sched_PA_MRW_EOI - Res.Sched_PA_Ben_Wu) + mean(Res.Sched_Rand_MRW_EOI - Res.Sched_Rand_Ben_Wu);
d = d / 2;

Sched_ME_WW = (a+b+c+d)/4;

%%%%%%%%%%% R
load('result/change_U/Res.mat','Res');
t = (Res.R_PA_Ben_Wu - Res.R_PA_MRW_EOI) ./ Res.R_PA_Ben_Wu;
t(isnan(t)) = [];
a = mean(t);
t = (Res.R_Rand_Ben_Wu - Res.R_Rand_MRW_EOI) ./ Res.R_Rand_Ben_Wu;
t(isnan(t)) = [];
a = a + mean(t);
a = a / 2;

load('result/change_S/Res.mat','Res');
t = (Res.R_PA_Ben_Wu - Res.R_PA_MRW_EOI) ./ Res.R_PA_Ben_Wu;
t(isnan(t)) = [];
b = mean(t);
t = (Res.R_Rand_Ben_Wu - Res.R_Rand_MRW_EOI) ./ Res.R_Rand_Ben_Wu;
t(isnan(t)) = [];
b = b + mean(t);
b = b / 2;

load('result/change_V/Res.mat','Res');
t = (Res.R_PA_Ben_Wu - Res.R_PA_MRW_EOI) ./ Res.R_PA_Ben_Wu;
t(isnan(t)) = [];
c = mean(t);
t = (Res.R_Rand_Ben_Wu - Res.R_Rand_MRW_EOI) ./ Res.R_Rand_Ben_Wu;
t(isnan(t)) = [];
c = c + mean(t);
c = c / 2;

load('result/change_pr/Res.mat','Res');
t = (Res.R_PA_Ben_Wu - Res.R_PA_MRW_EOI) ./ Res.R_PA_Ben_Wu;
t(isnan(t)) = [];
d = mean(t);
t = (Res.R_Rand_Ben_Wu - Res.R_Rand_MRW_EOI) ./ Res.R_Rand_Ben_Wu;
t(isnan(t)) = [];
d = d + mean(t);
d = d / 2;

R_ME_WW = (a+b+c+d)/4*100;


(Sched_ME_WW + R_ME_WW)/2






























