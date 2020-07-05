%% Noah Germolus, 26 June 2020
% This is all about evaluating whether relationships between C and Q change
% through time. I will use for this the log-log regression in model 4 from
% the paper. 

load('redoNullex_25April2020.mat', 'nullex'); load('NoahMaps.mat');
setDefaultFigs

% Load in both the giant workhorse of a workspace and my custom Promare
% color palette

nullex(:,5) = nullex(:,5).*0.0283168; % Converting to m3/d

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

G = findgroups(logs(:,1), logs(:,2));

% Add the harmonic time terms here. 

lintime = datenum(logs(:,1:3));
logs = [logs, sin(lintime*2*pi./365.25),cos(lintime*2*pi./365.25)];
clear lintime

logs = array2table(logs, 'VariableNames',...
    {'Y','M','d','logC','logQ','sine','cosine'});

[dates, slps, Rs, ps] = splitapply(@ExtractModelParams, logs, G);

plot(datetime(dates(Rs >0.5,:)), slps(Rs>0.5), 'Color', Promare{3})
xlabel('Date'); ylabel('Linear Slope')

%%
figure
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
%% Subroutines

function [date, slope, R, p] = ExtractModelParams(y,m,d,logC,logQ,sine,cosine)
tableInput = table(y,m,d,logC,logQ,sine,cosine);
regression = fitlm(tableInput, 'logC ~ logQ');% + sine + cosine');
slope = regression.Coefficients.Estimate(2);
R = regression.Rsquared.Adjusted;
date = tableInput{1,1:3};
p = regression.Coefficients.pValue(2);
end