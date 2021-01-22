%% Noah Germolus, 24 March 2018
% How about some R E G R E S S I O N S

setDefaultFigs 

FitTable = array2table(nullex{:,1:7}, 'VariableNames', {'Y','M','d','C','Q','T','P'});
FitTable.datenums = datenum(FitTable.Y,FitTable.M,FitTable.d);
FitTable.logQ = log10(FitTable.Q);% - min(FitTable.Q));
FitTable.lagQ = [NaN;NaN;NaN;NaN;FitTable.Q(1:end-4)];%-min(FitTable.Q(1:end-4))];
FitTable.loglagQ = log10(FitTable.lagQ);
FitTable.logC = log10(FitTable.C);
FitTable.sine = sin(FitTable.datenums*2*pi./365.25);
FitTable.cosine = cos(FitTable.datenums*2*pi./365.25);
FitTable.dater = FitTable.datenums(:,1) - FitTable.datenums(1);

mdl_lagQ = fitlm(FitTable, 'C ~ lagQ');
mdl_logQ = fitlm(FitTable, 'logC ~ logQ');
mdl_loglagQ = fitlm(FitTable, 'logC ~ loglagQ');
mdl_time = fitlm(FitTable, 'logC ~ loglagQ + sine + cosine');
mdl_timetr = fitlm(FitTable, 'logC ~ loglagQ + sine + cosine + dater');
mdl_time2 = fitlm(FitTable,...
    'logC ~ loglagQ + sine + cosine + dater + loglagQ^2');

subplot(5,1,1)
plot(mdl_lagQ)
subplot(5,1,2)
plot(mdl_loglagQ)
subplot(5,1,3)
plot(mdl_time)
subplot(5,1,4)
plot(mdl_timetr)
subplot(5,1,5)
plot(mdl_time2)

lagQtab = anova(mdl_lagQ)
loglagQtab = anova(mdl_loglagQ)
timetab = anova(mdl_time)
timetrtab = anova(mdl_timetr)
time2tab = anova(mdl_time2)

AdjR = [mdl_lagQ.Rsquared.Adjusted, mdl_logQ.Rsquared.Adjusted,...
    mdl_loglagQ.Rsquared.Adjusted,...
    mdl_time.Rsquared.Adjusted, mdl_timetr.Rsquared.Adjusted,...
    mdl_time2.Rsquared.Adjusted].';
MSEs = [mdl_lagQ.MSE, 10.^[mdl_logQ.MSE, mdl_loglagQ.MSE,...
    mdl_time.MSE, mdl_timetr.MSE,...
    mdl_time2.MSE]].';
RMSEs = [mdl_lagQ.RMSE, 10.^[mdl_logQ.RMSE, mdl_loglagQ.RMSE,...
    mdl_time.RMSE, mdl_timetr.RMSE,...
    mdl_time2.RMSE]].';
meanres = 10.^([nanmean(mdl_lagQ.Residuals.Raw), ...
    nanmean(mdl_logQ.Residuals.Raw), ...
    nanmean(mdl_loglagQ.Residuals.Raw),...
    nanmean(mdl_time.Residuals.Raw), nanmean(mdl_timetr.Residuals.Raw),...
    nanmean(mdl_time2.Residuals.Raw)]).';
maxres = 10.^([log10(nanmax(abs(mdl_lagQ.Residuals.Raw))), ...
    nanmax(abs(mdl_logQ.Residuals.Raw)),...
    nanmax(abs(mdl_loglagQ.Residuals.Raw)),...
    nanmax(abs(mdl_time.Residuals.Raw)), ...
    nanmax(abs(mdl_timetr.Residuals.Raw)),...
    nanmax(abs(mdl_time2.Residuals.Raw))]).';
AICc = [mdl_lagQ.ModelCriterion.AICc,...
    mdl_logQ.ModelCriterion.AICc,...
    mdl_loglagQ.ModelCriterion.AICc,...
    mdl_time.ModelCriterion.AICc,...
    mdl_timetr.ModelCriterion.AICc,...
    mdl_time2.ModelCriterion.AICc].';
BIC = [mdl_lagQ.ModelCriterion.BIC,...
    mdl_logQ.ModelCriterion.BIC,...
    mdl_loglagQ.ModelCriterion.BIC,...
    mdl_time.ModelCriterion.BIC,...
    mdl_timetr.ModelCriterion.BIC,...
    mdl_time2.ModelCriterion.BIC].';

