%This script plots secret-key/entanglement rate per optical mode.as a
%function of our analytically estimated error for FIGs. 21 nad 22

Lmax = 10000;
Lfix = 50;

X = zeros(1, Lmax/Lfix);
for i = 1:Lmax/Lfix
    Ltot = i * Lfix;
    X(i) = Ltot;
end

%Data with real rate for a given error rate
ProbErrorArray = 0:10^-3:0.5;
OldVariableReference = arrayfun(@(x,y) SecretKey6State(x,y), ProbErrorArray,ProbErrorArray);

%Our simulated rate vs distance
Variable1 = sigGKP13Etad97L05OnlyBest;
Variable2 = sigGKP13Etad99L05OnlyBest;
Variable3 = sigGKP13Etad97L10OnlyBest;
Variable4 = sigGKP13Etad99L10OnlyBest;
Variable5 = sigGKP13Etad99L20OnlyBest;
Variable6 = sigGKP14Etad98L05OnlyBest;
Variable7 = sigGKP14Etad98L10OnlyBest;


%Define the X-axis i.e. the modelled error rate obtained by applying our
%analytical rescaling function to the total distance
ResFactor = RescaleLtottoE(0.13, 0.97, 0.5, 2.45);
NewX1 = ResFactor*X(1:size(Variable1,2));
ResFactor = RescaleLtottoE(0.13, 0.99, 0.5, 2.45);
NewX2 = ResFactor*X(1:size(Variable2,2));
ResFactor = RescaleLtottoE(0.13, 0.97, 1, 2.45);
NewX3 = ResFactor*X(1:size(Variable3,2));
ResFactor = RescaleLtottoE(0.13, 0.99, 1, 2.45);
NewX4 = ResFactor*X(1:size(Variable4,2));
ResFactor = RescaleLtottoE(0.13, 0.99, 2, 2.45);
NewX5 = ResFactor*X(1:size(Variable5,2));
ResFactor = RescaleLtottoE(0.14, 0.98, 0.5, 2.45);
NewX6 = ResFactor*X(1:size(Variable6,2));
ResFactor = RescaleLtottoE(0.14, 0.98, 1, 2.45);
NewX7 = ResFactor*X(1:size(Variable7,2));

hold all

%If only best link considered for FIG. 21, multiply the rate Variables by
%k=20.
plot(ProbErrorArray, OldVariableReference, 'LineWidth',7, 'LineStyle', ':')
plot(NewX1, 20*Variable1, 'LineWidth',7)
plot(NewX2, 20*Variable2, 'LineWidth',7)
plot(NewX6, 20*Variable6, 'LineWidth',7)
plot(NewX3, 20*Variable3, 'LineWidth',7)
plot(NewX4, 20*Variable4, 'LineWidth',7)
plot(NewX7, 20*Variable7, 'LineWidth',7)
plot(NewX5, 20*Variable5, 'LineWidth',7)
xlim([10^(-4) 1])
ylim([0. 1])
grid on
ax = gca;
ax.GridAlpha = 1;
set(gca, 'XScale', 'log')
supersizeme(+4)

legend('Theoretical', '$\sigma_{GKP} = 0.13$, $\eta_d = 0.97$, $L=0.5$ km','$\sigma_{GKP} = 0.13$, $\eta_d = 0.99$, $L=0.5$ km','$\sigma_{GKP} = 0.14$, $\eta_d = 0.98$, $L=0.5$ km','$\sigma_{GKP} = 0.13$, $\eta_d = 0.97$, $L=1$ km','$\sigma_{GKP} = 0.13$, $\eta_d = 0.99$, $L=1$ km','$\sigma_{GKP} = 0.14$, $\eta_d = 0.98$, $L=1$ km','$\sigma_{GKP} = 0.13$, $\eta_d = 0.99$, $L=2$ km','Interpreter', 'latex','location', 'southwest')


title('Rate $R$ vs error rate $e$ with only the best out of $k=20$ links, rescaled by 20','Interpreter','latex')

xlabel('Error rate $e$','Interpreter','latex')
ylabel('Rate $R$','Interpreter','latex')