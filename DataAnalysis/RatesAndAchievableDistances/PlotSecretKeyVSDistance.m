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

%Plot PLOB bound
PLOB = -log2(1-exp(-vpa(X/22)));
figure
plot(X,PLOB,'LineWidth', 7,'LineStyle',':','DisplayName', 'PLOB')
hold all

%Plot all the rate arrays
for v = 1:numel(wvar)
   vvalue = eval(wvar{v});  
   plot(X(1:size(vvalue,2)), vvalue, 'LineWidth', 7,'DisplayName', string(wvar{v}))
end
ylim([0. 1])
grid on
ax = gca;
ax.GridAlpha = 1;
set(gca, 'XScale', 'log')
%set(gca, 'YScale', 'log')
supersizeme(+5)
%legend('PLOB','$\sigma_{GKP} = 0.11$, $\eta_d = 0.97$, $L=1$ km','$\sigma_{GKP} = 0.11$, $\eta_d = 0.98$, $L=2.5$ km','$\sigma_{GKP} = 0.11$, $\eta_d = 0.99$, $L=2.5$ km','$\sigma_{GKP} = 0.12$, $\eta_d = 0.98$, $L=1$ km','$\sigma_{GKP} = 0.12$, $\eta_d = 0.99$, $L=2.5$ km','$\sigma_{GKP} = 0.13$, $\eta_d = 0.98$, $L=1$ km','$\sigma_{GKP} = 0.13$, $\eta_d = 0.99$, $L=2$ km','$\sigma_{GKP} = 0.14$, $\eta_d = 0.99$, $L=2$ km', 'Interpreter', 'latex', 'location', 'northeast')
%legend('PLOB','$\sigma_{GKP} = 0.12$, $\eta_d = 0.97$, $L=0.5$ km','$\sigma_{GKP} = 0.12$, $\eta_d = 0.98$, $L=1$ km','$\sigma_{GKP} = 0.12$, $\eta_d = 0.99$, $L=2.5$ km','$\sigma_{GKP} = 0.13$, $\eta_d = 0.98$, $L=0.5$ km','$\sigma_{GKP} = 0.13$, $\eta_d = 0.99$, $L=2.5$ km','$\sigma_{GKP} = 0.14$, $\eta_d = 0.98$, $L=0.5$ km','$\sigma_{GKP} = 0.14$, $\eta_d = 0.99$, $L=1$ km','$\sigma_{GKP} = 0.15$, $\eta_d = 0.99$, $L=0.5$ km', 'Interpreter', 'latex', 'location', 'northeast')
%legend('PLOB','$\sigma_{GKP} = 0.12$, $\eta_d = 0.96$, $L=0.5$ km','$\sigma_{GKP} = 0.12$, $\eta_d = 0.99$, $L=2.5$ km','$\sigma_{GKP} = 0.13$, $\eta_d = 0.97$, $L=0.5$ km','$\sigma_{GKP} = 0.13$, $\eta_d = 0.99$, $L=2.5$ km','$\sigma_{GKP} = 0.14$, $\eta_d = 0.99$, $L=1$ km','$\sigma_{GKP} = 0.15$, $\eta_d = 0.99$, $L=0.5$ km','$\sigma_{GKP} = 0.16$, $\eta_d = 0.99$, $L=0.5$ km', 'Interpreter', 'latex', 'location', 'northeast')
legend('PLOB','$L=0.5$ km','$L=1$ km', '$L=2$ km', '$L=2.5$ km', '$L=5$ km', 'Interpreter', 'latex', 'location', 'northeast')
%Clear all the temporary variables from the workspace
clear ('i', 'Lfix', 'Lmax', 'Ltot', 'PLOB', 'v', 'vvalue', 'wvar', 'X', 'ax')

title('Rate $R$ vs distance, $\sigma_{GKP}=0.12$, $\eta_d = 0.98$ ','Interpreter','latex')
%title('Rate $R$ vs distance','Interpreter','latex')
xlabel('Distance $L_{tot}$ (km)','Interpreter','latex')
ylabel('Rate $R$','Interpreter','latex')