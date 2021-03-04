%% Noah Germolus, 26 June 2020
% This is all about evaluating whether relationships between C and Q change
% through time. I will use for this the log-log regression in model 4 from
% the paper. 

load('redoNullex_25April2020.mat', 'nullex'); load('NoahMaps.mat');
setDefaultFigs
outfolder = "../Figures/";

% Load in both the giant workhorse of a workspace and my custom Promare
% color palette

nullex(:,5) = nullex(:,5).*0.0283168; % Converting to m3/s

% Let's do this with the lag, too. Create a shifted column, where we move
% the color values four days back and pad the end with NaNs.

nullex(:,8) = [nullex(5:end,4);NaN;NaN;NaN;NaN];

% Trim off the year 1944 and the last four days

nullex([1:366, end-4:end],:) = []; %DO NOT SAVE THE FILE NOW THAT YOU HAVE 
% ALTERED NULLEX

% Now the part where we do logs
logs = [nullex(:,1:3),log10(nullex(:,[5,8]))];

% Great. Now, let's clean up.

clear nullex


% Add the harmonic time terms here. 

lintime = datenum(logs(:,1:3));
logs = [logs, sin(lintime*2*pi./365.25),cos(lintime*2*pi./365.25)];
clear lintime

logs = array2table(logs, 'VariableNames',...
    {'Y','M','d','logC','logQ','sine','cosine'});

logs.periodic = zeros(size(logs,1),1); %Set this regression parameter outside.
G = findgroups(logs.Y, logs.M);
[dates, slps,~, Rs, ps, ~] = splitapply(@ExtractModelParams, logs, G);

% plot(datetime(dates(Rs >0.5,:)), slps(Rs>0.5), 'Color', Promare{3})
% xlabel('Date'); ylabel('Linear Slope')

%%
f0 = figure('Position', [100,100,900,700], 'Units', 'inches');
for ii = 1:12
    subplot(4,3,ii)
    plot(dates(dates(:,2)==ii &ps<0.01, 1), slps(dates(:,2)==ii & ps<0.01), 'Color', Promare{5}) 
    title(month(datetime([1 ii 1]), 'name'))
    hold on
    scatter(dates(dates(:,2)==ii &ps<0.01 &slps>0, 1), slps(dates(:,2)==ii & ps<0.01 &slps>0),...
        20,'MarkerFaceColor', Promare{6}, 'MarkerEdgeColor', Promare{5})
    h = lsline; h.Color = Promare{7};
    [H, pval] = Mann_Kendall(slps(dates(:,2)==ii & ps<0.01 &slps>0), 0.05);
    text(gca, 0.65, 0.1, strjoin(['p = ', string(round(pval,3))]),...
        'Units', 'normalized')
    if pval <0.05
        h.Color = Promare{4}; h.LineWidth = 1;
    end
end
exportgraphics(f0, outfolder+"MonthTrend.tif", 'Resolution', 600)

%% The September 1988 example

s1988 = ismember( [logs.Y, logs.M],[1988, 9], 'rows');
figure
x = logs.logQ(s1988)'; y = logs.logC(s1988)'; z = zeros(flip(size(x)))';
c = [1:size(logs.logC(s1988),1)];
surface([x;x], [y;y],[z;z],[c;c],'FaceCol', 'no','EdgeCol', 'interp')
hold on
scatter(x, y, 30, Promare{3}, 'filled'); lsline;
title('September 1988'); xlabel('log_{10}Q'); ylabel('log_{10}C')
exportgraphics(gcf, outfolder+"S1988.tif", 'Resolution', 600)
close(gcf)

%% Redoing the main regressions in four groups of 16 years. 

logs.periodic = ones(size(logs,1)); %Set this regression parameter outside.
yearGroups = findgroups(logs.Y);
yG = zeros(size(yearGroups,1),1);
yG(yearGroups>48)=4; yG(yearGroups>32 & yearGroups<49)=3;
yG(yearGroups>16 & yearGroups<33)=2; yG(yearGroups<17)=1;
years = unique(logs.Y);
Periods = {
    string(years(1))+'-'+string(years(16));
    string(years(17))+'-'+string(years(32));
    string(years(33))+'-'+string(years(48));
    string(years(49))+'-'+string(years(end))
    };
[dates, slps,~, Rs, ps, SEs] = splitapply(@ExtractModelParams, logs, yG);

%% 
f1 = figure;
h(1) = bar(1:4, slps, 'EdgeColor', 'none', 'FaceColor', Promare{4});
hold on
h(2) = errorbar(1:4, slps, SEs, 'Color','k','LineStyle','none');
set(gca, 'XTickLabel', Periods, 'XTickLabelRotation', 60)
xlabel('Period of Model Fit')
ylabel('Linear Coefficient +/- SE')
exportgraphics(f1, outfolder+"FourGroups.tif", 'Resolution', 600)
close(gcf)

%% Trying expanding to one regression per year.

logs.periodic = ones(size(logs,1),1); %Set this regression parameter outside.
yG = findgroups(logs.Y);
years = unique(logs.Y);
[dates, slps, SCOS, Rs, ps, SEs] = splitapply(@ExtractModelParams, logs, yG);

%%

f1 = figure;
j = stem(years,Rs, 'Color', Promare{1}, 'Marker', 'none', 'LineWidth', 1);
hold on
ylim([0,1])
h(1) = errorbar(years, slps, SEs, 'Color','k','LineStyle','none');
hold on
h(2) = scatter(years(Rs>0.5), slps(Rs>0.5), 25,...
    'Marker','o','MarkerFaceColor', Promare{6}, 'MarkerEdgeColor', Promare{5});
ax1=gca;
set(ax1, 'XTickLabelRotation', 60)

h(3) = lsline; reg = fitlm(years(Rs>0.5), slps(Rs>0.5)); h(3).Color = [.1 .1 .1];
Mann_Kendall(slps(Rs>0.5),0.05)
Mann_Kendall(slps, 0.05)
h(4) = scatter(years(Rs<0.5), slps(Rs<0.5), 25,...
    'Marker','o','MarkerFaceColor', Promare{5}, 'MarkerEdgeColor', Promare{5});
xlabel('Period of Model Fit')
ylabel('Linear Coefficient +/- SE {\it or} R^2')
xlim([1946,2011]); ylim([0,2]);


% yyaxis right
% k(1) = scatter(years, SCOS, 15, 'Marker', 'x','MarkerEdgeColor', 'k'); k(2) = lsline;
% k(2).Color = 'k';
set(gca, 'YColor', 'k')
axes(ax1)
exportgraphics(f1, outfolder+"AllYearTrend.tif", 'Resolution', 600)
close(gcf)

%% Subroutines

function [date, slope, SCOS, R, p, SE] = ExtractModelParams(Y,M,d,logC,logQ,sine,cosine,periodic)
tableInput = table(Y,M,d,logC,logQ,sine,cosine,periodic);

if tableInput.periodic(1)>0
    regression = fitlm(tableInput, 'logC ~ logQ + sine + cosine');
    SCOS = sqrt(regression.Coefficients.Estimate(3)^2 +...
    regression.Coefficients.Estimate(4)^2);
else
    regression = fitlm(tableInput, 'logC ~ logQ');% + sine + cosine');
    SCOS = 0;
end
slope = regression.Coefficients.Estimate(2);
R = regression.Rsquared.Adjusted;
date = tableInput{1,1:3};
p = regression.Coefficients.pValue(2);
SE = regression.Coefficients.SE(2);

end