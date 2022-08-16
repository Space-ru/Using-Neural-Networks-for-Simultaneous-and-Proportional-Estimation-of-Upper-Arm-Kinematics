clear all;
close all;
clc;
for trialnumber = 1:10 % adjust accordingly
% Used for creation of a model per trial
%clearvars -except trialnumber
    
if trialnumber == 1
    filename = 'Dynamic Trial 01.xlsx';           % File from which EMG and joint angle are read.
    filename2 = 'TestTrial1.xlsx';      % File to which corresponding features and angle are written.
elseif trialnumber == 2
    filename = 'Dynamic Trial 02.xlsx';
    filename2 = 'TestTrial2.xlsx';
elseif trialnumber == 3
    filename = 'Dynamic Trial 03.xlsx';
    filename2 = 'TestTrial3.xlsx';
elseif trialnumber == 4
    filename = 'Dynamic Trial 04.xlsx';
    filename2 = 'TestTrial4.xlsx';
elseif trialnumber == 5
    filename = 'Dynamic Trial 05.xlsx';
    filename2 = 'TestTrial5.xlsx';
elseif trialnumber == 6
    filename = 'Dynamic Trial 06.xlsx';
    filename2 = 'TestTrial6.xlsx';
elseif trialnumber == 7
    filename = 'Dynamic Trial 07.xlsx';
    filename2 = 'TestTrial7.xlsx';
elseif trialnumber == 8
    filename = 'Dynamic Trial 08.xlsx';
    filename2 = 'TestTrial8.xlsx';
elseif trialnumber == 9
    filename = 'Dynamic Trial 09.xlsx';
    filename2 = 'TestTrial9.xlsx';
elseif trialnumber == 10
    filename = 'Dynamic Trial 10.xlsx';
    filename2 = 'TestTrial10.xlsx';
end

EMGrange = 'U6:U42005';     % Bicep Range
EMGrange2 = 'V6:V42005';    % Tricep Range
EMGrange3 = 'W6:W42005';    % ADeltoid Range
EMGrange4 = 'X6:X42005';    % PDeltoid Range
EMGrange5 = 'Y6:Y42005';    % Pectoralis Range

X1range = 'C42012:C46211'; % Shoulder position marker
Y1range = 'D42012:D46211';
Z1range = 'E42012:E46211';
X2range = 'F42012:F46211'; % Elbow Position marker
Y2range = 'G42012:G46211';
Z2range = 'H42012:H46211';
X3range = 'I42012:I46211'; % Wrist position marker
Y3range = 'J42012:J46211';
Z3range = 'K42012:K46211';
X4range = 'L42012:L46211';  % Knee position marker
Y4range = 'M42012:M46211';
Z4range = 'N42012:N46211';

BicepsEMG = xlsread(filename, EMGrange); %42000 readings for 42s
TricepsEMG = xlsread(filename,EMGrange2);
ADeltoidEMG = xlsread(filename,EMGrange3);
PDeltoidEMG = xlsread(filename, EMGrange4);
PectoralisEMG = xlsread(filename, EMGrange5);
time1 = 0.001:0.001:42;
time2 = 0.01:0.01:42;

ViconX1 = xlsread(filename,X1range);  % SHOULDER
ViconY1 = xlsread(filename,Y1range);
ViconZ1 = xlsread(filename,Z1range);
ViconX2 = xlsread(filename,X2range);  % ELBOW
ViconY2 = xlsread(filename,Y2range);
ViconZ2 = xlsread(filename,Z2range);
ViconX3 = xlsread(filename,X3range);  % WRIST
ViconY3 = xlsread(filename,Y3range);
ViconZ3 = xlsread(filename,Z3range);
ViconX4 = xlsread(filename,X4range);  % HIP
ViconY4 = xlsread(filename,Y4range);
ViconZ4 = xlsread(filename,Z4range);

L1 = sqrt((ViconX4 - ViconX1).^2 + (ViconZ4 - ViconZ1).^2);
L2 = sqrt((ViconX2 - ViconX1).^2 + (ViconZ2 - ViconZ1).^2);

A1 =  sqrt((ViconX4 - ViconX2).^2 + (ViconZ4 - ViconZ2).^2);

ELBAngle = acosd((L1.^2 + L2.^2 - A1.^2)./(2.*L1.*L2));

% A = ((ViconX1 - ViconX2).*(ViconX3 - ViconX2)) + ((ViconY1 - ViconY2).*(ViconY3 - ViconY2)) + ((ViconZ1 - ViconZ2).*(ViconZ3 - ViconZ2));
% 
% B = sqrt(((ViconX1 - ViconX2).^2) + ((ViconY1 - ViconY2).^2) + ((ViconZ1 - ViconZ2).^2));
% 
% C = sqrt(((ViconX3 - ViconX2).^2) + ((ViconY3 - ViconY2).^2) + ((ViconZ3 - ViconZ2).^2));
% 
% ELBAngle = acosd(A./(B.*C));

% D = (ViconY3 - ViconY2);
% E = (ViconX3 - ViconX2);
% Angle = atand(D./E);
%        
% for i = 1:4200
% if (Angle(i) > 0)
%     Angle2(i) = Angle(i) - 90;
%         else
%     Angle2(i) = Angle(i) + 90;
% end
% end;
% HorizAngle = Angle2';

F = ((ViconX2 - ViconX1).*(ViconX4 - ViconX1)) + ((ViconY2 - ViconY1).*(ViconY4 - ViconY1)) + ((ViconZ2 - ViconZ1).*(ViconZ4 - ViconZ1));

G = sqrt(((ViconX2 - ViconX1).^2) + ((ViconY2 - ViconY1).^2) + ((ViconZ2 - ViconZ1).^2));

H = sqrt(((ViconX4 - ViconX1).^2) + ((ViconY4 - ViconY1).^2) + ((ViconZ4 - ViconZ1).^2));

SHDAngle = acosd(F./(G.*H));

figure;

subplot(6,1,1);
plot(time2, SHDAngle);
title('Shoulder Joint Angle variation with time');
ylabel('Joint Angle');
xlabel('Time(s)');

subplot(6,1,2);
plot(time1, BicepsEMG);
title('Biceps EMG Voltage variation with time');
ylabel('Voltage(V)');
xlabel('Time(s)');

subplot(6,1,3);
plot(time1, TricepsEMG);
title('Triceps EMG voltage variation with time');
ylabel('Voltage(V)');
xlabel('Time(s)');

subplot(6,1,4);
plot(time1, ADeltoidEMG);
title('Ant. Deltoid EMG voltage variation with time');
ylabel('Voltage(V)');
xlabel('Time(s)');

subplot(6,1,5);
plot(time1, PDeltoidEMG);
title('Pos. Deltoid EMG voltage variation with time');
ylabel('Voltage(V)');
xlabel('Time(s)');

subplot(6,1,6);
plot(time1, PectoralisEMG);
title('Pectoralis M. EMG voltage variation with time');
ylabel('Voltage(V)');
xlabel('Time(s)');

OutputAngle = SHDAngle;
B_EMG = BicepsEMG(1:10:42000);
T_EMG = TricepsEMG(1:10:42000);
D_EMG = ADeltoidEMG(1:10:42000);
PD_EMG = PDeltoidEMG(1:10:42000);
P_EMG = PectoralisEMG(1:10:42000);
DownsampledData = [OutputAngle B_EMG T_EMG D_EMG PD_EMG P_EMG];
xlswrite(filename2, DownsampledData);
end;