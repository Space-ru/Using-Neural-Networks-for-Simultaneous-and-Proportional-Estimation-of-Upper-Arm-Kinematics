% 	Name of Author: Christian Grech  (adapted from Sean Kenneth Grech's
% 	code)
%   
%% 	Description: System identification for 10 different trials With Cross-validation
%   Input: (In-line code) (ten) xlsx files with EMG + joint angles
%   Output: EM + N4SID - created models for the different trials
%   Software required: MATLAB, Excel 2007 or above.
% 	Version: 2.2

close all;
clear all;
clear w;

%% catering for multiple trials
for trialnumber = 1:1% adjust accordingly

% Used for creation of a model per trial
clearvars -except trialnumber
 if trialnumber == 1
    filename1 = 'FeaturesTrial1.mat';
    filename2 = 'FeaturesTrial2.mat';
    filename3 = 'FeaturesTrial5.mat';
    filename4 = 'FeaturesTrial6.mat';
    filename5 = 'FeaturesTrial7.mat';
    filename6 = 'FeaturesTrial8.mat';
    filename8 = 'FeaturesTrial9.mat';
    filename9 = 'FeaturesTrial10.mat';
elseif trialnumber == 2
    filename1 = 'FeaturesTrial1.mat';
    filename2 = 'FeaturesTrial2.mat';
    filename3 = 'FeaturesTrial5.mat';
    filename4 = 'FeaturesTrial6.mat';
    filename5 = 'FeaturesTrial9.mat';
    filename6 = 'FeaturesTrial10.mat';
    filename8 = 'FeaturesTrial7.mat';
    filename9 = 'FeaturesTrial8.mat';
elseif trialnumber == 3
    filename1 = 'FeaturesTrial5.mat';
    filename2 = 'FeaturesTrial6.mat';
    filename3 = 'FeaturesTrial9.mat';
    filename4 = 'FeaturesTrial10.mat';
    filename5 = 'FeaturesTrial7.mat';
    filename6 = 'FeaturesTrial8.mat';
    filename8 = 'FeaturesTrial1.mat';
    filename9 = 'FeaturesTrial2.mat';
elseif trialnumber == 4
    filename1 = 'FeaturesTrial1.mat';
    filename2 = 'FeaturesTrial2.mat';
    filename3 = 'FeaturesTrial10.mat';
    filename4 = 'FeaturesTrial7.mat';
    filename5 = 'FeaturesTrial8.mat';
    filename6 = 'FeaturesTrial9.mat';
    filename8 = 'FeaturesTrial5.mat';
    filename9 = 'FeaturesTrial6.mat';
 end


filename7 = 'ReverseCVT.xls'; % Where to store features
% data = importdata(filename);
% columnA = data.store(:,1);
% columnB = data.store(:,3);

%% Import data from six trials
data = importdata(filename1);
target = data.store(101:2100,1)';
RMS = data.store(101:2100,3)';
RMS_t = data.store_t((101:2100),3)';

data2 = importdata(filename2);
target2 = data2.store(101:2100,1)';
RMS2 = data2.store(101:2100,3)';
RMS_t2 = data2.store_t((101:2100),3)';

data3 = importdata(filename3);
target3 = data3.store(101:2100,1)';
RMS3 = data3.store(101:2100,3)';
RMS_t3 = data3.store_t((101:2100),3)';

data4 = importdata(filename4);
target4 = data4.store(101:2100,1)';
RMS4 = data4.store(101:2100,3)';
RMS_t4 = data4.store_t((101:2100),3)';

data5 = importdata(filename5);
target5 = data5.store(101:2100,1)';
RMS5 = data5.store(101:2100,3)';
RMS_t5 = data5.store_t((101:2100),3)';

data6 = importdata(filename6);
target6 = data6.store(101:2100,1)';
RMS6 = data6.store(101:2100,3)';
RMS_t6 = data6.store_t((101:2100),3)';

data7 = importdata(filename8);
target7 = data7.store(101:2100,1)';
RMS7 = data7.store(101:2100,3)';
RMS_t7 = data7.store_t((101:2100),3)';

data8 = importdata(filename9);
target8 = data8.store(101:2100,1)';
RMS8 = data8.store(101:2100,3)';
RMS_t8 = data8.store_t((101:2100),3)';

%% Preparing signals

%Separate between input (EMG) and output (joint angles)
columnA = [target target2]';
columnB = [RMS RMS]';

columnC = [target7 target8]';
columnD = [RMS7 RMS8]';

duration = length(columnB);
duration2 = length(columnD);

Fs = 100;
dt = 1/Fs;
tt = (1:duration)*dt;
tt2 = (1:duration2)*dt;

 dL = fdesign.lowpass('N,Fc',4, 4, Fs);    % passband, stopband, passband ripple, stopband attenuation
 fL = design(dL, 'butter');

