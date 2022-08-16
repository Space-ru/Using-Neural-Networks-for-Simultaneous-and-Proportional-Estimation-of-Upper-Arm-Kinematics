y1 = solar_dataset;


y = y1(1:600);
y2 = y1(601:1000);

ftdnn_net = timedelaynet([1:3],10);
ftdnn_net.trainParam.epochs = 250;
ftdnn_net.divideFcn = '';
setdemorandstream(491218382)
[p,Pi,Ai,t] = preparets(ftdnn_net,y,y);
ftdnn_net = train(ftdnn_net,p,t,Pi);


[p,Pi,Ai,t] = preparets(ftdnn_net,y2,y2);
yp = ftdnn_net(p,Pi);
e = gsubtract(yp,t);
rmse = sqrt(mse(e));
yp = cell2mat(yp);
p = cell2mat(p);
t = 1:397;
plot(t, p, t, yp);
