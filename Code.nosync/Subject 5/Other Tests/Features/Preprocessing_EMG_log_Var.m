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
for trialnumber = 1:2 % adjust accordingly
% Used for creation of a model per trial
%clearvars -except trialnumber
    
if trialnumber == 1
    filename = 'TestTrial1.mat';           % File from which EMG and joint angle are read.
    filename2 = 'Features.mat';      % File to which corresponding features and angle are written.
elseif trialnumber == 2
    filename = 'TestTrial2.mat';
    filename2 = 'Features.mat';
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

maximumb(index) = max(Variance');    % Finding minimum and maximum EMG values for setting the normalisation levels
minimumb(index) = min(Variance');
maximumt(index) = max(Variance_t');
minimumt(index) = min(Variance_t');

maximumb2(index) = max(lgVariance');    % Finding minimum and maximum EMG values for setting the normalisation levels
minimumb2(index) = min(lgVariance');
maximumt2(index) = max(lgVariance_t');
minimumt2(index) = min(lgVariance_t');

end

mean_maxb = mean(maximumb);
mean_minb = mean(minimumb);
mean_maxt = mean(maximumt);
mean_mint = mean(minimumt);

mean_maxb2 = mean(maximumb2);
mean_minb2 = mean(minimumb2);
mean_maxt2 = mean(maximumt2);
mean_mint2 = mean(minimumt2);

save(filename2, 'mean_maxb', 'mean_minb', 'mean_maxt', 'mean_mint', 'mean_maxb2', 'mean_minb2', 'mean_maxt2', 'mean_mint2');