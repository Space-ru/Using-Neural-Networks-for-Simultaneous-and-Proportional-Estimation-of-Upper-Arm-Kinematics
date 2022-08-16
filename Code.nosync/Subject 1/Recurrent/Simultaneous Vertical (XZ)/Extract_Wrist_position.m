%% Getting wrist position into ten separate mat files, one for each trial

clear all;
close all;
clc;
for trialnumber = 1:10 % adjust accordingly
% Used for creation of a model per trial
%clearvars -except trialnumber
    
if trialnumber == 1
    filename = 'Dynamic Trial 22.xlsx';           % File from which EMG and joint angle are read.
    filename2 = 'TestTrial1xyz.mat';      % File to which corresponding features and angle are written.
elseif trialnumber == 2
    filename = 'Dynamic Trial 23.xlsx';
    filename2 = 'TestTrial2xyz.mat';
elseif trialnumber == 3
    filename = 'Dynamic Trial 24.xlsx';
    filename2 = 'TestTrial3xyz.mat';
elseif trialnumber == 4
    filename = 'Dynamic Trial 25.xlsx';
    filename2 = 'TestTrial4xyz.mat';
elseif trialnumber == 5
    filename = 'Dynamic Trial 26.xlsx';
    filename2 = 'TestTrial5xyz.mat';
elseif trialnumber == 6
    filename = 'Dynamic Trial 27.xlsx';
    filename2 = 'TestTrial6xyz.mat';
elseif trialnumber == 7
    filename = 'Dynamic Trial 28.xlsx';
    filename2 = 'TestTrial7xyz.mat';
elseif trialnumber == 8
    filename = 'Dynamic Trial 29.xlsx';
    filename2 = 'TestTrial8xyz.mat';
elseif trialnumber == 9
    filename = 'Dynamic Trial 30.xlsx';
    filename2 = 'TestTrial9xyz.mat';
elseif trialnumber == 10
    filename = 'Dynamic Trial 31.xlsx';
    filename2 = 'TestTrial10xyz.mat';
end

X1range = 'U42012:U46211'; % Wrist position marker
Z1range = 'V42012:V46211';


time2 = 0.01:0.01:42;

ViconX1 = xlsread(filename,X1range);  % SHOULDER
ViconZ1 = xlsread(filename,Z1range);

figure;

subplot(4,1,1);
plot(time2, ViconX1);
title('Wrist Vertical');
ylabel('Distance (mm)');
xlabel('Time(s)');

subplot(4,1,2);
plot(time2, ViconZ1);
title('Wrist Horizontal');
ylabel('Distance (mm)');
xlabel('Time(s)');


DownsampledData = [ViconX1 ViconZ1 ViconX2 ViconZ2 ViconX3 ViconZ3];
save(filename2, 'DownsampledData');
end;