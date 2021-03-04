%% Noah Germolus 29 May 2020
% This is literally just a plot generator.

load('redoNullex_10Jan2021.mat')
load('NoahMaps.mat') % Using the Promare color scheme for some graphs.
%nullex(:,5) = nullex(:,5).*0.0283168;
outfolder = "../Figures/";

%% Overall Dataset Plot

f = figure('Position', [100,100,1200,600],'Units','inches');

subplot(2,1,1)
h1 = plot(datetime(nullex(367:end,1:3)), nullex(367:end,4));
h1.LineWidth = 0.5;
h1.Color = [0.7 0.6 0.5];
xlabel('Date', 'Interpreter','tex');
ylabel('Color (PCU)', 'Interpreter','tex');
ax = gca; ax.FontName = 'arial'; ax.Box = 'on'; ax.LineWidth = 1; 
ax.FontWeight = 'bold';

subplot(2,1,2)
h1 = plot(datetime(nullex(367:end,1:3)), nullex(367:end,5));
h1.LineWidth = 0.5;
h1.Color = [0.3, 0.2, 1.0];
xlabel('Date', 'Interpreter','tex');
ylabel('Discharge (m^3 s^{-1})', 'Interpreter','tex');
ax = gca; ax.FontName = 'arial'; ax.Box = 'on'; ax.LineWidth = 1; 
ax.FontWeight = 'bold';

exportgraphics(f, outfolder+"wholedata.tif", 'Resolution', 600)
close(f)
%% Yearly Stats.

YearGroups = findgroups(nullex(:,1));

f = figure('Position', [100,100,900,600],'Units','inches');
subplot(2,1,1)
h(1) = plot(Year, splitapply(@nanmax, nullex(:,4), YearGroups),':', 'Color', Promare{8});
hold on
h(2) = plot(Year, splitapply(@nanmean, nullex(:,4), YearGroups),'-.', 'Color', Promare{1});
h(3) = plot(Year, splitapply(@nanmin, nullex(:,4), YearGroups),'-', 'Color', Promare{5});
h(1).LineWidth = 1.5;h(2).LineWidth = 1.5;h(3).LineWidth = 1.5;
legend({'Yearly Peak','Yearly Mean','Yearly Min'},'Location','northoutside','NumColumns', 3)
ylabel('Color (PCU)')
set(gca, 'LineWidth', 1, 'FontWeight', 'bold')

subplot(2,1,2)
h(1) = plot(Year, splitapply(@nanmax, nullex(:,5), YearGroups),':', 'Color', Promare{8});
hold on
h(2) = plot(Year, splitapply(@nanmean, nullex(:,5), YearGroups),'-.', 'Color', Promare{1});
h(3) = plot(Year, splitapply(@nanmin, nullex(:,5), YearGroups),'-', 'Color', Promare{5});
h(1).LineWidth = 1.5;h(2).LineWidth = 1.5;h(3).LineWidth = 1.5;
xlabel('Year'); ylabel('Discharge (m^3 s^{-1})', 'Interpreter','tex');
set(gca, 'LineWidth', 1, 'FontWeight', 'bold')

exportgraphics(f, outfolder+"YearStats.tif", 'Resolution', 600)
close(f)

%% Power Spectra

load('periodograms.mat')
f = figure('Position', [100,100,900,400],'Units','inches');
plot(DischargePeriodogram.Period./365, DischargePeriodogram.SpectralDensity,...
    '-', 'LineWidth', 1 ,'Color',Promare{1});
ylabel('Spectral Density (Discharge)')
xlabel('Period Length (Years)')
hold on

ylim([0,10^10])
yyaxis('right')
plot(ColorPeriodogram.Period./365, ColorPeriodogram.SpectralDensity,...
    '-', 'LineWidth', 1,'Color' ,Promare{2});
