years = readtable("D:\Documents\Research\CDOM\Thesis Materials\Spreadsheets\AvgYears.xlsx");
years(end,:) = [];

dates = datetime(1:365', 'ConvertFrom', 'datenum');

figure
cols = {[203 160 82]./255;
    [32 92 64]./255;
    [29 31 42]./255};
subplot(2,1,1)
h(1) = plot(dates, years.LowYear, '-', 'Color', cols{1});
hold on
h(2) = plot(dates, years.AvgYear, '-', 'Color', cols{2});
h(3) = plot(dates, years.HighYear, '-', 'Color', cols{3});
set(h, 'LineWidth', 1.5)
legend(h, {'Low Year','Average Year', 'High Year'}, 'Location', 'northeast')
ax = gca;
set(ax, 'Box', 'on', 'LineWidth',1)
ylabel('Color PCU')

subplot(2,1,2)
h(1) = plot(dates, years.LowYearStdDev, '-', 'Color', cols{1});
hold on
h(2) = plot(dates, years.AvgYearStdDev, '-', 'Color', cols{2});
h(3) = plot(dates, years.HighYearStdDev, '-', 'Color', cols{3});
set(h, 'LineWidth', 1.5)
%legend(h, {'Low Year','Average Year', 'High Year'}, 'Location', 'northeast')
ax = gca;
set(ax,'Box', 'on', 'LineWidth',1)
ylabel('Std. Dev., PCU'); xlabel('Date');
