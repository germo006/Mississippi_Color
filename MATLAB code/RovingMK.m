%% Noah Germolus, 14 Jan 2018
% This function evaluates the presence or absence of trend in ten-point
% groups and outputs a vector of p-values, and a vector of values either +,
% N, or - corresponding to the direction of trend.
% UPDATE 18 May 2020: This code now calculates a vector S, which are the
% Theil-Sen robust slope estimates for those cases where the interval has a
% significant trend. Because this is a really janky retrofit, it assumes
% the intervals (independent var) are all 1, and it uses Z. Danziger's code
% from the MATLAB File Exchange. 

function [S, Hval, pvals] = RovingMK(V, alpha)

Hval = zeros(length(V)-9,1);
pvals = zeros(length(V)-9,1);
S = zeros(length(V)-9,1);

for ii = 1:length(V)-9
    [Hvaliter,pvaliter] = Mann_Kendall(V(ii:ii+9,1),alpha);
    Hval(ii) = Hvaliter;
    pvals(ii) = pvaliter;
    if pvaliter < alpha
        [S(ii), ~] = TheilSen([[1:10]', V(ii:ii+9,1)]);
    else
        S(ii) = NaN;
    end
end

for jj = 1:length(Hval)
    if Hval(jj) == 1
        Hval(jj) = '+';
    elseif Hval(jj) == -1
        Hval(jj) = '-';
    else
        Hval(jj) = 'N';
    end
end

Hval = char(Hval);
%disp(pvals);
end