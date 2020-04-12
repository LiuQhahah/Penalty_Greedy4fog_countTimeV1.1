clc
clear all
close all
Sum = 30;  % 指定的和
N = 4;     % 随机数个数
r = zeros(1, N);   % 生成的随机数
sumtemp = floor(Sum/N);   % 每生成一个随机数后，剩余的和
for i=1:(N-1)
   r(i) = sumtemp.*randi; 
   sumtemp = floor((Sum - r(i))/(N-i) );
end
r(N) = Sum - sum(r(1:N-1));
fprintf(1, '生成的随机数为：');
disp(r);
%-- 验证 --%
sum_r = sum(r);
fprintf(1, '生成的随机数的和为：%d\n', sum_r);