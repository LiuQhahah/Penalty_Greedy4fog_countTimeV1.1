%n = 1:20:20; 
%y = unidrnd(n)
%n = 10:15:20;%10到15之间生成20个数
%y = unidrnd(15,1,20);
%s = randsrc(1,10,[1 2 3 4])  ; % 产生 5*5 的矩阵，元素从1，2，3，4中选取，每一个以相等的概率出现

%R = randi([20,50],1,100) % 生成m×n的iMin:iMax之间的均匀分布随机数 整数
%F = randi([0,100],20,2)% 20个雾设备容量限制
%F = randi([10,15],1,20) %20个雾设备连接数的随机分布
%F = randi([3,7],1,20) %20 个雾设备的处理速度
%F = randi([5,10],1,100) %100 个传感器的延迟
%F = randi([100,150],1,20) %20个雾设备的价格 100 -150

% 生成 种群规模为500个传感器设备与50个雾设备的
% 传感器设备的位置为 1-500 个数为500. 50/10000  500/
Sensor_position_Middle = randi([0,100],100,2);
% 雾设备的位置为1-500 ，个数为50
Fog_position_Middle = randi([0,100],20,2);
% 私有云的位置
Private_Position_Middle = [50,50];

% 1、设置传感器的任务量大小
Sensor_Task_Middle  = randi([1,100],1,100);
% 2、设置传感器的任务量延迟大小
Sensor_Delay_Middle = randi([5,10],1,100);
% 3、设置雾设备的最大连接数大小
Fog_LinkOfSize_Middle = randi([8,12],1,20);
% 4、设置雾设备的单位时间内处理速度大小
Fog_DealOfTask_Middle = randi([8 ,10],1,20);
% 5、设置雾设备的最大承载量大小
Fog_Capacity_Middle = randi([250,550],1,20);
% 6、雾设备价格大小 500-800
Fog_Price_Middle = randi([500,800],1,20);


%Sensor_Task_Middle  = Sensor_Task_Middle.Sensor_Task_Middle*0.01
