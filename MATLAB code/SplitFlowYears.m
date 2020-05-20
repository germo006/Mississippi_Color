nullex(:,5) = 0.0283168.*nullex(:,5);
YearGroups = findgroups(nullex(:,1));
precipCum = [unique(nullex(:,1)), splitapply(@sum, nullex(:,7), YearGroups)];
HighYrs = precipCum(precipCum(:,2)>prctile(precipCum(:,2),66) ,1);
LowYrs = precipCum(precipCum(:,2)<prctile(precipCum(:,2),33) ,1);
AvgYrs = precipCum(precipCum(:,2)<prctile(precipCum(:,2),66)&precipCum(:,2)>prctile(precipCum(:,2),33) ,1);

nullHigh = nullex(ismember(nullex(:,1),HighYrs),:);
nullLow = nullex(ismember(nullex(:,1),LowYrs),:);
nullAvg = nullex(ismember(nullex(:,1),AvgYrs),:);

nullHigh(nullHigh(:,2)==2&nullHigh(:,3)==29,:) = [];
nullLow(nullLow(:,2)==2&nullLow(:,3)==29,:) = [];
nullAvg(nullAvg(:,2)==2&nullAvg(:,3)==29,:) = [];

nh = length(HighYrs); nl = length(LowYrs); na = length(AvgYrs);

highFlow = reshape(nullHigh(:,5), [365, nh]);
lowFlow = reshape(nullLow(:,5), [365, nl]);
avgFlow = reshape(nullAvg(:,5), [365, na]);

highFlow_avg = mean(highFlow, 2); sdHi = std(highFlow, 0, 2);
lowFlow_avg = mean(lowFlow, 2); sdLo = std(lowFlow, 0, 2);
avgFlow_avg = mean(avgFlow, 2); sdAvg = std(avgFlow, 0, 2);


dates = datetime(1:365', 'ConvertFrom', 'datenum');

figure
cols = {[203 160 82]./255;
    [32 92 64]./255;
    [29 31 42]./255};
subplot(2,1,1)
h(1) = plot(dates, lowFlow_avg, '-', 'Color', cols{1});
hold on
h(2) = plot(dates, avgFlow_avg, '-', 'Color', cols{2});
h(3) = plot(dates, highFlow_avg, '-', 'Color', cols{3});
set(h, 'LineWidth', 1.5)
legend(h, {'Low Year','Average Year', 'High Year'}, 'Location', 'northeast')
ax = gca;
set(ax, 'Box', 'on', 'LineWidth',1)
ylabel('Discharge (m^3 s^{-1})')

subplot(2,1,2)
h(1) = plot(dates, sdLo, '-', 'Color', cols{1});
hold on
h(2) = plot(dates, sdAvg, '-', 'Color', cols{2});
h(3) = plot(dates, sdHi, '-', 'Color', cols{3});
set(h, 'LineWidth', 1.5)
%legend(h, {'Low Year','Average Year', 'High Year'}, 'Location', 'northeast')
ylabel('\sigma (m^3 s^{-1})')
ax = gca;
set(ax,'Box', 'on', 'LineWidth',1)