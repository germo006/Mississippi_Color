%% 03 June 2020 Noah Germolus
% This is a script to conduct a basic frequency-space analysis of the flow
% and color data

load('redoNullex_25April2020.mat')
load('NoahMaps.mat') % Using the Promare color scheme for some graphs.
nullex(:,5) = nullex(:,5).*0.0283168; % Converting to m3/d
setDefaultFigs

ft_flow = fft(nullex(:,5));
ft_color = fft(nullex(:,4));

fs = 1; % Sample frequency 1/day
n = size(nullex,1); 
f = (0:n-1)*(fs/n); % Frequency range

ps_flow = (abs(ft_flow).^2)/n;
ps_color = (abs(ft_color).^2)/n;

ft_flow0 = fftshift(ft_flow);         % shift y values
ft_color0 = fftshift(ft_color);         % shift y values
f0 = (-n/2:n/2-1)*(fs/n); % 0-centered frequency range
ps_flow0 = (abs(ft_flow0).^2)/n;
ps_color0 = (abs(ft_color0).^2)/n; % 0-centered power

subplot(2,1,1)
plot(f0, ps_color0)
xlabel('Frequency')
ylabel('Power')

subplot(2,1,2)
plot(f0, ps_flow0)
xlabel('Frequency')
ylabel('Power')
