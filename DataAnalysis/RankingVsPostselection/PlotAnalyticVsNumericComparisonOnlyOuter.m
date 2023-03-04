%This script plots a comparison of the numerical simulated data of rate vs
%multiplexed links with the analytical estimation of performacne when using
%only postselection on the outer leaves optimised over the post-selection
%window for FIG. 5. We consider only the outer leaves with the only source of noise
%being the communication channel, i.e. perfect squeezing, perfect homodyne
%and perfect storage of inner leaves.

%Specify the parameters for the plot.
kRange = 20;
Ltot = 2000;
L = 5;
rel_err_thr = 0.05;
s_Total_rel_err_thr = 0;

% We consider only outer leaves:
leaves = 0;
sTotal = [0,0];

%Define Data for error bars
DataBetter = (1 - rel_err_thr) * Data;
DataWorse = (1 + rel_err_thr) * Data;
sTotalBetter = (1 - s_Total_rel_err_thr) * sTotal;
sTotalWorse = (1 + s_Total_rel_err_thr) * sTotal;


%Calculate the rate for the simulated data for our strategy with ranking
SecretKey = SecretKeyVsMultiplexing(Data, L, Ltot, leaves, sTotal, kRange);
SecretKeyUpper = SecretKeyVsMultiplexing(DataBetter, L, Ltot, leaves, sTotalBetter, kRange);
SecretKeyLower = SecretKeyVsMultiplexing(DataWorse, L, Ltot, leaves, sTotalWorse, kRange);

%Calculate the error bars:
ypos = SecretKeyUpper - SecretKey;
yneg = SecretKey - SecretKeyLower;

%Calculate analytically the rate for the post-selection strategy optimised
%over the postselection window

k = 1:kRange;
SecKeyOptimised = zeros(kRange,1);
for i = k
   i
   SecKeyOptimised(i,1) = AnalyticSecretKeyPostselectionStrategyOptimised(L, i, Ltot);
end



figure
errorbar(k,SecretKey,yneg,ypos,'CapSize',18, 'LineWidth',7)
hold on
plot(k,SecKeyOptimised,'LineWidth', 7)
grid on
ax = gca;
ax.GridAlpha = 1;
supersizeme(+5.5)
title("Rate $R$ vs multiplexing $k$, outer leaves, $L_{tot}=$" + rats(Ltot)+ " km, $L=$" + rats(L) + " km",'Interpreter','latex')
xlabel('No of multiplexed links $k$','Interpreter','latex')
ylabel('Rate $R$','Interpreter','latex')
set(gcf, 'Position', get(0, 'Screensize'));
legend("Ranking strategy", "Postselecton strategy", "Location", "southeast")