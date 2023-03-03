%This script is used to generate FIGs. 11 and 12

hold all

plot(log10(ProbSuccAllSigGKP12Etad96(1,:)), ProbSuccAllSigGKP12Etad96(2,:), 'LineWidth', 7)
plot(log10(ProbSuccAllSigGKP16Etad99(1,:)), ProbSuccAllSigGKP16Etad99(2,:), 'LineWidth', 7)

% plot(log10(ProbSuccAllL05(1,:)), ProbSuccAllL05(2,:), 'LineWidth', 7)
% plot(log10(ProbSuccAllL10(1,:)), ProbSuccAllL10(2,:), 'LineWidth', 7)
% plot(log10(ProbSuccAllL20(1,:)), ProbSuccAllL20(2,:), 'LineWidth', 7)
% plot(log10(ProbSuccAllL25(1,:)), ProbSuccAllL25(2,:), 'LineWidth', 7)
% plot(log10(ProbSuccAllL50(1,:)), ProbSuccAllL50(2,:), 'LineWidth', 7)
ylim([0. 1])
xlim([4.2 5])
grid on
ax = gca;
ax.GridAlpha = 1;

%set(gca, 'XScale', 'log')
%set(gca, 'YScale', 'log')
supersizeme(+5)


%legend('$L=0.5$ km','$L=1$ km', '$L=2$ km', '$L=2.5$ km', '$L=5$ km', 'Interpreter', 'latex', 'location', 'northwest')
legend('$\sigma_{\textrm{GKP}} = 0.12$, $\eta_d = 0.96$, $L_{\textrm{tot}}= 850$ km','$\sigma_{\textrm{GKP}} = 0.16$, $\eta_d = 0.99$, $L_{\textrm{tot}}= 1500$ km', 'Interpreter', 'latex', 'location', 'northwest')

%Clear all the temporary variables from the workspace
clear ('i', 'Lfix', 'Lmax', 'Ltot', 'PLOB', 'v', 'vvalue', 'wvar', 'X', 'ax')

title('$p^{\textrm{res-gen}}_\textrm{succ}$ vs no of GKP qubits, $L= 0.5$ km','Interpreter','latex')

xlabel('$\log_{10}(\textrm{No of GKP qubits})$','Interpreter','latex')
ylabel('Probability $p^{\textrm{res-gen}}_\textrm{succ}$','Interpreter','latex')