legend({'Discharge','Color'}, 'Location', 'northeast')
line([1,1], [0,10^12], 'Color', Promare{5}, 'LineWidth', 0.75, 'HandleVisibility', 'off');
line(2.*[1,1], [0,10^12], 'Color', Promare{5}, 'LineWidth', 0.75, 'HandleVisibility', 'off');
line(3.*[1,1], [0,10^12], 'Color', Promare{5}, 'LineWidth', 0.75, 'HandleVisibility', 'off');
line(4.*[1,1], [0,10^12], 'Color', Promare{5}, 'LineWidth', 0.75, 'HandleVisibility', 'off');
line(5.*[1,1], [0,10^12], 'Color', Promare{5}, 'LineWidth', 0.75, 'HandleVisibility', 'off');
line(6.*[1,1], [0,10^12], 'Color', Promare{5}, 'LineWidth', 0.75, 'HandleVisibility', 'off');
line(7.*[1,1], [0,10^12], 'Color', Promare{5}, 'LineWidth', 0.75, 'HandleVisibility', 'off');
line(0.5.*[1,1], [0,10^12], 'Color', Promare{5}, 'LineWidth', 0.5,...
    'HandleVisibility', 'off', 'LineStyle', ':');
line(8.*[1,1], [0,10^12], 'Color', Promare{5}, 'LineWidth', 0.75, 'HandleVisibility', 'off');
line(9.*[1,1], [0,10^12], 'Color', Promare{5}, 'LineWidth', 0.75, 'HandleVisibility', 'off');
line(0.3333.*[1,1], [0,10^12], 'Color', Promare{5}, 'LineWidth', 0.5,...
    'HandleVisibility', 'off', 'LineStyle', ':');
line(11.*[1,1], [0,10^12], 'Color', Promare{5}, 'LineWidth', 0.75, 'HandleVisibility', 'off');
line(16.*[1,1], [0,10^12], 'Color', Promare{5}, 'LineWidth', 0.75, 'HandleVisibility', 'off');
ylim([0,10^5]); ylabel('Spectral Density (Color)');
set(gca, 'LineWidth', 1, 'FontWeight', 'bold','YColor','k',...
    'XScale', 'log')%, 'XTickLabelMode', 'manual')
xlim([10^2, 10^4]./365)
xticks([0.333,0.5,1:9,11,16])

exportgraphics(f, outfolder+"SpecDens.tif", 'Resolution', 600)
close(f)

%% Histograms

lQ = log10(nullex(:,5)); lC = log10(nullex(:,4));

f = figure('Position', [100,100,900,900],'Units','inches');
subplot(2,2,1)
histogram(lC, 15, 'EdgeColor', Promare{2}, 'FaceColor', Promare{4}, 'Normalization', 'probability')
ylabel('Relative Frequency'); xlabel('log_{10}(C)', 'Interpreter','tex')
xlim([0.75, 2.5]); set(gca, 'LineWidth', 1, 'FontWeight', 'bold');

subplot(2,2,2)
histogram(lQ, 15, 'EdgeColor', Promare{2}, 'FaceColor', Promare{4}, 'Normalization', 'probability')
xlabel('log_{10}(Q)', 'Interpreter','tex')
xlim([1, 3.5]); set(gca, 'LineWidth', 1, 'FontWeight', 'bold'); ylim([0,0.25]);

subplot(2,2,3)
histogram(nullex(:,4), 15, 'EdgeColor', Promare{2}, 'FaceColor', Promare{4}, 'Normalization', 'probability')
ylabel('Relative Frequency'); xlabel('Untransformed C', 'Interpreter','tex')
xlim([0, 150]); set(gca, 'LineWidth', 1, 'FontWeight', 'bold');

subplot(2,2,4)
histogram(nullex(:,5), 25, 'EdgeColor', Promare{2}, 'FaceColor', Promare{4}, 'Normalization', 'probability')
xlabel('Untransformed Q', 'Interpreter','tex')
xlim([-100, 2000]); set(gca, 'LineWidth', 1, 'FontWeight', 'bold'); ylim([0,0.5]);

exportgraphics(f, outfolder+"histograms.tif", 'Resolution', 600)
close(f)

%% Precip-Year separations.

