% Training Procedure for MLP (X-fold cross-validation)
% Author: Christian Grech
% Software: MATLAB 2014, Excel 2013
% Output: Network object, weights

close all;
clear all;
trialnumber = 1;
offset = 1;
for trialnumber = 1:4
 if trialnumber == 1
    filename1 = 'FeaturesTrialsim3.mat';
    filename2 = 'FeaturesTrialsim1.mat';
    filename3 = 'FeaturesTrialsim4.mat';
    filename4 = 'FeaturesTrialsim5.mat';
    filename5 = 'FeaturesTrialsim6.mat';
    filename6 = 'FeaturesTrialsim8.mat';
elseif trialnumber == 2
    filename1 = 'FeaturesTrialsim3.mat';
    filename2 = 'FeaturesTrialsim1.mat';
    filename3 = 'FeaturesTrialsim5.mat';
    filename4 = 'FeaturesTrialsim4.mat';
    filename5 = 'FeaturesTrialsim9.mat';
    filename6 = 'FeaturesTrialsim10.mat';
elseif trialnumber == 3
    filename1 = 'FeaturesTrialsim1.mat';
    filename2 = 'FeaturesTrialsim3.mat';
    filename3 = 'FeaturesTrialsim6.mat';
    filename4 = 'FeaturesTrialsim8.mat';
    filename5 = 'FeaturesTrialsim9.mat';
    filename6 = 'FeaturesTrialsim10.mat';
elseif trialnumber == 4
    filename1 = 'FeaturesTrialsim4.mat';
    filename2 = 'FeaturesTrialsim5.mat';
    filename3 = 'FeaturesTrialsim6.mat';
    filename4 = 'FeaturesTrialsim8.mat';
    filename5 = 'FeaturesTrialsim9.mat';
    filename6 = 'FeaturesTrialsim10.mat';
end

data = importdata(filename1);
target = data.store(101:4100,1)'; % the first and last second are omitted
RMS = data.store(101:4100,2)';
RMS_t = data.store((101:4100),3)';
target_s = data.store_t((101:4100),1)';
RMS_a = data.store_t(101:4100,2)';
RMS_p = data.store_t((101:4100),3)';

data2 = importdata(filename2);
target2 = data2.store(101:4100,1)';
RMS2 = data2.store(101:4100,2)';
RMS_t2 = data2.store((101:4100),3)';
target_s2 = data2.store_t((101:4100),1)';
RMS_a2 = data2.store_t(101:4100,2)';
RMS_p2 = data2.store_t((101:4100),3)';

data3 = importdata(filename3);
target3 = data3.store(101:4100,1)';
RMS3 = data3.store(101:4100,2)';
RMS_t3 = data3.store((101:4100),3)';
target_s3 = data3.store_t((101:4100),1)';
RMS_a3 = data3.store_t(101:4100,2)';
RMS_p3 = data3.store_t((101:4100),3)';

data4 = importdata(filename4);
target4 = data4.store(101:4100,1)';
RMS4 = data4.store(101:4100,2)';
RMS_t4 = data4.store((101:4100),3)';
target_s4 = data.store_t((101:4100),1)';
RMS_a4 = data4.store_t(101:4100,2)';
RMS_p4 = data4.store_t((101:4100),3)';

data5 = importdata(filename5);
target5 = data5.store(101:4100,1)';
RMS5 = data5.store(101:4100,2)';
RMS_t5 = data5.store((101:4100),3)';
target_s5 = data5.store_t((101:4100),1)';
RMS_a5 = data5.store_t(101:4100,2)';
RMS_p5 = data5.store_t((101:4100),3)';

data6 = importdata(filename6);
target6 = data6.store(101:4100,1)';
RMS6 = data6.store(101:4100,2)';
RMS_t6 = data6.store((101:4100),3)';
target_s6 = data6.store_t((101:4100),1)';
RMS_a6 = data6.store_t(101:4100,2)';
RMS_p6 = data6.store_t((101:4100),3)';

N = length(target)*6;                     
T1 = (1:N)/100;

input = [RMS RMS2 RMS3 RMS4 RMS5 RMS6; RMS_t RMS_t2 RMS_t3 RMS_t4 RMS_t5 RMS_t6; RMS_a RMS_a2 RMS_a3 RMS_a4 RMS_a5 RMS_a6; RMS_p RMS_p2 RMS_p3 RMS_p4 RMS_p5 RMS_p6];
x = input;
t = [target target2 target3 target4 target5 target6; target_s target_s2 target_s3 target_s4 target_s5 target_s6 ];

