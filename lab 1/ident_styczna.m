%% Metoda stycznej: porownanie odpowiedzi obiektu (dFw -> Twew) i modelu K*e^(-s*T0)/(T*s+1)
cd(fileparts(mfilename('fullpath')));
run('Wezel1Pom1CvwCvg_skrypt.m');   % robi "clear all", wiec parametry ponizej

K  = 205.44;   % [st.C/(kg/s)]
T0 = 62;       % [min]
T  = 650;      % [min]

[tr, iu] = unique(t - czas_skok, 'last');
tg = (0:floor(tr(end)))';
dy = interp1(tr, aTwew(iu) - aTwew(1), tg);
y_ust = mean(dy(end-100:end));

f = figure(11); clf;
set(f, 'Units', 'pixels', 'Position', [50 50 1600 1000], 'Color', 'w');
if exist('theme', 'file'), theme(f, 'light'); end
plot([-104 0], [0 0], 'b', tg, dy, 'b', 'LineWidth', 1.5); hold on;
plot([-104 2600], [0 0], 'k--', [-104 2600], [y_ust y_ust], 'k--', 'LineWidth', 1);
text(2600, 0, ' y = 0', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right', 'FontSize', 12);
text(2600, y_ust, sprintf(' y_{ust} = %.3f', y_ust), 'VerticalAlignment', 'bottom', ...
    'HorizontalAlignment', 'right', 'FontSize', 12);
ax = gca;
xlim([-104 2600]); ylim([-0.011 0.561]);
set(ax, 'XTick', 0:200:2600, 'YTick', 0:0.05:0.55, 'FontSize', 12);
grid on; grid minor; ax.MinorGridAlpha = 0.35; ax.GridAlpha = 0.5;
xlabel('t [min] (t = 0 w chwili skoku dF_w)');
ylabel('\Delta T_{wew} = T_{wew} - T_{wew0} [^\circC]');
title(sprintf('Odpowiedz skokowa obiektu, dF_w = %.5f kg/s', dFw));
hold off;
exportgraphics(f, fullfile('figures', 'odp_do_stycznej.png'), 'Resolution', 300);

ym = K*dFw*(1 - exp(-max(tg - T0, 0)/T));
e = dy - ym;
fprintf('ISE = %.4f  RMSE = %.4f  max|e| = %.4f\n', trapz(tg, e.^2), sqrt(trapz(tg, e.^2)/tg(end)), max(abs(e)));

t_exp = [0:20:300, 325:25:1000, 1100:100:2600];
fprintf('\n---OBIEKT---\n');
fprintf('(%g, %.4f) ', [t_exp; interp1(tg, dy, t_exp)]);
fprintf('\n\n---MODEL STYCZNEJ---\n');
fprintf('(%g, %.4f) ', [t_exp; interp1(tg, ym, t_exp)]);
fprintf('\n');
