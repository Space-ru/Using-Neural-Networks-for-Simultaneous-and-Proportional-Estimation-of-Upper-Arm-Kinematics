% Solve an Input-Output Fitting problem with a Neural Network
% Script generated by Neural Fitting app
% Created Tue Feb 02 14:23:59 CET 2016
%
close all;
clear all;

trialnumber = 1;
offset = 1;
for trialnumber = 1:20
 if trialnumber == 1
    filename1 = 'FeaturesTrial5.mat';
    filename2 = 'FeaturesTrial6.mat';
    filename3 = 'FeaturesTrial7.mat';
elseif trialnumber == 2
    filename1 = 'FeaturesTrial5.mat';
    filename2 = 'FeaturesTrial6.mat';
    filename3 = 'FeaturesTrial8.mat';
elseif trialnumber == 3
    filename1 = 'FeaturesTrial5.mat';
    filename2 = 'FeaturesTrial6.mat';
    filename3 = 'FeaturesTrial9.mat';
elseif trialnumber == 4
    filename1 = 'FeaturesTrial5.mat';
    filename2 = 'FeaturesTrial6.mat';
    filename3 = 'FeaturesTrial10.mat';
elseif trialnumber == 5
    filename1 = 'FeaturesTrial5.mat';
    filename2 = 'FeaturesTrial7.mat';
    filename3 = 'FeaturesTrial8.mat';
elseif trialnumber == 6
    filename1 = 'FeaturesTrial5.mat';
    filename2 = 'FeaturesTrial7.mat';
    filename3 = 'FeaturesTrial9.mat';
elseif trialnumber == 7
    filename1 = 'FeaturesTrial5.mat';
    filename2 = 'FeaturesTrial7.mat';
    filename3 = 'FeaturesTrial10.mat';
elseif trialnumber == 8
    filename1 = 'FeaturesTrial5.mat';
    filename2 = 'FeaturesTrial9.mat';
    filename3 = 'FeaturesTrial8.mat';
elseif trialnumber == 9
    filename1 = 'FeaturesTrial5.mat';
    filename2 = 'FeaturesTrial8.mat';
    filename3 = 'FeaturesTrial10.mat';
elseif trialnumber == 10
    filename1 = 'FeaturesTrial5.mat';
    filename2 = 'FeaturesTrial10.mat';
    filename3 = 'FeaturesTrial9.mat';
elseif trialnumber == 11
    filename1 = 'FeaturesTrial6.mat';
    filename2 = 'FeaturesTrial8.mat';
    filename3 = 'FeaturesTrial7.mat';
elseif trialnumber == 12
    filename1 = 'FeaturesTrial6.mat';
    filename2 = 'FeaturesTrial9.mat';
    filename3 = 'FeaturesTrial7.mat';
elseif trialnumber == 13
    filename1 = 'FeaturesTrial6.mat';
    filename2 = 'FeaturesTrial10.mat';
    filename3 = 'FeaturesTrial7.mat';
elseif trialnumber == 14
    filename1 = 'FeaturesTrial6.mat';
    filename2 = 'FeaturesTrial8.mat';
    filename3 = 'FeaturesTrial9.mat';
elseif trialnumber == 15
    filename1 = 'FeaturesTrial8.mat';
    filename2 = 'FeaturesTrial10.mat';
    filename3 = 'FeaturesTrial6.mat';
elseif trialnumber == 16
    filename1 = 'FeaturesTrial6.mat';
    filename2 = 'FeaturesTrial9.mat';
    filename3 = 'FeaturesTrial10.mat';
elseif trialnumber == 17
    filename1 = 'FeaturesTrial7.mat';
    filename2 = 'FeaturesTrial9.mat';
    filename3 = 'FeaturesTrial8.mat';
elseif trialnumber == 18
    filename1 = 'FeaturesTrial8.mat';
    filename2 = 'FeaturesTrial10.mat';
    filename3 = 'FeaturesTrial7.mat';
elseif trialnumber == 19
    filename1 = 'FeaturesTrial9.mat';
    filename2 = 'FeaturesTrial10.mat';
    filename3 = 'FeaturesTrial7.mat';
elseif trialnumber == 20
    filename1 = 'FeaturesTrial9.mat';
    filename2 = 'FeaturesTrial10.mat';
    filename3 = 'FeaturesTrial8.mat';
