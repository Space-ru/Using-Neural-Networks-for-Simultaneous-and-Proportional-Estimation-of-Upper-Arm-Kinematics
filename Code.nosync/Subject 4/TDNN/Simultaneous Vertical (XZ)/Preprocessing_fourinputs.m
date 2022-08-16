% 	Name of Author: Christian Grech  
%   
% 	Description: MLP four input Preprocessing
%   Input: (In-line code) (ten) xlsx files with EMG + joint angles
%   Output: ten xlsx files with target angle, normalised EMG and RMS
%   Software required: MATLAB 2014, Excel 2007 or above.

%% 	Instructions: 
%   On the first run, run for two trials and check mean_maxa,
% 	mean_mina.....etc for those two trials. Substitute these values in
% 	maxa, mina......etc and run for the second time, this time for only
% 	eight trials, leaving out the two trials in the first run.

close all;
clear all;
clear w;
index = 1;
trialnumber = 1;
%% catering for multiple trials
for trialnumber = 1:10 % adjust accordingly
    
if trialnumber == 1
    filename = 'TestTrial1.mat';           % File from which EMG and joint angle are read.
    filename2 = 'FeaturesTrialsim1.mat';      % File to which corresponding features and angle are written.
elseif trialnumber == 2
    filename = 'TestTrial2.mat';
    filename2 = 'FeaturesTrialsim2.mat';
elseif trialnumber == 3
    filename = 'TestTrial3.mat';
    filename2 = 'FeaturesTrialsim3.mat';
elseif trialnumber == 4
    filename = 'TestTrial4.mat';
    filename2 = 'FeaturesTrialsim4.mat';
elseif trialnumber == 5
    filename = 'TestTrial5.mat';
    filename2 = 'FeaturesTrialsim5.mat';
elseif trialnumber == 6
    filename = 'TestTrial6.mat';
    filename2 = 'FeaturesTrialsim6.mat';
elseif trialnumber == 7
    filename = 'TestTrial7.mat';
    filename2 = 'FeaturesTrialsim7.mat';
elseif trialnumber == 8
    filename = 'TestTrial8.mat';
    filename2 = 'FeaturesTrialsim8.mat';
elseif trialnumber == 9
    filename = 'TestTrial9.mat';
    filename2 = 'FeaturesTrialsim9.mat';
elseif trialnumber == 10
    filename = 'TestTrial10.mat';
    filename2 = 'FeaturesTrialsim10.mat';
end

data = importdata(filename);  
columnA = data(:,1); % Elbow Joint angle
columnB = data(:,2); % Bicep Deltoid EMG
columnC = data(:,3); % Tricep Deltoid EMG
columnD = data(:,4); % Shoulder Joint angle
columnE = data(:,5); % Anterior Deltoid EMG
columnF = data(:,6); % Posterior Deltoid EMG

%% Preparing signal

