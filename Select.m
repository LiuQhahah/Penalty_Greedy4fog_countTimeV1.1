%%调整顺序
function ret=Select(individuals,sizepop)
% 轮盘赌选择,根据期望繁殖概率排序
% individuals input  : 种群信息
% sizepop     input  : 种群规模
% ret         output : 选择后得到的种群

excellence=individuals.excellence;%期待繁殖概率的多样性

pselect=excellence./sum(excellence);%个体选择概率
% 事实上 pselect = excellence；




index=[]; 

%
for i=1:sizepop  %种群的解的个数
    pick=rand;
    while pick==0    
        pick=rand;        
    end
    for j=1:sizepop 
        %j
        pick=pick-pselect(j);      
        
        if pick<0   %扩大选择概率     
            index=[index j];
            break;  
        end
    end
         
end



% 注意：在转sizepop次轮盘的过程中，有可能会重复选择某些染色体


individuals.candidate_fog(index,:)=individuals.candidate_fog(index,:);%将新获取的序列传递给传感设备对应关系
individuals.fitness(index)=individuals.fitness(index);
individuals.concentration(index)=individuals.concentration(index);
individuals.excellence(index)=individuals.excellence(index);

individuals.sensor_link_fog(index,:) = individuals.sensor_link_fog(index,:);   


ret=individuals;


end
 