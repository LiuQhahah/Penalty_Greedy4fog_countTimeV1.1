%% 互换i与j中的某一个雾设备
function ret=Cross(pcross,chrom,sizepop,length)
% 交叉操作
% pcorss                input  : 交叉概率
% chrom                 input  : 抗体群
% sizepop               input  : 种群规模
% length                input  : 抗体长度
% ret                   output : 交叉得到的抗体群

% 每一轮for循环中，可能会进行一次交叉操作，随机选择染色体是和交叉位置，是否进行交叉操作则由交叉概率（continue）控制

% 交叉算子：PMX



% Step1 随机选择一对染色体（父代）中几个基因的起止位置（两染色体被选位置相同）:
% Step2 交换这两组基因的位置
% Step3 做冲突检测，根据交换的两组基因建立一个映射关系，如图所示，以1-6-3这一映射关系为例，可以看到第二步结果中子代1存在两个基因1，这时将其通过映射关系转变为基因3，以此类推至没有冲突为止。最后所有冲突的基因都会经过映射，保证形成的新一对子代基因无冲突：



for i=1:sizepop  
    
    % 随机选择两个染色体进行交叉
    pick=rand;
    while prod(pick)==0
        pick=rand(1);
    end
    
    if pick>pcross% 交叉概率0.5
        continue;
    end
    
    % 找出交叉个体 找个两个不同的解
    index(1)=randi([1,sizepop],1,1);
    
    index(2)=randi([1,sizepop],1,1);
   
    while index(2)==index(1)
        index(2)=unidrnd(sizepop);
    end

    % 个体交叉
    chrom1=chrom(index(1),:);
    chrom2=chrom(index(2),:);
  
    
    %% 交叉算法
    % 1、获取两个候选雾设备的数据
    
    % 2、随机生成交叉pos
    % 3、只交叉pos位置上的雾设备编号
    % 可能出现的问题，
    %12345
    %23456 抽到了pos = 1 。1、2
    
    
 
  %Step1 获取pos的位置
   pos=randi([1,length],1,1) ;
   
  
   for num = pos:length
       temp = chrom1(num);
       chrom1(num) = chrom2(num);
       chrom2(num) = temp;
   end

        chrom(index(1),:)=  chrom1;
        chrom(index(2),:)= chrom2;
  
  
    
end


ret=chrom;
end