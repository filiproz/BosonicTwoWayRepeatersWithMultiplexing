%This script plots secret-key/entanglement rate per optical mode.
%It plots the rate for all the variables in the workspace (make sure to
%have only rate arrays in the workspace). The legend consists simply of the
%names of the arrays from the workspace.


%Define a structure with all the data (SecretKeyArrays) from the workspace
wvar = who;

Lmax = 10000;
Lfix = 50;
Lfix2 = 1;

X = zeros(1, Lmax/Lfix);
for i = 1:Lmax/Lfix
    Ltot = i * Lfix;
    X(i) = Ltot;
end

Y = zeros(1, Lmax/Lfix2);
for i = 1:Lmax/Lfix2
    Ltot = i * Lfix2;
    Y(i) = Ltot;
end
Y = Y(1,Lfix/Lfix2:end);

%Plot PLOB bound
PLOB = -log2(1-exp(-vpa(Y/22)));
figure
plot(Y,PLOB,'LineWidth', 7,'LineStyle',':','DisplayName', 'PLOB')
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
supersizeme(+4.5)
%legend('PLOB','$\sigma_{\textrm{GKP}} = 0.12$, $\eta_d = 0.96$, $L=0.5$ km','$\sigma_{\textrm{GKP}} = 0.12$, $\eta_d = 0.99$, $L=2.5$ km','$\sigma_{\textrm{GKP}} = 0.13$, $\eta_d = 0.97$, $L=0.5$ km','$\sigma_{\textrm{GKP}} = 0.13$, $\eta_d = 0.99$, $L=2.5$ km','$\sigma_{\textrm{GKP}} = 0.14$, $\eta_d = 0.99$, $L=1$ km','$\sigma_{\textrm{GKP}} = 0.15$, $\eta_d = 0.99$, $L=0.5$ km','$\sigma_{\textrm{GKP}} = 0.16$, $\eta_d = 0.99$, $L=0.5$ km', 'Interpreter', 'latex', 'location', 'northeast')
legend('PLOB','$L=0.5$ km','$L=1$ km', '$L=2$ km', '$L=2.5$ km', '$L=5$ km', 'Interpreter', 'latex', 'location', 'northeast')

%Clear all the temporary variables from the workspace
clear ('i', 'Lfix', 'Lfix2', 'Lmax', 'Ltot', 'PLOB', 'v', 'vvalue', 'wvar', 'X', 'Y', 'ax')

title('Rate $R$ vs distance, $\sigma_{\textrm{GKP}}=0.13$, $\eta_d = 0.99$ ','Interpreter','latex')
%title('Rate $R$ vs distance','Interpreter','latex')
xlabel('Distance $L_{\textrm{tot}}$ (km)','Interpreter','latex')
ylabel('Rate $R$','Interpreter','latex')