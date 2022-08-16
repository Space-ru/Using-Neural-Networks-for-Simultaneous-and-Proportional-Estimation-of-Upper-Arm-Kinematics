% 	Name of Author: Christian Grech  
%   
% 	Description: MLP Preprocessing
%   Input: (In-line code) (ten) xlsx files with EMG + joint angles
%   Output: ten xlsx files with target angle, normalised EMG and three
%   features
%   Software required: MATLAB, Excel 2007 or above.
% 	Version: 1.1

close all;
clear all;
clear w;
load('Features.mat');
for trialnum = 1:5


if trialnum == 1
    s = 75;    %window size
elseif trialnum == 2
    s = 100;    %window size
elseif trialnum == 3
    s = 125;    %window size
elseif trialnum == 4
    s = 150;    %window size
elseif trialnum == 5
    s = 200;    %window size
end;

%% catering for multiple trials
for trialnumber = 1:10 % adjust accordingly
% Used for creation of a model per trial

    
if trialnumber == 1
    filename = 'TestTrial1.mat';           % File from which EMG and joint angle are read.
    filename2 = 'FeaturesTrial1.mat';      % File to which corresponding features and angle are written.
elseif trialnumber == 2
    filename = 'TestTrial2.mat';
    filename2 = 'FeaturesTrial2.mat';
elseif trialnumber == 3
    filename = 'TestTrial3.mat';
    filename2 = 'FeaturesTrial3.mat';
elseif trialnumber == 4
    filename = 'TestTrial4.mat';
    filename2 = 'FeaturesTrial4.mat';
elseif trialnumber == 5
    filename = 'TestTrial5.mat';
    filename2 = 'FeaturesTrial5.mat';
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
maxb = 0.2785;  %These values are set on the second run
minb = 0.0092;
maxt = 0.0862;
mint = 0.007;
NormMax = 1;
NormMin = -1;
for n = 1:duration
   RMS_norm(n) = (((NormMax - NormMin)*(RMS_EMGf(n)-minb))/(maxb-minb)) + NormMin;
   Var_norm(n) = (((NormMax - NormMin)*(Variancef(n)-mean_minb))/(mean_maxb-mean_minb)) + NormMin;
   lgVar_norm(n) = (((NormMax - NormMin)*(lgVariancef(n)-mean_minb2))/(mean_maxb2-mean_minb2)) + NormMin;
   sEMG_norm(n) = (((NormMax - NormMin)*(sEMG(n)-min(sEMG)))/(max(sEMG)-min(sEMG))) + NormMin;
   
   RMS_norm_t(n) = (((NormMax - NormMin)*(RMS_EMGf_t(n)-mint))/(maxt-mint)) + NormMin;
   Var_norm_t(n) = (((NormMax - NormMin)*(Variancef_t(n)-mean_mint))/(mean_maxt-mean_mint)) + NormMin;
   lgVar_norm_t(n) = (((NormMax - NormMin)*(lgVariancef_t(n)-mean_mint2))/(mean_maxt2-mean_mint2)) + NormMin;
   sEMG_norm_t(n) = (((NormMax - NormMin)*(sEMG_t(n)-min(sEMG_t)))/(max(sEMG_t)-min(sEMG_t))) + NormMin;
end;

y = columnA(1:duration);
y_scaled = (y-min(y))*(1-(-1))/(max(y)-min(y)) -1;

% Store into excel 

  titles = {'Target Angle','EMG_norm','RMS', 'Log Variance', 'Variance'};
  store = [columnA; sEMG_norm; RMS_norm; lgVar_norm; Var_norm]';
%  
  titles_t = {'Target Angle','T-EMG_norm','T-RMS', 'T-Log Variance', 'T-Variance'};
  store_t = [columnA; sEMG_norm_t; RMS_norm_t; lgVar_norm_t; Var_norm_t]';
save(filename2, 'store', 'store_t');
end

trialnumber = 1;

for trialnumber = 1:4
if trialnumber == 1
    filename1 = 'FeaturesTrial1.mat';
    filename2 = 'FeaturesTrial2.mat';
    filename3 = 'FeaturesTrial3.mat';
    filename4 = 'FeaturesTrial4.mat';
    filename5 = 'FeaturesTrial5.mat';
    filename6 = 'FeaturesTrial6.mat';
elseif trialnumber == 2
    filename1 = 'FeaturesTrial1.mat';
    filename2 = 'FeaturesTrial2.mat';
    filename3 = 'FeaturesTrial3.mat';
    filename4 = 'FeaturesTrial4.mat';
    filename5 = 'FeaturesTrial7.mat';
    filename6 = 'FeaturesTrial9.mat';
