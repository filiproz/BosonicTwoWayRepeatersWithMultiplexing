%This script plots the probability of being outside of the typical set of sequences
%generated by the inner leaf information for different typical sets parameterised by z for FIG. 34.
%Specifically it is the probability that at least one of the $Z$ and $X$ syndrome bit strings is
%atypical.
%It plots the probability as a function of distance for all the variables in the workspace (make sure to
%have only probability arrays in the workspace).


%Define a structure with all the data (Probabilities of being out of
%typical set) from the workspace.
wvar = who;

Lmax = 10000;
Lfix = 1;

X = zeros(1, Lmax/Lfix);
for i = 1:Lmax/Lfix
    Ltot = i * Lfix;
    X(i) = Ltot;
end

         

figure
hold all
set(gca,'ColorOrderIndex',2)
%Plot all the rate arrays
for v = 1:numel(wvar)
    vvalue = eval(wvar{v});  
    plot(X(1:size(vvalue,2)), vvalue, 'LineWidth', 4,'LineStyle','--')
end
ylim([10^(-14), 1])
grid on
ax = gca;
ax.GridAlpha = 1;
set(gca, 'YScale', 'log')
supersizeme(+4.5)

legend('$z = 0$', '$z = 0.01$', '$z = 0.02$', '$z = 0.03$', '$z = 0.04$', 'Interpreter','latex','location', 'northeast')
%Clear all the temporary variables from the workspace
clear ('i', 'Lfix', 'Lmax', 'Ltot', 'v', 'vvalue', 'wvar', 'X', 'ax')

title('Probability outside typical set vs distance, $\sigma_{\textrm{GKP}}=0.12$, $\eta_d = 0.96$, $L=0.5$ ','Interpreter','latex')
xlabel('Distance $L_{\textrm{tot}}$ (km)','Interpreter','latex')
ylabel('Probability','Interpreter','latex')