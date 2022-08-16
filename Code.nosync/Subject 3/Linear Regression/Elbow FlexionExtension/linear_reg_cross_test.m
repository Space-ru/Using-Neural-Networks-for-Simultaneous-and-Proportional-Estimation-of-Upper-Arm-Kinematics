% Solve an Input-Output Fitting problem with a Neural Network
% Script generated by Neural Fitting app
% Created Tue Feb 02 14:23:59 CET 2016
%
close all;
clear all;
load('LR.mat');
trialnumber = 1;
offset = 1;
for trialnumber = 1:4
 if trialnumber == 1
    filename1 = 'FeaturesTrial7_RMS.mat';
    filename2 = 'FeaturesTrial9_RMS.mat';
    intercept1 = intercept(:,1);
    bicep = bicep_constant(:,1);
    tricep = tricep_constant(:,1);
elseif trialnumber == 2
    filename1 = 'FeaturesTrial5_RMS.mat';
    filename2 = 'FeaturesTrial6_RMS.mat';
    intercept1 = intercept(:,2);
    bicep = bicep_constant(:,2);
    tricep = tricep_constant(:,2);
elseif trialnumber == 3
    filename1 = 'FeaturesTrial3_RMS.mat';
    filename2 = 'FeaturesTrial4_RMS.mat';
    intercept1 = intercept(:,3);
    bicep = bicep_constant(:,3);
    tricep = tricep_constant(:,3);
elseif trialnumber == 4
    filename1 = 'FeaturesTrial1_RMS.mat';
    filename2 = 'FeaturesTrial2_RMS.mat';
    intercept1 = intercept(:,4);
    bicep = bicep_constant(:,4);
    tricep = tricep_constant(:,4);
end
%% Import data
data = importdata(filename1);
target = data.store(101:4100,1)';
RMS = data.store(101:4100,3)';
RMS_t = data.store_t((101:4100),3)';

data2 = importdata(filename2);
target2 = data2.store(101:4100,1)';
RMS2 = data2.store(101:4100,3)';
RMS_t2 = data2.store_t((101:4100),3)';

N = length(target)*2; % total length of testing set
T1 = (1:N)/100;
%% Select inputs
input = [RMS RMS2];
input2 = [RMS_t RMS_t2];
x = input';
x2 = input2';
t = [target target2];

y = intercept1 + (bicep*x) + (tricep*x2);

error_test = (t-y').^2;
mse_test = (sum(error_test)./N);
rmse_train = sqrt(mse_test);

figure, plot(T1,t, T1,y);
xlabel('Time (seconds)');
ylabel('Elbow Joint Angle (degrees)');
h = legend('actual angle','estimated angle',2);
set(h,'Location','SouthEast')

%% CC - correlation coefficient : Testing

y_mn_test = mean(y);
t_mn_test = mean(t);

for(n=1:N)
   num_test(n) = (y(n)-y_mn_test)*(t(n)-t_mn_test);
   den1_test(n) = (y(n)-y_mn_test)^2;
   den2_test(n) = (t(n)-t_mn_test)^2;
end

numerator_test = sum(num_test);
denominator_test = sqrt(sum(den1_test)*sum(den2_test));
CC_train = numerator_test/denominator_test;

%% R square value - : Testing
for(n=1:N)
    den_R2_test(n) = (y(n) - mean(y));
end

R2 = 1 - (mse_test/mean(den_R2_test.^2));


 Rows = {'1';'2';'3';'4';'Mean';'SD'};
 rmsetrain(trialnumber) = rmse_train;
 CCtrain(trialnumber) = CC_train;
 R2train(trialnumber) = R2;

end

%% Analysis of results in a table
 rmse_train_mean = mean(rmsetrain); %Calculate mean
 CC_train_mean = mean(CCtrain);
 R2_train_mean = mean(R2train);
% 
 rmse_train_std = std(rmsetrain); % Calculate stdeviation
 CC_train_std = std(CCtrain);
 R2_train_std = std(R2train);
% 
 rmsetrain1 = [rmsetrain rmse_train_mean rmse_train_std]; % Append Mean and Stdeviation
 CCtrain1 = [CCtrain CC_train_mean CC_train_std];
 R2train1 = [R2train R2_train_mean R2_train_std];
 
T = table(rmsetrain1',CCtrain1',R2train1','VariableNames',{'RMSE' 'CC' 'R2'},'RowNames',Rows)