elseif trialnumber == 3
    filename1 = 'FeaturesTrial1.mat';
    filename2 = 'FeaturesTrial2.mat';
    filename3 = 'FeaturesTrial5.mat';
    filename4 = 'FeaturesTrial6.mat';
    filename5 = 'FeaturesTrial7.mat';
    filename6 = 'FeaturesTrial9.mat';
elseif trialnumber == 4
    filename1 = 'FeaturesTrial3.mat';
    filename2 = 'FeaturesTrial4.mat';
    filename3 = 'FeaturesTrial5.mat';
    filename4 = 'FeaturesTrial6.mat';
    filename5 = 'FeaturesTrial7.mat';
    filename6 = 'FeaturesTrial9.mat';
end
%% Import data from six trials
data = importdata(filename1);
target = data.store(101:4100,1)';
RMS = data.store(101:4100,3)';
RMS_t = data.store_t((101:4100),3)';
VAR = data.store(101:4100,5)';
VAR_t = data.store_t((101:4100),5)';
lgVAR = data.store(101:4100,4)';
lgVAR_t = data.store_t((101:4100),4)';

data2 = importdata(filename2);
target2 = data2.store(101:4100,1)';
RMS2 = data2.store(101:4100,3)';
RMS_t2 = data2.store_t((101:4100),3)';
VAR2 = data2.store(101:4100,5)';
VAR_t2 = data2.store_t((101:4100),5)';
lgVAR2 = data2.store(101:4100,4)';
lgVAR_t2 = data2.store_t((101:4100),4)';

data3 = importdata(filename3);
target3 = data3.store(101:4100,1)';
RMS3 = data3.store(101:4100,3)';
RMS_t3 = data3.store_t((101:4100),3)';
VAR3 = data3.store(101:4100,5)';
VAR_t3 = data3.store_t((101:4100),5)';
lgVAR3 = data3.store(101:4100,4)';
lgVAR_t3 = data3.store_t((101:4100),4)';

data4 = importdata(filename4);
target4 = data4.store(101:4100,1)';
RMS4 = data4.store(101:4100,3)';
RMS_t4 = data4.store_t((101:4100),3)';
VAR4 = data4.store(101:4100,5)';
VAR_t4 = data4.store_t((101:4100),5)';
lgVAR4 = data4.store(101:4100,4)';
lgVAR_t4 = data4.store_t((101:4100),4)';

data5 = importdata(filename5);
target5 = data5.store(101:4100,1)';
RMS5 = data5.store(101:4100,3)';
RMS_t5 = data5.store_t((101:4100),3)';
VAR5 = data5.store(101:4100,5)';
VAR_t5 = data5.store_t((101:4100),5)';
lgVAR5 = data5.store(101:4100,4)';
lgVAR_t5 = data5.store_t((101:4100),4)';

data6 = importdata(filename6);
target6 = data6.store(101:4100,1)';
RMS6 = data6.store(101:4100,3)';
RMS_t6 = data6.store_t((101:4100),3)';
VAR6 = data6.store(101:4100,5)';
VAR_t6 = data6.store_t((101:4100),5)';
lgVAR6 = data6.store(101:4100,4)';
lgVAR_t6 = data6.store_t((101:4100),4)';

N = length(target)*6;
T1 = (1:N)/100;

%% Set one of these inputs
input = [RMS RMS2 RMS3 RMS4 RMS5 RMS6 ; RMS_t RMS_t2 RMS_t3 RMS_t4 RMS_t5 RMS_t6];
input2 = [VAR VAR2 VAR3 VAR4 VAR5 VAR6 ; VAR_t VAR_t2 VAR_t3 VAR_t4 VAR_t5 VAR_t6];
input3 = [lgVAR lgVAR2 lgVAR3 lgVAR4 lgVAR5 lgVAR6 ; lgVAR_t lgVAR_t2 lgVAR_t3 lgVAR_t4 lgVAR_t5 lgVAR_t6];
x = input3;
%% Target angles
t = [target target2 target3 target4 target5 target6];
% 'trainlm' is usually fastest.
% 'trainbr' takes longer but may be better for challenging problems.
% 'trainscg' uses less memory. NFTOOL falls back to this in low memory situations.
trainFcn = 'trainlm';  % Levenberg-Marquardt
setdemorandstream(491218382);  % remove random seed

