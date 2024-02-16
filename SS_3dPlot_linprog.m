clear all
close all
clc
% Pos = [36.2000 248.2000 886.4000 361.6000];
 Pos2 = [25 136.3333 756.6667 516.6667]
Pos2 = [138.3333 212.2000 678.6667 414.4000]
Pos = Pos2;
  Cevcs  = 324*0.001   
  
    
 ang_y=-19;
 ang_x=13.5;  
load('SS_230309.mat')
load('SS_230321.mat')  
c_pv_ =max(log.tb_SMP_ref(:));
%%
N_xlog = size(log.x)
year_tmp=log.year_tmp;
factor_pv_tmp=log.factor_pv_tmp;

for i =1:N_xlog(2)
    for j =1:N_xlog(3)
    sum_Eg2cv_C2(i,j) = sum(log.x([1:N_Cg],i,j));
    sum_Eg2cv_C1(i,j) = sum(log.EV_ref(:,i,j));
    % 
    %
    SOC_min_(i,j) = min(log.SOC(:,i,j));
    SOC_max_(i,j) = max(log.SOC(:,i,j));
%%% When E_cap is below than 0.01kWh, set SOC_min/max as its setting value.
        if log.E_cap(i,j) < 0.01
            SOC_min_(i,j) =log.SOC_min;
            SOC_max_(i,j) = log.SOC_max;
        end

    E_sell_C0(i,j) = sum(log.PV_ref(:,i,j));
    E_sell_C4_sum(i,j) = sum(log.E_sell(:,i,j));
%     E_sell_C4_2(i,j) = log.E_sell(2,i,j);
    Cost_PV_install(i,j) = factor_pv_tmp(i)*(5966/3)/(365*year_tmp(j));
    
 Rev_Esell_test(i,j)  = 0.5*log.PV_ref(:,i,j)'*log.tb_SMP_ref(:,i,j);
 
 E_PV_sum(i,j) = sum(log.PV_ref(:,i,j));
 E_g2cs_night(i,j) = sum(log.x([1:N_end_cheap],i,j));
    end
end
Revenue_C0 =  -log_C0.Cost1         + log_C0.Rev_Esell + Cevcs.*sum(log.EV_ref(:,i,j));
Revenue_C4 = -log.Cost1 - log.Cost2 + log.Rev_Esell    + Cevcs.*sum(log.EV_ref(:,i,j));

Revenue_C0_test =  Revenue_C0 - Cost_PV_install;
Revenue_C4_test =Revenue_C4 - Cost_PV_install;
[plt_x,plt_y] = meshgrid(year_tmp,factor_pv_tmp) ;
 
 %% 
FS = 14;
f11 = figure
surf(plt_x,plt_y, E_sell_C4_sum ); hold on; grid on;
% mesh(plt_x,plt_y,E_PV_sum+ E_g2cs_night);
% surf(plt_x,plt_y, E_sell_C4_2); hold on; grid on;
% mesh(plt_x,plt_y, E_sell_C0);

xlabel('Useful life of ESS (year)', 'Interpreter','Latex','FontSize',FS);
ylabel('Peak Power of PV (kWp)', 'Interpreter','Latex','FontSize',FS);
zlabel('$\sum_{k=0}^{23}E_{s,p_i}^*$ (kWh)', 'Interpreter','Latex','FontSize',FS+3);
set(get(gca,'ylabel'),'rotation',ang_y);
set(get(gca,'xlabel'),'rotation',ang_x);
 colormap jet
colorbar
set(gcf,'Position',Pos)
caxis([0 2500]); zlim([0 2500]);  
view([-38.8985 24.4515]);
ylim([0 35])
% xlim([10 20])
  
f12 = figure 
surf(plt_x,plt_y,log.E_cap);grid on; hold on;

xlabel('Useful life of ESS (year)', 'Interpreter','Latex','FontSize',FS);
ylabel('Peak Power of PV (kWp)', 'Interpreter','Latex','FontSize',FS);
zlabel('$E_{cap}^*$ (kWh)', 'Interpreter','Latex','FontSize',FS+3); 
set(get(gca,'ylabel'),'rotation',ang_y);
set(get(gca,'xlabel'),'rotation',ang_x);
% zlabel('ESS Cap(kWh)');
 colormap jet
colorbar
set(gcf,'Position',Pos)
caxis([0 3000]); zlim([0 3000]); 
view([-38.8985 24.4515]);

ylim([0 35])
% xlim([10 20])
 
 
%  
f13 = figure
mesh(plt_x,plt_y, SOC_min_*100);hold on;
surf(plt_x,plt_y, SOC_max_*100,'FaceAlpha', 0.5); 

xlabel('Useful life of ESS (year)', 'Interpreter','Latex','FontSize',FS);
ylabel('Peak Power of PV (kWp)', 'Interpreter','Latex','FontSize',FS);
zlabel('$\overline{SOC_{k}} $, $\underline{SOC_{k}} $ (\%)', 'Interpreter','Latex','FontSize',FS+3); 
% zlabel('$\max (SOC_{k}) $, $\min(SOC_{k})$ (\%)', 'Interpreter','Latex','FontSize',FS); 
set(get(gca,'ylabel'),'rotation',ang_y);
set(get(gca,'xlabel'),'rotation',ang_x);

