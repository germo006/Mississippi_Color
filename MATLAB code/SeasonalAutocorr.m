%% Noah Germolus 24 May 2020
% This script is meant to use MATLAB's version of an autocorrelation
% function and create a matrix of figures (2x2x3=12) of this function for
% the mean, max, and min of color and flow for winter and summer. 

load('redoNullex_25April2020.mat')
load('NoahMaps.mat')

figure
subplot(4,3,1)
[acf, lags, bounds, h] = autocorr(SummerMinColor(:,2), 'NumLags', 10);
% h(1) is the ball and stick plot.
% h(2) is upper bound
% h(3) is lower bound
h(2).Color = Promare{3}; h(2).LineStyle = '--';
h(3).Color = Promare{3}; h(3).LineStyle = '--';
h(1).Color = Promare{7}; 
ax = gca; ax.GridColor = 'none'; ax.TickLength = [0,0];
ax.FontWeight = 'bold'; ax.LineWidth = 1;
title('Minimum')
ylabel('Summer Color')
xlabel('')

subplot(4,3,2)
[acf, lags, bounds, h] = autocorr(SummerMeanColor(:,2), 'NumLags', 10);
% h(1) is the ball and stick plot.
% h(2) is upper bound
% h(3) is lower bound
h(2).Color = Promare{3}; h(2).LineStyle = '--';
h(3).Color = Promare{3}; h(3).LineStyle = '--';
h(1).Color = Promare{7}; 
ax = gca; ax.GridColor = 'none'; ax.TickLength = [0,0];
ax.FontWeight = 'bold'; ax.LineWidth = 1;
title('Mean')
ylabel('')
xlabel('')

subplot(4,3,3)
[acf, lags, bounds, h] = autocorr(SummerMaxColor(:,2), 'NumLags', 10);
% h(1) is the ball and stick plot.
% h(2) is upper bound
% h(3) is lower bound
h(2).Color = Promare{3}; h(2).LineStyle = '--';
h(3).Color = Promare{3}; h(3).LineStyle = '--';
h(1).Color = Promare{7}; 
ax = gca; ax.GridColor = 'none'; ax.TickLength = [0,0];
ax.FontWeight = 'bold'; ax.LineWidth = 1;
title('Maximum')
ylabel('')
xlabel('')

subplot(4,3,4)
[acf, lags, bounds, h] = autocorr(SummerMinFlow(:,2), 'NumLags', 10);
% h(1) is the ball and stick plot.
% h(2) is upper bound
% h(3) is lower bound
h(2).Color = Promare{3}; h(2).LineStyle = '--';
h(3).Color = Promare{3}; h(3).LineStyle = '--';
h(1).Color = Promare{7}; 
ax = gca; ax.GridColor = 'none'; ax.TickLength = [0,0];
ax.FontWeight = 'bold'; ax.LineWidth = 1;
title('')
ylabel('Summer Flow')
xlabel('')

subplot(4,3,5)
[acf, lags, bounds, h] = autocorr(SummerMeanFlow(:,2), 'NumLags', 10);
% h(1) is the ball and stick plot.
% h(2) is upper bound
% h(3) is lower bound
h(2).Color = Promare{3}; h(2).LineStyle = '--';
h(3).Color = Promare{3}; h(3).LineStyle = '--';
h(1).Color = Promare{7}; 
ax = gca; ax.GridColor = 'none'; ax.TickLength = [0,0];
ax.FontWeight = 'bold'; ax.LineWidth = 1;
title('')
ylabel('')
xlabel('')

subplot(4,3,6)
[acf, lags, bounds, h] = autocorr(SummerMaxFlow(:,2), 'NumLags', 10);
% h(1) is the ball and stick plot.
% h(2) is upper bound
% h(3) is lower bound
h(2).Color = Promare{3}; h(2).LineStyle = '--';
h(3).Color = Promare{3}; h(3).LineStyle = '--';
h(1).Color = Promare{7}; 
ax = gca; ax.GridColor = 'none'; ax.TickLength = [0,0];
ax.FontWeight = 'bold'; ax.LineWidth = 1;
title('')
ylabel('')
xlabel('')

