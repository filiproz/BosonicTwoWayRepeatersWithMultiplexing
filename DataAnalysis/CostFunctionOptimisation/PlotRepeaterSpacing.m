%This script plots optimal repeater spacing for FIG. 13


Lmax = 10000;
Lfix = 50;

X = zeros(1, Lmax/Lfix);
for i = 1:Lmax/Lfix
    Ltot = i * Lfix;
    X(i) = Ltot;
end


plot(X, OptimalRepSepSigGKP13Etad98, 'LineWidth', 7)
hold all
plot(X, OptimalRepSepSigGKP12Etad98, 'LineWidth', 7)
plot(X, OptimalRepSepSigGKP13Etad99, 'LineWidth', 7)
grid on
ax = gca;
ax.GridAlpha = 1;
set(gca, 'XScale', 'log')

supersizeme(+5.5)

legend('$\sigma_{\textrm{GKP}} = 0.13, \eta_d = 0.98$','$\sigma_{\textrm{GKP}} = 0.12, \eta_d = 0.98$','$\sigma_{\textrm{GKP}} = 0.13, \eta_d = 0.99$', 'Interpreter', 'latex', 'location', 'southwest')

title('Optimal repeater spacing $L$ vs distance','Interpreter','latex')

xlabel('Distance $L_{\textrm{tot}}$ (km)','Interpreter','latex')
ylabel('Repeater spacing $L$','Interpreter','latex')