%This script plots secret-key/entanglement rate per optical mode.
%It plots the rate for all the variables in the workspace (make sure to
%have only rate arrays in the workspace). The legend consists simply of the
%names of the arrays from the workspace.


%Define a structure with all the data (SecretKeyArrays) from the workspace
wvar = who;

Lmax = 10000;
Lfix = 50;

X = zeros(1, Lmax/Lfix);
for i = 1:Lmax/Lfix
    Ltot = i * Lfix;
    X(i) = Ltot;
end

ResFactor = RescaleLtot(0.13, 0.97, 0.12, 0.96, 2)

hold all

plot(X(1:size(sigGKP12Etad96,2)), sigGKP12Etad96, 'LineWidth', 7,'DisplayName', string(wvar{v}))
plot(X(1:size(sigGKP13Etad97,2)), sigGKP13Etad97, 'LineWidth', 7,'DisplayName', string(wvar{v}))
plot(X(1:size(sigGKP13Etad97,2)), sigGKP13Etad97, 'LineWidth', 7,'DisplayName', string(wvar{v}))
ylim([0. 1])
grid on
ax = gca;
ax.GridAlpha = 1;
set(gca, 'XScale', 'log')
%set(gca, 'YScale', 'log')
supersizeme(+5)
%legend('$\sigma_{GKP} = 0.11$, $\eta_d = 0.97$, $L=1$ km','$\sigma_{GKP} = 0.11$, $\eta_d = 0.98$, $L=2.5$ km','$\sigma_{GKP} = 0.11$, $\eta_d = 0.99$, $L=2.5$ km','$\sigma_{GKP} = 0.12$, $\eta_d = 0.98$, $L=1$ km','$\sigma_{GKP} = 0.12$, $\eta_d = 0.99$, $L=2.5$ km','$\sigma_{GKP} = 0.13$, $\eta_d = 0.98$, $L=1$ km','$\sigma_{GKP} = 0.13$, $\eta_d = 0.99$, $L=2$ km','$\sigma_{GKP} = 0.14$, $\eta_d = 0.99$, $L=2$ km', 'Interpreter', 'latex', 'location', 'northeast')
%legend('PLOB','$\sigma_{GKP} = 0.12$, $\eta_d = 0.97$, $L=0.5$ km','$\sigma_{GKP} = 0.12$, $\eta_d = 0.98$, $L=1$ km','$\sigma_{GKP} = 0.12$, $\eta_d = 0.99$, $L=2.5$ km','$\sigma_{GKP} = 0.13$, $\eta_d = 0.98$, $L=0.5$ km','$\sigma_{GKP} = 0.13$, $\eta_d = 0.99$, $L=2.5$ km','$\sigma_{GKP} = 0.14$, $\eta_d = 0.98$, $L=0.5$ km','$\sigma_{GKP} = 0.14$, $\eta_d = 0.99$, $L=1$ km','$\sigma_{GKP} = 0.15$, $\eta_d = 0.99$, $L=0.5$ km', 'Interpreter', 'latex', 'location', 'northeast')
legend('$\sigma_{GKP} = 0.12$, $\eta_d = 0.96$', '$\sigma_{GKP} = 0.13$, $\eta_d = 0.97$, $L=0.5$ km','analytical', 'Interpreter', 'latex', 'location', 'northeast')
%legend('PLOB','$L=0.5$ km','$L=1$ km', '$L=2$ km', '$L=2.5$ km', '$L=5$ km', 'Interpreter', 'latex', 'location', 'northeast')
%Clear all the temporary variables from the workspace
clear ('i', 'Lfix', 'Lmax', 'Ltot', 'PLOB', 'v', 'vvalue', 'wvar', 'X', 'ax')

title('Rate $R$ vs distance, $\sigma_{GKP}=0.12$, $\eta_d = 0.98$ ','Interpreter','latex')
%title('Rate $R$ vs distance','Interpreter','latex')
xlabel('Distance $L_{tot}$ (km)','Interpreter','latex')
ylabel('Rate $R$','Interpreter','latex')