% Straight up ripped this code from SplitFlowYears.m
% New in Jan 2021: use of 12-mo SPI supercedes the single-station precip
load('SPIyr.mat')
[~, ia, ~] = unique(spi{:,1});
spi_yr = spi{ia, 2};
hispi = Year(spi_yr > prctile(spi_yr, 66), 1);
lospi = Year(spi_yr < prctile(spi_yr, 33), 1);
avspi = Year(spi_yr < prctile(spi_yr, 66) & spi_yr > prctile(spi_yr, 33), 1);

precipCum = [unique(nullex(:,1)), splitapply(@sum, nullex(:,7), YearGroups)];
HighYrs = precipCum(precipCum(:,2)>prctile(precipCum(:,2),66) ,1);
LowYrs = precipCum(precipCum(:,2)<prctile(precipCum(:,2),33) ,1);
AvgYrs = precipCum(precipCum(:,2)<prctile(precipCum(:,2),66)&precipCum(:,2)>prctile(precipCum(:,2),33) ,1);

hidiff = (sum(~ismember(hispi, HighYrs)))/length(hispi);
lodiff = (sum(~ismember(lospi, LowYrs)))/length(lospi);
avdiff = (sum(~ismember(avspi, AvgYrs)))/length(avspi);

nullHigh = nullex(ismember(nullex(:,1),hispi),:);
nullLow = nullex(ismember(nullex(:,1),lospi),:);
nullAvg = nullex(ismember(nullex(:,1),avspi),:);

nullHigh(nullHigh(:,2)==2&nullHigh(:,3)==29,:) = [];
nullLow(nullLow(:,2)==2&nullLow(:,3)==29,:) = [];
nullAvg(nullAvg(:,2)==2&nullAvg(:,3)==29,:) = [];

nh = length(hispi); nl = length(lospi); na = length(avspi);

highFlow = reshape(nullHigh(:,5), [365, nh]);
lowFlow = reshape(nullLow(:,5), [365, nl]);
avgFlow = reshape(nullAvg(:,5), [365, na]);

highFlow_avg = mean(highFlow, 2); sdHi = std(highFlow, 0, 2);
lowFlow_avg = mean(lowFlow, 2); sdLo = std(lowFlow, 0, 2);
avgFlow_avg = mean(avgFlow, 2); sdAvg = std(avgFlow, 0, 2);

% Some standard error on the mean...
seHi = sdHi./sqrt(nh); seLo = sdLo./sqrt(nl); seAvg = sdAvg./sqrt(na); 

