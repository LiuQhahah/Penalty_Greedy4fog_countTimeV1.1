function candidate_fog = popinit(M,selected_fog_length,fog_size)
%种群初始化函数(记忆库库为空，全部随机产生)
% M                     input    种群数量
% selected_fog_length   input    选中雾设备节点个数
%fog_size               input    总的雾设备节点个数

%candidate_fog          output  输出选中雾设备节点 





candidate_fog = zeros(M,selected_fog_length);
%生成M个数组
for i=1:M
 
        [a,fog_index]=sort(rand(1,fog_size));    %随机生成fog_size小数，并排序。
      
       
        candidate_fog(i,:) = fog_index(1:selected_fog_length); %选择前selected_fog_length个雾设备节点编号
       
end
