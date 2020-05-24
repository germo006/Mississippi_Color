% Replacing Figure SI1 with something that looks more consistent.

load('redoNullex_25April2020.mat')
load('NoahMaps.mat')

figure
[acf, lags, bounds, h] = autocorr(nullex(:,4), 'NumLags', 30);
h(2).Color = Promare{3}; h(2).LineStyle = 'none'; h(2).HandleVisibility = 'off';
h(3).Color = Promare{3}; h(3).LineStyle = 'none'; h(3).HandleVisibility = 'off';
h(1).Color = Promare{7}; 
h(4).HandleVisibility = 'off';
hold on
[acf2, lags2, bounds2, h2] = autocorr(nullex(:,5), 'NumLags', 30);
h2(2).Color = Promare{3}; h2(2).LineStyle = '--';
h2(3).Color = Promare{3}; h2(3).LineStyle = '--';
h2(1).Color = Promare{8}; 

ax = gca; ax.LineWidth = 1; ax.FontWeight = 'bold';
legend({'Color', 'Discharge'}, 'Location', 'northeast')
ylim([0,1])
title('')
grid off