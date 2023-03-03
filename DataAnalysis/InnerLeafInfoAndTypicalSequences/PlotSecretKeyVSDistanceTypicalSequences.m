%This script plots secret-key/entanglement rate per optical mode for FIG. 35.
%It plots the rate for all the variables in the workspace (make sure to
%have only rate arrays in the workspace).


%Define a structure with all the data (SecretKeyArrays) from the workspace
wvar = who;

Lmax = 2000;
Lfix = 1;

X = zeros(1, Lmax/Lfix);
for i = 1:Lmax/Lfix
    Ltot = i * Lfix;
    X(i) = Ltot;
end
Lfix2 = 50;
Y = zeros(1, Lmax/Lfix2);
for i = 1:Lmax/Lfix2
    Ltot = i * Lfix2;
    Y(i) = Ltot;
end

figure
hold all
%Plot PLOB bound
PLOB = -log2(1-vpa(exp(-X/22)));
plot(X,PLOB,'LineWidth', 7,'LineStyle',':')
%Plot all the rate arrays
for v = 1:numel(wvar)-1
   vvalue = eval(wvar{v});  
   plot(X(1:size(vvalue,2)), vvalue, 'LineWidth', 4,'LineStyle','--')
end
plot(Y(1:size(SecretKeyArray,2)), SecretKeyArray, 'LineWidth', 7)
ylim([0. 1])
grid on
ax = gca;
ax.GridAlpha = 1;   
set(gca, 'YScale', 'log')
supersizeme(+4.5)
legend('PLOB', '$z = 0$', '$z = 0.01$', '$z = 0.02$', '$z = 0.03$', '$z = 0.04$', 'All sequences', 'Interpreter','latex','location', 'northeast')
%Clear all the temporary variables from the workspace
clear ('i', 'Lfix', 'Lmax', 'Ltot', 'PLOB', 'v', 'vvalue', 'wvar', 'X', 'ax', 'Lfix2', 'Y')

title('Rate $R$ vs distance for different typical sets, $\sigma_{GKP}=0.12$, $\eta_d = 0.96$, $L=0.5$','Interpreter','latex')
xlabel('Distance $L_{tot}$ (km)', 'Interpreter','latex')
ylabel('Rate $R$', 'Interpreter','latex')