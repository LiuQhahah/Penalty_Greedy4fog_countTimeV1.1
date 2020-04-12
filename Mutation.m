%
function ret=Mutation(pmutation,candidate_fog,sizepop,fog_sum_length)
% 变异操作 变异的是雾设备情况
% pmutation        input  : 变异概率
% candidate_fog            input  : 抗体群
% sizepop          input  : 种群规模
% iii              input  : 进化代数
% MAXGEN           input  : 最大进化代数
% length1          input  : 抗体长度
% ret              output : 变异得到的抗体群
% 变异;替换其中一个雾设备

% 变异：更换整个节点的值
% i并不意味着没一个种群都变异，输出随机数小于设定的概率才进行变异
for i=1:sizepop   
    
    % 变异概率
    pick=rand;
    while pick==0
        pick=rand;
    end
    %在60个种群中，选择一个编译
    index=unidrnd(sizepop);

   % 判断是否变异
    if pick>pmutation
        continue;
    end
   
    
    cadicate_size = length(candidate_fog(1,:));
    %选择变异的位置
    pos=randi([1,cadicate_size],1,1);  
    fog_number_old = candidate_fog(index,pos);
   
    
    
    fog_number_new =  randi([1,fog_sum_length],1,1);

       candidate_fog(index,pos)  =  fog_number_new;
       
 
end

ret=candidate_fog;
end
 