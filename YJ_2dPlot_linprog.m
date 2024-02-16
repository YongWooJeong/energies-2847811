clear all
close all
clc

Pos = [36.2000 248.2000 886.4000 361.6000];
Pos2 = [25 136.3333 756.6667 516.6667]
Cevcs  = 324*0.001  

load('YJ_230309.mat')   
load('YJ_230321.mat')    

idx_pv =21; idx_year= 16;
 
%%
N_xlog = size(log.x)


year_tmp = log.year_tmp
factor_pv_tmp = log.factor_pv_tmp 
Time=[0:23]; Cg_total = log.Cg_total;
SOC_max = log.SOC_max; SOC_min = log.SOC_min;
 


for i =1:N_xlog(2)
for j =1:N_xlog(3)
sum_Eg2cv(i,j) = sum(log.x([1:end-2],i,j));
% 

 
 
%  
%
%
SOC_min__(i,j) = min(log.SOC(:,i,j));
SOC_max__(i,j) = max(log.SOC(:,i,j));
if log.E_cap(i,j) < 0.1
SOC_min__(i,j) =0.2;
SOC_max__(i,j) = 0.8;
end
    

E_sell_C0(i,j) = sum(log.PV_ref(:,i,j));
E_sell_C4(i,j) = log.x(end-1,i,j);
end
end

Cost_C4  =  log.Cost1; 
Cost_EYJ   =  log.Cost2; 
Cost_EYJ_max  = max(max(Cost_EYJ));

% Revenue_C0 =  -log_C0.Cost1       - log_C0.Rev_Esell + Cevcs.*sum(log.EV_ref(:,i,j));
% Revenue_C4 = -Cost_C4 -Cost_EYJ_max - log.Rev_Esell+ Cevcs.*sum(log.EV_ref(:,i,j));

Revenue_C0 =  -log_C0.Cost1       - log_C0.Rev_Esell + Cevcs.*sum(log.EV_ref(:,i,j));
Revenue_C4 = -log.Cost1 - log.Cost2 - log.Rev_Esell+ Cevcs.*sum(log.EV_ref(:,i,j));

 

[plt_x,plt_y] = meshgrid(year_tmp,factor_pv_tmp) ;


val_min = min( min(Revenue_C0(:)), min(Revenue_C4(:)) )
val_max = max( max(Revenue_C0(:)), max(Revenue_C4(:)) )
 
% load('data_230321_YJ_LowSun.mat')

 


% Time
tb_pv_ref = log.PV_ref(:,idx_pv,idx_year);
tb_ev_ref = log.EV_ref(:,idx_pv,idx_year);
% Cg_total
SOC_ = log.SOC(:,idx_pv,idx_year);
E_cap = log.E_cap(idx_pv,idx_year); 
if (E_cap <= 0)
    E_cap = 100;
end

E_g2EV=log.x([1:end-2],idx_pv,idx_year);
[val idx_hour_sell]= max(tb_SMP_ref); %time index for selling
E_sell = zeros(size(E_g2EV));
E_sell(idx_hour_sell) = log.E_sell(1,idx_pv,idx_year);
SOC_max_ = SOC_max__(idx_pv,idx_year);
SOC_min_ = SOC_min__(idx_pv,idx_year);
% idx_hour_sell
% Time_sell

 

PV_cap__=factor_pv_tmp(idx_pv) 
Year__=year_tmp(idx_year) 

%%

% 


f1 = figure 
ff=3;
subplot(2,1,1)    
plot(Time,ones(size(Cg_total))*Cevcs*1000,'-*'); hold on; grid on;
plot(Time,Cg_total*1000,'b-x'); hold on; grid on;
plot(Time,tb_SMP_ref*1000,'r-o'); hold on; grid on;
plot(Time(idx_sell),tb_SMP_ref(idx_sell)*1000,'*','LineWidth',2); hold on; grid on;
ylabel('(KRW/kWh)','FontSize',13,'Interpreter','Latex')
legend('$c_{cs}$ ',...
    '$c_{g,k}$ ',...    
    '$c_{s,k}$ ',...
    '$c_{s,i},~i\in p_{[1:n]}$ ',...
    'Interpreter','Latex','FontSize',14)
xlim([Time(1) Time(end)])
xlabel('$k$ (hour)','Interpreter','Latex','FontSize',13)
set(gca,'XTick',[0:2:24])
 ylim([50 350])
set(gca,'YTick',[50:50:350]) 




