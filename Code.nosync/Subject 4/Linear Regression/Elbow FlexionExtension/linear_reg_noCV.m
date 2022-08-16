%% Linear Regression parameter estimation and testing without cross-validation
%Christian Grech
close all;
clear all;
trialnumber = 1;
offset = 1;
for trialnumber = 1:8
 if trialnumber == 1
    filename1 = 'FeaturesTrial1_RMS.mat';
elseif trialnumber == 2
    filename1 = 'FeaturesTrial2_RMS.mat';
elseif trialnumber == 3
    filename1 = 'FeaturesTrial3_RMS.mat';
elseif trialnumber == 4
    filename1 = 'FeaturesTrial4_RMS.mat';
elseif trialnumber == 5
    filename1 = 'FeaturesTrial10_RMS.mat';
elseif trialnumber == 6
    filename1 = 'FeaturesTrial8_RMS.mat';
elseif trialnumber == 7
    filename1 = 'FeaturesTrial9_RMS.mat';
elseif trialnumber == 8
    filename1 = 'FeaturesTrial7_RMS.mat';
 end
 
 data = importdata(filename1);
target = data.store(101:4100,1);
RMS = data.store(101:4100,3);
RMS_t = data.store_t((101:4100),3);

N = length(target);
M = 4000;
T1 = (1:M)/100;

input1 = RMS;
input2 = RMS_t;

%% Training Phase
x = input1(1:M);
x_2 = input2(1:M);
t = target(1:M);

tbl = table(x,x_2,t,'VariableNames',{'Input_b','Input_t','Angle'});

lm = fitlm(tbl,'linear');

rmse_train = lm.RMSE;
figure, plot(T1,t, T1,lm.Fitted);
xlabel('Time (seconds)');
ylabel('Elbow Joint Angle (degrees)');
h = legend('actual angle','estimated angle',2);
set(h,'Location','SouthEast')
 
 % CC - correlation coefficient : Training
y_mn_train = mean(lm.Fitted);
t_mn_train = mean(t);

for(n=1:M)
   num_train(n) = (lm.Fitted(n)-y_mn_train)*(t(n)-t_mn_train);
   den1_train(n) = (lm.Fitted(n)-y_mn_train)^2;
   den2_train(n) = (t(n)-t_mn_train)^2;
end

numerator_train = sum(num_train);
denominator_train = sqrt(sum(den1_train)*sum(den2_train));
CC_train = numerator_train/denominator_train;
 
% R square value - : Training
for(n=1:M)
    den_R2(n) = (lm.Fitted(n) - mean(lm.Fitted));
end

R2 = 1 - (rmse_train^2/mean(den_R2.^2));
intercept(trialnumber) = lm.Coefficients{1,{'Estimate'}};
bicep_constant(trialnumber) = lm.Coefficients{2,{'Estimate'}};
tricep_constant(trialnumber) = lm.Coefficients{3,{'Estimate'}};
Rows = {'1';'2';'3';'4';'5';'6';'7';'8';'Mean';'SD'};
trialnum(trialnumber) = trialnumber;
rmsetrain(trialnumber) = rmse_train;
CCtrain(trialnumber) = CC_train;
R2train(trialnumber) = R2;

end
%% Analysis of results in a table
rmse_train_mean = mean(rmsetrain); %Calculate mean
CC_train_mean = mean(CCtrain);
R2_train_mean = mean(R2train);
c1_mean = mean(bicep_constant);
c2_mean = mean(tricep_constant);
c3_mean = mean(intercept);

rmse_train_std = std(rmsetrain); % Calculate stdeviation
CC_train_std = std(CCtrain);
R2_train_std = std(R2train);
c1_std = std(bicep_constant);
c2_std = std(tricep_constant);
c3_std = std(intercept);

rmsetrain1 = [rmsetrain rmse_train_mean rmse_train_std]; % Append Mean and Stdeviation
CCtrain1 = [CCtrain CC_train_mean CC_train_std];
R2train1 = [R2train R2_train_mean R2_train_std];
c1_1 = [bicep_constant c1_mean c1_std];
c2_1 = [tricep_constant c2_mean c2_std];
c3_1 = [intercept c3_mean c3_std];

T = table(rmsetrain1',CCtrain1',R2train1','VariableNames',{'RMSE_train' 'CC_train' 'R2_train'},'RowNames',Rows)

T_2 = table(c1_1',c2_1',c3_1','VariableNames',{'Bicep_Constant' 'Tricep_Constant' 'Intercept'},'RowNames',Rows)