% 'trainlm' is usually fastest.
% 'trainbr' takes longer but may be better for challenging problems.
% 'trainscg' uses less memory. NFTOOL falls back to this in low memory situations.
trainFcn = 'trainlm';  % Levenberg-Marquardt
setdemorandstream(491218382); %remove random seed

% Create a Fitting Network
hiddenLayerSize = 3;
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
p1 = perform(net,t(1,:),y(1,:));
p2 = perform(net,t(2,:),y(2,:));
rmse_elbow = sqrt(p1);
rmse_shoulder = sqrt(p2);
weights(:,trialnumber) = getwb(net);

% % View the Network
% view(net)
 
 figure, 
 subplot(2,1,1);
 plot(T1,t(1,:), T1,y(1,:));
 xlabel('Time (seconds)');
 ylabel('Elbow Joint Angle (degrees)');
 h = legend('actual angle','estimated angle',2);
 set(h,'Location','SouthEast')
 
 subplot(2,1,2);
 plot(T1,t(2,:), T1,y(2,:));
 xlabel('Time (seconds)');
 ylabel('Shoulder Joint Angle (degrees)');
 h = legend('actual angle','estimated angle',2);
 set(h,'Location','SouthEast')
%  
  %% CC - correlation coefficient : Training
 y1 = y(1,:);
 y2 = y(2,:);
 t1 = t(1,:);
 t2 = t(2,:);
 y_mn_train = mean(y1);
 t_mn_train = mean(t1);
 y_mn_train2 = mean(y2);
 t_mn_train2 = mean(t2);
 
 for(n=1:N)
    num_train(n) = (y1(n)-y_mn_train)*(t1(n)-t_mn_train);
    den1_train(n) = (y1(n)-y_mn_train)^2;
    den2_train(n) = (t1(n)- t_mn_train)^2;
    
    num_train2(n) = (y2(n)-y_mn_train2)*(t2(n)-t_mn_train2);
    den1_train2(n) = (y2(n)-y_mn_train2)^2;
    den2_train2(n) = (t2(n)- t_mn_train2)^2;
 end
% 
 %% R square value - : Training
 for(n=1:N)
     den_R2(n) = (y1(n) - mean(y1));
     den_R2_2(n) = (y2(n) - mean(y2));
 end
 
 R2 = 1 - (p1/mean(den_R2.^2));
 R2_2 = 1 - (p2/mean(den_R2_2.^2));
 
 numerator_train = sum(num_train);
 denominator_train = sqrt(sum(den1_train)*sum(den2_train));
 CC_1 = numerator_train/denominator_train;
 
 numerator_train2 = sum(num_train2);
 denominator_train2 = sqrt(sum(den1_train2)*sum(den2_train2));
 CC_2 = numerator_train2/denominator_train2;
 
Rows = {'1';'2';'3';'4';'Mean';'SD'};

rmsetrain(trialnumber) = rmse_elbow;
 CCtrain(trialnumber) = CC_1;
 R2train(trialnumber) = R2;
 
 rmsetrain2(trialnumber) = rmse_shoulder;
 CCtrain2(trialnumber) = CC_2;
 R2train2(trialnumber) = R2_2;

end

%% Analysis of results in a table
 rmse_train_mean = mean(rmsetrain); %Calculate mean
 CC_train_mean = mean(CCtrain);
 R2_train_mean = mean(R2train);
 
 rmse_train_mean2 = mean(rmsetrain2); %Calculate mean
 CC_train_mean2 = mean(CCtrain2);
 R2_train_mean2 = mean(R2train2);
 
 rmse_train_std = std(rmsetrain); % Calculate stdeviation
 CC_train_std = std(CCtrain);
 R2_train_std = std(R2train);
 
 rmse_train_std2 = std(rmsetrain2); % Calculate stdeviation
 CC_train_std2 = std(CCtrain2);
 R2_train_std2 = std(R2train2);
 
 rmsetrain1 = [rmsetrain rmse_train_mean rmse_train_std]; % Append Mean and Stdeviation
 CCtrain1 = [CCtrain CC_train_mean CC_train_std];
 R2train1 = [R2train R2_train_mean R2_train_std];
 
 rmsetrain2 = [rmsetrain2 rmse_train_mean2 rmse_train_std2]; % Append Mean and Stdeviation
 CCtrain2 = [CCtrain2 CC_train_mean2 CC_train_std2];
 R2train2 = [R2train2 R2_train_mean2 R2_train_std2];
 
T = table(rmsetrain1', CCtrain1', R2train1',rmsetrain2', CCtrain2', R2train2','VariableNames',{'RMSE_Elbow', 'CC_Elbow', 'R2_Elbow' 'RMSE_Shoulder', 'CC_Shoulder', 'R2_Shoulder'},'RowNames',Rows)
save('CV.mat', 'net', 'weights')

