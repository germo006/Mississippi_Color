%% Noah Germolus, 10 January 2018
% This script probes nullex for the statistical average, max, and min of
%" winter" (Nov-Feb) and "summer" (May-Sept) seasons. 

%% Finding Indices
% Here, the indices of all points corresponding to summer months and winter
% months are determined.

SummerIndices = find(ismember(nullex(:,2), [5,6,7,8]));
WinterIndices = find(ismember(nullex(:,2), [11,12,1,2]));

%% Separating Seasonal Data
% Here, these indices are used to make nullex into chunks

nullexSummer = nullex(SummerIndices, :);
nullexWinter = nullex(WinterIndices, :);

%% Creating Year Groups
% Here, I group the new variables by year.

YearGroupSummer = findgroups(nullexSummer(:,1));
YearGroupWinter = findgroups(nullexWinter(:,1));

%% Applying Statistical Functions
% Here, I find the quantities of interest for the seasons.

SummerMeanColor = [Year,splitapply(@mean, nullexSummer(:,4), YearGroupSummer)];
SummerSDColor = [Year,splitapply(@std, nullexSummer(:,4), YearGroupSummer)];
SummerRangeColor = [Year,splitapply(@range, nullexSummer(:,4), YearGroupSummer)];
SummerMaxColor = [Year,splitapply(@max, nullexSummer(:,4), YearGroupSummer)];
SummerMinColor = [Year,splitapply(@min, nullexSummer(:,4), YearGroupSummer)];

WinterMeanColor = [Year,splitapply(@mean, nullexWinter(:,4), YearGroupWinter)];
WinterSDColor = [Year,splitapply(@std, nullexWinter(:,4), YearGroupWinter)];
WinterRangeColor = [Year,splitapply(@range, nullexWinter(:,4), YearGroupWinter)];
WinterMaxColor = [Year,splitapply(@max, nullexWinter(:,4), YearGroupWinter)];
WinterMinColor = [Year,splitapply(@min, nullexWinter(:,4), YearGroupWinter)];

SummerMeanFlow = [Year,splitapply(@mean, nullexSummer(:,5), YearGroupSummer)];
SummerSDFlow = [Year,splitapply(@std, nullexSummer(:,5), YearGroupSummer)];
SummerRangeFlow = [Year,splitapply(@range, nullexSummer(:,5), YearGroupSummer)];
SummerMaxFlow = [Year,splitapply(@max, nullexSummer(:,5), YearGroupSummer)];
SummerMinFlow = [Year,splitapply(@min, nullexSummer(:,5), YearGroupSummer)];

WinterMeanFlow = [Year,splitapply(@mean, nullexWinter(:,5), YearGroupWinter)];
WinterSDFlow = [Year,splitapply(@std, nullexWinter(:,5), YearGroupWinter)];
WinterRangeFlow = [Year,splitapply(@range, nullexWinter(:,5), YearGroupWinter)];
WinterMaxFlow = [Year,splitapply(@max, nullexWinter(:,5), YearGroupWinter)];
WinterMinFlow = [Year,splitapply(@min, nullexWinter(:,5), YearGroupWinter)];

SummerMeanHighT = [Year,splitapply(@mean, nullexSummer(:,6), YearGroupSummer)];
SummerSDHighT = [Year,splitapply(@std, nullexSummer(:,6), YearGroupSummer)];
SummerRangeHighT = [Year,splitapply(@range, nullexSummer(:,6), YearGroupSummer)];
SummerMaxHighT = [Year,splitapply(@max, nullexSummer(:,6), YearGroupSummer)];
SummerMinHighT = [Year,splitapply(@min, nullexSummer(:,6), YearGroupSummer)];

WinterMeanHighT = [Year,splitapply(@mean, nullexWinter(:,6), YearGroupWinter)];
WinterSDHighT = [Year,splitapply(@std, nullexWinter(:,6), YearGroupWinter)];
WinterRangeHighT = [Year,splitapply(@range, nullexWinter(:,6), YearGroupWinter)];
WinterMaxHighT = [Year,splitapply(@max, nullexWinter(:,6), YearGroupWinter)];
WinterMinHighT = [Year,splitapply(@min, nullexWinter(:,6), YearGroupWinter)];

%% GRAPHING
% This section of the code takes these new variables and plays with them. 

figure('Name','Summer Stats')

subplot(3,1,1)
hold on
title('Summer Color')
xlabel('Year')
ylabel('Color [PCU]')
scatter(SummerMinColor(:,1),SummerMinColor(:,2),36,'c','+')
scatter(SummerMaxColor(:,1),SummerMaxColor(:,2),36,'r','+')
errorbar(SummerMeanColor(:,1),SummerMeanColor(:,2),SummerSDColor(:,2),'-k') 

subplot(3,1,2)
hold on
title('Summer Flow')
xlabel('Year')
ylabel('Flow [cfs]')
scatter(SummerMinFlow(:,1),SummerMinFlow(:,2),36,'c','+')
scatter(SummerMaxFlow(:,1),SummerMaxFlow(:,2),36,'r','+')
errorbar(SummerMeanFlow(:,1),SummerMeanFlow(:,2),SummerSDFlow(:,2),'-k')

subplot(3,1,3)
hold on
title('Summer High Temperature')
xlabel('Year')
ylabel('High Temp [°F]')
scatter(SummerMinHighT(:,1),SummerMinHighT(:,2),36,'c','+')
scatter(SummerMaxHighT(:,1),SummerMaxHighT(:,2),36,'r','+')
errorbar(SummerMeanHighT(:,1),SummerMeanHighT(:,2),SummerSDHighT(:,2),'-k')

figure('Name','Winter Stats')

subplot(3,1,1)
hold on
title('Winter Color')
xlabel('Year')
ylabel('Color [PCU]')
scatter(WinterMinColor(:,1),WinterMinColor(:,2),36,'c','+')
scatter(WinterMaxColor(:,1),WinterMaxColor(:,2),36,'r','+')
errorbar(WinterMeanColor(:,1),WinterMeanColor(:,2),WinterSDColor(:,2),'-k')

subplot(3,1,2)
hold on
title('Winter Flow')
xlabel('Year')
ylabel('Flow [cfs]')
scatter(WinterMinFlow(:,1),WinterMinFlow(:,2),36,'c','+')
scatter(WinterMaxFlow(:,1),WinterMaxFlow(:,2),36,'r','+')
errorbar(WinterMeanFlow(:,1),WinterMeanFlow(:,2),WinterSDFlow(:,2),'-k')

subplot(3,1,3)
hold on
title('Winter High Temperature')
xlabel('Year')
ylabel('High Temp [°F]')
scatter(WinterMinHighT(:,1),WinterMinHighT(:,2),36,'c','+')
scatter(WinterMaxHighT(:,1),WinterMaxHighT(:,2),36,'r','+')
errorbar(WinterMeanHighT(:,1),WinterMeanHighT(:,2),WinterSDHighT(:,2),'-k')

