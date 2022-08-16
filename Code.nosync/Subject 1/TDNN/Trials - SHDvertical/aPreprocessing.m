% 	Name of Author: Christian Grech  
%   
% 	Description: MLP/Linear Regression Preprocessing
%   Input: (In-line code) (ten) xlsx files with EMG + joint angles
%   Output: ten xlsx files with target angle, normalised EMG and RMS
%   Software required: MATLAB 2014, Excel 2007 or above.
% 	Version: 1.1

close all;
clear all;
clear w;
index = 1;
trialnumber = 1;
%% catering for multiple trials
for trialnumber = 4:5 % adjust accordingly
    
if trialnumber == 1
    filename = 'TestTrial1.xlsx';           % File from which EMG and joint angle are read.
    filename2 = 'FeaturesTrial1.xlsx';      % File to which corresponding features and angle are written.
elseif trialnumber == 2
    filename = 'TestTrial2.xlsx';
    filename2 = 'FeaturesTrial2.xlsx';
elseif trialnumber == 3
    filename = 'TestTrial3.xlsx';
    filename2 = 'FeaturesTrial3.xlsx';
elseif trialnumber == 4
    filename = 'TestTrial4.xlsx';
    filename2 = 'FeaturesTrial4.xlsx';
elseif trialnumber == 5
    filename = 'TestTrial5.xlsx';
    filename2 = 'FeaturesTrial5.xlsx';
elseif trialnumber == 6
    filename = 'TestTrial6.xlsx';
    filename2 = 'FeaturesTrial6.xlsx';
elseif trialnumber == 7
    filename = 'TestTrial7.xlsx';
    filename2 = 'FeaturesTrial7.xlsx';
elseif trialnumber == 8
    filename = 'TestTrial8.xlsx';
    filename2 = 'FeaturesTrial8.xlsx';
elseif trialnumber == 9
    filename = 'TestTrial9.xlsx';
    filename2 = 'FeaturesTrial9.xlsx';
elseif trialnumber == 10
    filename = 'TestTrial10.xlsx';
    filename2 = 'FeaturesTrial10.xlsx';
end

data = importdata(filename);  
columnA = data(:,1); % Joint angle
columnB = data(:,4); % Anterior Deltoid EMG
columnC = data(:,5); % Posterior Deltoid EMG

%% Preparing signal

%Separate between input (EMG) and output (joint angles)
columnA = columnA';
sEMG = abs(columnB');
sEMG_t = abs(columnC');

duration = length(sEMG);
Fs = 100;               % Sampling Rate
dt = 1/Fs;
tt3 = (1:duration)*dt;
temp = 0;               % temporary variables
temp2 = 0;
temp3 = 0;
temp_t = 0;
temp2_t = 0;
temp3_t = 0;
s = 100;                % half window size

for n = 1:s
    temp = sum(sEMG(1:n).^2);
    RMS_EMG(n) = sqrt(temp/n);
    
    temp_t = sum(sEMG_t(1:s).^2);
    RMS_EMG_t(n) = sqrt(temp_t/(s-1));
 end;

for l = (s+1):(duration-(s+1))
  temp2 = sum(sEMG((l-s):(l+s)).^2);
  RMS_EMG(l)= sqrt(temp2/(2*s));
  
  temp2_t = sum(sEMG_t((l-s):(l+s)).^2);
  RMS_EMG_t(l)= sqrt(temp2_t/(2*s));
end;

for m = (duration-s):duration
    temp3 = sum(sEMG((duration-s):duration).^2);
    RMS_EMG(m) = sqrt(temp3/s);
    
    temp3_t = sum(sEMG_t((duration-s):duration).^2);
    RMS_EMG_t(m) = sqrt(temp3_t/s);
 end;
%% Get the maximum/min of the RMS_EMG for bicep/tricep and find the mean
maximumb(index) = max(RMS_EMG');     
minimumb(index) = min(RMS_EMG');
maximumt(index) = max(RMS_EMG_t');
minimumt(index) = min(RMS_EMG_t');
maximum_bicep = max(maximumb);
maximum_tricep = max(maximumt);
minimum_bicep = min(minimumb);
minimum_tricep = min(minimumt);

mean_maxb = mean(maximumb);
mean_minb = mean(minimumb);
mean_maxt = mean(maximumt);
mean_mint = mean(minimumt);
%% Filter 1Hz as suggested by Aung
RMS_EMGf(1:s) = RMS_EMG(1:s);
RMS_EMGf_t(1:s) = RMS_EMG_t(1:s);

for n = s:duration
   RMS_EMGf(n) = (RMS_EMG(n) * 0.06283) + (RMS_EMGf(n - 1) * (1 - 0.06283));
   RMS_EMGf_t(n) = (RMS_EMG_t(n) * 0.06283) + (RMS_EMGf_t(n - 1) * (1 - 0.06283));
end;
%% Temporary AD and PD limits
maxb = 0.0414;
minb = 0.0065;
maxt = 0.0146;
mint = 0.0052;

%% Normalisation
NormMax = 1;
NormMin = -1;
for n = 1:duration
   RMS_norm(n) = (((NormMax - NormMin)*(RMS_EMGf(n)-minb))/(maxb-minb)) + NormMin;
   sEMG_norm(n) = (((NormMax - NormMin)*(sEMG(n)-min(sEMG)))/(max(sEMG)-min(sEMG))) + NormMin;
   
   RMS_norm_t(n) = (((NormMax - NormMin)*(RMS_EMGf_t(n)-mint))/(maxt-mint)) + NormMin;
   sEMG_norm_t(n) = (((NormMax - NormMin)*(sEMG_t(n)-min(sEMG_t)))/(max(sEMG_t)-min(sEMG_t))) + NormMin;
end;

y = columnA(1:duration); % define joint angles
%% Plots
%Plot joint signal
 figure;
 plot(tt3, y, '-r.');
  xlabel('time(s)');
  ylabel('Joint Angle');
  title('Measurement value with time');
 legend('Joint Angle','Location','northoutside','Orientation','horizontal');
 
 % Plot Anterior Deltoid features
 figure; 
    plot(tt3, sEMG_norm, '-k.');
    hold on;
    plot(tt3, RMS_norm, '-r.');
 
    legend('Raw EMG','RMS','Location','northoutside','Orientation','horizontal');
    xlabel('time (s)');
    ylabel('EMG Voltage');
    title('Processing Anterior Deltoid EMG data');

 % Plot Posterior Deltoid signal's features
 figure;
    plot(tt3, sEMG_norm_t, '-k.');
    hold on;
    plot(tt3, RMS_norm_t, '-r.');
    legend('Raw EMG','RMS','Location','northoutside','Orientation','horizontal');

    xlabel('time (s)');
    ylabel('EMG Voltage');
    title('Processing EMG Posterior Deltoid data');
    index = index + 1;
end
%% Save limits calculated
save('Limits.mat', 'mean_maxb', 'mean_minb', 'mean_maxt', 'mean_mint'); 