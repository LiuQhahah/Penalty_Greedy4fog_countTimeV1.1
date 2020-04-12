function [fit,fit_delay,fit_capaticy,fit_limit]=fitness(sensor_link_fog)%传感器位置、候选雾节点位置传进来的参数是一组x,y坐标
%计算个体适应度值
%candidate_fog    input      选中的雾设备
% fs             input      适应度值与罚函数的权重比
%fit           output     适应度值


price_fog = load('Fog_Price_Middle.mat');
price_fog = price_fog.Fog_Price_Middle;


wire_price = 1;%光纤价格
%找出最近配送点
%语法解释：city_coordinate(i,:)':'表示所有列，i表示第i行
% distance:100*10，记录了100个节点到10个候选位置的数值fit

% 测试用例：
% 1、a = popinit(60,10);
% 2、candidate_fog = a(1,:);
% 3、sensor_link_fog = greedy_v1(candidate_fog);
% 4、统计10个雾设备的连接数
%{
fog_select = zeros(1,20);
for i = 1:100
    fog_select(sensor_link_fog(i)) = fog_select(sensor_link_fog(i))+1;
end
%}

% 5、计算100传感器设备到雾设备的距离
%{
distance = zeros(1,100);
for i = 1:100
    distance(i) = dist(fog(sensor_link_fog(i),:),sensor(i,:)');
    
end
%}

% 6、计算雾设备到云中心的成本
%{
cloud = [50,50];
distance_cloud_fog = zeros(1,10);
for i = 1:10%计算10个雾设备到私有云的距离
        distance_cloud_fog(i) = dist(fog(candidate_fog(i),:),cloud');
end
expense_wire_fog_cloud = wire_price*sum(distance_cloud_fog);
%}


% 导入500个传感器位置信息
sensor = load('Sensor_position_Middle.mat');
sensor = sensor.Sensor_position_Middle;% 获取传感设备的坐标
% 导入100个雾设备位置信息 
fog_available = load('Fog_position_Middle.mat');
fog= fog_available.Fog_position_Middle;

% 长度为100
fog_size = length(fog);
% 传感器大小为500
selected_sensor_length = length(sensor_link_fog);
%fog_select = [ 10  ,   7 ,   15 ,   19 ,    6  ,  13 ,    3  ,  18  ,  16 ,    4];
%sensor_link_fog = [  3  ,   6  ,   4   , 13  ,   6   , 13  ,  13  ,  10,    16  ,   6  ,   7  ,   6  ,  13 ,   10  ,   3 ,   19  ,  18  ,  13 ,    6,    15 ,   13  ,  13  ,  16  ,  10  ,  10  ,  18  ,   7, 4   ,  4    ,19   , 19  ,  18 ,   15 ,   15  ,   7  ,  10,    13 ,   19   , 15 ,    6  ,  10 ,   13  ,   7   , 10   , 13,    19 ,    6  ,   3  ,   6   ,  3    ,18    ,15  ,  18 ,    7,4  ,  13   , 10  ,   7   , 15 ,   10,     7,    10  ,  10   ,  3 ,   15  ,  18   , 16  ,   3   , 10     ,6    ,19  ,  13 ,   13   , 18 ,    4    ,19 ,   18  ,   6    ,19  ,  10  ,   7,  4 ,    7   ,  4   , 15    , 7,     3   ,  4    ,13   , 19  ,   6  ,   6   , 19   ,  3   ,  4  ,  19 ,    7 ,    7 ,   19,    13];






%% 统计雾设备选中的元素，以及连接传感设备的个数
fog_select = zeros(1,fog_size);
for i = 1:selected_sensor_length
   
    fog_select(sensor_link_fog(i)) = fog_select(sensor_link_fog(i))+1;
end

% 候选雾设备的个数fog_candidate_size
fog_candidate_size= 0;
for i = 1:fog_size
    if fog_select(i)>0
        fog_candidate_size = fog_candidate_size+1;
    end
end


%% 传感设备连接到雾设备的距离 距离2×2矩阵
distance = zeros(1,selected_sensor_length);
for i = 1:selected_sensor_length
    distance(i) = dist(fog(sensor_link_fog(i),:),sensor(i,:)');
    
end
expense=wire_price*sum(distance);%成本：距离乘以网线的价格

%% 计算部署设备的费用 计算方式1 弃用
%{
expense_fog = zeros(1,20);
for i = 1:20
    if fog_select(i)>0
    expense_fog(i)  =  price_fog(i);
    end
end
%}


%% 雾设备到私有云的距离

cloud = load('Private_Position_Middle.mat');
cloud = cloud.Private_Position_Middle;
distance_cloud_fog = zeros(1,fog_size);

for i = 1:fog_size%计算50个雾设备到私有云的距离
        if fog_select(i)>0
                distance_cloud_fog(i) = dist(fog(i,:),cloud');
        end
        
    
end

%expense_wire_fog_cloud = wire_price*sum(distance_cloud_fog);
%% 适应度函数:线缆成本+设备成本+线缆成本


 %% 适应度函数添加惩罚函数
 % 1、惩罚函数1：容量约束的惩罚
 % 2、惩罚函数2：连接数约束惩罚
 % 3、惩罚函数3：传感器任务延迟惩罚
 


% 1、导入雾设备连接数信息
% 2、导入雾设备处理速度
% 3、导入雾设备的存储容量
% 4、导入传感设备的延迟约束
% 5、导入传感设备的任务量

fog_limit =  load('Fog_LinkOfSize_Middle.mat');

%有约束
fog_limit = fog_limit.Fog_LinkOfSize_Middle;

fog_speed = load('Fog_DealOfTask_Middle.mat');


% 有约束
fog_speed = fog_speed.Fog_DealOfTask_Middle;

fog_capacity =  load('Fog_Capacity_Middle.mat');


%有约束
fog_capacity = fog_capacity.Fog_Capacity_Middle;


sensor_delay  = load('Sensor_Delay_Middle.mat');
sensor_delay = sensor_delay.Sensor_Delay_Middle;

sensor_task = load('Sensor_Task_Middle.mat');
sensor_task = sensor_task.Sensor_Task_Middle;

% 计算部署设备的费用 计算方式2
%fog_candidate_size = length(candidate_fog);
expense_fog = zeros(1,fog_size);

for i = 1:fog_size
    if fog_select(i)>0% 大于0 ，说明此编号为i的雾设备被选中
        expense_fog(i)  =  fog_capacity(i)+fog_speed(i);% 传感设备到雾设备的编号
    end
    
   
end


% 1、雾设备的容量约束 20×1
% 2、雾设备的连接数约束 20×1
% 3、传感器任务约束 100×1
fog_receive = zeros(1,fog_size);
fog_number = zeros(1,fog_size);

% 统计雾设备接收任务量与雾设备的连接数
for i = 1:selected_sensor_length 
   fog_receive(sensor_link_fog(i)) = fog_receive(sensor_link_fog(i))+sensor_task(i);
   fog_number(sensor_link_fog(i)) = fog_number(sensor_link_fog(i))+1;
end


penalty_limit = 0;
penalty_capacity = 0;
penalty_delay = 0;

% 计算违约的个数
for i = 1:fog_size
    if  fog_limit(i)<fog_number(i) % 雾设备规定的连接数小于实际连接数，违反了
       % flag = flag + 1;
       penalty_limit = penalty_limit+fog_number(i) - fog_limit(i);%实际连接数- 规定连接数
      
    end
    if fog_capacity(i)< fog_receive(i)% 雾设备规定的容量 小于 雾设备实际接收的容量
        % flag = flag + 1;
        penalty_capacity = penalty_capacity+fog_receive(i)-fog_capacity(i);
    end 
end

%计算延时，找到雾设备接受的总任务量，得到最小延时。
% fog_receive为接受的总任务量
for i=1:fog_size
   
    cc=find(sensor_link_fog==i);%获取等于编号的传感器信息
    if min(sensor_delay(cc))<fog_receive(i)/fog_speed(i)
         penalty_delay = penalty_delay +  fog_receive(i)/fog_speed(i)-min(sensor_delay(cc));
    end   
        
end
%{
for i = 1:selected_sensor_length
        if sensor_delay(i)< (sensor_task(i)/fog_speed(sensor_link_fog(i)))% 传感器规定的任务延迟 小于实际运算结果
          %  flag = flag+1;
          penalty_delay = penalty_delay +  (sensor_task(i)/fog_speed(sensor_link_fog(i))) - sensor_delay(i);
         
        end
      % (sensor_task(i)/fog_speed(sensor_link_fog(i)))
end
%}


expense_wire_fog_cloud = 0;
% 价格范围 3600 100 6830
fit_fit = expense+sum(expense_fog) + sum(expense_wire_fog_cloud) ;% 4.0e+4*length(find(distance>60));
% fit_punishment = M*flag;

% fit_fit 千位数
%penalty_limit ：个位数
% penalty_capacity：常为0
% penalty_delay： 十位数

% 保证容量、连接数、延迟在一个数据量中，同时整体要比适应度高2个数量级
M_limit = 100*1000;
M_capacity  = 1000;
M_delay = 100*1000;
%penalty_limit
%penalty_capacity
%penalty_delay
fit_punishment =M_limit*penalty_limit+M_capacity*penalty_capacity+M_delay*penalty_delay ;
%fit_punishment =M_limit*penalty_limit+M_capacity*penalty_capacity+M_delay*penalty_delay ;
%fit_fit

%flag


%fit = fit_fit+fit_punishment;
%fit_punishment*fs % 389100   3.7138e+05 370000
%fit_fit*(1-fs) % 1236   1.1863e+03 1186
fit=fit_fit+fit_punishment;
fit_delay = penalty_delay;
fit_capaticy=penalty_capacity;
fit_limit=penalty_limit;



end