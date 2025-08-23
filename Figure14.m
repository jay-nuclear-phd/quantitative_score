% This script generates a plot of the Extreme Value PDF for different block sizes.
% It compares the baseline normal distribution with Gumbel (EV1) distributions
% fitted to block maxima of different orders.

%% Whisper — Extreme Value PDF
% - Baseline distribution: N(0,1)
% - Block maxima: block size n ∈ {5, 15, 25}
% - Each set of maxima is fitted with a Gumbel (EV1) distribution
% - The curves are scaled for visualization (not normalized)

clear; clc; close all

% ---------- 1) Figure and axis style ----------
% Initialize the figure and set basic properties.
figure('Color','w'); hold on
set(gca,'LineWidth',1.1,'FontSize',12)
box off

% Baseline (same color as your original)
c_pdf = [0.9290 0.6940 0.1250];

% ---------- 2) Baseline normal distribution PDF ----------
% Plot the PDF of the standard normal distribution.
x  = linspace(-8, 6, 1001);
y0 = normpdf(x, 0, 1);
plot(x, y0, 'LineWidth', 2.2, 'Color', c_pdf);

% ---------- 3) Block maxima → Gumbel fit and PDF ----------
% Generate block maxima, fit a Gumbel distribution, and plot the PDF.
block_sizes = [5, 15, 25];
rng(6)                        % keep seed for identical colors
SCALE = 0.25;
N     = 1000;

for k = 1:numel(block_sizes)
    n = block_sizes(k);

    % (a) generate samples and block maxima
    xMax = max(randn(N, n), [], 2);

    % (b) fit EV1 to -xMax (MATLAB convention)
    param = evfit(-xMax);

    % (c) evaluate EV1 pdf on grid and scale for visualization
    p  = evpdf(-x, param(1), param(2));
    yk = SCALE * (N/300) * p;

    % (d) use the SAME random-color scheme as your original (after randn)
    col = rand(1,3);                      % <-- this reproduces your colors
    plot(x, yk, 'LineWidth', 2.2, 'Color', col);
end

% ---------- 4) Axis, labels, legend ----------
% Finalize the plot with axis limits, labels, title, and legend.
ylim([0 0.8])
set(gca, 'YTickLabel', []);
set(gca, 'XTickLabel', []);
box on
title('Extreme Value PDF', 'FontWeight', 'normal')
lg = legend( ...
    'Original PDF', ...
    '5th-order EV', ...
    '15th-order EV', ...
    '25th-order EV', ...
    'Location', 'northwest');
lg.Box = 'on';

% Note: curves are scaled for display; not probability-normalized.

% Save the figure as a high-resolution PNG file.
print(gcf, 'Figures/Figure14.png', '-dpng', '-r300');