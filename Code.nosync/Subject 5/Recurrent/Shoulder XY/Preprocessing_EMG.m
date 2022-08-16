% 	Name of Author: Christian Grech  
%   
% 	Description: MLP/Linear Regression Preprocessing - Combined
%   Input: (In-line code) (ten) xlsx files with EMG + joint angles
%   Output: ten xlsx files with target angle, normalised EMG and three
%   features
%   Software required: MATLAB, Excel 2007 or above.
% 	Version: 1.1

close all;
clear all;
clear w;
index = 1;
trialnumber = 1;
%% catering for multiple trials
for trialnumber = 1:10% adjust accordingly
    
if trialnumber == 1
    filename = 'TestTrial1.mat';           % File from which EMG and joint angle are read.
    filename2 = 'FeaturesTrial1.mat';      % File to which corresponding features and angle are written.
elseif trialnumber == 2
    filename = 'TestTrial5.mat';
    filename2 = 'FeaturesTrial5.mat';
elseif trialnumber == 3
    filename = 'TestTrial3.mat';
    filename2 = 'FeaturesTrial3.mat';
elseif trialnumber == 4
    filename = 'TestTrial4.mat';
    filename2 = 'FeaturesTrial4.mat';
elseif trialnumber == 5
    filename = 'TestTrial2.mat';
    filename2 = 'FeaturesTrial2.mat';
elseif trialnumber == 6
    filename = 'TestTrial6.mat';
    filename2 = 'FeaturesTrial6.mat';
elseif trialnumber == 7
    filename = 'TestTrial7.mat';
    filename2 = 'FeaturesTrial7.mat';
elseif trialnumber == 8
    filename = 'TestTrial8.mat';
    filename2 = 'FeaturesTrial8.mat';
elseif trialnumber == 9
    filename = 'TestTrial9.mat';
    filename2 = 'FeaturesTrial9.mat';
elseif trialnumber == 10
    filename = 'TestTrial10.mat';
    filename2 = 'FeaturesTrial10.mat';
end

data = importdata(filename);  
columnA = data(:,1); % Joint angle
columnB = data(:,5); % PDeltoid EMG
columnC = data(:,6); % Pectoralis EMG

%% Preparing signal

%Separate between input (EMG) and output (joint angles)
columnA = columnA';
sEMG = abs(columnB');
sEMG_t = abs(columnC');

duration = length(sEMG);
Fs = 100;   % Sampling Rate
dt = 1/Fs;
tt3 = (1:duration)*dt;
temp = 0;        % temporary variables
temp2 = 0;
temp3 = 0;
temp_t = 0;
temp2_t = 0;
temp3_t = 0;
s = 100;    % half window size

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
%% Filter 1Hz
RMS_EMGf(1:s) = RMS_EMG(1:s);
RMS_EMGf_t(1:s) = RMS_EMG_t(1:s);

for n = s:duration
   RMS_EMGf(n) = (RMS_EMG(n) * 0.06283) + (RMS_EMGf(n - 1) * (1 - 0.06283));
   RMS_EMGf_t(n) = (RMS_EMG_t(n) * 0.06283) + (RMS_EMGf_t(n - 1) * (1 - 0.06283));
end;
%% Set normalisation limits
maxb = 0.1349;
minb = 0.0389;
maxt = 0.0618;
mint = 0.0149;

NormMax = 1;
NormMin = -1;
for n = 1:duration
   RMS_norm(n) = (((NormMax - NormMin)*(RMS_EMGf(n)-minb))/(maxb-minb)) + NormMin;
   sEMG_norm(n) = (((NormMax - NormMin)*(sEMG(n)-min(sEMG)))/(max(sEMG)-min(sEMG))) + NormMin;
   
   RMS_norm_t(n) = (((NormMax - NormMin)*(RMS_EMGf_t(n)-mint))/(maxt-mint)) + NormMin;
   sEMG_norm_t(n) = (((NormMax - NormMin)*(sEMG_t(n)-min(sEMG_t)))/(max(sEMG_t)-min(sEMG_t))) + NormMin;
end;

y = columnA(1:duration);
%% Plots
%Plot joint signal
 figure;
    plot(tt3, y, '-r.');
    xlabel('time(s)');
    ylabel('Joint Angle');
    title('Measurement value with time');
  %  legend('Joint Angle','Location','northoutside','Orientation','horizontal');
 
% Plot bicep features
 figure; 
    plot(tt3, sEMG_norm, '-k.');
    hold on;
    plot(tt3, RMS_norm, '-r.');
    legend('Raw EMG','RMS','Location','northoutside','Orientation','horizontal');
    xlabel('time (s)');
    ylabel('EMG Voltage');
    title('Processing Posterior Deltoid EMG data');

% Plot tricep signal's features
 figure;
 plot(tt3, sEMG_norm_t, '-k.');
 
 hold on;
 plot(tt3, RMS_norm_t, '-r.');
 legend('Raw EMG','RMS','Location','northoutside','Orientation','horizontal');
    xlabel('time (s)');
    ylabel('EMG Voltage');
    title('Processing EMG Pectoralis data');
    index = index + 1;
%% Store into excel 

 titles = {'Target Angle','EMG_norm','RMS'};
 store = [columnA; sEMG_norm; RMS_norm]';
 
 titles_t = {'Target Angle','T-EMG_norm','T-RMS'};
 store_t = [columnA; sEMG_norm_t; RMS_norm_t]';
 
save(filename2, 'store', 'store_t');

end
