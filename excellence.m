function exc=excellence(individuals,M,ps)
% 计算个体繁殖概率
% individuals    input      种群
% M              input      种群规模
% ps             input      多样性评价参数
% exc            output     繁殖概率

fit = 1./individuals.fitness;%取倒数，选择成本最小的解
sumfit = sum(fit);
con = individuals.concentration;%浓度

sumcon = sum(con);
% 亲和度越大表示适应度值小，浓度越高表示种群中优质解的比例高，适应度函数越高，可以保证快速收敛

for i=1:M
    %(fit(i)/sumfit)*ps
    %(con(i)/sumcon)*(1-ps)
    exc(i) = (fit(i)/sumfit)*ps +(con(i)/sumcon)*(1-ps); 
end

end