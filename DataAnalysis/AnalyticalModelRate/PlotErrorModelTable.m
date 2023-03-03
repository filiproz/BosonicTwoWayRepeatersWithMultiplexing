%This script generates the bar plot for FIG. 20 of the inner leaf error probability for
%our analytical model and simulation data for different parameter
%configurations.


DataNumbers = 1:20;


hold all
Data = [AvErrorPerRepeaterDataArray(1:16)', AvErrorPerRepeaterModelArray(1:16)']

bar(Data)

grid on
ax = gca;
ax.GridAlpha = 1;
ylim([10^-7 0.05])
set(gca, 'YScale', 'log')
supersizeme(+5)

legend('simulation', 'analytical model','location', 'northwest')

title('Average inner leaf error rate per repeater','Interpreter','latex')
xlabel('Parameter configuration','Interpreter','latex')
ylabel('Error rate','Interpreter','latex')