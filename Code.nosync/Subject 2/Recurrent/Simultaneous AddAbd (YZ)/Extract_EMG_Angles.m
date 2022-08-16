%% Extracting EMG and position data from CSV files obtained from Vicon
% Author: Christian Grech
% Using Excel 2013 and MATLAB R2014b
% Note: Make sure to save the CSV files as XLSX files before running this
% program. The Excel files need to be placed in the same folder as this
% file.

clear all;
close all;
clc;
%% Repeat procedure for amount of trials recorded
for trialnumber = 1:10 % adjust accordingly

if trialnumber == 1
    filename = 'Sub2_SimYZ_1.csv';           % File from which EMG and joint angle are read.
    filename2 = 'TestTrial1.mat';      % File to which corresponding features and angle are written.
elseif trialnumber == 2
    filename = 'Sub2_SimYZ_2.csv';
    filename2 = 'TestTrial2.mat';
elseif trialnumber == 3
    filename = 'Sub2_SimYZ_3.csv';
    filename2 = 'TestTrial3.mat';
elseif trialnumber == 4
    filename = 'Sub2_SimYZ_4.csv';
    filename2 = 'TestTrial4.mat';
elseif trialnumber == 5
    filename = 'Sub2_SimYZ_5.csv';
    filename2 = 'TestTrial5.mat';
elseif trialnumber == 6
    filename = 'Sub2_SimYZ_6.csv';
    filename2 = 'TestTrial6.mat';
elseif trialnumber == 7
    filename = 'Sub2_SimYZ_7.csv';
    filename2 = 'TestTrial7.mat';
elseif trialnumber == 8
    filename = 'Sub2_SimYZ_8.csv';
    filename2 = 'TestTrial8.mat';
elseif trialnumber == 9
    filename = 'Sub2_SimYZ_9.csv';
    filename2 = 'TestTrial9.mat';
elseif trialnumber == 10
    filename = 'Sub2_SimYZ_10.csv';
    filename2 = 'TestTrial10.mat';
end


%% Parameters specifications

EMGrange = 'U6:U42005';     % Bicep Range
EMGrange2 = 'V6:V42005';    % Tricep Range
EMGrange3 = 'W6:W42005';    % ADeltoid Range
EMGrange4 = 'X6:X42005';    % PDeltoid Range
EMGrange5 = 'Y6:Y42005';    % Pectoralis Range

X1range = 'C42012:C46211'; % Wrist position marker
Y1range = 'D42012:D46211';
Z1range = 'E42012:E46211';
X2range = 'F42012:F46211'; % Elbow Position marker
Y2range = 'G42012:G46211';
Z2range = 'H42012:H46211';
X3range = 'I42012:I46211'; % Shoulder position marker
Y3range = 'J42012:J46211';
Z3range = 'K42012:K46211';
X5range = 'O42012:O46211';  % Knee position marker
Y5range = 'P42012:P46211';
Z5range = 'Q42012:Q46211';

BicepsEMG = xlsread(filename, EMGrange); %42000 readings for 42s
TricepsEMG = xlsread(filename,EMGrange2);
ADeltoidEMG = xlsread(filename,EMGrange3);
PDeltoidEMG = xlsread(filename, EMGrange4);
PectoralisEMG = xlsread(filename, EMGrange5);
time1 = 0.001:0.001:42;
time2 = 0.01:0.01:42;

ViconX1 = xlsread(filename,X3range);  % SHOULDER
ViconY1 = xlsread(filename,Y3range);
ViconZ1 = xlsread(filename,Z3range);
ViconX2 = xlsread(filename,X2range);  % ELBOW
ViconY2 = xlsread(filename,Y2range);
ViconZ2 = xlsread(filename,Z2range);
ViconX3 = xlsread(filename,X1range);  % WRIST
ViconY3 = xlsread(filename,Y1range);
ViconZ3 = xlsread(filename,Z1range);
ViconX4 = xlsread(filename,X5range);  % HIP
ViconY4 = xlsread(filename,Y5range);
ViconZ4 = xlsread(filename,Z5range);

A = ((ViconX1 - ViconX2).*(ViconX3 - ViconX2)) + ((ViconY1 - ViconY2).*(ViconY3 - ViconY2)) + ((ViconZ1 - ViconZ2).*(ViconZ3 - ViconZ2));

B = sqrt(((ViconX1 - ViconX2).^2) + ((ViconY1 - ViconY2).^2) + ((ViconZ1 - ViconZ2).^2));

C = sqrt(((ViconX3 - ViconX2).^2) + ((ViconY3 - ViconY2).^2) + ((ViconZ3 - ViconZ2).^2));

ELBAngle = acosd(A./(B.*C));

F = ((ViconX2 - ViconX1).*(ViconX4 - ViconX1)) + ((ViconY2 - ViconY1).*(ViconY4 - ViconY1)) + ((ViconZ2 - ViconZ1).*(ViconZ4 - ViconZ1));

G = sqrt(((ViconX2 - ViconX1).^2) + ((ViconY2 - ViconY1).^2) + ((ViconZ2 - ViconZ1).^2));

H = sqrt(((ViconX4 - ViconX1).^2) + ((ViconY4 - ViconY1).^2) + ((ViconZ4 - ViconZ1).^2));

SHDAngle = acosd(F./(G.*H));

figure;

subplot(7,1,1);
plot(time2, ELBAngle);
title('Elbow Joint Angle variation with time');
ylabel('Joint Angle');
xlabel('Time(s)');

subplot(7,1,2);
plot(time1, BicepsEMG);
title('Biceps EMG Voltage variation with time');
ylabel('Voltage(V)');
xlabel('Time(s)');

subplot(7,1,3);
plot(time1, TricepsEMG);
title('Triceps EMG voltage variation with time');
ylabel('Voltage(V)');
xlabel('Time(s)');

subplot(7,1,4);
plot(time2, SHDAngle);
title('Shoulder Joint Angle variation with time');
ylabel('Joint Angle');
xlabel('Time(s)');

subplot(7,1,5);
plot(time1, ADeltoidEMG);
title('Ant. Deltoid EMG voltage variation with time');
ylabel('Voltage(V)');
xlabel('Time(s)');

subplot(7,1,6);
plot(time1, PDeltoidEMG);
title('Pos. Deltoid EMG voltage variation with time');
ylabel('Voltage(V)');
xlabel('Time(s)');

subplot(7,1,7);
plot(time1, PectoralisEMG);
title('Pectoralis EMG voltage variation with time');
ylabel('Voltage(V)');
xlabel('Time(s)');

OutputAngle = ELBAngle;
OutputAngle2 = SHDAngle;
B_EMG = BicepsEMG(1:10:42000);
T_EMG = TricepsEMG(1:10:42000);
D_EMG = ADeltoidEMG(1:10:42000);
PD_EMG = PDeltoidEMG(1:10:42000);
P_EMG = PectoralisEMG(1:10:42000);
DownsampledData = [OutputAngle B_EMG T_EMG OutputAngle2 D_EMG PD_EMG P_EMG];
save(filename2, 'DownsampledData')

end;
