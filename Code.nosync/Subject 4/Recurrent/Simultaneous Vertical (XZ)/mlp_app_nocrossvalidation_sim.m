% Training Procedure for MLP (X-fold cross-validation)
% Author: Christian Grech
% Software: MATLAB 2014, Excel 2013
% Output: Network object, weights

close all;
clear all;
trialnumber = 1;
offset = 1;
for trialnumber = 1:8
if trialnumber == 1
    filename1 = 'FeaturesTrialsim1.mat';
elseif trialnumber == 2
    filename1 = 'FeaturesTrialsim3.mat';
elseif trialnumber == 3
    filename1 = 'FeaturesTrialsim4.mat';
elseif trialnumber == 4
    filename1 = 'FeaturesTrialsim5.mat';
elseif trialnumber == 5
    filename1 = 'FeaturesTrialsim6.mat';
elseif trialnumber == 6
    filename1 = 'FeaturesTrialsim8.mat';
elseif trialnumber == 7
    filename1 = 'FeaturesTrialsim2.mat';
elseif trialnumber == 8
    filename1 = 'FeaturesTrialsim7.mat';
end

data = importdata(filename1);
target = data.store(101:4100,1)'; % the first and last second are omitted
RMS = data.store(101:4100,2)';
RMS_t = data.store((101:4100),3)';
target_s = data.store_t((101:4100),1)';
RMS_a = data.store_t(101:4100,2)';
RMS_p = data.store_t((101:4100),3)';

N = length(target);                     
T1 = (1:N)/100;

input = [RMS; RMS_t; RMS_a; RMS_p]; % Four inputs
x = input;
t = [target; target_s]; %

% 'trainlm' is usually fastest.
% 'trainbr' takes longer but may be better for challenging problems.
% 'trainscg' uses less memory. NFTOOL falls back to this in low memory situations.
trainFcn = 'trainlm';  % Levenberg-Marquardt
setdemorandstream(491218382);

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
 set(h,'Location','SouthEast', 'Orientation','Horizontal');
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
 
Rows = {'1';'2';'3';'4';'5';'6';'7';'8';'Mean';'SD'};

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
save('noCV.mat', 'net', 'weights');