% Create a Fitting Network
hiddenLayerSize = 3;
net = fitnet(hiddenLayerSize,trainFcn);
net.trainParam.lr = 0.5;                    %setting the learning rate
net.trainParam.epochs = 20;                %setting the amount of training epochs
net.trainParam.showWindow=0;
net.layers{1}.transferFcn = 'tansig';
net.layers{2}.transferFcn = 'tansig';

% Train the Network
[net,tr] = train(net,x,t);

% Test the Network
y = net(x);
e = gsubtract(t,y);
p = perform(net,t,y);
rmse_train = sqrt(p);
weights(:,trialnumber) = getwb(net); % Get weights

end

trialnumber = 1;
offset = 1;
for trialnumber = 1:4
 if trialnumber == 1
    filename1 = 'FeaturesTrial9.mat';
    filename2 = 'FeaturesTrial7.mat';
    net = setwb(net,weights(:,1));
elseif trialnumber == 2
    filename1 = 'FeaturesTrial5.mat';
    filename2 = 'FeaturesTrial6.mat';
    net = setwb(net,weights(:,2));
elseif trialnumber == 3
    filename1 = 'FeaturesTrial3.mat';
    filename2 = 'FeaturesTrial4.mat';
    net = setwb(net,weights(:,3));
elseif trialnumber == 4
    filename1 = 'FeaturesTrial1.mat';
    filename2 = 'FeaturesTrial2.mat';
    net = setwb(net,weights(:,4));
end

data = importdata(filename1);
target = data.store(101:4100,1)';
RMS = data.store(101:4100,3)';
RMS_t = data.store_t((101:4100),3)';
VAR = data.store(101:4100,5)';
VAR_t = data.store_t((101:4100),5)';
lgVAR = data.store(101:4100,4)';
lgVAR_t = data.store_t((101:4100),4)';

data2 = importdata(filename2);
target2 = data2.store(101:4100,1)';
RMS2 = data2.store(101:4100,3)';
RMS_t2 = data2.store_t((101:4100),3)';
VAR2 = data2.store(101:4100,5)';
VAR_t2 = data2.store_t((101:4100),5)';
lgVAR2 = data2.store(101:4100,4)';
lgVAR_t2 = data2.store_t((101:4100),4)';

N = length(target)*2;
T1 = (1:N)/100;

input = [RMS RMS2; RMS_t RMS_t2];
input2 = [VAR VAR2; VAR_t VAR_t2];
input3 = [lgVAR lgVAR2; lgVAR_t lgVAR_t2];
x = input3;
t = [target target2];
%t = [target target2 target3 target4];

% Test the Network
y = net(x);
e = gsubtract(t,y);
p = perform(net,t,y);
rmse_train = sqrt(p);
 
 % % View the Network
 %view(net)
% 
%  figure, plot(T1,t, T1,y);
%  xlabel('Time (seconds)');
%  ylabel('Elbow Joint Angle (degrees)');
%  h = legend('actual angle','estimated angle',2);
%  set(h,'Location','SouthEast')

 %% CC - correlation coefficient : Training
y_mn_train = mean(y);
t_mn_train = mean(t);

for(n=1:N)
   num_train(n) = (y(n)-y_mn_train)*(t(n)-t_mn_train);
   den1_train(n) = (y(n)-y_mn_train)^2;
   den2_train(n) = (t(n)-t_mn_train)^2;
end

%% R square value - : Training
for(n=1:N)
    den_R2(n) = (y(n) - mean(y));
end

R2 = 1 - (p/mean(den_R2.^2));

numerator_train = sum(num_train);
denominator_train = sqrt(sum(den1_train)*sum(den2_train));
CC_train = numerator_train/denominator_train;


Rows = {'1';'2';'3';'4';'Mean';'SD'};
 rmsetrain(trialnumber) = rmse_train;
 CCtrain(trialnumber) = CC_train;
 R2train(trialnumber) = R2;


end

%% Analysis of results in a table
 rmse_train_mean = mean(rmsetrain); %Calculate mean
 CC_train_mean = mean(CCtrain);
 R2_train_mean = mean(R2train);
 
 rmse_train_std = std(rmsetrain); % Calculate stdeviation
 CC_train_std = std(CCtrain);
 R2_train_std = std(R2train);

 rmsetrain1 = [rmsetrain rmse_train_mean rmse_train_std]; % Append Mean and Stdeviation
 CCtrain1 = [CCtrain CC_train_mean CC_train_std];
 R2train1 = [R2train R2_train_mean R2_train_std];
 
T = table(rmsetrain1',CCtrain1',R2train1','VariableNames',{'RMSE' 'CC' 'R2'},'RowNames',Rows)

end

