%% Noah Germolus 8 Jan 2021

% This is a wrapper script for the Mann_Kendall_Targeted.m function, and
% takes the generalized function down to give exact years for our summary
% datasets, including the part where it takes a year rather than an index. 

function spanyears = mkt(X, year, l, a)

X(1,:) = []; %delete 1944

i = find(X(:,1)==year);

[ind, ~, ~] = Mann_Kendall_Targeted(X(:,2), l, i, a);

if isnan(ind)
    spanyears = ind;
else
    spanyears = X(logical(ind),1);
end
end