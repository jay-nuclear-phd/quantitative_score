% This script runs two cases of covariance modification and plots the results.
% Case 1: No noise is added to the covariance matrix.
% Case 2: Noise is added to the covariance matrix.

%% Run two cases of covariance modification and plot
% Case 1:  Ckk = Ck(I,I)
% Case 2:  Ckk = Ck(I,I) + eye(2)*0.0025^2

clear; clc;

% ---------------- Data load ----------------
% Load and preprocess the necessary data.
Ck = load("Ck");  Ck = (Ck + Ck')/2;   % symmetrize
Cm = load("Cm");
k  = load("k");
m  = load("m");

% ---------------- Main routine as function ----------------
% This function generates the figures for a given covariance matrix.
function makeFigure(Ck, Cm, k, m, addNoise)
    % Set the random seed for reproducibility.
    rng(11)
    N = 10000;
    score = zeros(1,N);
    jk    = zeros(1,N);

    for i = 1:N
        I = randi(425,[1,2]);
        kk = k(I);
        mm = m(I);

        % ---- covariance selection ----
        % Choose the covariance matrix based on the addNoise flag.
        if addNoise
            Ckk = Ck(I,I) + eye(2)*0.0025^2;   % with noise
        else
            Ckk = Ck(I,I);                     % without noise
        end

        Cmm = Cm(I(1),I(1));
        Cdd = Ckk;
        Cdd(1,1) = Ckk(1,1) + Cmm(1,1);

        R = corrcov(Cdd);
        jk(i) = R(1,2);

        % Calculate the score.
        bias = -Ckk(2,1)/Cdd(1,1) * (kk(1) - mm(1));
        post = kk(end) + bias;
        sig  = sqrt(Ckk(2,2) - Ckk(1,2)/Cdd(1,1)*Ckk(1,2));
        score(i) = (post - mm(end)) / sig;
    end

    % ---------------- Plot ----------------
    % Create the plots.
    figure('Color','w','Position',[100 100 1000 400]); % wide figure

    % Left subplot: jk vs score
    subplot(1,2,1)
    scatter(jk, score, '.')
    box on; grid on
    ylim([-10 10]); xlim([0.7 1])
    ylabel("Score"); xlabel("{\it j_k}")
    % 95% confidence interval lines
    h1 = yline(2.58,'LineWidth',1.5,'Color','red','LineStyle','--',...
               'DisplayName','95% confidence interval');
    yline(-2.58,'LineWidth',1.5,'Color','red','LineStyle','--');

    set(gca,'FontName','Times')

    % Legend (only one entry for the dashed red line)
    legend(h1,'Location','northeast')

    set(gca,'FontName','Times')

    % Right subplot: score spread vs jk bin
    subplot(1,2,2)
    I = 0.65:0.010:1.0;
    gstd = zeros(1,length(I)-1);
    for ii = 1:length(I)-1
        gstd(ii) = std(score(jk>I(ii) & jk<=I(ii+1)));
    end
    I = I(2:end);
    plot(I, gstd,'LineWidth',1.5)
    xlim([0.7 1]); ylim([0 4])
    xlabel("{\it j_k}"); ylabel("Score spread")
    grid on
    set(gca,'FontName','Times')
end

% ---------------- Execute both cases ----------------
% Generate and save the figures for both cases.
makeFigure(Ck, Cm, k, m, false);  % Case 1: without noise
print('Figures/Figure12','-dpng','-r300')

makeFigure(Ck, Cm, k, m, true);   % Case 2: with noise
print('Figures/Figure13','-dpng','-r300')