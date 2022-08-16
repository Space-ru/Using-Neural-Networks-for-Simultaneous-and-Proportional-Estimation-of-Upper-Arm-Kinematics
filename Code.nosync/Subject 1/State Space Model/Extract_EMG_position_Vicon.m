%% Extraction of EMG and cartesian co-ordinates from .xlsx files to obtain
% elbow angle and corresponding EMG
% Created by Christian Grech

%% Input file definition
filename = 'Dynamic Trial 01 - Continuous Metronome.xlsx';   % .xlsx file name
filename2 = 'Trial 1 - Biceps.xlsx'; % output file name

%% Excel file co-ordinates and EMG ranges
xlrange = 'M6:M40005';     
xlrange2 = 'N6:N40005';
X1range = 'C40012:C44011';
Y1range = 'D40012:D44011';
Z1range = 'E40012:E44011';
X2range = 'F40012:F44011';
Y2range = 'G40012:G44011';
Z2range = 'H40012:H44011';
X3range = 'I40012:I44011';
Y3range = 'J40012:J44011';
Z3range = 'K40012:K44011';

BicepsEMG = xlsread(filename, xlrange); %40000 readings for 40s
TricepsEMG = xlsread(filename,xlrange2);

time1 = 0.001:0.001:40;
time2 = 0.01:0.01:40;

ViconX1 = xlsread(filename,X1range);  % SHOULDER co-ordinates
ViconY1 = xlsread(filename,Y1range);
ViconZ1 = xlsread(filename,Z1range);
ViconX2 = xlsread(filename,X2range);  % ELBOW co-ordinates
ViconY2 = xlsread(filename,Y2range);
ViconZ2 = xlsread(filename,Z2range);
ViconX3 = xlsread(filename,X3range);  % WRIST co-ordinates
ViconY3 = xlsread(filename,Y3range);
ViconZ3 = xlsread(filename,Z3range);

%% Angle calculation
A = ((ViconX1 - ViconX2).*(ViconX3 - ViconX2)) + ((ViconY1 - ViconY2).*(ViconY3 - ViconY2)) + ((ViconZ1 - ViconZ2).*(ViconZ3 - ViconZ2));

B = sqrt(((ViconX1 - ViconX2).^2) + ((ViconY1 - ViconY2).^2) + ((ViconZ1 - ViconZ2).^2));

C = sqrt(((ViconX3 - ViconX2).^2) + ((ViconY3 - ViconY2).^2) + ((ViconZ3 - ViconZ2).^2));

VICONAngle = acosd(A./(B.*C));   % Elbow joint angle

%% Plot joint angle and EMG data
figure;
subplot(3,1,1);
plot(time2, VICONAngle);
title('Elbow Joint Angle variation with time');
ylabel('Joint Angle');
xlabel('Time(s)');

subplot(3,1,2);
plot(time1, BicepsEMG);
title('Biceps EMG Voltage variation with time');
ylabel('Voltage(V)');
xlabel('Time(s)');

subplot(3,1,3);
plot(time1, TricepsEMG);
title('Triceps EMG Voltage variation with time');
ylabel('Voltage(V)');
xlabel('Time(s)');

%% Output data
BEMG = BicepsEMG(1:10:40000);  %Downsample EMG data
TEMG = TricepsEMG(1:10:40000);
OutputAngle = VICONAngle;
DownsampledData = [OutputAngle BEMG TEMG];
xlswrite(filename2, DownsampledData);
