%% Noah Germolus  24 Jan 2018 
% This script takes the "RovingMK_30" function and makes a huge table out of a
% lot of data.

%NEED: Array of decade names and variable names. "Decades","Vars"
% Decades = num2cell(char([num2str([1947:2001].'),'-'*ones(55,1),...
%     num2str([1956:2010].')]),2);
Vars = {'Period';...
'Summer_Mean_Color';'p1';'S1';'Summer_Max_Color';'p2';'S2';...
'Summer_Min_Color';'p3';'S3';'Summer_SD_Color';'p4';'S4';...
'Summer_Mean_Flow';'p5';'S5';'Summer_Max_Flow';'p6';'S6';...
'Summer_Min_Flow';'p7';'S7';'Summer_SD_Flow';'p8';'S8';...
'Winter_Mean_Color';'p9';'S9';'Winter_Max_Color';'p10';'S10';...
'Winter_Min_Color';'p11';'S11';'Winter_SD_Color';'p12';'S12';...
'Winter_Mean_Flow';'p13';'S13';'Winter_Max_Flow';'p14';'S14';...
'Winter_Min_Flow';'p15';'S15';'Winter_SD_Flow';'p16';'S16'};

[S1, H1, p1] = RovingMK_30(SummerMeanColor(2:end,2),0.05);
[S2, H2, p2] = RovingMK_30(SummerMaxColor(2:end,2), 0.05);
[S3, H3, p3] = RovingMK_30(SummerMinColor(2:end,2), 0.05);
[S4, H4, p4] = RovingMK_30(SummerSDColor(2:end,2), 0.05);
[S5, H5, p5] = RovingMK_30(SummerMeanFlow(2:end,2), 0.05);
[S6, H6, p6] = RovingMK_30(SummerMaxFlow(2:end,2), 0.05);
[S7, H7, p7] = RovingMK_30(SummerMinFlow(2:end,2), 0.05);
[S8, H8, p8] = RovingMK_30(SummerSDFlow(2:end,2), 0.05);
[S9, H9, p9] = RovingMK_30(WinterMeanColor(2:end,2), 0.05);
[S10, H10, p10] = RovingMK_30(WinterMaxColor(2:end,2), 0.05);
[S11, H11, p11] = RovingMK_30(WinterMinColor(2:end,2), 0.05);
[S12, H12, p12] = RovingMK_30(WinterSDColor(2:end,2), 0.05);
[S13, H13, p13] = RovingMK_30(WinterMeanFlow(2:end,2), 0.05);
[S14, H14, p14] = RovingMK_30(WinterMaxFlow(2:end,2), 0.05);
[S15, H15, p15] = RovingMK_30(WinterMinFlow(2:end,2), 0.05);
[S16, H16, p16] = RovingMK_30(WinterSDFlow(2:end,2), 0.05);

TrendTableRoving = table(Thirty,...
    H1, p1, S1, H2, p2, S2, H3, p3, S3, H4, p4, S4,...
    H5, p5, S5, H6, p6, S6, H7, p7, S7, H8, p8, S8,...
    H9, p9, S9, H10, p10, S10, H11, p11, S11, H12,...
    p12, S12, H13, p13, S13, H14, p14, S14, H15, p15, S15,...
    H16, p16, S16,...
    'VariableNames',Vars);
disp(TrendTableRoving)

clear H1 H2 H3 H4 H5 H6 H7 H8 H9 H10 H11 H12 H13 H14 H15 H16
clear p1 p2 p3 p4 p5 p6 p7 p8 p9 p10 p11 p12 p13 p14 p15 p16
clear S1 S2 S3 S4 S5 S6 S7 S8 S9 S10 S11 S12 S13 S14 S15 S16

save('mk30.mat', 'TrendTableRoving')