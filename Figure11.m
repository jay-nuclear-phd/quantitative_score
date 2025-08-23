% This script analyzes the relationship between the score and two variables,
% jk and SB, by binning the data and visualizing the results.

clear 
Ck = load("Ck");
Cm = load("Cm");
k  = load("k");
m  = load("m");
Ck = (Ck + Ck')/2;   % Symmetrize covariance matrix

%% Sampling
% This section performs random sampling to calculate the score, jk, and SB.
rng(3)
n = 100000;
% n = 1000;
N = 2;

score = zeros(1,n);
ck    = zeros(2,n);
jk    = zeros(1,n);
SB    = zeros(2,n);

for i = 1:n
    I  = randi(425,[1,N+1]);     % Random index pair
    kk = k(I);
    mm = m(I);
    
    k_tilde = kk./mm;

    Ckk = Ck(I,I);
    Cmm = Cm(I(1:N),I(1:N));
    
    wi = 1./diag(Cmm);
    W = sum(wi);

    k_bar = 1/W*(wi'*k_tilde(1:N));

    sk2 = 1/W*N/(N-1)*(wi'*(k_tilde(1:N) - k_bar));
    sigk2 = N/W;
    sig_beta = sqrt(sk2 + sigk2);

    Rk   = corrcov(Ckk + eye(length(kk))*1e-8);
    Cdd   = Ckk;
    Cdd(1:N,1:N) = Cdd(1:N,1:N) + Cmm;
    Rd   = corrcov(Cdd);

    jk(i) = sqrt(Rd(end,1:N)*inv(Rd(1:N,1:N))*Rd(1:N,end));
    
    % Normalized score
    score(i) = (mm(end) - k_bar) / sig_beta;

    ck(:,i)    = Rk(end,1:N)';
    
    % Define SB depending on relative variances
    for j = 1:N
        if Ckk(j,j) < Ckk(end,end)
            SB(j,i) = ck(j,i)*Ckk(j,j) / Ckk(end,end);
        else
            SB(j,i) = ck(j,i)*Ckk(end,end) / Ckk(j,j);
        end
    end
end
SB = mean(SB);

%% Bin edges for jk and SB
% This section defines the bin edges for jk and SB and calculates statistics for each bin.
edges = 0.7:0.05:1.0;
nBins = length(edges)-1;

% Statistics by jk bins
score_mean_by_jk = zeros(1, nBins);
score_std_by_jk  = zeros(1, nBins);

for ii = 1:nBins
    idx = jk > edges(ii) & jk <= edges(ii+1);
    score_mean_by_jk(ii) = mean(score(idx));
    score_std_by_jk(ii)  = std(score(idx));
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
binCenter_jk = (edges(1:end-1) + edges(2:end))/2;
binCenter_SB = (edges(1:end-1) + edges(2:end))/2;

% Summary tables
T_jk = table(binCenter_jk', score_mean_by_jk', score_std_by_jk', ...
            'VariableNames', {'jk_bin_center','score_mean_by_jk','score_std_by_jk'})

T_SB = table(binCenter_SB', score_mean_by_SB', score_std_by_SB', ...
            'VariableNames', {'SB_bin_center','score_mean_by_SB','score_std_by_SB'})

%% Visualization
% This section creates a scatter plot of the score vs. jk and SB,
% and overlays the normal distribution for each bin.
figure('Color','w','Position',[100 100 1000 400]); % Wide figure
n = 20000;                                         % Number of scatter points
yvals = linspace(-10,10,200);                     % Vertical axis for PDF curves

for i = 1:2
    subplot(1,2,i)
    if i == 1
        scatter(jk(1:n/6), score(1:n/6),'.')
        xlabel("{\it c_k}")
        binCenters = binCenter_jk;
        mu  = score_mean_by_jk;
        sig = score_std_by_jk;
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
print('Figures/Figure11','-dpng','-r300')