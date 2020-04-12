function fit=greedy_v1(candidate_fog,selected_sensor_length,selected_fog_length,fog_size)%50个雾设备的编号
% 输入 ： 候选的50个雾设备编号
% 输出 ： 500个传感器与50个雾设备的映射关系

% 导传感器位置信息
sensor = load('Sensor_position_Middle.mat');
sensor = sensor.Sensor_position_Middle;% 获取传感设备的坐标
% 导入雾设备位置信息 
fog_available = load('Fog_position_Middle.mat');
fog_available= fog_available.Fog_position_Middle;



%得到选中雾设备节点坐标
fog_selected_location = zeros(selected_fog_length,2);
for i = 1:selected_fog_length
    fog_selected_location(i,:) = fog_available(candidate_fog(i),:);
end




% 1、导入雾设备连接数信息
% 2、导入雾设备处理速度
% 3、导入雾设备的存储容量
% 4、导入传感设备的延迟约束
% 5、导入传感设备的任务量
fog_limit =  load('Fog_LinkOfSize_Middle.mat');
fog_limit = fog_limit.Fog_LinkOfSize_Middle;

fog_speed = load('Fog_DealOfTask_Middle.mat');
fog_speed = fog_speed.Fog_DealOfTask_Middle*10;

fog_capacity =  load('Fog_Capacity_Middle.mat');
fog_capacity = fog_capacity.Fog_Capacity_Middle;


sensor_delay  = load('Sensor_Delay_Middle.mat');
sensor_delay = sensor_delay.Sensor_Delay_Middle;

sensor_task = load('Sensor_Task_Middle.mat');
sensor_task = sensor_task.Sensor_Task_Middle;


% 获取部署传感器的坐标
sensor = sensor(1:selected_sensor_length,:);
%% Step 1计算 传感器到 雾设备 的距离
D = pdist2(sensor,fog_selected_location);

min_value = zeros(selected_sensor_length,1);
index = zeros(selected_sensor_length,1);
%% Step2:传感器选中雾设备节点
for i=1:selected_sensor_length
    [min_value(i),index(i)]=min(D(i,:));%返回最小值及其对应位置
   
    %判断是否违约，布尔值
    flag_limit = 0;
    flag_capacity = 0;
    flag_delay = 0;
    
  
    %% Step3 判断当前雾设备是否满足约束
    
    max_limit = selected_fog_length;
    while max_limit>0
     % 剩余连接数大于当前雾设备连接数
     if fog_limit(index(i))>0
        flag_limit  = 1;
     end
    
    % 剩余容量大于当前雾设备容量
    if fog_capacity(index(i))> sensor_task(i)
        flag_capacity = 1;
    end
    
    
    % 当前处理速度要大于规定的约束
  
    if (sensor_task(i)/fog_speed(index(i)))<sensor_delay(i) 
        flag_delay = 1;
    end
 
    
    % 1、判断是否满足连接数约束，如果满足，对应的连接数-1
    % 2、判断是否满足容量约束，如果满足，对应雾设备的容量减1、否则重新选择雾设备
    % 3 判断是否满足延迟约束，如果不满足，则重新选择下一雾设备
    
    % 结果为0,说明有一组不满足
  
    % 重新判断
    
     if flag_limit*flag_capacity*flag_delay==1
        break;
     else
     % 重新选择新的节点
     D(i,index(i)) = Inf;
     [min_value(i),index(i)]=min(D(i,:));
         max_limit = max_limit-1;
       
     end
     
    
    end 
    
    % 部署完成后，得到剩余连接数以及剩余容量
    fog_limit(index(i)) = fog_limit(index(i))-1;
    fog_capacity(index(i)) = fog_capacity(index(i))- sensor_delay(i) ;
    
end



fit = zeros(1,selected_sensor_length);
for i =1: selected_sensor_length
    fit(i) = candidate_fog(index(i));
end


end




