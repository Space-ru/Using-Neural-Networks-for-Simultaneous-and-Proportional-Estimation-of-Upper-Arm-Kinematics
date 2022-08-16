% Testing Weights and network on new data
% Script generated by Neural Fitting app
% Created Tue Feb 02 14:23:59 CET 2016
%
close all;
clear all;
load('CVhorizontal2.mat');

trialnumber = 1;
offset = 1;
for trialnumber = 1:4
 if trialnumber == 1
    filename1 = 'FeaturesTrialsim17.mat';
    filename2 = 'FeaturesTrialsim18.mat';
   file1 = load('TestTrial7xyz.mat');
   file2 = load('TestTrial8xyz.mat');
    net = setwb(net,weights(:,1));
elseif trialnumber == 2
    filename1 = 'FeaturesTrialsim15.mat';
    filename2 = 'FeaturesTrialsim16.mat';
    file1 = load('TestTrial5xyz.mat');
    file2 = load('TestTrial6xyz.mat');
    net = setwb(net,weights(:,2));
elseif trialnumber == 3
    filename1 = 'FeaturesTrialsim20.mat';
    filename2 = 'FeaturesTrialsim14.mat';
    file1 = load('TestTrial10xyz.mat');
    file2 = load('TestTrial4xyz.mat');
    net = setwb(net,weights(:,3));
elseif trialnumber == 4
    filename1 = 'FeaturesTrialsim11.mat';
    filename2 = 'FeaturesTrialsim12.mat';
    file1 = load('TestTrial1xyz.mat');
    file2 = load('TestTrial2xyz.mat');
    net = setwb(net,weights(:,4));
 end
 
 
SHD = zeros(1,8000);
data = importdata(filename1);
target = data.store(101:4100,1)'; % the first and last second are omitted
RMS = data.store(101:4100,2)';
RMS_t = data.store((101:4100),3)';
target_s = data.store_t((101:4100),1)';
RMS_a = data.store_t(101:4100,2)';
RMS_p = data.store_t((101:4100),3)';
W_X = [file1.DownsampledData(101:4100,5); file2.DownsampledData(101:4100,5)]';
W_Y = [file1.DownsampledData(101:4100,6); file2.DownsampledData(101:4100,6)]';

data2 = importdata(filename2);
target2 = data2.store(101:4100,1)';
RMS2 = data2.store(101:4100,2)';
RMS_t2 = data2.store((101:4100),3)';
target_s2 = data2.store_t((101:4100),1)';
RMS_a2 = data2.store_t(101:4100,2)';
RMS_p2 = data2.store_t((101:4100),3)';

N = length(target)*2;
T1 = (1:N)/100;
input = [RMS RMS2; RMS_t RMS_t2; RMS_a RMS_a2];
x = input;
t = [target target2; target_s target_s2];

maxb = max(input(1,:));
maxt = max(input(2,:));
maxa = max(input(3,:));
minb = min(input(1,:));
mint = min(input(2,:));
mina = min(input(3,:));

% Test the Network
y = net(x);
e = gsubtract(t,y);
p1 = perform(net,t(1,:),y(1,:));
p2 = perform(net,t(2,:),y(2,:));
rmse_elbow = sqrt(p1);
rmse_shoulder = sqrt(p2);
 L1 = 316;
 L2 = 256;
ELB(1,:) = y(1,:);
SHD(1,:) = y(2,:);
 for i = 1:8000
    if SHD(1,i) > 90
        SHD(1,i) = SHD(1,i)-90;
        X_WRT(i)= L1.*cosd(SHD(1,i))- L2.*cosd(ELB(1,i)-SHD(1,i));
        Y_WRT(i)= -L1.*sind(SHD(1,i))- L2.*sind(ELB(1,i)-SHD(1,i));
    else
        X_WRT(i)= L1.*sind(SHD(1,i))+ L2.*sind(ELB(1,i)-SHD(1,i));
        Y_WRT(i)=L1.*cosd(SHD(1,i))- L2.*cosd(ELB(1,i)-SHD(1,i));
    end;
 end;
% 
error_x = (W_X-X_WRT).^2;
error_y = (W_Y-Y_WRT).^2;
RMSE_X(trialnumber) = sqrt(sum(error_x)/8000);
RMSE_Y(trialnumber) = sqrt(sum(error_y)/8000);
mean_x = mean(RMSE_X);
mean_y = mean(RMSE_Y);
std_x = std(RMSE_X);
std_y = std(RMSE_Y);

% % View the Network
% view(net)
figure, 
 subplot(2,1,1);
 plot(T1,t(1,:), T1,y(1,:));
 xlabel('Time (seconds)');
 ylabel('Elbow Angle (degrees)');
 subplot(2,1,2);
 plot(T1,t(2,:), T1,y(2,:));
 xlabel('Time (seconds)');
 ylabel('Shoulder Angle (degrees)');
 h = legend('actual angle','estimated angle',2);
 set(h,'Location','northoutside','Orientation','horizontal');
 
 figure, 
 subplot(2,1,1);
 plot(T1,X_WRT, T1, W_X);
 xlabel('Time (seconds)');
 ylabel('X (forward and backwards)');
 subplot(2,1,2);
 plot(T1,Y_WRT, T1, W_Y);
 xlabel('Time (seconds)');
 ylabel('Y (side-ways)');
 h = legend('estimated position','actual position',2);
 set(h,'Location','northoutside','Orientation','horizontal');
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
 
T = table(rmsetrain1', CCtrain1', R2train1' ,rmsetrain2', CCtrain2', R2train2','VariableNames',{'RMSE_Elbow', 'CC_Elbow', 'R2_Elbow' 'RMSE_Shoulder', 'CC_Shoulder', 'R2_Shoulder'},'RowNames',Rows)
