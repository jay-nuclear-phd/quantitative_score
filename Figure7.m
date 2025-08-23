% This script provides an example of heteroscedastic data and compares
% Ordinary Least Squares (OLS) and Weighted Least Squares (WLS) fits.

%% Heteroscedastic example: OLS vs WLS
clear; clc; close all

% --- Data (x, y) and measurement std (sigma) -----------------------------
x     = [-2  -1   0   1   2]';
y     = [ 4  -1   0   1  -4]';
sigma = [10  .1  .1  .1  10]';   % standard deviations at each point

% --- Ordinary Least Squares (y = a + b x) -------------------------------
X     = [ones(size(x)) x];
beta_ols = (X.'*X) \ (X.'*y);     % [a; b]

% --- Weighted Least Squares (weights = 1/sigma^2) -----------------------
w     = 1./(sigma.^2);            % larger sigma -> smaller weight
W     = diag(w);
beta_wls = (X.'*W*X) \ (X.'*W*y); % [a; b]

% --- Lines for plotting --------------------------------------------------
xf   = linspace(-2.5, 2.5, 400);
y_ols = beta_ols(1) + beta_ols(2)*xf;
y_wls = beta_wls(1) + beta_wls(2)*xf;

% --- Plot ---------------------------------------------------------------
figure('Color','w','Position',[100 100 800 700]);
hold on; grid on; box on;
set(gca,'FontSize',12)

% Colors from MATLAB default palette (orange & yellow)
c_orange = [0.8500 0.3250 0.0980];
c_yellow = [0.9290 0.6940 0.1250];

% Data points
plot(x, y, 'b*', 'LineWidth', 1.2, 'MarkerSize', 8)

% Regression lines
plot(xf, y_ols, 'Color', c_orange, 'LineWidth', 2.2)   % OLS
plot(xf, y_wls, 'Color', c_yellow, 'LineWidth', 2.2)   % WLS

hPoints = plot(x, y, 'b*', 'LineWidth', 1.2, 'MarkerSize', 8);
uistack(hPoints, 'top');
% Labels (σ = ...)
offset = [ 0.10  0.10;   % for (-2, 4)
           0.05 -0.25;   % for (-1,-1)
           0.05  0.10;   % for ( 0, 0)
           0.05  0.10;   % for ( 1, 1)
           0.10 -0.25];  % for ( 2,-4)
for i = 1:numel(x)
    text(x(i)+offset(i,1), y(i)+offset(i,2), ...
        sprintf('(\sigma = %.3g)', sigma(i)), ...  % Use %.3g for formatting
        'FontSize', 14)
end

% Axis & legend
xlim([-2.5 2.5]); ylim([-4.5 4.5])
legend('Data points','OLS fit','WLS fit','Location','northeast','FontName','Times New Roman','FontSize',14,'Box','on')

set(gca,'FontName','Times New Roman','FontSize',16);
xlabel('$x$','FontName','Times New Roman','FontSize',18, 'Interpreter','latex');
ylabel('$y$','FontName','Times New Roman','FontSize',18, 'Interpreter','latex');
% legend('Location','northeast');

% --- (Optional) print computed coefficients to command window -----------
fprintf('OLS:  y = %.4f + %.4f x\n', beta_ols(1), beta_ols(2));
fprintf('WLS:  y = %.4f + %.4f x\n', beta_wls(1), beta_wls(2));

% Save the figure as a high-resolution PNG file.
print(gcf, 'Figures/Figure7.png', '-dpng', '-r300');