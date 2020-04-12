function rets=bestselect(individuals,m,n)
% 初始化记忆库,依据excellence，将群体中高适应度低相似度的overbest个个体存入记忆库
% m                  input          抗体数
% n                  input          记忆库个体数\父代群规模
% individuals        input          抗体群
% bestindividuals    output         记忆库\父代群

% 精英保留策略，将fitness最好的s个个体先存起来，避免因其浓度高而被淘汰
s=3;%只取前3个
rets= struct('fitness',zeros(1,m), 'concentration',zeros(1,m),'excellence',zeros(1,m),'candidate_fog',[],'sensor_link_fog',[]);
[fitness,index] = sort(individuals.fitness);%对获取的M个解的适应度进行排序


for i=1:s
    rets.fitness(i) = individuals.fitness(index(i));   
    rets.concentration(i) = individuals.concentration(index(i));
    rets.excellence(i) = individuals.excellence(index(i));
  rets.sensor_link_fog(i,:) = individuals.sensor_link_fog(index(i),:);   
    rets.candidate_fog(i,:) = individuals.candidate_fog(index(i),:);
end



% 剩余m-s个个体 相对来说，不是优秀的选择，创建变量来存储剩余的个体
leftindividuals= struct('fitness',zeros(1,m), 'concentration',zeros(1,m),'excellence',zeros(1,m),'candidate_fog',[],'sensor_link_fog',[]);
for k=1:m-s
    leftindividuals.fitness(k) = individuals.fitness(index(k+s));   
    leftindividuals.concentration(k) = individuals.concentration(index(k+s));
    leftindividuals.excellence(k) = individuals.excellence(index(k+s));
   leftindividuals.sensor_link_fog(k,:) = individuals.sensor_link_fog(index(k+s),:);
  
    leftindividuals.candidate_fog(k,:) = individuals.candidate_fog(index(k+s),:);
end

% 将剩余抗体按excellence值排序  sort：从小达到排序，excellence：从打到小排序：选择优质解
[excellence,index]=sort(1./leftindividuals.excellence);%将成本最小的解作为"杰出解"

% 在剩余抗体群中按excellence再选n-s个最好的个体
for i=s+1:n
    rets.fitness(i) = leftindividuals.fitness(index(i-s));
    rets.concentration(i) = leftindividuals.concentration(index(i-s));
    rets.excellence(i) = leftindividuals.excellence(index(i-s));
    rets.sensor_link_fog(i,:) = leftindividuals.sensor_link_fog(index(i-s),:);
    rets.candidate_fog(i,:) = leftindividuals.candidate_fog(index(i-s),:);
end

end