%Separate between input (EMG) and output (joint angles)
columnA = columnA';
sEMG = abs(columnB');
sEMG_t = abs(columnC');
columnD = columnD';
sEMG_a = abs(columnE');
sEMG_p = abs(columnF');

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
s = 100;                % half of the window size

for n = 1:s
    temp = sum(sEMG(1:n).^2);
    RMS_EMG(n) = sqrt(temp/n);
    
    temp_t = sum(sEMG_t(1:n).^2);
    RMS_EMG_t(n) = sqrt(temp_t/n);
    
    temp_a = sum(sEMG_a(1:n).^2);
    RMS_EMG_a(n) = sqrt(temp_a/n);
    
    temp_p = sum(sEMG_p(1:n).^2);
    RMS_EMG_p(n) = sqrt(temp_p/n);
 end;

for l = (s+1):(duration-(s+1))
  temp2 = sum(sEMG((l-s):(l+s)).^2);
  RMS_EMG(l)= sqrt(temp2/(2*s));
  
  temp2_t = sum(sEMG_t((l-s):(l+s)).^2);
  RMS_EMG_t(l)= sqrt(temp2_t/(2*s));
  
  temp2_a = sum(sEMG_a((l-s):(l+s)).^2);
  RMS_EMG_a(l)= sqrt(temp2_a/(2*s));
  
  temp2_p = sum(sEMG_p((l-s):(l+s)).^2);
  RMS_EMG_p(l)= sqrt(temp2_p/(2*s));
end;

for m = (duration-s):duration
    temp3 = sum(sEMG((duration-s):duration).^2);
    RMS_EMG(m) = sqrt(temp3/s);
    
    temp3_t = sum(sEMG_t((duration-s):duration).^2);
    RMS_EMG_t(m) = sqrt(temp3_t/s);
    
    temp3_a = sum(sEMG_a((duration-s):duration).^2);
    RMS_EMG_a(m) = sqrt(temp3_a/s);
    
    temp3_p = sum(sEMG_p((duration-s):duration).^2);
    RMS_EMG_p(m) = sqrt(temp3_p/s);
 end;
 
%% Get the maximum/min of the RMS_EMG for bicep/tricep and find the mean
maximumb(index) = max(RMS_EMG');     
minimumb(index) = min(RMS_EMG');
maximumt(index) = max(RMS_EMG_t');
minimumt(index) = min(RMS_EMG_t');

maximuma(index) = max(RMS_EMG_a');     
minimuma(index) = min(RMS_EMG_a');
maximump(index) = max(RMS_EMG_p');
minimump(index) = min(RMS_EMG_p');

maximum_bicep = max(maximumb);
maximum_tricep = max(maximumt);
minimum_bicep = min(minimumb);
minimum_tricep = min(minimumt);

maximum_anterior = max(maximuma);
maximum_posterior = max(maximump);
minimum_anterior = min(minimuma);
minimum_posterior = min(minimump);

mean_maxa = mean(maximuma);
mean_mina = mean(minimuma);
mean_maxp = mean(maximump);
mean_minp = mean(minimump);

mean_maxb = mean(maximumb);
mean_minb = mean(minimumb);
mean_maxt = mean(maximumt);
mean_mint = mean(minimumt);

%% Filter 1Hz as suggested by Aung
RMS_EMGf(1:s) = RMS_EMG(1:s);
RMS_EMGf_t(1:s) = RMS_EMG_t(1:s);
RMS_EMGf_a(1:s) = RMS_EMG_a(1:s);
RMS_EMGf_p(1:s) = RMS_EMG_p(1:s);

for n = s:duration
   RMS_EMGf(n) = (RMS_EMG(n) * 0.06283) + (RMS_EMGf(n - 1) * (1 - 0.06283));
   RMS_EMGf_t(n) = (RMS_EMG_t(n) * 0.06283) + (RMS_EMGf_t(n - 1) * (1 - 0.06283));
   RMS_EMGf_a(n) = (RMS_EMG_a(n) * 0.06283) + (RMS_EMGf_a(n - 1) * (1 - 0.06283));
   RMS_EMGf_p(n) = (RMS_EMG_p(n) * 0.06283) + (RMS_EMGf_p(n - 1) * (1 - 0.06283));
end;
%% Set bicep, tricep, AD and PD limits obtained from the first run
maxb = 0.0164;
minb = 0.0011;
maxt = 0.0210;
mint = 0.000842;

maxa = 0.0126;
mina = 0.0025;
maxp = 0.0139;
minp = 0.0059;

%% Normalisation
NormMax = 1;
NormMin = -1;
for n = 1:duration
   RMS_norm(n) = (((NormMax - NormMin)*(RMS_EMGf(n)-minb))/(maxb-minb)) + NormMin;
   sEMG_norm(n) = (((NormMax - NormMin)*(sEMG(n)-min(sEMG)))/(max(sEMG)-min(sEMG))) + NormMin;
   
   RMS_norm_t(n) = (((NormMax - NormMin)*(RMS_EMGf_t(n)-mint))/(maxt-mint)) + NormMin;
   sEMG_norm_t(n) = (((NormMax - NormMin)*(sEMG_t(n)-min(sEMG_t)))/(max(sEMG_t)-min(sEMG_t))) + NormMin;
   
   RMS_norm_a(n) = (((NormMax - NormMin)*(RMS_EMGf_a(n)-mina))/(maxa-mina)) + NormMin;
   sEMG_norm_a(n) = (((NormMax - NormMin)*(sEMG_a(n)-min(sEMG_a)))/(max(sEMG_a)-min(sEMG_a))) + NormMin;
   
   RMS_norm_p(n) = (((NormMax - NormMin)*(RMS_EMGf_p(n)-minp))/(maxp-minp)) + NormMin;
   sEMG_norm_p(n) = (((NormMax - NormMin)*(sEMG_p(n)-min(sEMG_p)))/(max(sEMG_p)-min(sEMG_p))) + NormMin;
end;

y = columnA(1:duration); % define elbow joint angles
y2 = columnD(1:duration); % define shoulder joint angles
%% Plots
%Plot joint signal
 figure;
 subplot(2,1,1);
 plot(tt3, y, '-r.');
  xlabel('time(s)');
  ylabel('Joint Angle');
  title('Elbow Joint Angle value with time');
 
  subplot(2,1,2);
 plot(tt3, y2, '-r.');
  xlabel('time(s)');
  ylabel('Joint Angle');
  title('Shoulder Joint Angle value with time');
  
 % Plot bicep features
 figure; 
    subplot(2,1,1);
    plot(tt3, sEMG_norm, '-k.');
    hold on;
    plot(tt3, RMS_norm, '-r.');
 
    legend('Raw EMG','RMS','Location','northoutside','Orientation','horizontal');
    xlabel('time (s)');
    ylabel('EMG Voltage');
    title('Bicep EMG data');

 % Plot tricep signal's features
    subplot(2,1,2);
    plot(tt3, sEMG_norm_t, '-k.');
    hold on;
    plot(tt3, RMS_norm_t, '-r.');
    legend('Raw EMG','RMS','Location','northoutside','Orientation','horizontal');

    xlabel('time (s)');
    ylabel('EMG Voltage');
    title('Tricep EMG data');
    
  % Plot AD features
 figure; 
    subplot(2,1,1);
    plot(tt3, sEMG_norm_a, '-k.');
    hold on;
    plot(tt3, RMS_norm_a, '-r.');
 
    legend('Raw EMG','RMS','Location','northoutside','Orientation','horizontal');
    xlabel('time (s)');
    ylabel('EMG Voltage');
    title('Processing Anterior Deltoid EMG data');

 % Plot PD signal's features
    subplot(2,1,2);
    plot(tt3, sEMG_norm_p, '-k.');
    hold on;
    plot(tt3, RMS_norm_p, '-r.');
    legend('Raw EMG','RMS','Location','northoutside','Orientation','horizontal');

    xlabel('time (s)');
    ylabel('EMG Voltage');
    title('Processing EMG Posterior Deltoid data');   
    
    index = index + 1;
    
    %% Store into excel 

 titles = {'Target Angle','RMS','RMS_t'};
 store = [columnA; RMS_norm; RMS_norm_t]';
 
 titles_t = {'Target Angle','RMS_a','RMS_p'};
 store_t = [columnD; RMS_norm_a; RMS_norm_p]';
 
 save(filename2, 'store', 'store_t');
end
