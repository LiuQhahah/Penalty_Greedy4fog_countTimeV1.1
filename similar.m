function resemble = similar(individual1,individual2)
% 计算个体individual1和individual2的相似度
% individual1,individual2    input     两个个体
% resemble                   output     相似度

% intersect(a,b) 数组a、b相同元素的个数


%{
k=zeros(1,length(individual1));
for i=1:length(individual1)
    if find(individual1(i)==individual2(i))%是不是相同的解，如果是则k = 1
        k(i)=1;
    end
end
%}
k = length(intersect(individual1,individual2));
resemble=k/length(individual1);%相同的解越多，那么相似度就越大
%resemble=sum(k)/length(individual1);%相同的解越多，那么相似度就越大

end

