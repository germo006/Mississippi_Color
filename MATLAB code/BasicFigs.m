%% Noah Germolus 29 May 2020
% This is literally just a plot generator.

load('redoNullex_25April2020.mat')
load('NoahMaps.mat') % Using the Promare color scheme for some graphs.
nullex(:,5) = nullex(:,5).*0.0283168;

figure

subplot(2,1,1)
h1 = plot(datetime(nullex(367:end,1:3)), nullex(367:end,4));
h1.LineWidth = 0.2;
h1.Color = Promare{5};
xlabel('Date', 'Interpreter','tex');
ylabel('Color (PCU)', 'Interpreter','tex');
ax = gca; ax.FontName = 'arial'; ax.Box = 'on'; ax.LineWidth = 1; 
ax.FontWeight = 'bold';

subplot(2,1,2)
h1 = plot(datetime(nullex(367:end,1:3)), nullex(367:end,5));
h1.LineWidth = 0.2;
h1.Color = Promare{7};
xlabel('Date', 'Interpreter','tex');
ylabel('Discharge (m^3 s^{-1})', 'Interpreter','tex');
ax = gca; ax.FontName = 'arial'; ax.Box = 'on'; ax.LineWidth = 1; 
ax.FontWeight = 'bold';