end

data = importdata(filename1);
target = data.store(101:4100,1)';
RMS = data.store(101:4100,3)';
RMS_t = data.store_t((101:4100),3)';

data2 = importdata(filename2);
target2 = data2.store(101:4100,1)';
RMS2 = data2.store(101:4100,3)';
RMS_t2 = data2.store_t((101:4100),3)';

data3 = importdata(filename3);
target3 = data3.store(101:4100,1)';
RMS3 = data3.store(101:4100,3)';
RMS_t3 = data3.store_t((101:4100),3)';

N = length(target)*3;
T1 = (1:N)/100;

input = [RMS RMS2 RMS3; RMS_t RMS_t2 RMS_t3];
%input2 = [RMS RMS2 RMS3 RMS4 RMS5 RMS6];
%input3 = [RMS_t RMS_t2 RMS_t3 RMS_t4 RMS_t5 RMS_t6];
x = input;
%t = [target target2 target3 target4 ; target target2 target3 target4];
t = [target target2 target3];

% 'trainlm' is usually fastest.
% 'trainbr' takes longer but may be better for challenging problems.
% 'trainscg' uses less memory. NFTOOL falls back to this in low memory situations.
trainFcn = 'trainlm';  % Levenberg-Marquardt
setdemorandstream(491218382);

% Create a Fitting Network
hiddenLayerSize = 3;
net = fitnet(hiddenLayerSize,trainFcn);
net.trainParam.lr = 0.5;                    %setting the learning rate
net.trainParam.epochs = 20;                %setting the amount of training epochs
net.trainParam.showWindow=0;
net.layers{1}.transferFcn = 'tansig';
net.layers{2}.transferFcn = 'tansig';
%net.numInputs = 2;
% Train the Network
[net,tr] = train(net,x,t);

% Test the Network
y = net(x);
e = gsubtract(t,y);
p = perform(net,t,y);
rmse_train = sqrt(p);
weights(:,trialnumber) = getwb(net);
end
save('CV.mat', 'net', 'weights')

trialnumber = 1;
filename1 = 'FeaturesTrial1.mat';
filename2 = 'FeaturesTrial2.mat';
for trialnumber = 1:20
 if trialnumber == 1
    net = setwb(net,weights(:,1));
elseif trialnumber == 2
    net = setwb(net,weights(:,2));
elseif trialnumber == 3
    net = setwb(net,weights(:,3));
elseif trialnumber == 4
    net = setwb(net,weights(:,4));
elseif trialnumber == 5
    net = setwb(net,weights(:,5));
elseif trialnumber == 6
    net = setwb(net,weights(:,6));
elseif trialnumber == 7
    net = setwb(net,weights(:,7));
elseif trialnumber == 8
    net = setwb(net,weights(:,8));
elseif trialnumber == 9
    net = setwb(net,weights(:,9));
elseif trialnumber == 10
    net = setwb(net,weights(:,10));
elseif trialnumber == 11
    net = setwb(net,weights(:,11));
elseif trialnumber == 12
    net = setwb(net,weights(:,12));
elseif trialnumber == 13
    net = setwb(net,weights(:,13));
elseif trialnumber == 14
    net = setwb(net,weights(:,14));
elseif trialnumber == 15
    net = setwb(net,weights(:,15));
elseif trialnumber == 16
    net = setwb(net,weights(:,16));
elseif trialnumber == 17
    net = setwb(net,weights(:,17));
elseif trialnumber == 18
    net = setwb(net,weights(:,18));
elseif trialnumber == 19
    net = setwb(net,weights(:,19));
elseif trialnumber == 20
    net = setwb(net,weights(:,20));
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


Rows = {'1';'2';'3';'4';'5';'6';'7';'8';'9';'10';'11';'12';'13';'14';'15';'16';'17';'18';'19';'20';'Mean';'SD'};
% trialnum(trialnumber) = trialnumber;
 rmsetrain(trialnumber) = rmse_train;
% rmsetest(trialnumber) = rmse_test;
 CCtrain(trialnumber) = CC_train;
% CCtest(trialnumber) = CC_test;
 R2train(trialnumber) = R2;
% R2test(trialnumber) = R2_test;

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


