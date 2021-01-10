%% Noah Germolus, 07 Jan 2021

function [ind, p, H] = Mann_Kendall_Targeted(V, l, i, a)

% This script is built to apply the Mann-Kendall nonparametric trend test
% in a way that "zeros in" on the longest time-scale for which a trend is
% significant. It requires 10 values at minimum, and will default to
% starting at the first ten.
%
% INPUT
% 
% V     = vector of input values where a trend occurs
% i     = index to start searching (default 1). This requires a priori
%           knowledge of where a trend might be, otherwise the 
%           function stops
% l     = length of initial search (min 10)
% a     = significance level (default 0.05)
%
% OUTPUT
% 
% ind   = boolean index of the values constituting the targeted trend. 
% p     = p-vals of the Kendall Tau at each inclusion. This is a matrix
%           where dimension 1 is values added backwards and the second
%           dimension is for values added forward. 
% H     = indicator of trend direction, 1, 0, -1 in the form of a matrix
%           the same dimensions of p

if nargin==1
    i = 1; a = 0.05; l = 10;
elseif nargin==2
    a = 0.05; i = 1;
elseif nargin==3
    a = 0.05;
end

pflagfwd = 0;
pflagbwd = 0;

start = V(i:i+l-1);
[Hs, ps] = Mann_Kendall(start, a);

if Hs==0
    disp('There is no trend in the supplied initial values supplied.')
    ind = NaN;
    p = NaN;
    H = NaN;
    scatter(1:length(start),start); lsline;
    return
end

p = nan(length(V)-length(V(i:end)), length(V)-(i+l-2));
H = p; %Preallocation

H(1,1) = Hs; p(1,1) = ps;
clear ps Hs

% ii = 1;
% if i - ii==0
%     pflagbwd=1;
% end
% 
% if ii + l-1 == length(V)
%     pflagfwd=1;
% end

for ii = 0:(length(V)-i-l+1)
    for jj = 0:(length(V) - length(V(i:end))-1)
        [Ht, pt] = Mann_Kendall(V(i-jj:i+l-1+ii),a);
        H(jj+1,ii+1) = Ht;
        p(jj+1,ii+1) = pt;
        if Ht == 0
            break
        end
    end
    if jj==0
        break
    end
end

[X,Y] = meshgrid(1:size(p,2), 1:size(p,1));
evaluator = abs((X+Y).*H);
[back,fwd] = find(evaluator == nanmax(nanmax((evaluator))));
back = back-1; fwd = fwd-1;
ind = zeros(length(V),1);
ind(i-back:i+l-1+fwd) = 1;

end
    