

%% 清空环境
clc
clear

%%传感器坐标
sensor = load('Sensor_position_Middle.mat');
sensor = sensor.Sensor_position_Middle;
% 雾设备坐标
fog = load('Fog_position_Middle.mat');
fog= fog.Fog_position_Middle;



%% 算法基本参数    
sizepop=45;           % 记忆库种群
overbest=3;          % 优秀种群
MAXGEN=40;            % 迭代次数
pcross=0.1;           % 交叉概率
pmutation=0.1;        % 变异概率
ps=0.5;              % 多样性评价参数
M=sizepop+overbest; %种群规模：记忆库种群+优秀种群
ss = 0.5                    ; %相似度阈值

%% 场景设置
%selected_sensor_length 部署传感器节点总数
%fog_size               雾设备节点总数
%selected_fog_length     选中雾设备节点个数
selected_sensor_length =80 ;
selected_fog_length = 15;
fog_size = 20;   


%% 参数
%适应度值——fitness
%浓度——concentration
%延时惩罚值——fit_delay
%容量惩罚值——fit_capaticy
%连接数惩罚值——fit_limit
%期望繁殖概率——excellence
%选中雾设备节点集合——candidate_fog
%传感器节点与雾设备节点对应关系——sensor_link_fog
individuals = struct('fitness',zeros(1,M), 'concentration',zeros(1,M),'fit_delay',zeros(1,M),'fit_capaticy',zeros(1,M),'fit_limit',zeros(1,M), 'excellence',zeros(MAXGEN,M),'candidate_fog',zeros(M,selected_fog_length),'sensor_link_fog',zeros(M,selected_sensor_length));
%% step1 产生初始种群：
%得到选中的雾设备节点，比如从8个雾设备节点中选择4个节点，返回结果为1 3 4 5
individuals.candidate_fog = popinit(M,selected_fog_length,fog_size); 

trace=[]; %记录每代最个体优适应度和平均适应度
trace_delay = [];%记录每次迭代的延时违约值
fit_capaticy = [];%记录每次迭代的容量违约值
fit_limit = [];%记录每次迭代的连接数违约值
time_trace = zeros(6,MAXGEN);%记录算法运行时间
tic; %计时开始
  %% step2 迭代
 iii = 1;
 while true
   if iii>21&&(trace(iii-1,1)-trace(iii-20,1)<trace(iii-1,1)*0.01) %算法终止条件 ：优化进度不足1%且20代无进化
   
      break;
  else
  
