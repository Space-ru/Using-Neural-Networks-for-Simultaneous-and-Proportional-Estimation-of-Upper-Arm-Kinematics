% Solve an Input-Output Fitting problem with a Neural Network
% Script generated by Neural Fitting app
% Created Tue Feb 02 14:23:59 CET 2016
%
close all;
clear all;
load('CV.mat');

trialnumber = 1;
offset = 1;
for trialnumber = 1:4
 if trialnumber == 1
    filename1 = 'FeaturesTrial10_RMS.mat';
    filename2 = 'FeaturesTrial9_RMS.mat';
    net = setwb(net,weights(:,1));
elseif trialnumber == 2
    filename1 = 'FeaturesTrial7_RMS.mat';
    filename2 = 'FeaturesTrial8_RMS.mat';
    net = setwb(net,weights(:,2));
elseif trialnumber == 3
    filename1 = 'FeaturesTrial3_RMS.mat';
    filename2 = 'FeaturesTrial4_RMS.mat';
    net = setwb(net,weights(:,3));
elseif trialnumber == 4
    filename1 = 'FeaturesTrial1_RMS.mat';
    filename2 = 'FeaturesTrial2_RMS.mat';
    net = setwb(net,weights(:,4));
end

data = importdata(filename1);
target = data.store(101:4100,1)';
RMS = data.store(101:4100,3)';
RMS_t = data.store_t((101:4100),3)';

data2 = importdata(filename2);
target2 = data2.store(101:4100,1)';
RMS2 = data2.store(101:4100,3)';
RMS_t2 = data2.store_t((101:4100),3)';

N = length(target)*2;
T1 = (1:N)/100;

input = [RMS RMS2; RMS_t RMS_t2];
x = input;
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
 figure, plot(T1,t, T1,y);
 xlabel('Time (seconds)');
 ylabel('Elbow Joint Angle (degrees)');
 h = legend('actual angle','estimated angle',2);
 set(h,'Location','SouthEast')

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

