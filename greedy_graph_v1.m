clc
clear

% 10*20的矩阵 
a = popinit(60,50,100);



candidate_fog = a(1,:);





%data = load('/home/liu/Documents/Project4Mat/Clustering-matlab/Dataset/Spiral.mat');
% 导入500个传感器位置信息
sensor = load('Sensor_position_Big.mat');
sensor = sensor.Sensor_position_Big;% 获取传感设备的坐标
% 导入100个雾设备位置信息 
fog_available = load('Fog_position_Big.mat');
fog_available= fog_available.Fog_position_Big;

% 100个传感器连接到10个雾设备中，100×1 的数组提取出雾设备的编号

%sensor_link_fog
%fog_selected_number = unique(sensor_link_fog);

% 找出100个雾设备中被选中的集合 获取种群中雾设备的长度，计算一行的个数
fog_size = length(candidate_fog(1,:));
% 50个雾设备的x坐标、y坐标信息
fog_selected_location = zeros(fog_size,2);

for i = 1:fog_size
    fog_selected_location(i,:) = fog_available(candidate_fog(i),:);
end




% 1、导入雾设备连接数信息
% 2、导入雾设备处理速度
% 3、导入雾设备的存储容量
% 4、导入传感设备的延迟约束
% 5、导入传感设备的任务量

fog_limit =  load('Fog_LinkOfSize_Big.mat');
% 约束限制减少
fog_limit = fog_limit.Fog_LinkOfSize_Big*10;

fog_speed = load('Fog_DealOfTask_Big.mat');
% 约束限制减少
fog_speed = fog_speed.Fog_DealOfTask_Big*10;

fog_capacity =  load('Fog_Capacity_Big.mat');
% 约束限制减少
fog_capacity = fog_capacity.Fog_Capacity_Big*10;


sensor_delay  = load('Sensor_Delay_Big.mat');
sensor_delay = sensor_delay.Sensor_Delay_Big;

sensor_task = load('Sensor_Task_Big.mat');
sensor_task = sensor_task.Sensor_Task_Big;




% 计算 500个传感器到 50个 雾设备 的距离
D = pdist2(sensor,fog_selected_location);
sensor_size = length(sensor);
% 最小值、索引位置，1个传感器到10个雾设备的距离，100个传感器，所以最小值、索引值的大小为100
min_value = zeros(sensor_size,1);
index = zeros(sensor_size,1);
% 500个传感器设备

for i=1:sensor_size
    % 传感设备到10个雾设备的距离中，选取最短距离
    % max_a 表示最小距离、index表示雾设备的编号
    
    
    %[min_value(i),index(i)]=min(D(i,:),[],2);
    [min_value(i),index(i)]=min(D(i,:));
    % 约束条件这儿怎么处理
    flag_limit = 0;
    flag_capacity = 0;
    flag_delay = 0;
    
    %% 保证原子性 三个条件同时满足、三个条件同时不满足
    % 最多只允许执行10次
   
    
    max_limit = fog_size;
    while max_limit>0
    % start = index(i)
        
    % 当前雾设备的连接数允许再连接一个设备
  %  fog_limit(index(i))
    if fog_limit(index(i))>0
        flag_limit  = 1;
      %  fog_limit(index(i)) = fog_limit(index(i))-1;
    end
    
    % 剩余容量大于当前雾设备容量
    if fog_capacity(index(i))> sensor_task(i)
        flag_capacity = 1;
    end
    %flag_limit
    
    % 当前处理速度要大于规定的延迟
   % sensor_task(i)
    %fog_speed(index(i))
    %sensor_delay(i) 
    if (sensor_task(i)/fog_speed(index(i)))<sensor_delay(i) 
        flag_delay = 1;
    end
   % flag_delay
    
    % 1、判断是否满足连接数约束，如果满足，对应的连接数-1
    % 2、判断是否满足容量约束，如果满足，对应雾设备的容量减1、否则重新选择雾设备
    % 3 判断是否满足延迟约束，如果不满足，则重新选择下一雾设备
    
    % 结果为0,说明有一组不满足
  
    % 重新判断
   % flag_limit*flag_limit*flag_delay
     if flag_limit*flag_capacity*flag_delay==1
        break;
     end
     
     % 重新选择新的节点
     D(i,index(i)) = Inf;
     [min_value(i),index(i)]=min(D(i,:));
    % update  = index(i)
       max_limit = max_limit-1;
    end 
    
    % 部署完成后，得到剩余连接数以及剩余容量
    fog_limit(index(i)) = fog_limit(index(i))-1;
    fog_capacity(index(i)) = fog_capacity(index(i))- sensor_delay(i) ;
    
end







figure(1)
title('传感器连接到雾设备')

plot(fog_available(:,1),fog_available(:,2),'rs','LineWidth',1,...%
    'MarkerEdgeColor','r',...% 大红
    'MarkerFaceColor','r',...%蓝色
    'MarkerSize',10)
hold on


plot(sensor(:,1),sensor(:,2),'o','LineWidth',1,...
    'MarkerEdgeColor','k',...%黑色
    'MarkerFaceColor','g',...%绿色
    'MarkerSize',5)

    
for i=1:sensor_size%画线，候选设备到其余节点的连接
    x=[sensor(i,1),fog_available(candidate_fog(index(i)),1)];
    y=[sensor(i,2),fog_available(candidate_fog(index(i)),2)];
    plot(x,y,'c');hold on %亮蓝
end


figure(2)
title('雾设备连接到私有云')


plot(fog_available(:,1),fog_available(:,2),'rs','LineWidth',1,...%
    'MarkerEdgeColor','k',...%黑色
    'MarkerFaceColor','g',...%绿色
    'MarkerSize',5)
hold on
plot(250,250,'rs','LineWidth',1,...%
    'MarkerEdgeColor','r',...% 大红
    'MarkerFaceColor','r',...%蓝色
    'MarkerSize',10)


for i=1:fog_size%画线，候选设备到其余节点的连接
   
        x=[250,fog_available(candidate_fog(i),1)];
        y=[250,fog_available(candidate_fog(i),2)];
        plot(x,y,'b',...  
        'MarkerEdgeColor','k',...%黑色
        'MarkerFaceColor','y',...%绿色
        'MarkerSize',10);hold on %黑色
    
end