dates = datetime(1:365', 'ConvertFrom', 'datenum');

f = figure('Position', [100,100,900,600],'Units','inches');
subplot(2,1,2)

h(1) = fill([dates, fliplr(dates)],...
    [highFlow_avg' + seHi', fliplr(highFlow_avg' - seHi')],...
    Promare{1}, 'EdgeColor', 'none', 'FaceAlpha', 0.2);
hold on
h(2) = plot(dates, highFlow_avg, 'Color', Promare{1}.*[0.5,0.5,1.1], 'LineWidth', 1,...
    'LineStyle', '--');

j(1) = fill([dates, fliplr(dates)],...
    [lowFlow_avg' + seLo', fliplr(lowFlow_avg' - seLo')],...
    Promare{5}, 'EdgeColor', 'none', 'FaceAlpha', 0.2);
j(2) = plot(dates, lowFlow_avg, 'Color', Promare{5}, 'LineWidth', 1);

i(1) = fill([dates, fliplr(dates)],...
    [avgFlow_avg' + seAvg', fliplr(avgFlow_avg' - seAvg')],...
    Promare{7}, 'EdgeColor', 'none', 'FaceAlpha', 0.1);
i(2) = plot(dates, avgFlow_avg, 'Color', Promare{7}, 'LineWidth', 1,...
    'LineStyle','-.');


set(gca, 'LineWidth', 1, 'FontWeight', 'bold')
ylabel('Discharge (m^3 s^{-1})', 'Interpreter','tex'); xlabel('Date');

highCol = reshape(nullHigh(:,4), [365, nh]);
lowCol = reshape(nullLow(:,4), [365, nl]);
avgCol = reshape(nullAvg(:,4), [365, na]);

highCol_avg = mean(highCol, 2); sdHi = std(highCol, 0, 2);
lowCol_avg = mean(lowCol, 2); sdLo = std(lowCol, 0, 2);
avgCol_avg = mean(avgCol, 2); sdAvg = std(avgCol, 0, 2);

% Some standard error on the mean...
seHi = sdHi./sqrt(nh); seLo = sdLo./sqrt(nl); seAvg = sdAvg./sqrt(na); 

subplot(2,1,1)

h(1) = fill([dates, fliplr(dates)],...
    [highCol_avg' + seHi', fliplr(highCol_avg' - seHi')],...
    Promare{1}, 'EdgeColor', 'none', 'FaceAlpha', 0.2);
hold on
h(2) = plot(dates, highCol_avg, 'Color', Promare{1}.*[0.5,0.5,1.1], 'LineWidth', 1,...
    'LineStyle', '--');

j(1) = fill([dates, fliplr(dates)],...
    [lowCol_avg' + seLo', fliplr(lowCol_avg' - seLo')],...
    Promare{5}, 'EdgeColor', 'none', 'FaceAlpha', 0.2);
j(2) = plot(dates, lowCol_avg, 'Color', Promare{5}, 'LineWidth', 1);

i(1) = fill([dates, fliplr(dates)],...
    [avgCol_avg' + seAvg', fliplr(avgCol_avg' - seAvg')],...
    Promare{7}, 'EdgeColor', 'none', 'FaceAlpha', 0.1);
i(2) = plot(dates, avgCol_avg, 'Color', Promare{7}, 'LineWidth', 1,...
    'LineStyle','-.');

set(gca, 'LineWidth', 1, 'FontWeight', 'bold')
ylabel('Color (PCU)', 'Interpreter','tex');
legend([h(1), j(1), i(1)],{'Wet Year','Dry Year','Avg Year'},'Location','northeast')

exportgraphics(f, outfolder+"FlowYears.tif", 'Resolution', 600)
close(f)

%%
load('mk40.mat');load('NoahMaps.mat')

sY = 1947:1971; % starting years of the periods.
f = figure;
subplot(2,1,1)

h(1) = plot(sY, 1-mk.p, 'Color', Promare{7}, 'LineWidth', 1); hold on;
h(2) = plot(sY, 1-mk.p1, 'Color', Promare{1}, 'LineWidth', 1);
h(3) = plot(sY, 1-mk.p2, 'Color', Promare{3}, 'LineWidth', 1);
xlim([1947 1971]); ylim([0.8 1]);
scatter(1,1,'MarkerFaceColor', Promare{6}, 'MarkerEdgeColor', 'k', 'MarkerFaceAlpha', 0.5)
scatter(1,1,'MarkerFaceColor', Promare{5}, 'MarkerEdgeColor', 'k', 'MarkerFaceAlpha', 0.5)
ax = gca;
ax.LineWidth = 1;
ylabel('1 - P(no trend)')
ax.FontWeight = 'bold';
legend(ax, {'Mean', 'Max', 'Min', 'Decreasing', 'Increasing'})
s(1) = scatter(sY(mk.Trend=='-'), 1-mk.p(mk.Trend=='-'),...
    'MarkerFaceColor', Promare{6}, 'MarkerEdgeColor', 'k',...
    'HandleVisibility', 'off', 'MarkerFaceAlpha', 0.5);
s(2) = scatter(sY(mk.Trend=='+'), 1-mk.p(mk.Trend=='+'),...
    'MarkerFaceColor', Promare{5}, 'MarkerEdgeColor', 'k',...
    'HandleVisibility', 'off', 'MarkerFaceAlpha', 0.5);
s(3) =  scatter(sY(mk.Trend1=='-'), 1-mk.p1(mk.Trend1=='-'),...
    'MarkerFaceColor', Promare{6}, 'MarkerEdgeColor', 'k',...
    'HandleVisibility', 'off', 'MarkerFaceAlpha', 0.5);
s(4) = scatter(sY(mk.Trend1=='+'), 1-mk.p1(mk.Trend1=='+'),...
    'MarkerFaceColor', Promare{5}, 'MarkerEdgeColor', 'k',...
    'HandleVisibility', 'off', 'MarkerFaceAlpha', 0.5);
s(5) =  scatter(sY(mk.Trend2=='-'), 1-mk.p2(mk.Trend2=='-'),...
    'MarkerFaceColor', Promare{6}, 'MarkerEdgeColor', 'k',...
    'HandleVisibility', 'off', 'MarkerFaceAlpha', 0.5);
s(6) = scatter(sY(mk.Trend2=='+'), 1-mk.p2(mk.Trend2=='+'),...
    'MarkerFaceColor', Promare{5}, 'MarkerEdgeColor', 'k',...
    'HandleVisibility', 'off', 'MarkerFaceAlpha', 0.5);
plot(sY, 0.95*ones(size(sY)), '--', 'Color', [0.5 0.5 0.5],...
    'HandleVisibility', 'off')

yyaxis right
ax2 = gca; ax2.YColor = 'k'; ax2.YTickLabel = '';
ylabel('Summer')

subplot(2,1,2)

h(1) = plot(sY, 1-mk.p8, 'Color', Promare{7}, 'LineWidth', 1); hold on;
h(2) = plot(sY, 1-mk.p9, 'Color', Promare{1}, 'LineWidth', 1);
h(3) = plot(sY, 1-mk.p10, 'Color', Promare{3}, 'LineWidth', 1);
xlim([1947 1971]); ylim([0.8 1]);
ax = gca;
ax.LineWidth = 1;
ylabel('1 - P(no trend)')
plot(sY, 0.95*ones(size(sY)), '--', 'Color', [0.5 0.5 0.5],...
    'HandleVisibility', 'off')
ax.FontWeight = 'bold';
s(1) = scatter(sY(mk.Trend8=='-'), 1-mk.p8(mk.Trend8=='-'),...
    'MarkerFaceColor', Promare{6}, 'MarkerEdgeColor', 'k',...
    'HandleVisibility', 'off', 'MarkerFaceAlpha', 0.5);
s(2) = scatter(sY(mk.Trend8=='+'), 1-mk.p8(mk.Trend8=='+'),...
    'MarkerFaceColor', Promare{5}, 'MarkerEdgeColor', 'k',...
    'HandleVisibility', 'off', 'MarkerFaceAlpha', 0.5);
s(3) =  scatter(sY(mk.Trend9=='-'), 1-mk.p9(mk.Trend9=='-'),...
    'MarkerFaceColor', Promare{6}, 'MarkerEdgeColor', 'k',...
    'HandleVisibility', 'off', 'MarkerFaceAlpha', 0.5);
s(4) = scatter(sY(mk.Trend9=='+'), 1-mk.p9(mk.Trend9=='+'),...
    'MarkerFaceColor', Promare{5}, 'MarkerEdgeColor', 'k',...
    'HandleVisibility', 'off', 'MarkerFaceAlpha', 0.5);
s(5) =  scatter(sY(mk.Trend10=='-'), 1-mk.p10(mk.Trend10=='-'),...
    'MarkerFaceColor', Promare{6}, 'MarkerEdgeColor', 'k',...
    'HandleVisibility', 'off', 'MarkerFaceAlpha', 0.5);
s(6) = scatter(sY(mk.Trend10=='+'), 1-mk.p10(mk.Trend10=='+'),...
    'MarkerFaceColor', Promare{5}, 'MarkerEdgeColor', 'k',...
    'HandleVisibility', 'off', 'MarkerFaceAlpha', 0.5);

yyaxis right
ax2 = gca; ax2.YColor = 'k'; ax2.YTickLabel = '';
ylabel('Winter')
xlabel('40-Year Period Start Year')
exportgraphics(gcf, outfolder+"MK40.tif", 'Resolution', 600)
close(gcf)