% 	Name of Author: Christian Grech  
%   
% 	Description: MLP/Linear Regression Preprocessing
%   Input: (In-line code) (ten) mat files with EMG + joint angles
%   Output: ten mat files with target angle, normalised EMG and three
%   features
%   Software required: MATLAB, Excel 2007 or above.
% 	Version: 1.1

%Instructions: On the first run, mean_maxb, mean_minb, mean_maxt and
%mean_mint  for two trials are noted. These two trials are then discarded. 
%maxb, minb, mint and maxt are then set as these
%values on the second run where only eight trials are run.

close all;
clear all;
clear w;
index = 1;
trialnumber = 1;
%% catering for multiple trials
for trialnumber = 1:10 % adjust accordingly
% Used for creation of a model per trial
%clearvars -except trialnumber
    
if trialnumber == 1
    filename = 'TestTrial11.mat';           % File from which EMG and joint angle are read.
    filename2 = 'FeaturesTrial1_RMS.mat';      % File to which corresponding features and angle are written.
elseif trialnumber == 2
    filename = 'TestTrial12.mat';
    filename2 = 'FeaturesTrial2_RMS.mat';
elseif trialnumber == 3
    filename = 'TestTrial13.mat';
    filename2 = 'FeaturesTrial3_RMS.mat';
elseif trialnumber == 4
    filename = 'TestTrial4.mat';
    filename2 = 'FeaturesTrial4_RMS.mat';
elseif trialnumber == 5
    filename = 'TestTrial5.mat';
    filename2 = 'FeaturesTrial5_RMS.mat';
elseif trialnumber == 6
    filename = 'TestTrial6.mat';
    filename2 = 'FeaturesTrial6_RMS.mat';
elseif trialnumber == 7
    filename = 'TestTrial7.mat';
    filename2 = 'FeaturesTrial7_RMS.mat';
elseif trialnumber == 8
    filename = 'TestTrial8.mat';
    filename2 = 'FeaturesTrial8_RMS.mat';
elseif trialnumber == 9
    filename = 'TestTrial9.mat';
    filename2 = 'FeaturesTrial9_RMS.mat';
elseif trialnumber == 10
    filename = 'TestTrial10.mat';
    filename2 = 'FeaturesTrial10_RMS.mat';
end

data = importdata(filename);  
columnA = data(:,1); % Joint angle
columnB = data(:,2); % Bicep EMG
columnC = data(:,3); % Tricep EMG

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
    Variance(n) = var(sEMG(1:n));
    lgVariance(n) = log(var(sEMG(1:s)));
    
    temp_t = sum(sEMG_t(1:s).^2);
    RMS_EMG_t(n) = sqrt(temp_t/(s-1));
     Variance_t(n) = var(sEMG_t(1:s));
    lgVariance_t(n) = log(var(sEMG_t(1:s)));    
 end;

for l = (s+1):(duration-(s+1))
  temp2 = sum(sEMG((l-s):(l+s)).^2);
  RMS_EMG(l)= sqrt(temp2/(2*s));
  Variance(l) = var(sEMG((l-s):(l+s)));
  lgVariance(l) = log(var(sEMG((l-s):(l+s))));
  
  temp2_t = sum(sEMG_t((l-s):(l+s)).^2);
  RMS_EMG_t(l)= sqrt(temp2_t/(2*s));
  Variance_t(l) = var(sEMG_t((l-s):(l+s)));
  lgVariance_t(l) = log(var(sEMG_t((l-s):(l+s))));
end;

for m = (duration-s):duration
    temp3 = sum(sEMG((duration-s):duration).^2);
    RMS_EMG(m) = sqrt(temp3/s);
    Variance(m) = var(sEMG((duration-s):duration));
    lgVariance(m) = log(var(sEMG((duration-s):duration)));
     
    temp3_t = sum(sEMG_t((duration-s):duration).^2);
    RMS_EMG_t(m) = sqrt(temp3_t/s);
    Variance_t(m) = var(sEMG_t((duration-s):duration));
    lgVariance_t(m) = log(var(sEMG_t((duration-s):duration)));
 end;

