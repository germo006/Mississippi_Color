%% Noah Germolus 26 April 2020

% After using the Lyne-Hollick Filter and a corresponding code by Tony
% Ladson (applied in R) I will reimport the Nullex workspace and add to it
% these calculations. 

% "High-Flow Events" will be considered as those which the streamflow is
% 50% above the baseflow. Because the Lyne-Hollick results are agnostic to
% the number per year, I will have to use a quick algorithm based on
% ice-out dates and rainfall to sort the event type. 

% Post calculating baseflow with the Lyne-Hollick filter, I'm using nullex
% as a table rather than a straight numerical matrix.

% BEWARE: As-is this script generates about 50 plots. It takes a hot minute
% to run on my laptop. 

load('redoNullex_25April2020.mat')
load('NoahMaps.mat') % Using the Promare color scheme for some graphs.
nullex = readtable('../Spreadsheets/nullexR_out.csv');
nullex(:,1) = []; % Remove an extraneous row added by R
% Convert to m3 s-1
nullex.baseflow = nullex.baseflow.*0.0283168;
nullex.discharge = nullex.discharge.*0.0283168;
% Interpolating erroneous color values.
nullex.color(nullex.color>200) = ...
    (nullex.color(find(nullex.color>200)-1) +...
    nullex.color(find(nullex.color>200)+1))./2;

%% Part 1: Discrimination/Grouping
% Each high-flow "event" will be uniquely assigned a number. No sequence of
% less than five days counts. 

nullex.IsHigh = (nullex.discharge > 1.5*nullex.baseflow);
nullex.Events = 0*nullex.discharge;
eventNum = 1;
for ii = 1:length(nullex.IsHigh)
    if nullex.IsHigh(ii) == 0 
        continue
    elseif ismember(ii, 1:5)
        continue
    elseif nullex.IsHigh(ii) == 1 && sum(nullex.IsHigh(ii-4:ii)) == 5 && nullex.IsHigh(ii+1) == 0 
        nBack = 0; nFwd = 0;
        while nullex.discharge(ii+nFwd) > nullex.discharge(ii+nFwd+1)
            nFwd = nFwd+1;
        end
        while sum(nullex.IsHigh(ii-nBack:ii)) == nBack+1 || nullex.discharge(ii-nBack) > nullex.discharge(ii-nBack-1)
            nBack = nBack+1;
        end
        nullex.Events(ii-nBack+1:ii+nFwd) = eventNum;
        eventNum = eventNum+1;
    else
        continue
    end
end

clear nBack nFwd

%% That actually worked. Very cool. Now, let's take those events and sort
% them according to their type (ice-out, rain, etc.)

JustEvents = nullex; 
JustEvents(JustEvents.Events == 0,:) = [];

IceOuts = readtable("../Spreadsheets/Ice Out.xlsx", "Sheet", "Koronis",...
    'DatetimeType', 'datetime', 'ReadVariableNames', 0);
IceOuts(:,2)=[];
IceOuts.Year = year(IceOuts.Var1);
IceOuts.Month= month(IceOuts.Var1);
IceOuts.Day = day(IceOuts.Var1);

avPrecip = nanmean(nullex.precip); avprecip9 = 9*avPrecip;
JustEvents.Type = zeros(height(JustEvents),1);

for ii = 1:length(unique(JustEvents.Events))
    iEvent = find(nullex.Events == ii);
    PrecipEvent = sum(nullex.precip(iEvent(1)-6:iEvent(1)+2));
    precRatio = PrecipEvent/avprecip9;
    
    iEvent_just = find(JustEvents.Events == ii);
    Event = JustEvents(JustEvents.Events==ii, :);
    Year = Event.year(1);
    
    if ismember(IceOuts{IceOuts.Year==Year, 2:4},...
            nullex{iEvent(1)-10:iEvent(1)+10, 1:3}, 'rows')
        JustEvents.Type(iEvent_just)=1;
    elseif precRatio>1
        JustEvents.Type(iEvent_just)=2;
    else
        JustEvents.Type(iEvent_just)=0;
    end
    
end

%% The Final Cut: Differentiating the Two Main Types.

IceOut = JustEvents(JustEvents.Type==1,:);
Rain = JustEvents(JustEvents.Type==2,:);
NoType = JustEvents(JustEvents.Type==0,:);

%% What did we end up with?
% Now, we'll look at the loops themselves. 

UniqueIce = unique(IceOut.Events); UniqueRain = unique(Rain.Events);

IceMap = winter(numel(UniqueIce));
RainMap = jet(numel(UniqueRain));