%u_filt = abs(columnB);
u_filt = filter(fL,abs(columnB));
%u_filt = detrend(u_filt);
u_filt2 = filter(fL,abs(columnD));
% Extract first 20s
u = u_filt;
y = columnA;


% % Extract second 20s
u_v = u_filt2;
y_v = columnC;

% Make 1 for reverse cross-validation
reverse = 0;                                                

% if (reverse == 1)
%     u_v = u_filt(1:duration2);
%     y_v = columnA(1:duration2);
%     
%     u = u_filt(duration2 + 1 : duration);
%     y = columnA(duration2 + 1 : duration);
% end

% Plot joint signal
figure(1);
plot(tt, y, '-r.');
xlabel('samples(k)');
ylabel('Measurement term');
title('Measurement value with time');

% Plot EMG signal
figure(2);
plot(tt, u, '-k.');

n=1;                % length of input and output vector
d=2;                % length of state vector
T = length(u);

%% ----------------------------- N4SID ----------------------------------%%
% Create SS model using first 20s of trial
data = iddata(y',u',0.01);
optCVA = n4sidOptions('Focus','simulation','N4weight','AUTO');
[sysCVA, x0] = n4sid(data,2, optCVA);
% These values are taken with ‘best’ selected. This is done by allow the choice of order using [1:10] in the field instead. 1, 2, 3,… etc was chosen.
% It was found that using ‘best’ is equivalent to selecting from [1:10]. This produces better results than when writing 2 alone.


% Extract A, B and C matrices

A_u = sysCVA.a;
B_u = sysCVA.b;
C_u = sysCVA.c;

A = A_u;
B = B_u;
C = C_u;

% Extract model order
d = size(B_u, 1);

x_n = zeros(d,duration2);
y_n = zeros(1,duration2);

x_n(:,1) = x0;

% Obtain estimated joint angles using second 20s of trial's EMG signal
% CROSS-VALIDATION
for t = 1:duration2
    x_n(:,t+1) = A_u*x_n(:,t) + B_u*u_v(:,t);
    y_n(:,t) = C_u*x_n(:,t);
end

% Plot estimated vs. actual joint angles for second 20s
figure;
hold on;
plot(tt, y_v, '-r', 'linewidth',2);
hold on ;
plot(tt, y_n, '-b','linewidth',2);

h = legend('actual elbow joint angle','estimated elbow joint angle',2);
set(h,'Location','SouthEast')
xlabel('time (s)');
ylabel('Elbow Joint Angle (degrees)');
title('Elbow Joint angle with time');

%% MSE

for(t=1:T)
   error_N4(t) = y_v(1,t)-y_n(1,t);
end

mse_N4 = mean(error_N4.^2);

%% RMSE - root mean squared error : answer in radians

for(t=1:T)
   error_N4(t) = (y_v(1,t)-y_n(1,t))^2;
end

rmse_N4 = sqrt((1/T)*sum(error_N4));

%% CC - correlation coefficient : 1 => perfect correlation

ys_mn_N4 = mean(y_v(1,:));
ms_mn_N4 = mean(y_n(1,:));

for(t=1:T)
   num_N4(t) = (y_v(1,t)-ys_mn_N4)*(y_n(1,t)-ms_mn_N4);
   den1_N4(t) = (y_v(1,t)-ys_mn_N4)^2;
   den2_N4(t) = (y_n(1,t)-ms_mn_N4)^2;
end

numerator_N4 = sum(num_N4);
denominator_N4 = sqrt(sum(den1_N4)*sum(den2_N4));
CC_N4 = numerator_N4/denominator_N4;

%% Store into excel 

% Store titles
titles = {'Trial number','N4SID/EM    ','RMS error   ','CC          '};
store = {trialnumber,'N4SID',rmse_N4,CC_N4};

% Store A matrix
for i = 1:d
    for k = 1:d
        store = {store{:},A_u(i,k)};
        titles = {titles{:},'A           '};
    end
end
    
% Store B matrix
for i = 1:d
    store = {store{:},B_u(i)};
    titles = {titles{:},'B           '};
end

% Store C matrix
for i = 1:d
    store = {store{:},C_u(i)};
    titles = {titles{:},'C           '};
end

if ~exist(filename7,'file')
    xlswrite(filename7, [titles;store], d);
end

[xlsStatus, sheets] = xlsfinfo(filename7);

if ~ismember(num2str(d),sheets)
    xlswrite(filename7, [titles;store], num2str(d)); 
else
    [a,b,prevData] = xlsread(filename7, num2str(d));
    xlswrite(filename7,[prevData;store], num2str(d));
end

end