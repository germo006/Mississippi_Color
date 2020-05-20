%% Noah Germolus, 10 Jan 2018
% This script builds upon the Seasons script and performs the Mann-Kendall
% test on the variables involved. The output matrix is a table containing
% trend test results.

%% Computing Trend Presence
% Harnessing Simone Fatichi's code, this section conducts M-K tests on
% season-separated variables: min, max, mean, and SD for winter and summer
% months.

alpha = 0.05;

[HMaxColorSummer, pvalMaxColorSummer] = Mann_Kendall(SummerMaxColor(2:end,2), alpha);
[HMeanColorSummer, pvalMeanColorSummer] = Mann_Kendall(SummerMeanColor(2:end,2), alpha);
[HMinColorSummer, pvalMinColorSummer] = Mann_Kendall(SummerMinColor(2:end,2), alpha);

[HMaxColorWinter, pvalMaxColorWinter] = Mann_Kendall(WinterMaxColor(2:end,2), alpha);
[HMeanColorWinter, pvalMeanColorWinter] = Mann_Kendall(WinterMeanColor(2:end,2), alpha);
[HMinColorWinter, pvalMinColorWinter] = Mann_Kendall(WinterMinColor(2:end,2), alpha);

[HMaxFlowSummer, pvalMaxFlowSummer] = Mann_Kendall(SummerMaxFlow(2:end,2), alpha);
[HMeanFlowSummer, pvalMeanFlowSummer] = Mann_Kendall(SummerMeanFlow(2:end,2), alpha);
[HMinFlowSummer, pvalMinFlowSummer] = Mann_Kendall(SummerMinFlow(2:end,2), alpha);

[HMaxFlowWinter, pvalMaxFlowWinter] = Mann_Kendall(WinterMaxFlow(2:end,2), alpha);
[HMeanFlowWinter, pvalMeanFlowWinter] = Mann_Kendall(WinterMeanFlow(2:end,2), alpha);
[HMinFlowWinter, pvalMinFlowWinter] = Mann_Kendall(WinterMinFlow(2:end,2), alpha);

if HMaxColorSummer == 1
    HMaxColorSummer = '+';
elseif HMaxColorSummer == -1
    HMaxColorSummer = '-';
else
    HMaxColorSummer = 'N';
end

if HMeanColorSummer == 1
    HMeanColorSummer = '+';
elseif HMeanColorSummer == -1
    HMeanColorSummer = '-';
else
    HMeanColorSummer = 'N';
end

if HMinColorSummer == 1
    HMinColorSummer = '+';
elseif HMinColorSummer == -1
    HMinColorSummer = '-';
else
    HMinColorSummer = 'N';
end

if HMaxColorWinter == 1
    HMaxColorWinter = '+';
elseif HMaxColorWinter == -1
    HMaxColorWinter = '-';
else
    HMaxColorWinter = 'N';
end

if HMeanColorWinter == 1
    HMeanColorWinter = '+';
elseif HMeanColorWinter == -1
    HMeanColorWinter = '-';
else
    HMeanColorWinter = 'N';
end

if HMinColorWinter == 1
    HMinColorWinter = '+';
elseif HMinColorWinter == -1
    HMinColorWinter = '-';
else
    HMinColorWinter = 'N';
end

if HMaxFlowSummer == 1
    HMaxFlowSummer = '+';
elseif HMaxFlowSummer == -1
    HMaxFlowSummer = '-';
else
    HMaxFlowSummer = 'N';
end

if HMeanFlowSummer == 1
    HMeanFlowSummer = '+';
elseif HMeanFlowSummer == -1
    HMeanFlowSummer = '-';
else
    HMeanFlowSummer = 'N';
end

if HMinFlowSummer == 1
    HMinFlowSummer = '+';
elseif HMinFlowSummer == -1
    HMinFlowSummer = '-';
else
    HMinFlowSummer = 'N';
end

if HMaxFlowWinter == 1
    HMaxFlowWinter = '+';
elseif HMaxFlowWinter == -1
    HMaxFlowWinter = '-';
else
    HMaxFlowWinter = 'N';
end

if HMeanFlowWinter == 1
    HMeanFlowWinter = '+';
elseif HMeanFlowWinter == -1
    HMeanFlowWinter = '-';
else
    HMeanFlowWinter = 'N';
end

if HMinFlowWinter == 1
    HMinFlowWinter = '+';
elseif HMinFlowWinter == -1
    HMinFlowWinter = '-';
else
    HMinFlowWinter = 'N';
end

%% Tabulation

TrendTable = table({'Max Summer Color';'Mean Summer Color';'Min Summer Color';...
    'Max Winter Color';'Mean Winter Color';'Min Winter Color';...
    'Max Summer Flow';'Mean Summer Flow';'Min Summer Flow';...
    'Max Winter Flow';'Mean Winter Flow';'Min Winter Flow'},[HMaxColorSummer;...
    HMeanColorSummer;HMinColorSummer;HMaxColorWinter;HMeanColorWinter;...
    HMinColorWinter;HMaxFlowSummer;HMeanFlowSummer;HMinFlowSummer;...
    HMaxFlowWinter;HMeanFlowWinter;HMinFlowWinter],round([pvalMaxColorSummer;...
    pvalMeanColorSummer;pvalMinColorSummer;pvalMaxColorWinter;pvalMeanColorWinter;...
    pvalMinColorWinter;pvalMaxFlowSummer;pvalMeanFlowSummer;pvalMinFlowSummer;...
    pvalMaxFlowWinter;pvalMeanFlowWinter;pvalMinFlowWinter],3));
TrendTable.Properties.VariableNames = {'Quantity' 'Trend' 'pValue'};
disp(TrendTable);
