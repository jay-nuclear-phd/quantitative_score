% This script plots the sensitivity per unit lethargy for three different cases.

%% Plot sensitivity per unit lethargy for three cases
E = load('scale_252group_boundaries');

Y1 = load('HMF-015-001');
Y2 = load('HMF-016-001');
Y3 = load('HST-001-001');


%% Plotting
% Use stairs to create a stairstep plot.
figure('Color','w','Position',[100 100 1000 700]); % Increased figure size
hold on; box on;

stairs(E(1:end-1), Y1, 'b', 'LineWidth',1.8, ...
    'DisplayName','HMF-015 Case 1 U-235 Fission');
stairs(E(1:end-1), Y2, 'r', 'LineWidth',1.8, ...
    'DisplayName','HMF-016 Case 1 U-235 Fission');
stairs(E(1:end-1), Y3, 'Color',[0.929,0.694,0.125], 'LineWidth',1.8, ...
    'DisplayName','HST-001 Case 1 U-235 Fission');

set(gca,'XScale','log');
xlim([1e-4 1e8]); ylim([0 0.06]);
grid on;

% Set all fonts to Times New Roman
set(gca,'FontName','Times New Roman','FontSize',16);
xlabel('Energy (eV)','FontName','Times New Roman','FontSize',18);
ylabel('Sensitivity per unit Lethargy','FontName','Times New Roman','FontSize',18);
legend('Location','northwest','FontName','Times New Roman','FontSize',14,'Box','on');

% Save the figure as a high-resolution PNG file.
print(gcf, 'Figures/Figure3.png', '-dpng', '-r300');