colormap jet; colorbar;
caxis([0 100]); zlim([0 100]); 
set(gcf,'Position',Pos)
view([-38.8985 24.4515]);  
 
ylim([0 35])
% xlim([10 20])
 
% FS = 12; 
 
% f15 = figure
% % mesh(plt_x,plt_y, sum_Eg2cv_C1,'FaceAlpha', 0.2);  hold on; grid on;
% surf(plt_x,plt_y, sum_Eg2cv_C2,'FaceAlpha', 0.8);
%  
% ylim([0 35])
% % xlim([10 25])
% 
% xlabel('Useful life of ESS (year)', 'Interpreter','Latex','FontSize',FS);
% ylabel('Peak Power of PV (kWp)', 'Interpreter','Latex','FontSize',FS);
% zlabel('$\sum_{k=0}^{23}E_{g2cs,k}^*$ (kWh)', 'Interpreter','Latex','FontSize',FS+3)
% set(get(gca,'ylabel'),'rotation',ang_y);
% set(get(gca,'xlabel'),'rotation',ang_x);
% 
% 
%  colormap jet; colorbar; 
% % caxis([60 150]*1000); zlim([60 150]*1000); 
% view([-38.8985 24.4515]);
% 
% set(gcf,'Position',Pos) 
 

f14 = figure
mesh(plt_x,plt_y, Revenue_C4*1000,'FaceAlpha', 0.4,'LineWidth',1.4);  hold on; grid on;
surf(plt_x,plt_y, Revenue_C0*1000,'FaceAlpha', 1);
% surf(plt_x,plt_y, Revenue_C4_test*1000,'FaceAlpha', 0.5); hold on; grid on;
% mesh(plt_x,plt_y, Revenue_C0_test*1000,'FaceAlpha', 0.2);  
zlabel('Expected Daily Profit (KRW)');

ylim([0 35])
% xlim([10 20])
xlabel('Useful life of ESS (year)', 'Interpreter','Latex','FontSize',FS);
ylabel('Peak Power of PV (kWp)', 'Interpreter','Latex','FontSize',FS);
zlabel('$P_{prop}$, $P_{conv}$ (KRW)', 'Interpreter','Latex','FontSize',FS+3)
set(get(gca,'ylabel'),'rotation',ang_y);
set(get(gca,'xlabel'),'rotation',ang_x);


 colormap jet; colorbar;  
view([-38.8985 24.4515]);
% caxis([40 150]*1000); zlim([40 150]*1000);   
caxis([0.5 3.5]*100000); zlim([0.5 3.5]*100000);   

set(gcf,'Position',Pos2) 
%  



f141 = figure
% mesh(plt_x,plt_y, (Revenue_C4-Revenue_C0)*1000,'FaceAlpha', 1,'LineWidth',1);  hold on; grid on;

surf(plt_x,plt_y, (Revenue_C4-Revenue_C0)*1000,'FaceAlpha', 1);  hold on; grid on;
% mesh(plt_x,plt_y, Revenue_C0*1000,'FaceAlpha', 0.2); 
zlabel('Expected Daily Profit (KRW)');

ylim([0 35])
% xlim([10 20])
xlabel('Useful life of ESS (year)', 'Interpreter','Latex','FontSize',FS);
ylabel('Peak Power of PV (kWp)', 'Interpreter','Latex','FontSize',FS);
zlabel('$P_{prop}-P_{conv}$ (KRW)', 'Interpreter','Latex','FontSize',FS+3)
set(get(gca,'ylabel'),'rotation',ang_y);
set(get(gca,'xlabel'),'rotation',ang_x);
 
 colormap jet; colorbar;  
% view( [-62.2625 10.8749]) 
view([-38.8985 24.4515]);
 zlim([-5 15]*10^4);caxis([-5 15]*10^4);
% zlim([6 11]*10000)
% caxis([6 11]*10000); zlim([6 11]*10000);   
% set(gcf,'Position',[10 10 692.6667 473]) 
set(gcf,'Position',Pos2) 


%% %%
% %  
%    saveas(f13,'figSOC_230321_SS.fig')
% saveas(f13,'figSOC_230321_SS.epsc')
% 
%    saveas(f12,'figEcap_230321_SS.fig')
% saveas(f12,'figEcap_230321_SS.epsc')
% 
%    saveas(f11,'figEsell_230321_SS.fig')
% saveas(f11,'figEsell_230321_SS.epsc')
% 
% %    saveas(f15,'figEg2cs_230321_SS.fig')
% % saveas(f15,'figEg2cs_230321_SS.epsc')
% % 
%    saveas(f14,'figProfit_230321_SS.fig')
% saveas(f14,'figProfit_230321_SS.epsc')
% 
%    saveas(f141,'figP_comp_230321_SS.fig')
% saveas(f141,'figP_comp_230321_SS.epsc')
% % % 


% %  
% % saveas(gcf,'figSOC_230321_SS.epsc') 
% % saveas(gcf,'figEcap_230321_SS.epsc') 
% % saveas(gcf,'figEsell_230321_SS.epsc') 
% % saveas(gcf,'figEg2cs_230321.epsc') 
% % saveas(gcf,'figProfit_230321_SS.epsc') 
% % saveas(gcf,'figP_comp_230321_SS.epsc')
% % 