subplot(2,1,2) 
% yyaxis left 
plot(Time,tb_ev_ref,'b-x','LineWidth',1.5,'Color',[0.00,0.45,0.74]);hold on; grid on;
xlim([Time(1) Time(end)])
xlabel('$k$ (hour)','Interpreter','Latex','FontSize',13)
ylabel('(kWh)','Interpreter','Latex','FontSize',13)
set(gca,'YTick',[0:PV_cap__/5:PV_cap__] *ff) 
set(gca,'ylim',[0 PV_cap__] *ff) 
tmp_ylim = get(gca,'ylim')

% yyaxis right
plot(Time,tb_pv_ref,'r-.x','LineWidth',1.5,'Color',[0.85,0.33,0.10]);hold on; grid on;
% plot(Time,tb_pv_ref/(PV_cap__)*100,'r-.x','LineWidth',1.5,'Color',[0.85,0.33,0.10]);hold on; grid on;
%ylabel('Intensity of sunlight (%)','Interpreter','Latex','FontSize',13)

legend( ' $E_{cs,k}^e$','$E_{pv,k}^e$',...
    'Interpreter','Latex','FontSize',14)
set(gca,'XTick',[0:2:24]) 
% set(gca,'ylim',tmp_ylim/max(tmp_ylim) *100*ff) 
% set(gca,'YTick',[0:PV_cap__/2:PV_cap__]/PV_cap__  *100) 
 
 
 
plt_Esell = zeros(size(log.E_g2EV(:,idx_pv,idx_year)));
plt_Esell(log.idx_hour_sell) = log.E_sell(:,idx_pv,idx_year);





f13 = figure
subplot(2,1,1)
yyaxis left
 plot(Time, ones(size(Time))*E_cap,'-.','LineWidth',3); hold on; grid on;
plot(Time, SOC_*E_cap,'r-x'); hold on; grid on;
plot(Time, ones(size(Time))*SOC_max*E_cap,'k--'); hold on; grid on;
plot(Time, ones(size(Time))*SOC_min*E_cap,'k--'); hold on; grid on;
xlim([Time(1) Time(end)])
xlabel('$k$ (hour)','Interpreter','Latex','FontSize',13)
ylabel('$E_{cap}^*$~(kWh)','FontSize',13,'Interpreter','Latex')
ylim([0 E_cap*1.4])
 
set(gca,'YTick',[-20:20:120])


set(gca,'YTick',round([0:E_cap/5:E_cap]))
set(gca,'XTick',[0:2:24])
% 
yyaxis right
% % plot(Time, SOC_*100,'-x'); hold on; grid on;
% % plot(Time, SOC_2*100,'-x'); hold on; grid on;
xlim([Time(1) Time(end)])
xlabel('$k$ (hour)','Interpreter','Latex','FontSize',13)
% ylabel('SoC (%)','FontSize',13,'Interpreter','Latex')
ylabel('$SoC_k~(\%)$','Interpreter','Latex','FontSize',13)
% legend( 'SoC')
legend( '$E_{cap}^*$','$SOC_k$',...
    '$SOC_{\max}$, $SOC_{\min}$',...
    'Interpreter','Latex','FontSize',14)
ylim([0 140])
set(gca,'YTick',[0:20:100])

 


subplot(2,1,2)   
plot(Time,tb_ev_ref,'LineWidth',2);hold on; grid on;
plot(Time,tb_pv_ref,'-.','LineWidth',2);hold on; grid on;

plot(Time,log.E_g2EV(:,idx_pv,idx_year),'-.x','LineWidth',1);hold on; grid on;
plot(Time, plt_Esell,'-.o' ,'LineWidth',1);hold on; grid on;

xlim([Time(1) Time(end)])
set(gca,'XTick',[0:2:24])
xlabel('$k$ (hour)','Interpreter','Latex','FontSize',13)
ylabel('(kWh) ','Interpreter','Latex','FontSize',13) 
% ylabel('$E_{cs,k}^e$, $E_{pv,k}^e$, $E_{g2cs,k}^*$, $E_{s,k}^*$ (kWh)','Interpreter','Latex','FontSize',13) 
legend('$E_{cs,k}^e$','$E_{pv,k}^e$', ...
    ' $E_{g2cs,k}^*$','$E_{s,k}^*$',...
    'Interpreter','Latex','FontSize',14)
ylim([0 350])
%  yyaxis left

  
%%

% 
% saveas(f1,'fig1_230321_YJ.epsc')
% saveas(f1,'fig1_230321_YJ.fig')
% 
% saveas(f13,'fig2_230321_YJ.epsc')
% saveas(f13,'fig2_230321_YJ.fig')