%%
for ii = 1:length(UniqueIce)
    figure
    disc = IceOut.discharge(IceOut.Events==UniqueIce(ii));
    colr = IceOut.color(IceOut.Events==UniqueIce(ii));
    yr = IceOut.year(IceOut.Events==UniqueIce(ii)); yr = yr(1);
    plot(disc, colr, 'Color',...
        IceMap(ii,:), 'LineWidth', 1.5)
    hold on
    m1 = fitlm(disc,colr);
    h = plot(m1);
    h(3).Visible = 'off'; h(4).Visible = 'off';
    h(3).HandleVisibility = 'off'; h(4).HandleVisibility = 'off';
    ax = gca;
    legend('off');
    title('')
    text(ax.XLim(1)+2, ax.YLim(2)-2, ['Year ', num2str(yr)], 'FontWeight',...
        'bold')
    ax.FontName = 'arial';
    ax.FontWeight = 'bold';
    ax.LineWidth = 1;
    ax.Box = 'on';
    ylabel('Color (PCU)')
    xlabel('Discharge (m^3/s)')
end
clear m1 disc colr yr h
%%
for ii = 1:length(UniqueRain)-100
    figure
    disc = Rain.discharge(Rain.Events==UniqueRain(ii));
    colr = Rain.color(Rain.Events==UniqueRain(ii));
    yr = Rain.year(Rain.Events==UniqueRain(ii)); yr = yr(1);
    plot(Rain.discharge(Rain.Events==UniqueRain(ii)),...
        Rain.color(Rain.Events==UniqueRain(ii)), 'Color',...
        RainMap(ii,:), 'LineWidth', 1.5)
    hold on
    m1 = fitlm(disc,colr);
    h = plot(m1);
    h(3).Visible = 'off'; h(4).Visible = 'off';
    h(3).HandleVisibility = 'off'; h(4).HandleVisibility = 'off';
    legend('off');
    title('')
    ax = gca;
    ax.FontName = 'arial';
    ax.FontWeight = 'bold';
    ax.LineWidth = 1;
    ax.Box = 'on';
    ylabel('Color (PCU)')
    xlabel('Discharge (m^3/s)')
end

clear m1 disc colr yr h
%% After examining a bunch of graphs, we want to show off UniqueRain(23) 
% and UniqueIce(4)

f = figure('Position', [100,100,900,200],'Units','inches');
subplot(1,4,2)
plot(IceOut.discharge(IceOut.Events==UniqueIce(16)),...
    IceOut.color(IceOut.Events==UniqueIce(16)), 'Color',...
    Promare{1}, 'LineWidth', 1.5)
hold on
m1 = fitlm(IceOut.discharge(IceOut.Events==UniqueIce(16)),...
    IceOut.color(IceOut.Events==UniqueIce(16)));
h = plot(m1);
h(3).Visible = 'off'; h(4).Visible = 'off'; h(1).Visible = 'off';
h(2).LineStyle = '--';
h(2).Color = Promare{5};
h(2).LineWidth = 1;
h(3).HandleVisibility = 'off'; h(4).HandleVisibility = 'off';
text(100,100,'b','FontWeight','bold')
legend('off');
title('')
ax = gca;
ax.FontName = 'arial';
ax.FontWeight = 'bold';
ax.LineWidth = 1;
ax.Box = 'on';
xlim([0 700]);ylim([30 105]);
ylabel('')
xlabel('Discharge (m^3/s)', 'Interpreter','tex')

subplot(1,4,3)
plot(Rain.discharge(Rain.Events==UniqueRain(34)),...
    Rain.color(Rain.Events==UniqueRain(34)), 'Color',...
    Promare{3}, 'LineWidth', 1.5)
hold on
m1 = fitlm(Rain.discharge(Rain.Events==UniqueRain(34)),...
    Rain.color(Rain.Events==UniqueRain(34)));
h = plot(m1);
h(3).Visible = 'off'; h(4).Visible = 'off'; h(1).Visible = 'off';
h(2).LineStyle = '--';
h(2).Color = Promare{5};
h(2).LineWidth = 1;
h(3).HandleVisibility = 'off'; h(4).HandleVisibility = 'off';
text(100,100,'c','FontWeight','bold')
legend('off');
title('')
ax = gca;
ax.FontName = 'arial';
ax.FontWeight = 'bold';
ax.LineWidth = 1;
ax.Box = 'on';
xlim([0 700]);ylim([30 105]);
ylabel('')
xlabel('Discharge (m^3/s)', 'Interpreter','tex')

