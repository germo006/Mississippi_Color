%% Noah Germolus 10 Jan 2021

% This is a wrapper for mkt.m that also performs Thiel-Sen slope estimation
% for the period of significance.

function [spanyears, slp, mag, lf] = tsr(X, year, l, a)

% INPUT %%%%%%%%%%%%%
% X     = Time-series of yearly data where the first row needs removal.
%           X(:,1) are the years, X(:,2) are the data.
% year  = The year at which trend-testing should begin
% l     = The beginning (minimum) window length.
% a     = Significance level (default 0.05)
%
% OUTPUT %%%%%%%%%%%%
% spanyears     = Years of the optimum trend.
% slp           = Thiel-Sen slope estimator, units of [data units]/yr
% lf            = Length of the optimum trend.
% mag           = Magnitude of the trend, slp*lf.

spanyears = mkt(X, year, l, a);

[~,ia,~] = intersect(X(:,1),spanyears);

[slp, ~] = TheilSen(X(ia,:));

lf = length(spanyears);

mag = slp*lf;

end