%% 03 June 2020 Noah Germolus
% This is a script to conduct a basic frequency-space analysis of the flow
% and color data

load('redoNullex_25April2020.mat')
load('NoahMaps.mat') % Using the Promare color scheme for some graphs.
nullex(:,5) = nullex(:,5).*0.0283168; % Converting to m3/d
setDefaultFigs
n = size(nullex,1); 
ft_flow = fft(nullex(:,5))./sqrt(n);
ft_color = fft(nullex(:,4))./sqrt(n);

fs = 1; % Sample frequency 1/day

f = (0:n-1)*(fs/n); % Frequency range

ps_flow = (abs(ft_flow).^2)/n;
ps_color = (abs(ft_color).^2)/n;

ft_flow0 = fftshift(ft_flow);         % shift y values
ft_color0 = fftshift(ft_color);         % shift y values
f0 = (-n/2:n/2-1)*(fs/n); % 0-centered frequency range
ps_flow0 = (abs(ft_flow0).^2)/n;
ps_color0 = (abs(ft_color0).^2)/n; % 0-centered power

plot((f0.*365.25).^(-1), -log10(ps_color0./max(ps_color0)), 'LineWidth', 1, 'Color', Promare{2}, 'Marker', 'none')
hold on
plot((f0.*365.25).^(-1), -log10(ps_flow0./max(ps_flow0)), 'LineWidth', 1.5, 'Color', Promare{7}, 'LineStyle', ':', 'Marker','none')
stem((f0.*365.25).^(-1), -log10(ps_flow0./max(ps_flow0)), 'LineWidth', 1.5, 'Color', Promare{7}, 'LineStyle', ':', 'Marker','none')
stem((f0.*365.25).^(-1), -log10(ps_color0./max(ps_color0)), 'LineWidth', 1, 'Color', Promare{2}, 'Marker', 'none')
xlabel('Oscillation Period (yr)')
ylabel('Normalized Power')
% ylim([0,0.01])
hold on
% yyaxis right
% set(gca, 'YColor', 'k')

%ylim([0,0.01])
% ylabel('Normalized Power (Flow)')
legend('Color Power Spectrum', 'Flow Power Spectrum')
ax = gca;
ax.TickLength = [0,0];
ax.XScale = "log"; xlim([1,50]);
xticks([1:2:11,20:10:50])
%ax.XTickLabel = str2double(cellstr(ax.XTickLabel)).*365;