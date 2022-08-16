x = [1;2;3;4;5;6];
RMSE_e = [22.7808; 24.58975; 25.91825; 23.11625; 19.679; 15.15675];
CC_e = [0.82781; 0.84455; 0.84684; 0.86058; 0.89826; 0.91403];
R2_e = [-0.30747; -0.34894; -0.61245; -0.02905; 0.44857; 0.7358];

RMSE_s = [14.0525; 12.949; 13.07775; 12.77325; 12.2445; 12.22825];
CC_s = [0.923098; 0.930523; 0.931248; 0.933403; 0.936163; 0.93623];
R2_s = [0.811595; 0.843773; 0.820645; 0.834565; 0.844515; 0.867753];

figure, plot(x,RMSE_s,'-x', x,RMSE_e,'-x');
 xlabel('Number of trials used to train the network');
 ylabel('RMSE (degrees)');
 h = legend('Shoulder','Elbow',2);
 set(h,'Location','SouthEast')
 
%  figure, plot(x,CC_s, x,CC_e);
%  xlabel('Number of trials used to train the network');
%  ylabel('CC (degrees)');
%  h = legend('Shoulder','Elbow',2);
%  set(h,'Location','SouthEast')
 
 figure, plot(x,R2_s, '-x', x,R2_e, '-x');
 xlabel('Number of trials used to train the network');
 ylabel('R2 (degrees)');
 h = legend('Shoulder','Elbow',2);
 set(h,'Location','SouthEast')