%for iii=1:MAXGEN % 迭代次数 
    %%任务：1计算初始化解（适应度、抗体浓度）
    %2、根据亲和度与浓度评价 
    %3、计算优秀局部与整体的平均适应度
    %4更新局部与整体的最优
    %5、选择、交叉、变异

   
     %% step2 计算适应度值与浓度
     for i=1:M 
        % 得到雾设备与传感器的连接关系
        individuals.sensor_link_fog(i,1:selected_sensor_length) = greedy_v1(individuals.candidate_fog(i,1:selected_fog_length),selected_sensor_length,selected_fog_length,fog_size);
        % 计算当前部署结果的适应度值及延时惩罚值、容量惩罚值、连接数惩罚值
        [individuals.fitness(i),individuals.fit_delay(i),individuals.fit_capaticy(i),individuals.fit_limit(i)]= fitness(individuals.sensor_link_fog(i,1:selected_sensor_length));      % 抗体与抗原亲和度(适应度值）计算 M个初始解
          
     end
     
     for i=1:M
       individuals.concentration(i) = concentration(i,M,individuals,ss); % 抗体浓度计算：与相似度有关，同一次迭代中，相似度越大，浓度越高
     end
       
       
   
     
     % 综合亲和度和浓度评价抗体优秀程度，得出繁殖概率 
     % 期望的繁殖概率一致
     individuals.excellence(iii,:) = excellence(individuals,M,ps);
 
          
     % 记录当代最佳个体和种群平均适应度
     [best,index] = min(individuals.fitness);   % 找出最优适应度 ，在M个初始解中找到最优的
      % 找出最优适应度 ，在M个初始解中找到最优的
     bestsensor = individuals.sensor_link_fog(index,:);
     average = mean(individuals.fitness);       % 计算平均适应度
               % 记录 每次迭代均记录 每一次的最小值与平均值
      trace = [trace;best,average]; 
       %trace(iii,1)
    trace_delay = [trace_delay;individuals.fit_delay(index)]; 
    fit_capaticy = [fit_capaticy;individuals.fit_capaticy(index)];
    fit_limit = [fit_limit;individuals.fit_limit(index)];
     %% step4 根据excellence，形成父代群，更新记忆库（加入精英保留策略，可由s控制）
     bestindividuals = bestselect(individuals,M,overbest);   % 更新记忆库
     individuals = bestselect(individuals,M,sizepop);        % 形成父代群   
     
       
    
     %% step 选择，交叉，变异操作，再加入记忆库中抗体，产生新种群
     individuals = Select(individuals,sizepop);  %选择 将 100个传感器 打到10个雾设备中    
     individuals.candidate_fog = Cross(pcross,individuals.candidate_fog,sizepop,selected_fog_length);    %交叉   交叉概率0.5                              
     individuals.candidate_fog = Mutation(pmutation,individuals.candidate_fog,sizepop,fog_size);   % 变异
     individuals = incorporate(individuals,sizepop,bestindividuals,overbest);   %新种群    
     
    
iii = iii+1;
iii
   
  end
end


toc

trace(iii-1)
trace_delay(iii-1)
fit_capaticy(iii-1)
fit_limit(iii-1)

%% 生成惩罚值对比图
%{
figure(1)
ga_ia_fit= load('giha201580matlab.mat');
ga_ia_fit = ga_ia_fit.trace(:,1);

plot(ga_ia_fit);
hold on
ia_fit = load('ia201580matlab.mat');
ia_fit = ia_fit.trace(:,1);

plot(ia_fit,'--');
legend('GIHA','IA')

title('收敛曲线比较','fontsize',12)
xlabel('迭代次数','fontsize',12)
ylabel('适应度值','fontsize',12)
axes('Position',[0.4 0.3 0.3 0.25]);


figure(4)
ai_punish= load('ia-punish.mat');
ai_punish = ai_punish.trace_delay(:,1);
ga_ai_punish= load('ga-ia-punish.mat');
ga_ai_punish = ga_ai_punish.trace_delay(:,1);
plot(ga_ai_punish(:,1));
hold on
plot(ai_punish(:,1),'--');
legend('GA-IA','IA')

title('收敛曲线比较','fontsize',12)
xlabel('迭代次数','fontsize',12)
ylabel('惩罚值','fontsize',12)


%}


%% 画出免疫算法收敛曲线
figure(1)
plot(trace(:,1));
legend('最优适应度值')
title('贪婪与免疫混合算法收敛曲线','fontsize',12)
xlabel('迭代次数','fontsize',12)
ylabel('适应度值','fontsize',12)
%{
figure(4)

plot(trace_delay(:,1));
legend('GIHA')

title('收敛曲线比较','fontsize',12)
xlabel('迭代次数','fontsize',12)
ylabel('惩罚值','fontsize',12)

%}
%% 画出配送中心选址图


%{
figure(1)
trace = load("trace.mat");
trace = trace.trace;

trace2 = load('trace2.mat');
trace2 = trace2.trace;
plot(trace,'r');
hold on
plot(trace2,'--');
legend('IA','GIAI')
title('收敛曲线','fontsize',12)
xlabel('迭代次数','fontsize',12)
ylabel('适应度值','fontsize',12)
%}

 
 

figure(2)
title('部署图')

%对候选设备进行画图

plot(fog(1:fog_size,1),fog(1:fog_size,2),'rs','LineWidth',1,...%
    'MarkerEdgeColor','r',...% 大红
    'MarkerFaceColor','r',...%蓝色
    'MarkerSize',10)
hold on

plot(sensor(1:selected_sensor_length,1),sensor(1:selected_sensor_length,2),'o','LineWidth',1,...
    'MarkerEdgeColor','k',...%黑色
    'MarkerFaceColor','g',...%绿色
    'MarkerSize',5)




for i=1:selected_sensor_length%画线，候选设备到其余节点的连接
    x=[sensor(i,1),fog(bestsensor(i),1)];
    y=[sensor(i,2),fog(bestsensor(i),2)];
    plot(x,y,'c');hold on %亮蓝
end
%{
hold on

plot(50,50,'h','LineWidth',1,...%
    'MarkerFaceColor','r',...% 大红
    'MarkerFaceColor','r',...%蓝色
    'MarkerSize',10)


 fog_select = zeros(1,fog_size);
    for j = 1:selected_sensor_length      
        fog_select( bestsensor(j)) = fog_select( bestsensor(j))+1;
    end
  

for i=1:fog_size%画线，候选设备到其余节点的连接
    if(fog_select(i)~=0)
        x=[50,fog(i,1)];
        y=[50,fog(i,2)];
     plot(x,y,'b',...  
        'MarkerEdgeColor','k',...%黑色
        'MarkerFaceColor','y',...%绿色
        'MarkerSize',40);hold on %黑色
    end
end
%}

%{

figure(3)
title('雾设备到私有云部署曲线')


plot(fog(1:fog_size,1),fog(1:fog_size,2),'rs','LineWidth',1,...%
    'MarkerEdgeColor','k',...%黑色
    'MarkerFaceColor','g',...%绿色
    'MarkerSize',5)
hold on
plot(50,50,'rs','LineWidth',1,...%
    'MarkerEdgeColor','r',...% 大红
    'MarkerFaceColor','r',...%蓝色
    'MarkerSize',10)


 fog_select = zeros(1,fog_size);
    for j = 1:selected_sensor_length      
        fog_select( bestsensor(j)) = fog_select( bestsensor(j))+1;
    end
  

for i=1:fog_size%画线，候选设备到其余节点的连接
    if(fog_select(i)~=0)
        x=[50,fog(i,1)];
        y=[50,fog(i,2)];
        plot(x,y,'b',...  
        'MarkerEdgeColor','k',...%黑色
        'MarkerFaceColor','y',...%绿色
        'MarkerSize',40);hold on %黑色
    end
end

%}