maximumb(index) = max(RMS_EMG');    % Finding minimum and maximum EMG values for setting the normalisation levels
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

%% Filter according to Aung
RMS_EMGf(1:s) = RMS_EMG(1:s);
Variancef(1:s) = Variance(1:s);
lgVariancef(1:s) = lgVariance(1:s);

RMS_EMGf_t(1:s) = RMS_EMG_t(1:s);
Variancef_t(1:s) = Variance_t(1:s);
lgVariancef_t(1:s) = lgVariance_t(1:s);

for n = s:duration
   RMS_EMGf(n) = (RMS_EMG(n) * 0.06283) + (RMS_EMGf(n - 1) * (1 - 0.06283));
   Variancef(n) = (Variance(n) * 0.06283) + (Variancef(n - 1) * (1 - 0.06283));
   lgVariancef(n) = (lgVariance(n) * 0.06283) + (lgVariancef(n - 1) * (1 - 0.06283));
   
   RMS_EMGf_t(n) = (RMS_EMG_t(n) * 0.06283) + (RMS_EMGf_t(n - 1) * (1 - 0.06283));
   Variancef_t(n) = (Variance_t(n) * 0.06283) + (Variancef_t(n - 1) * (1 - 0.06283));
   lgVariancef_t(n) = (lgVariance_t(n) * 0.06283) + (lgVariancef_t(n - 1) * (1 - 0.06283));
end;

maxb = 0.0161;  %These values are set on the second run
minb = 0.002;
maxt = 0.0199;
mint = 0.001;
NormMax = 1;
NormMin = -1;
%% Normalise according to values above
for n = 1:duration
   RMS_norm(n) = (((NormMax - NormMin)*(RMS_EMGf(n)-minb))/(maxb-minb)) + NormMin;
   Var_norm(n) = (((NormMax - NormMin)*(Variancef(n)-min(Variancef)))/(max(Variancef)-min(Variancef))) + NormMin;
   lgVar_norm(n) = (((NormMax - NormMin)*(lgVariancef(n)-min(lgVariancef)))/(max(lgVariancef)-min(lgVariancef))) + NormMin;
   sEMG_norm(n) = (((NormMax - NormMin)*(sEMG(n)-min(sEMG)))/(max(sEMG)-min(sEMG))) + NormMin;
   
   RMS_norm_t(n) = (((NormMax - NormMin)*(RMS_EMGf_t(n)-mint))/(maxt-mint)) + NormMin;
   sEMG_norm_t(n) = (((NormMax - NormMin)*(sEMG_t(n)-min(sEMG_t)))/(max(sEMG_t)-min(sEMG_t))) + NormMin;
   Var_norm_t(n) = (((NormMax - NormMin)*(Variancef_t(n)-min(Variancef_t)))/(max(Variancef_t)-min(Variancef_t))) + NormMin;
   lgVar_norm_t(n) = (((NormMax - NormMin)*(lgVariancef_t(n)-min(lgVariancef_t)))/(max(lgVariancef_t)-min(lgVariancef_t))) + NormMin;
end;

y = columnA(1:duration);

%Plot joint signal
 figure;
 plot(tt3, y, '-r.');
  xlabel('time(s)');
  ylabel('Joint Angle');
  title('Measurement value with time');
 legend('RMS bicep','Joint Angle','RMS triceps','Location','northoutside','Orientation','horizontal');
 
% % Plot bicep features
 figure;
 plot(tt3, sEMG_norm, '-k.');
 
 hold on;
 plot(tt3, RMS_norm, '-r.');
 
 hold on;
 plot(tt3, lgVar_norm, '-g.');
 
 hold on;
 plot(tt3, Var_norm, '-y.');
 
legend('Raw EMG','RMS','Log Variance','Variance','Location','northoutside','Orientation','horizontal');

xlabel('time (s)');
ylabel('Normalised EMG Voltage');
title('Processing bicep EMG data');

% % Plot tricep signal's features
 figure;
  plot(tt3, sEMG_norm_t, '-k.');
 
 hold on;
 plot(tt3, RMS_norm_t, '-r.');
 
 hold on;
 plot(tt3, lgVar_norm_t, '-g.');
 
 hold on;
 plot(tt3, Var_norm_t, '-y.');
 
legend('Raw EMG','RMS','Log Variance','Variance','Location','northoutside','Orientation','horizontal');

xlabel('time (s)');
ylabel('Normalised EMG Voltage');
title('Processing EMG tricep data');

% Store into excel 

 titles = {'Target Angle','EMG_norm','RMS'};
 store = [columnA; sEMG_norm; RMS_norm]';
 
 titles_t = {'Target Angle','T-EMG_norm','T-RMS'};
 store_t = [columnA; sEMG_norm_t; RMS_norm_t]';
%  
 save(filename2, 'store', 'store_t');

end

