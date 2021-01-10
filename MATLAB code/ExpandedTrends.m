%% Noah Germolus, 10 Jan 2021

% This is a script that uses tsr.m and data from the roving analysis to
% look at the magnitude of trends of intermediate length.

input = readtable('../Spreadsheets/TrendsToExpand.csv');
a = 0.05;

input.spanyearstart  = zeros(height(input),1);
input.spanyearend    = zeros(height(input),1);
input.slp            = zeros(height(input),1);
input.mag            = zeros(height(input),1);
input.lf             = zeros(height(input),1);

for ii = 1:height(input)
    stat = eval(input.stat{ii});
    [spanyears, input.slp(ii), input.mag(ii), input.lf(ii)] = ...
        tsr(stat,input.testyears(ii),input.lengthy(ii),a);
    input.spanyearstart(ii) = spanyears(1);
    input.spanyearend(ii)   = spanyears(end);
end

writetable(input, '../Spreadsheets/ExpandedTrends.csv')