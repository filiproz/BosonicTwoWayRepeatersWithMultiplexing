%This script plots secret-key/entanglement rate per optical mode for
%comparison of the case with and without the inner leaf info in FIG. 6.
%It plots the rate for all the variables in the workspace (make sure to
%have only rate arrays in the workspace). The legend consists simply of the
%names of the arrays from the workspace.


%Define a structure with all the data (SecretKeyArrays) from the workspace
%wvar = who;

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
plot(X,PLOB,'LineWidth', 7,'LineStyle','--','DisplayName', 'PLOB')
hold all
%Plot the achievabel rates
plot(X(1:size(SecretKeyArray,2)), SecretKeyArray, 'LineWidth', 7)
plot(X(1:size(SecretKeyArrayNoInnerLeafInfo,2)), SecretKeyArrayNoInnerLeafInfo, 'LineWidth', 7)

ylim([0. 1])
grid on
ax = gca;
ax.GridAlpha = 1;

set(gca, 'YScale', 'log')
supersizeme(+4.5)
legend('PLOB', 'With inner leaf info', 'Without inner leaf info','location', 'northeast')
%Clear all the temporary variables from the workspace
clear ('i', 'Lfix', 'Lmax', 'Ltot', 'PLOB', 'v', 'vvalue', 'wvar', 'X', 'ax')

title('Rate R vs distance, $\sigma_{\textrm{GKP}}=0.14$, $\eta_d = 0.98$, $L = 0.5$ km','Interpreter','latex')

xlabel('Distance $L_{\textrm{tot}}$ (km)', 'Interpreter','latex')
ylabel('Rate $R$', 'Interpreter','latex')
