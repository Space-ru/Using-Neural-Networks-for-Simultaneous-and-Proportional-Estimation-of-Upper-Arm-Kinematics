clear all;
close all;
clc;
for trialnumber = 1:10 % adjust accordingly
% Used for creation of a model per trial
%clearvars -except trialnumber
    
if trialnumber == 1
    filename = 'Sub3_Sin1XZ_1.csv';           % File from which EMG and joint angle are read.
    filename2 = 'TestTrial1.mat';      % File to which corresponding features and angle are written.
elseif trialnumber == 2
    filename = 'Sub3_Sin1XZ_2.csv';
    filename2 = 'TestTrial2.mat';
elseif trialnumber == 3
    filename = 'Sub3_Sin1XZ_3.csv';
    filename2 = 'TestTrial3.mat';
elseif trialnumber == 4
    filename = 'Sub3_Sin1XZ_4.csv';
    filename2 = 'TestTrial4.mat';
elseif trialnumber == 5
    filename = 'Sub3_Sin1XZ_5.csv';
    filename2 = 'TestTrial5.mat';
elseif trialnumber == 6
    filename = 'Sub3_Sin1XZ_6.csv';
    filename2 = 'TestTrial6.mat';
elseif trialnumber == 7
    filename = 'Sub3_Sin1XZ_7.csv';
    filename2 = 'TestTrial7.mat';
elseif trialnumber == 8
    filename = 'Sub3_Sin1XZ_8.csv';
    filename2 = 'TestTrial8.mat';
elseif trialnumber == 9
    filename = 'Sub3_Sin1XZ_9.csv';
    filename2 = 'TestTrial9.mat';
elseif trialnumber == 10
    filename = 'Sub3_Sin1XZ_10.csv';
    filename2 = 'TestTrial10.mat';
end

xlrange = 'U6:U42005';
xlrange2 = 'V6:V42005';
X1range = 'I42012:I46211';
Y1range = 'J42012:J46211';
Z1range = 'K42012:K46211';
X2range = 'F42012:F46211';
Y2range = 'G42012:G46211';
Z2range = 'H42012:H46211';
X3range = 'C42012:C46211';
Y3range = 'D42012:D46211';
Z3range = 'E42012:E46211';

BicepsEMG = xlsread(filename, xlrange); %42000 readings for 42s
TricepsEMG = xlsread(filename,xlrange2);


time1 = 0.001:0.001:42;
time2 = 0.01:0.01:42;

ViconX1 = xlsread(filename,X1range);  % SHOULDER
ViconY1 = xlsread(filename,Y1range);
ViconZ1 = xlsread(filename,Z1range);
ViconX2 = xlsread(filename,X2range);  % ELBOW
ViconY2 = xlsread(filename,Y2range);
ViconZ2 = xlsread(filename,Z2range);
ViconX3 = xlsread(filename,X3range);  % Wrist
ViconY3 = xlsread(filename,Y3range);
ViconZ3 = xlsread(filename,Z3range);

A = ((ViconX1 - ViconX2).*(ViconX3 - ViconX2)) + ((ViconY1 - ViconY2).*(ViconY3 - ViconY2)) + ((ViconZ1 - ViconZ2).*(ViconZ3 - ViconZ2));

B = sqrt(((ViconX1 - ViconX2).^2) + ((ViconY1 - ViconY2).^2) + ((ViconZ1 - ViconZ2).^2));

C = sqrt(((ViconX3 - ViconX2).^2) + ((ViconY3 - ViconY2).^2) + ((ViconZ3 - ViconZ2).^2));

VICONAngle = acosd(A./(B.*C));

figure;
subplot(3,1,1);
plot(time2, VICONAngle);
title('Joint Angle variation with time');
ylabel('Joint Angle');
xlabel('Time(s)');

subplot(3,1,2);
plot(time1, TricepsEMG);
title('Triceps EMG voltage variation with time');
ylabel('Voltage(V)');
xlabel('Time(s)');

subplot(3,1,3);
plot(time1, BicepsEMG);
title('Biceps EMG Voltage variation with time');
ylabel('Voltage(V)');
xlabel('Time(s)');


OutputAngle = VICONAngle;
B_EMG = BicepsEMG(1:10:42000);
T_EMG = TricepsEMG(1:10:42000);
DownsampledData = [OutputAngle B_EMG T_EMG];
save(filename2, 'DownsampledData');
end;