subplot(4,3,7)
[acf, lags, bounds, h] = autocorr(WinterMinColor(:,2), 'NumLags', 10);
% h(1) is the ball and stick plot.
% h(2) is upper bound
% h(3) is lower bound
h(2).Color = Promare{3}; h(2).LineStyle = '--';
h(3).Color = Promare{3}; h(3).LineStyle = '--';
h(1).Color = Promare{7}; 
ax = gca; ax.GridColor = 'none'; ax.TickLength = [0,0];
ax.FontWeight = 'bold'; ax.LineWidth = 1;
title('')
ylabel('Winter Color')
xlabel('')

subplot(4,3,8)
[acf, lags, bounds, h] = autocorr(WinterMeanColor(:,2), 'NumLags', 10);
% h(1) is the ball and stick plot.
% h(2) is upper bound
% h(3) is lower bound
h(2).Color = Promare{3}; h(2).LineStyle = '--';
h(3).Color = Promare{3}; h(3).LineStyle = '--';
h(1).Color = Promare{7}; 
ax = gca; ax.GridColor = 'none'; ax.TickLength = [0,0];
ax.FontWeight = 'bold'; ax.LineWidth = 1;
title('')
ylabel('')
xlabel('')

subplot(4,3,9)
[acf, lags, bounds, h] = autocorr(WinterMaxColor(:,2), 'NumLags', 10);
% h(1) is the ball and stick plot.
% h(2) is upper bound
% h(3) is lower bound
h(2).Color = Promare{3}; h(2).LineStyle = '--';
h(3).Color = Promare{3}; h(3).LineStyle = '--';
h(1).Color = Promare{7}; 
ax = gca; ax.GridColor = 'none'; ax.TickLength = [0,0];
ax.FontWeight = 'bold'; ax.LineWidth = 1;
title('')
ylabel('')
xlabel('')

subplot(4,3,10)
[acf, lags, bounds, h] = autocorr(WinterMinFlow(:,2), 'NumLags', 10);
% h(1) is the ball and stick plot.
% h(2) is upper bound
% h(3) is lower bound
h(2).Color = Promare{3}; h(2).LineStyle = '--';
h(3).Color = Promare{3}; h(3).LineStyle = '--';
h(1).Color = Promare{7}; 
ax = gca; ax.GridColor = 'none'; ax.TickLength = [0,0];
ax.FontWeight = 'bold'; ax.LineWidth = 1;
title('')
ylabel('Winter Flow')
xlabel('Lag (years)')

subplot(4,3,11)
[acf, lags, bounds, h] = autocorr(WinterMeanFlow(:,2), 'NumLags', 10);
% h(1) is the ball and stick plot.
% h(2) is upper bound
% h(3) is lower bound
h(2).Color = Promare{3}; h(2).LineStyle = '--';
h(3).Color = Promare{3}; h(3).LineStyle = '--';
h(1).Color = Promare{7}; 
ax = gca; ax.GridColor = 'none'; ax.TickLength = [0,0];
ax.FontWeight = 'bold'; ax.LineWidth = 1;
title('')
ylabel('')
xlabel('Lag (years)')

subplot(4,3,12)
[acf, lags, bounds, h] = autocorr(WinterMaxFlow(:,2), 'NumLags', 10);
% h(1) is the ball and stick plot.
% h(2) is upper bound
% h(3) is lower bound
h(2).Color = Promare{3}; h(2).LineStyle = '--';
h(3).Color = Promare{3}; h(3).LineStyle = '--';
h(1).Color = Promare{7}; 
ax = gca; ax.GridColor = 'none'; ax.TickLength = [0,0];
ax.FontWeight = 'bold'; ax.LineWidth = 1;
title('')
ylabel('')
xlabel('Lag (years)')