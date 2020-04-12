function concentration = concentration(i,M,individuals,ss)
% 计算个体浓度值
% i              input      第i个抗体
% M              input      种群规模
% individuals    input     个体
% ss               input   相似度阈值
% concentration  output     浓度值

concentration=0;

for j=1:M
    
    xsd_sensor = similar(individuals.candidate_fog(i,:),individuals.candidate_fog(j,:));
    % 相似度大于阀值
   % xsd_sensor
    if xsd_sensor > ss % 如果相似度大于了0.7,意味着浓度+1
        
        concentration=concentration+1;
    end
end

concentration=concentration/M;
%concentration

end