subplot(1,4,1)
simFlow = 0.0283168.*(2000+19000.*sin(pi().*[1:21]'./21));
simCol = 50 + 30*sin(pi().*[1:21]'./19.5 - (5*pi()/21))-([1:21]'./3.5).^2;
plot(simFlow(1:20),...
    simCol(1:20), 'Color',...
    Promare{8}, 'LineWidth', 1.5)
hold on
m1 = fitlm(simFlow(1:20),...
    simCol(1:20));
h = plot(m1);
h(3).Visible = 'off'; h(4).Visible = 'off'; h(1).Visible = 'off';
h(2).LineStyle = '--';
h(2).Color = Promare{5};
h(2).LineWidth = 1;
h(3).HandleVisibility = 'off'; h(4).HandleVisibility = 'off';
text(100,100,'a','FontWeight','bold')
legend('off');
title('')
ax = gca;
ax.FontName = 'arial';
ax.FontWeight = 'bold';
ax.LineWidth = 1;
ax.Box = 'on';
xlim([0 700]);ylim([30 105]);
ylabel('Color (PCU)')
xlabel('Discharge (m^3/s)','Interpreter','tex')
annotation('arrow',[0.2 0.25],[0.25 0.4], 'HeadWidth', 5, 'Color', Promare{5})
annotation('arrow',[0.23 0.18],[0.5 0.35], 'HeadWidth', 5, 'Color', Promare{5})


%% An Analysis of Slope. If a linear regression is significant, keep its 
% slope and p-value for later. 
iceSlopes = zeros(length(UniqueIce), 3); %Year, Slope, pval
rainSlopes = zeros(length(UniqueRain), 3);
for ii = 1:length(UniqueIce)
    disc = IceOut.discharge(IceOut.Events==UniqueIce(ii));
    colr = IceOut.color(IceOut.Events==UniqueIce(ii));
    yr = IceOut.year(IceOut.Events==UniqueIce(ii)); yr = yr(1);
    m1 = fitlm(disc,colr);
    iceSlopes(ii,:) = [yr, m1.Coefficients.Estimate(2), m1.Coefficients.pValue(2)];
end
for ii = 1:length(UniqueRain)
    disc = Rain.discharge(Rain.Events==UniqueRain(ii));
    colr = Rain.color(Rain.Events==UniqueRain(ii));
    yr = Rain.year(Rain.Events==UniqueRain(ii)); yr = yr(1);
    m1 = fitlm(disc,colr);
    rainSlopes(ii,:) = [yr, m1.Coefficients.Estimate(2), m1.Coefficients.pValue(2)];
end
clear m1 disc colr yr h

elimIce = 100* ((length(iceSlopes) - sum(iceSlopes(:,3)>0.01))/length(iceSlopes));
iceSlopes(iceSlopes(:,3)>0.01, :) = [];
elimRain = 100* ((length(rainSlopes) - sum(rainSlopes(:,3)>0.01))/length(rainSlopes));
rainSlopes(rainSlopes(:,3)>0.01, :) = [];

%% A bit of wrangling to get the boxplot to work
types = [string(repmat('Ice Loops', size(iceSlopes,1),1));...
    string(repmat('Rain Loops', size(rainSlopes,1),1))];
subplot(1,4,4)
labs = {'Ice-Out','Rain'};
xl = ['n = ', num2str(size(iceSlopes,1)),...
    '   n = ', num2str(size(rainSlopes,1))];
boxplot([iceSlopes(:,2); rainSlopes(:,2)],types,'Labels', labs)
ax = gca;
hold on
ax.FontName = 'arial';
ax.FontWeight = 'bold';
ax.LineWidth = 1;
ax.Box = 'on';
ax.XAxis.TickLabelInterpreter = 'tex';
ax.YAxisLocation = 'Right';
xlabel(xl)
ylabel('Loop Slope (PCU m^{-3} d)')

text(0.6,0.36,'d','FontWeight','bold')
[h, p]=ttest2(iceSlopes(:,2),rainSlopes(:,2))
exportgraphics(f, "../figures/hysteresis.tif", 'Resolution', 600)
close(f)

text(0.6,0.37,'d','FontWeight','bold')
[h, p]=ttest2(iceSlopes(:,2),rainSlopes(:,2))

%% Addendum 11 June 2020
% Comparing valid loop slopes over time.

setDefaultFigs
subplot(2,1,1)
errorbar(iceSlopes(:,1), iceSlopes(:,2),...
    std(iceSlopes(:,2))*ones(length(iceSlopes),1),...
    'LineWidth', 1, 'Color', Promare{8})
ylabel('Ice-out Q-C Slope')
hold on
scatter(iceSlopes(:,1), iceSlopes(:,2), 'Marker', 'none')
lsline
% OOH. Let's do the actual regression.
rIceOut = fitlm(iceSlopes(:,1), iceSlopes(:,2)); % go ahead and look at the coeffs.
subplot(2,1,2)
rmeansl = splitapply(@mean, rainSlopes(:,2), findgroups(rainSlopes(:,1)));
plot(unique(rainSlopes(:,1)), rmeansl,...
    'LineWidth', 1, 'Color', Promare{3})
ylabel('Mean rain Q-C Slope')
xlabel('Year')
