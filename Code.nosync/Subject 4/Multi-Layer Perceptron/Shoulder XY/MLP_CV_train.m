% Training Procedure for MLP (X-fold cross-validation) Shoulder XY
% Author: Christian Grech   
% Software: MATLAB 2014, Excel 2013
% Output: Network object, weights

close all;
clear all;
trialnumber = 1;
offset = 1;
for trialnumber = 1:4
 if trialnumber == 1
    filename1 = 'FeaturesTrial3.mat';
    filename2 = 'FeaturesTrial1.mat';
    filename3 = 'FeaturesTrial2.mat';
    filename4 = 'FeaturesTrial4.mat';
    filename5 = 'FeaturesTrial6.mat';
    filename6 = 'FeaturesTrial7.mat';
elseif trialnumber == 2
    filename1 = 'FeaturesTrial3.mat';
    filename2 = 'FeaturesTrial1.mat';
    filename3 = 'FeaturesTrial2.mat';
    filename4 = 'FeaturesTrial4.mat';
    filename5 = 'FeaturesTrial9.mat';
    filename6 = 'FeaturesTrial8.mat';
elseif trialnumber == 3
    filename1 = 'FeaturesTrial1.mat';
    filename2 = 'FeaturesTrial2.mat';
    filename3 = 'FeaturesTrial6.mat';
    filename4 = 'FeaturesTrial8.mat';
    filename5 = 'FeaturesTrial7.mat';
    filename6 = 'FeaturesTrial9.mat';
elseif trialnumber == 4
    filename1 = 'FeaturesTrial3.mat';
    filename2 = 'FeaturesTrial4.mat';
    filename3 = 'FeaturesTrial6.mat';
    filename4 = 'FeaturesTrial7.mat';
    filename5 = 'FeaturesTrial8.mat';
    filename6 = 'FeaturesTrial9.mat';
end

data = importdata(filename1);
target = data.store(101:4100,1)'; % the first and last second are omitted
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

data4 = importdata(filename4);
target4 = data4.store(101:4100,1)';
RMS4 = data4.store(101:4100,3)';
RMS_t4 = data4.store_t((101:4100),3)';

data5 = importdata(filename5);
target5 = data5.store(101:4100,1)';
RMS5 = data5.store(101:4100,3)';
RMS_t5 = data5.store_t((101:4100),3)';

data6 = importdata(filename6);
target6 = data6.store(101:4100,1)';
RMS6 = data6.store(101:4100,3)';
RMS_t6 = data6.store_t((101:4100),3)';

N = length(target)*6;                     
T1 = (1:N)/100;

input = [RMS RMS2 RMS3 RMS4 RMS5 RMS6; RMS_t RMS_t2 RMS_t3 RMS_t4 RMS_t5 RMS_t6 ];
x = input;
t = [target target2 target3 target4 target5 target6];

% 'trainlm' is usually fastest.
% 'trainbr' takes longer but may be better for challenging problems.
% 'trainscg' uses less memory. NFTOOL falls back to this in low memory situations.
trainFcn = 'trainlm';  % Levenberg-Marquardt
setdemorandstream(491218382);

% Create a Fitting Network
hiddenLayerSize = 40;
net = fitnet(hiddenLayerSize,trainFcn);
net.trainParam.lr = 0.5;                   %setting the learning rate
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
weights(:,trialnumber) = getwb(net);

% % View the Network
% view(net)
 
 figure, plot(T1,t, T1,y);
 xlabel('Time (seconds)');
 ylabel('Shoulder XY Joint Angle (degrees)');
 h = legend('actual angle','estimated angle',2);
 set(h,'Location','SouthEast')
%  
  %% CC - correlation coefficient : Training
 y_mn_train = mean(y);
 t_mn_train = mean(t);
 
 for(n=1:N)
    num_train(n) = (y(n)-y_mn_train)*(t(n)-t_mn_train);
    den1_train(n) = (y(n)-y_mn_train)^2;
    den2_train(n) = (t(n)- t_mn_train)^2;
 end
% 
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
 
T = table(rmsetrain1', CCtrain1', R2train1','VariableNames',{'RMSE_train', 'CC_train', 'R2_train'},'RowNames',Rows)
save('CV.mat', 'net', 'weights')

