%% Linear Regression cross-validation training model
% Christian Grech

close all;
clear all;

trialnumber = 1;
offset = 1;
for trialnumber = 1:4
 if trialnumber == 1
    filename1 = 'FeaturesTrial1_RMS.mat';
    filename2 = 'FeaturesTrial2_RMS.mat';
    filename3 = 'FeaturesTrial3_RMS.mat';
    filename4 = 'FeaturesTrial4_RMS.mat';
    filename5 = 'FeaturesTrial5_RMS.mat';
    filename6 = 'FeaturesTrial6_RMS.mat';
elseif trialnumber == 2
    filename1 = 'FeaturesTrial1_RMS.mat';
    filename2 = 'FeaturesTrial2_RMS.mat';
    filename3 = 'FeaturesTrial3_RMS.mat';
    filename4 = 'FeaturesTrial4_RMS.mat';
    filename5 = 'FeaturesTrial7_RMS.mat';
    filename6 = 'FeaturesTrial9_RMS.mat';
elseif trialnumber == 3
    filename1 = 'FeaturesTrial1_RMS.mat';
    filename2 = 'FeaturesTrial2_RMS.mat';
    filename3 = 'FeaturesTrial5_RMS.mat';
    filename4 = 'FeaturesTrial6_RMS.mat';
    filename5 = 'FeaturesTrial7_RMS.mat';
    filename6 = 'FeaturesTrial9_RMS.mat';
elseif trialnumber == 4
    filename1 = 'FeaturesTrial3_RMS.mat';
    filename2 = 'FeaturesTrial4_RMS.mat';
    filename3 = 'FeaturesTrial5_RMS.mat';
    filename4 = 'FeaturesTrial6_RMS.mat';
    filename5 = 'FeaturesTrial7_RMS.mat';
    filename6 = 'FeaturesTrial9_RMS.mat';
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

input2 = [RMS RMS2 RMS3 RMS4 RMS5 RMS6]';
input3 = [RMS_t RMS_t2 RMS_t3 RMS_t4 RMS_t5 RMS_t6]';
x = input2;
x_2 = input3;
t = [target target2 target3 target4 target5 target6]';

tbl = table(x,x_2,t,'VariableNames',{'Input_b','Input_t','Angle'});

lm = fitlm(tbl,'linear');

intercept(trialnumber) = lm.Coefficients{1,{'Estimate'}};
bicep_constant(trialnumber) = lm.Coefficients{2,{'Estimate'}};
tricep_constant(trialnumber) = lm.Coefficients{3,{'Estimate'}};
Rows = {'1';'2';'3';'4';'Mean';'SD'};
end
%% Analysis
c1_mean = mean(bicep_constant);
c2_mean = mean(tricep_constant);
c3_mean = mean(intercept);

c1_std = std(bicep_constant);
c2_std = std(tricep_constant);
c3_std = std(intercept);

c1_1 = [bicep_constant c1_mean c1_std];
c2_1 = [tricep_constant c2_mean c2_std];
c3_1 = [intercept c3_mean c3_std];

T_2 = table(c1_1',c2_1',c3_1','VariableNames',{'Bicep_Constant' 'Tricep_Constant' 'Intercept'},'RowNames',Rows)
save('LR.mat', 'intercept', 'bicep_constant', 'tricep_constant'); %Output linear model parameters
