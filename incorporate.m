function newindividuals = incorporate(individuals,sizepop,bestindividuals,overbest)
% 将记忆库中抗体加入，形成新种群
% individuals         input          抗体群
% sizepop             input          抗体数
% bestindividuals     input          记忆库
% overbest            input          记忆库容量

m = sizepop+overbest;
newindividuals = struct('fitness',zeros(1,m), 'concentration',zeros(1,m),'excellence',zeros(1,m),'candidate_fog',[],'sensor_link_fog',[]);

% 遗传操作得到的抗体
for i=1:sizepop
   
    newindividuals.fitness(i) = individuals.fitness(i);   
    newindividuals.concentration(i) = individuals.concentration(i);   
    newindividuals.excellence(i) = individuals.excellence(i);   
      newindividuals.sensor_link_fog(i,:) = individuals.sensor_link_fog(i,:);   
    newindividuals.candidate_fog(i,:) = individuals.candidate_fog(i,:);   
end
% 记忆库中抗体
for i=sizepop+1:m
    newindividuals.fitness(i) = bestindividuals.fitness(i-sizepop);   
    newindividuals.concentration(i) = bestindividuals.concentration(i-sizepop);   
    newindividuals.excellence(i) = bestindividuals.excellence(i-sizepop);   
  newindividuals.sensor_link_fog(i,:) = bestindividuals.sensor_link_fog(i-sizepop,:);   
    newindividuals.candidate_fog(i,:) = bestindividuals.candidate_fog(i-sizepop,:);   
end

end


