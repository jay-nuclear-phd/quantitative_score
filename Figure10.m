% This script analyzes the relationship between the score and two variables,
% ck and SB, by binning the data and visualizing the results.

clear 
Ck = load("Ck");
Cm = load("Cm");
k  = load("k");
m  = load("m");
Ck = (Ck + Ck')/2;   % Symmetrize covariance matrix

%% Sampling
% This section performs random sampling to calculate the score, ck, and SB.
rng(3)
N = 100000;
score = zeros(1,N);
ck    = zeros(1,N);
SB    = zeros(1,N);

for i = 1:N
    I  = randi(425,[1,2]);     % Random index pair
    kk = k(I);
    mm = m(I);
    
    Ckk = Ck(I,I);
    Cmm = Cm(I(1),I(1));
    
    R   = corrcov(Ckk);
    
    % Simple bias correction
    bias = kk(1) - mm(1);
    post = kk(end) - bias;
    sig = sqrt(Cmm(1,1));
    
    % Normalized score
    score(i) = (post - mm(end)) / sig;
    ck(i)    = R(1,2);
    
    % Define SB depending on relative variances
    if Ckk(1,1) < Ckk(2,2)
        SB(i) = ck(i)*Ckk(1,1) / Ckk(2,2);
    else
        SB(i) = ck(i)*Ckk(2,2) / Ckk(1,1);
    end
end

%% Bin edges for ck and SB
% This section defines the bin edges for ck and SB and calculates statistics for each bin.
edges = 0.7:0.05:1.0;
nBins = length(edges)-1;

% Statistics by ck bins
score_mean_by_ck = zeros(1, nBins);
score_std_by_ck  = zeros(1, nBins);

for ii = 1:nBins
    idx = ck > edges(ii) & ck <= edges(ii+1);
    score_mean_by_ck(ii) = mean(score(idx));
    score_std_by_ck(ii)  = std(score(idx));
end

% Statistics by SB bins
score_mean_by_SB = zeros(1, nBins);
score_std_by_SB  = zeros(1, nBins);

for ii = 1:nBins
    idx = SB > edges(ii) & SB <= edges(ii+1);
    score_mean_by_SB(ii) = mean(score(idx));
    score_std_by_SB(ii)  = std(score(idx));
end

% Bin centers
binCenter_ck = (edges(1:end-1) + edges(2:end))/2;
binCenter_SB = (edges(1:end-1) + edges(2:end))/2;

% Summary tables
T_ck = table(binCenter_ck', score_mean_by_ck', score_std_by_ck', ...
            'VariableNames', {'ck_bin_center','score_mean_by_ck','score_std_by_ck'})

T_SB = table(binCenter_SB', score_mean_by_SB', score_std_by_SB', ...
            'VariableNames', {'SB_bin_center','score_mean_by_SB','score_std_by_SB'})

%% Visualization
% This section creates a scatter plot of the score vs. ck and SB,
% and overlays the normal distribution for each bin.
figure('Color','w','Position',[100 100 1000 400]); % Wide figure
n = 5000;                                         % Number of scatter points
yvals = linspace(-10,10,200);                     % Vertical axis for PDF curves

for i = 1:2
    subplot(1,2,i)
    if i == 1
        scatter(ck(1:n), score(1:n),'.')
        xlabel("{\it c_k}")
        binCenters = binCenter_ck;
        mu  = score_mean_by_ck;
        sig = score_std_by_ck;
    else
        scatter(SB(1:n), score(1:n),'.')
        xlabel("{\it S_B}")
        binCenters = binCenter_SB;
        mu  = score_mean_by_SB;
        sig = score_std_by_SB;
    end
    
    hold on
    % Overlay normal distribution curves for each bin
    for j = 1:length(binCenters)
        if isnan(mu(j)) || isnan(sig(j)) || sig(j)==0
            continue
        end
        pdf_vals = normpdf(yvals, mu(j), sig(j));
        pdf_vals = pdf_vals / max(pdf_vals) * 0.05;  % Scaled to fit bin width
        plot(binCenters(j) - 0.025 + pdf_vals, yvals,'LineWidth',1.5)
    end
    hold off
    
    box on
    xlim([0.68 1.02])
    ylim([-10 10])
    ylabel('Score')
    set(gca, 'FontName','times')
end

% Save figure as 300 dpi PNG
print('Figures/Figure10','-dpng','-r300')