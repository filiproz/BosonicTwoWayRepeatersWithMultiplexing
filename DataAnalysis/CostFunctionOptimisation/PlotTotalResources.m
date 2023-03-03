%This script plots optimal total resources for FIG. 14


Lmax = 10000;
Lfix = 50;

X = zeros(1, Lmax/Lfix);
for i = 1:Lmax/Lfix
    Ltot = i * Lfix;
    X(i) = Ltot;
end


plot(X, OptimalTotalResourcesSigGKP13Etad98, 'LineWidth', 7)
hold all
plot(X, OptimalTotalResourcesSigGKP12Etad98, 'LineWidth', 7)
plot(X, OptimalTotalResourcesSigGKP13Etad99, 'LineWidth', 7)
grid on
ax = gca;
ax.GridAlpha = 1;
set(gca, 'XScale', 'log')
set(gca, 'YScale', 'log')
supersizeme(+5.5)

legend('$\sigma_{GKP} = 0.13, \eta_d = 0.98$','$\sigma_{GKP} = 0.12, \eta_d = 0.98$','$\sigma_{GKP} = 0.13, \eta_d = 0.99$', 'Interpreter', 'latex', 'location', 'northwest')


title('Total resources vs distance','Interpreter','latex')

xlabel('Distance $L_{tot}$ (km)','Interpreter','latex')
ylabel('Total resources','Interpreter','latex')