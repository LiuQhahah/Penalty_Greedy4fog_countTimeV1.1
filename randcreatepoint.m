clear;
clc;
a = 100; %%%%% 长
b = 100; %%%%% 宽
%n = 100; %%%%% 点数量
n = 20;
cxd1 = a*rand(n,1); %%%%%% 产生横坐标
cxd2 = b*rand(n,1); %%%%%% 产生纵坐标
cxd = [cxd1 cxd2]; %%%%%% 生产随机点
figure(1)
plot(cxd1,cxd2,'o') %%%%%% 绘图，从图可以大致看出随机分布
figure(2)
hist(cxd1) %%%%%% 验证横坐标随机分布
figure(3)
hist(cxd2) %%%%%% 验证纵坐标随机分布
