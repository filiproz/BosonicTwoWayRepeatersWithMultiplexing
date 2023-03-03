%This script plots the optimised secret-key/entanglement rate per optical
%mode for FIG. 16

Lmax = 10000;
Lfix = 50;

X = zeros(1, Lmax/Lfix);
for i = 1:Lmax/Lfix
    Ltot = i * Lfix;
    X(i) = Ltot;
end


plot(X, OptimalSecretKeyArraySigGKP13Etad98, 'LineWidth', 7)
hold all
plot(X, OptimalSecretKeyArraySigGKP12Etad98, 'LineWidth', 7)
plot(X, OptimalSecretKeyArraySigGKP13Etad99, 'LineWidth', 7)
grid on
ax = gca;
ax.GridAlpha = 1;
set(gca, 'XScale', 'log')

supersizeme(+5.5)

legend('$\sigma_{GKP} = 0.13, \eta_d = 0.98$','$\sigma_{GKP} = 0.12, \eta_d = 0.98$','$\sigma_{GKP} = 0.13, \eta_d = 0.99$', 'Interpreter', 'latex', 'location', 'northeast')


title('Optimal rate $R$ vs distance','Interpreter','latex')

xlabel('Distance $L_{tot}$ (km)','Interpreter','latex')
ylabel('Rate $R$','Interpreter','latex')