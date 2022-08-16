%% Cross-validation test Shoulder YZ 
% by Christian Grech
close all;
clear all;
load('CV.mat');

trialnumber = 1;
offset = 1;
for trialnumber = 1:4
 if trialnumber == 1
    filename1 = 'FeaturesTrial10.mat';
    filename2 = 'FeaturesTrial9.mat';
    net = setwb(net,weights(:,1));
elseif trialnumber == 2
    filename1 = 'FeaturesTrial6.mat';
    filename2 = 'FeaturesTrial7.mat';
    net = setwb(net,weights(:,2));
elseif trialnumber == 3
    filename1 = 'FeaturesTrial5.mat';
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

data2 = importdata(filename2);
target2 = data2.store(101:4100,1)';
RMS2 = data2.store(101:4100,3)';
RMS_t2 = data2.store_t((101:4100),3)';

N = (length(target)*2)-10;
T1 = (1:N)/100;

input = [RMS RMS2; RMS_t RMS_t2];
x = input;
t = [target target2];
%t = [target target2 target3 target4];
x = con2seq(x);
t = con2seq(t);

% Test the Network
[p,Pi,Ai,t] = preparets(net,x,t);
y = net(p,Pi);
e = gsubtract(t,y);
p = perform(net,t,y);
rmse_train = sqrt(p);

 % % View the Network
 %view(net)
y = cell2mat(y);
t = cell2mat(t);


 figure, plot(T1,t, T1,y);
 xlabel('Time (seconds)');
 ylabel('Shoulder YZ Joint Angle (degrees)');
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
 rmsetest(trialnumber) = rmse_train;
 CCtest(trialnumber) = CC_train;
 R2test(trialnumber) = R2;

 end;

%% Analysis of results in a table
 rmse_test_mean = mean(rmsetest); %Calculate mean
 rmse_test_std = std(rmsetest); % Calculate stdeviation
 CC_test_mean = mean(CCtest); %Calculate mean
 CC_test_std = std(CCtest);
 R2_test_mean = mean(R2test); %Calculate mean
 R2_test_std = std(R2test);

 rmsetest1 = [rmsetest rmse_test_mean rmse_test_std]; % Append Mean and Stdeviation
 CCtest1 = [CCtest CC_test_mean CC_test_std];
 R2test1 = [R2test R2_test_mean R2_test_std];
 
T = table(rmsetest1',CCtest1',R2test1','VariableNames',{'RMSE' 'CC' 'R2'},'RowNames',Rows)

