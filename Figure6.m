% This script generates a heatmap of the U-235 fission covariance matrix.

%% U-235 fission covariance heatmap
clear; clc;

% 1) Load the matrix (handles ASCII files without extensions)
S = load('U235_fission_cov');       % Reads as a matrix if it contains only numbers, or as a struct for MAT files
if isstruct(S)
    fn = fieldnames(S);  C = S.(fn{1});
else
    C = S;                              % [N x N] covariance (or sensitivity) matrix
end
assert(ismatrix(C) && size(C,1)==size(C,2), 'Square matrix expected.');

N = size(C,1);

% 2) Energy axis (linearly maps 0 to 2e7 eV over N intervals)
Emin = 0; Emax = 2e7;
E = linspace(Emin, Emax, N);           % Axis coordinates (used as centers)

% 3) Logarithmic transformation for color (with a floor to prevent log(0) or log(negative))
floor_val = 1e-12;                     % Adjust as needed
C_log = log10(max(abs(C), floor_val)); % Based on absolute values (for signed values, use symlog or other methods)

% 4) Plotting
figure('Color','w','Position',[120 120 900 700]);  % Large figure
imagesc([Emin Emax], [Emin Emax], C_log);          % Specify coordinates in energy (eV)
set(gca,'YDir','normal');                          % Set origin to the bottom-left
axis square; box on; grid off;

colormap(parula);
cb = colorbar;                                     
caxis([-6 -2]);                                    % Range from 10^-6 to 10^-2 (adjust to fit data)
cb.Ticks = -6:-2;                                  % Ticks
cb.TickLabels = arrayfun(@(v)sprintf('10^{%d}',v), cb.Ticks, 'uni',0);

% 5) Labels/Fonts
set(gca,'FontName','Times New Roman','FontSize',16);
xlabel('Energy (eV)','FontName','Times New Roman','FontSize',18);
ylabel('Energy (eV)','FontName','Times New Roman','FontSize',18);

% Save the figure as a high-resolution PNG file.
print(gcf, 'Figures/Figure6.png', '-dpng', '-r300');