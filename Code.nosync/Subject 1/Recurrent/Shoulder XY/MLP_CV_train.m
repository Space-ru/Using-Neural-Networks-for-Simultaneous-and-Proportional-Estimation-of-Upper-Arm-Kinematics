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

N = (length(target)*6)-10;
T1 = ((1:N)/100);

%% Set one of these inputs
input = [RMS RMS2 RMS3 RMS4 RMS5 RMS6 ; RMS_t RMS_t2 RMS_t3 RMS_t4 RMS_t5 RMS_t6];
input2 = [RMS RMS2 RMS3 RMS4 RMS5 RMS6];
input3 = [RMS_t RMS_t2 RMS_t3 RMS_t4 RMS_t5 RMS_t6];
x = input;
x = con2seq(x);

%% Target angles
t = [target target2 target3 target4 target5 target6];
t = con2seq(t);
setdemorandstream(491218382);  % remove random seed

% Create a Fitting Network
ftdnn_net = layrecnet([1:10],5);
ftdnn_net.trainParam.epochs = 10;
ftdnn_net.divideFcn = '';
setdemorandstream(491218382)
[p,Pi,Ai,t] = preparets(ftdnn_net,x,t);
ftdnn_net.trainParam.showWindow=0;
ftdnn_net = train(ftdnn_net,p,t,Pi);

 
% Test the Network
yp = ftdnn_net(p,Pi);
e = gsubtract(yp,t);
rmse_train = sqrt(mse(e));
weights(:,trialnumber) = getwb(ftdnn_net); % Get weights
net = ftdnn_net;
%% View the Network
% view(ftdnn_net)
yp = cell2mat(yp);
t = cell2mat(t);

figure, plot(T1,t, T1,yp);
 xlabel('Time (seconds)');
 ylabel('Elbow Joint Angle (degrees)');
 h = legend('actual angle','estimated angle',2);
 set(h,'Location','SouthEast')
%  
  %% CC - correlation coefficient : Training
 y_mn_train = mean(yp);
 t_mn_train = mean(t);
 
 for(n=1:N)
    num_train(n) = (yp(n)-y_mn_train)*(t(n)-t_mn_train);
    den1_train(n) = (yp(n)-y_mn_train)^2;
    den2_train(n) = (t(n)- t_mn_train)^2;
 end
% 
 %% R square value - : Training
 for(n=1:N)
     den_R2(n) = (yp(n) - mean(yp));
 end
 
 R2 = 1 - (mse(e)/mean(den_R2.^2));
 
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

