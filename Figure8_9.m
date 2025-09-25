% This script generates 2x2 histograms of scores for four different methods:
% Parametric, Nonparametric, Whisper, and TSURFER.
% It also creates a separate plot showing the mean of each distribution
% on a standard normal curve.

%% 2x2 histograms of scores (Parametric / Nonparametric / Whisper / TSURFER)

clear 
% Load data
Ck = load("Ck");
Cm = load("Cm");
k = load("k");
m = load("m");
Ck = (Ck + Ck')/2; % Symmetrize the covariance matrix
mu_names = {'Parametric','Nonparametric','Whisper','TSURFER'};

% Initialization
n = 10000;
score = zeros(n,4);
rng(3) % Set random seed for reproducibility

% Calculate scores for each method
for i=1:n
    score(i,:) = randomPNWG(k,m,Ck,Cm);
end

% --- bins & edges ---
nbins = 35;                                   % number of bins
edges = linspace(-7, 10, nbins+1);            % fixed x-axis range

% --- stats ---
% Calculate mean and standard deviation for each method
mu  = mean(score, 1);
sig = std(score, 0, 1);

% --- figure & layout ---
f = figure('Color','w','Position',[80 80 1000 700]);
t = tiledlayout(2,2,'TileSpacing','compact','Padding','compact');

% panel labels to place under the x-axis label
panel_labels = {'(a) Parametric','(b) Nonparametric','(c) Whisper','(d) TSURFER'};

% --- Plot histograms ---
for j = 1:4
    ax = nexttile(t, j);
    hold(ax,'on'); box(ax,'on');

    % histogram
    h = histogram(ax, score(:,j), ...
        'Normalization','probability', ...
        'BinEdges', edges, ...
        'FaceColor',[0 0.4470 0.7410], ...
        'EdgeColor','k', ...
        'LineWidth',0.5);

    % add legend (top-left)
    legend(ax, h, sprintf('%s score distribution', mu_names{j}), ...
        'Location','northwest', ...
        'FontName','Times');

    % axes style
    set(ax,'FontName','Times');
    xlim(ax,[-7 10]);
    ylim(ax,[0 0.20]);
    yticks(ax,[]);

    % labels
    % put panel label together with xlabel (two lines)
    xlabel(ax, sprintf('Collected scores\n%s', panel_labels{j}), ...
        'FontName','Times','FontSize',14);

    ylabel(ax,'Probability mass','FontName','Times');

    % stats (upper-right)
    txt = sprintf('Mean : %.4f\nSTD  : %.4f', mu(j), sig(j));
    text(ax, 0.97, 0.92, txt, ...
        'Units','normalized', ...
        'HorizontalAlignment','right', ...
        'VerticalAlignment','top', ...
        'FontName','Times');
end

% Save the first figure
print(gcf, 'Figures/Figure8.jpg', '-dpng', '-r300');

%%
% Plot means on a standard normal curve
x = linspace(-4, 4, 2000);
y = normpdf(x, 0, 1);

f2 = figure('Color','w','Position',[120 120 1000 420]);
ax2 = axes(f2); hold(ax2,'on'); box(ax2,'on');
plot(ax2, x, y, 'LineWidth', 2);

mu_names = {'Parametric','Nonparametric','Whisper','TSURFER'};
mu_colors = [ ...
    0.8500 0.3250 0.0980;   % orange
    0.5000 0.5000 0.5000;   % gray
    0.4660 0.6740 0.1880;   % green
    0.4940 0.1840 0.5560];  % purple

h = gobjects(1,4);
for j = 1:4
    h(j) = xline(ax2, mu(j), '--', 'Color', mu_colors(j,:), ...
        'LineWidth', 2, ...
        'DisplayName', sprintf('%s, \mu = %.3f', mu_names{j}, mu(j)));
end

legend(ax2, h, get(h,'DisplayName'), 'Location','northwest');
set(ax2, 'FontName','Times');
xlim(ax2, [-4 4]); ylim(ax2, [0 max(y)*1.05]);
xlabel(ax2, '\sigma');

% Save the second figure
print(gcf, 'Figures/Figure9.jpg', '-dpng', '-r300');