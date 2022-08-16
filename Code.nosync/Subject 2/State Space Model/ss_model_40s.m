% 	Name of Author: Christian Grech  (adapted from Sean Kenneth Grech's
% 	code)
%   
%% System identification for 10 different trials Without Cross-validation
%   Input: (In-line code) (ten) xlsx files with EMG + joint angles
%   Output: N4SID - created models for the different trials
%   Software required: MATLAB, Excel 2007 or above.

close all;
clear all;
clear w;
trialnumber = 1;
%% catering for multiple trials
for trialnumber = 1:1 % adjust accordingly
% Used for creation of a model per trial
clearvars -except trialnumber
    
if trialnumber == 1
    filename2 = 'TestTrial1.mat';      % File to which corresponding features and angle are written.
elseif trialnumber == 2
    filename2 = 'TestTrial2.mat';
elseif trialnumber == 3
    filename2 = 'TestTrial3.mat';
elseif trialnumber == 4
    filename2 = 'TestTrial4.mat';
elseif trialnumber == 5
    filename2 = 'TestTrial5.mat';
elseif trialnumber == 6
    filename2 = 'TestTrial6.mat';
elseif trialnumber == 7
    filename2 = 'TestTrial7.mat';
elseif trialnumber == 8
    filename2 = 'TestTrial8.mat';
elseif trialnumber == 9
    filename2 = 'TestTrial9.mat';
elseif trialnumber == 10
    filename2 = 'TestTrial10.mat';
end

filename3 = 'BicepFinal.xls'; % Where to store features
data = importdata(filename2);
columnA = data(:,1);
columnB = data(:,2);

%% Preparing signals

%Separate between input (EMG) and output (joint angles)
columnA = columnA';
columnB = columnB';

duration = length(columnB);
Fs = 100;
dt = 1/Fs;
tt3 = (1:duration)*dt;

dL = fdesign.lowpass('N,Fc',4, 4, Fs);    % order,fc, fs
%dL = fdesign.lowpass('Fp,Fst,Ap,Ast',3, 5, 1, 10, Fs);    % passband, stopband, passband ripple, stopband attenuation
fL = design(dL, 'butter');

u_filt = filter(fL,abs(columnB));

% Extract 40s
u = u_filt(1:duration);
y = columnA(1:duration);

% Plot joint signal
 figure(1);
 plot(tt3, y, '-r.');
 xlabel('samples(k)');
 ylabel('Measurement term');
 title('Measurement value with time');

% Plot EMG signal
 figure(2);
 plot(tt3, u, '-k.');

n=1;                % length of input and output vector
d=2;                % length of state vector
T = length(u);

%% ----------------------------- N4SID ----------------------------------%%

% Create SS model using 40s of trial

data = iddata(y',u',0.01);
optCVA = n4sidOptions('Focus', 'simulation','N4weight','Auto');
[sysCVA, x0] = n4sid(data,'best', optCVA);
%[sysCVA, x0] = n4sid(data,2, optCVA, 'DisturbanceModel', 'none');
% These values are taken with ‘best’ selected. This is done by allow the choice of order using [1:10] in the field instead. 1, 2, 3,… etc was chosen.
% It was found that using ‘best’ is equivalent to selecting from [1:10]. This produces better results than when writing 2 alone.

% Extract A, B and C matrices
A_u = sysCVA.a;
B_u = sysCVA.b;
C_u = sysCVA.c;
K_u = sysCVA.k;

A = A_u;
B = B_u;
C = C_u;
K = K_u;
% Extract model order
d = size(B_u, 1);

x_n = zeros(d,duration);
y_n = zeros(1,duration);

x_n(:,1) = x0;
R = normrnd(0, 0.01, 1, 4000);
% Obtain estimated joint angles using trial's EMG signal
% No CROSS-VALIDATION
for t = 1:duration
    x_n(:,t+1) = A_u*x_n(:,t) + B_u*u(:,t);
    y_n(:,t) = C_u*x_n(:,t);
end

% Plot estimated vs. actual joint angles for 40s
figure;
hold on;
plot(tt3, y, '-r', 'linewidth',2);
hold on ;
plot(tt3, y_n, '-b','linewidth',2);


h = legend('actual elbow joint angle','estimated elbow joint angle',2);
set(h,'Location','SouthEast')
xlabel('time (s)');
ylabel('Elbow Joint Angle (degrees)');
title('Elbow Joint angle with time');

%% MSE

for(t=1:T)
   error_N4(t) = y(1,t)-y_n(1,t);
end

mse_N4 = mean(error_N4.^2);

%% RMSE - root mean squared error : answer in radians

for(t=1:T)
   error_N4(t) = (y(1,t)-y_n(1,t))^2;
end

rmse_N4 = sqrt((1/T)*sum(error_N4));

%% CC - correlation coefficient : 1 => perfect correlation

ys_mn_N4 = mean(y(1,:));
ms_mn_N4 = mean(y_n(1,:));

for(t=1:T)
   num_N4(t) = (y(1,t)-ys_mn_N4)*(y_n(1,t)-ms_mn_N4);
   den1_N4(t) = (y(1,t)-ys_mn_N4)^2;
   den2_N4(t) = (y_n(1,t)-ms_mn_N4)^2;
end

numerator_N4 = sum(num_N4);
denominator_N4 = sqrt(sum(den1_N4)*sum(den2_N4));
CC_N4 = numerator_N4/denominator_N4;

%% R square value - : 1 => perfect fit
for(t=1:T)
    den_R2(t) = (y(1,t) - mean(y));
end

R2 = 1 - ((mse_N4)/mean(den_R2.^2));

%% Store into excel 

% Store titles
titles = {'Trial number','R2    ','RMS error   ','CC          '};
store = {trialnumber,R2,rmse_N4,CC_N4};

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

% Store K matrix
for i = 1:d
    store = {store{:},K_u(i)};
    titles = {titles{:},'K           '};
end

if ~exist(filename3,'file')
    xlswrite(filename3, [titles;store], d);
end

[xlsStatus, sheets] = xlsfinfo(filename3);

if ~ismember(num2str(d),sheets)
    xlswrite(filename3, [titles;store], num2str(d)); 
else
    [a,b,prevData] = xlsread(filename3, num2str(d));
    xlswrite(filename3,[prevData;store], num2str(d));
end

end