RegressStats = table(AdjR, MSEs, RMSEs, meanres, maxres, AICc, BIC, 'RowNames',...
    {'lagQ','logQ','loglagQ','time','timetr','time2'}, 'VariableNames', {'AdjR',...
    'MSE','RMSE','meanresidual','maxresidual','AICc','BIC'});
%% Plotting residuals

figure
subplot(5,1,1)
plot(1:size(mdl_lagQ.Residuals.Raw,1),mdl_lagQ.Residuals.Raw)
ylabel('Model 1 Residual [PCU]')
subplot(5,1,2)
plot(1:size(mdl_loglagQ.Residuals.Raw,1),10.^mdl_loglagQ.Residuals.Raw)
ylabel('Model 2 Residual [PCU]')
subplot(5,1,3)
plot(1:size(mdl_time.Residuals.Raw,1),10.^mdl_time.Residuals.Raw)
ylabel('Model 3 Residual [PCU]')
subplot(5,1,4)
plot(1:size(mdl_timetr.Residuals.Raw,1),10.^mdl_timetr.Residuals.Raw)
ylabel('Model 4 Residual [PCU]')
subplot(5,1,5)
plot(1:size(mdl_time2.Residuals.Raw,1),10.^mdl_time2.Residuals.Raw)
xlabel('Record Number')
ylabel('Model 5 Residual [PCU]')

%% Are the residuals normally distributed?
[hist_lagQ, bin_lagQ] = hist(mdl_lagQ.Residuals.Raw, 25);
[hist_loglagQ, bin_loglagQ] = hist(mdl_loglagQ.Residuals.Raw, 25);
[hist_time, bin_time] = hist(mdl_time.Residuals.Raw, 25);
[hist_timetr, bin_timetr] = hist(mdl_timetr.Residuals.Raw, 25);
[hist_time2, bin_time2] = hist(mdl_time2.Residuals.Raw, 25);

figure
subplot(1,5,1)
bar(bin_lagQ, hist_lagQ)
title('Model 1')
xlabel('Model Residual [PCU]')
ylabel('frequency')
subplot(1,5,2)
bar(bin_loglagQ, hist_loglagQ)
xlabel('Model Residual [PCU]')
title('Model 2')
subplot(1,5,3)
bar(bin_time, hist_time)
xlabel('Model Residual [PCU]')
title('Model 3')
subplot(1,5,4)
bar(bin_timetr, hist_timetr)
xlabel('Model Residual [PCU]')
title('Model 4')
subplot(1,5,5)
bar(bin_time2, hist_time2)
xlabel('Model Residual [PCU]')
title('Model 5')

H_lagQ   = lillietest(mdl_lagQ.Residuals.Raw)
H_loglagQ= lillietest(mdl_loglagQ.Residuals.Raw)
H_time   = lillietest(mdl_time.Residuals.Raw)
H_timetr = lillietest(mdl_timetr.Residuals.Raw)
H_time2  = lillietest(mdl_time2.Residuals.Raw)



%% Original figure for lag justification
figure
subplot(1,2,1)
dummy = fitlm(FitTable,'logC ~ logQ');
plot(dummy)
title(['Non-Lagged (adj. R^2 =' num2str(round(dummy.Rsquared.Adjusted,3)) ')'],...
    'interpreter', 'tex')
ylabel('log_{10}(Color)','interpreter', 'tex')
xlabel('log_{10}(Q_t)','interpreter', 'tex')
ax = gca;
ax.TickLength = [0,0];
ax.LineWidth = 1; ax.FontName = 'Arial';
ax.Children(2).Visible = 'off';

subplot(1,2,2)
dummy = fitlm(FitTable,'logC ~ loglagQ');
plot(dummy)
title(['Lagged (adj. R^2 =' num2str(round(dummy.Rsquared.Adjusted,3)) ')'],...
    'interpreter', 'tex')
xlabel('log_{10}(Q_{t-4})','interpreter', 'tex')
ax = gca;
ax.TickLength = [0,0];
ax.LineWidth = 1; ax.FontName = 'Arial';
ax.Children(2).Visible = 'off';




%clear datenums Q logQ lagQ loglagQ C logC P