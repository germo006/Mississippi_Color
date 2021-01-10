%% Noah Germolus 07 July 2020 
% This code is primarily meant to look at associations with rainfall data. 
% In nullex, this is column 7.

load('redoNullex_25April2020.mat')
load('NoahMaps.mat')
setDefaultFigs

nullex(:,5) = nullex(:,5).*0.0283168; %Convert to m3/s

outfolder = "../Figures/";
slimNullex = nullex(nullex(:,1)>=1947,:);

P = slimNullex(:,7);

plot(datetime(slimNullex(:,1:3)), P)

N = length(P);
Pdft = fft(P);
Pdft = Pdft(1:N/2+1);
psdP = (1/(N*N)) * abs(Pdft).^2;
psdP(2:end-1) = 2*psdP(2:end-1);
freq = 0:1/length(P):1/2;
periods = 1./(365.25*freq);
plot(periods,psdP)
grid on
title('Periodogram Using FFT')
xlabel('Period (Years)')
ylabel('Power')
set(gca, 'XScale', 'log')

figure
scatter(10*log10(periodogram(P)), 10*log10(periodogram(nullex(:,5))), 2)
xlabel('scaled P periodogram')
ylabel('scaled Q periodogram')

%% Maybe use monthly precipitation totals and weekly average streamflows?
monthGroups = findgroups(nullex(nullex(:,1)>=1947,1), nullex(nullex(:,1)>=1947,2));
preciptotals = splitapply(@nansum, P, monthGroups);
wetDays = P>0;
wetTotals = splitapply(@nansum, P, monthGroups);
N = length(preciptotals);
preciptotalsdft = fft(preciptotals);
preciptotalsdft = preciptotalsdft(1:N/2+1);
psdpreciptotals = (1/(N*N)) * abs(preciptotalsdft).^2;
psdpreciptotals(2:end-1) = 2*psdpreciptotals(2:end-1);
wetTotalsdft = fft(wetTotals);
wetTotalsdft = wetTotalsdft(1:N/2+1);
psdwetTotals = (1/(N*N)) * abs(wetTotalsdft).^2;
psdwetTotals(2:end-1) = 2*psdwetTotals(2:end-1);
freq = 0:1/length(preciptotals):1/2;
periods = 1./(12*freq);
plot(periods,psdwetTotals)
grid on
title('Periodogram Using FFT')
xlabel('Period (Years)')
ylabel('Power')


%% Alright, so Pat gave me the JMP version of the P periodogram

load('periodograms.mat')
f = figure('Position', [100,100,900,400],'Units','inches');
plot(DischargePeriodogram.Period./365, DischargePeriodogram.SpectralDensity,...
    '-', 'LineWidth', 1 ,'Color',Promare{1});
ylabel('Spectral Density (Discharge)')
xlabel('Period Length (Years)')
ciDis = 2*DischargePeriodogram.Periodogram./chi2inv([0.975,0.025],2);
hold on
%plot(DischargePeriodogram.Period./365,ciDis, '--','Color', Promare{1})


ylim([0,10^10])
yyaxis('right')
plot(PrecipPeriodogram.Period./365, PrecipPeriodogram.SpectralDensity,...
    '-', 'LineWidth', 1,'Color' ,Promare{4});
legend({'Discharge','Precipitation'}, 'Location', 'northeast')
line([1,1], [0,10^12], 'Color', Promare{5}, 'LineWidth', 0.75, 'HandleVisibility', 'off');
line(0.5.*[1,1], [0,10^12], 'Color', Promare{5}, 'LineWidth', 0.5,...
    'HandleVisibility', 'off', 'LineStyle', ':');
line(0.3333.*[1,1], [0,10^12], 'Color', Promare{5}, 'LineWidth', 0.5,...
    'HandleVisibility', 'off', 'LineStyle', ':');
ylim([0,0.3]); ylabel('Spectral Density (Precipitation)');
set(gca, 'LineWidth', 1, 'FontWeight', 'bold','YColor','k',...
    'XScale', 'log')%, 'XTickLabelMode', 'manual')
xlim([10^2, 10^4]./365)
xticks([0.333,0.5,1:9,11,16])
ciP = 2*PrecipPeriodogram.Periodogram./chi2inv([0.975,0.025],2);
plot(PrecipPeriodogram.Period./365,ciP, '--','Color', Promare{4})