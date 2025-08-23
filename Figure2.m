% This script generates a plot illustrating the concept of a function and its tangent line.

%% Default LaTeX interpreter settings (valid for the session)
set(groot,'defaultTextInterpreter','latex');
set(groot,'defaultAxesTickLabelInterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');

%% Example function/tangent
% k   = @(a) -0.015*(a-1.5).^3 + 0.45*(a-1.5) + 0.5;
k   = @(a) -0.04*a.*(a-1.0).*(a-7) + 0.5;
amin = -1.0; amax = 7.5;
a    = linspace(amin, amax, 1000);
ka   = k(a);

alpha0 = 1.2;  h = 1e-4;
k0     = k(alpha0);
S      = (k(alpha0+h)-k(alpha0-h))/(2*h);
theta  = atan(S);
y_tan  = @(x) k0 + S*(x - alpha0);

% Figure
figure('Color','w','Position',[80 80 1000 600]);
ax = axes; hold(ax,'on');

% ---- Curve & Tangent ----
plot(a, ka, 'Color',[0 0.35 0.8], 'LineWidth',2.0);
plot(a, y_tan(a), 'r-', 'LineWidth',2.0);
plot(alpha0, k0, 'o', 'MarkerSize',6, 'MarkerEdgeColor','k','MarkerFaceColor','w');

% ---- Custom arrow axes inside the graph ----
y_max = max(ka)+0.9; y_min = min(ka)-0.4;
plot([amin amax],[0 0],'k','LineWidth',1.2);
plot([0 0],[y_min y_max],'k','LineWidth',1.2);
scatter(amax,0,70,'k','>','filled');         % x-axis arrow
scatter(0,y_max,70,'k','^','filled');        % y-axis arrow

% ---- Vertical dashed line & labels ----
plot([alpha0 alpha0],[0 k0],'k--','LineWidth',1.2);
text(alpha0, -0.08, '$\\alpha_0$', 'Interpreter','latex', 'HorizontalAlignment','center','FontSize',20);
text(alpha0-0.72, k0+0.12, '$k(\\alpha_0)$', 'Interpreter','latex','FontSize',20);

% ---- Angle visualization (with translation) ----
L  = 2.0; 
dx = 1.52;    % Rightward shift
dy = 0.47;    % Upward shift

% Use the translated position from the original point (alpha0, k0)
xA = alpha0 + dx; 
yA = k0 + dy;     

xH = xA + L;  yH = yA;          % End of horizontal side
xB = xH;       yB = yA + S*L;   % End of vertical side (considering tangent slope)

plot([xA xH],[yA yH],'--','Color',[1 .6 0],'LineWidth',1.8);
plot([xH xB],[yH yB],'--','Color',[1 .6 0],'LineWidth',1.8);
text(3.5, 1.13, '$\\theta$', 'Interpreter','latex','FontSize',20);

% Angle arc, also translated from the same reference point
r  = 0.35*L;  
 tt = linspace(0, theta, 100);
plot(xA + r*cos(tt), yA + r*sin(tt), 'Color',[0 0 0.0], 'LineWidth',1.8);
text(alpha0-0.72, k0+0.12, '$k(\\alpha_0)$', 'Interpreter','latex','FontSize',20);

% ---- Equation (LaTeX) ----
eqn = '$\\tan\\theta = S = \\frac{\\partial k}{\\partial \\alpha}\\big|{\\alpha=\\alpha_0}$';
text(amin+1.6, y_max-0.55, eqn, 'Interpreter','latex', 'FontSize', 24);

% ---- View range ----
xlim([amin amax]); ylim([y_min y_max]);

% ---- Hide default axes (bottom/left), keeping the custom arrows ----
box off
set(ax,'XColor','none','YColor','none','XTick',[],'YTick',[])
% The line above hides only the default axes/ticks, leaving our custom arrow axes.

% (Optional) Add axis labels as text at the end
text(amax-0.2, +0.2, '\alpha', 'VerticalAlignment','middle', 'FontSize', 24);
text(-0.4, y_max-0.2, '$k(\\alpha)$', 'Interpreter','latex', 'HorizontalAlignment','center', 'FontSize', 24);

% Save the figure as a high-resolution PNG file.
print(gcf, 'Figures/Figure2.png', '-dpng', '-r300');