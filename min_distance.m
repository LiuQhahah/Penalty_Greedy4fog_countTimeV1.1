clc
clear
n = 20 ;       %用于记录点数

x = zeros(1,n) ;                           %产生一个与经过点数相同的行向量
y = zeros(1,n) ;

best = 1:1:n;                              %生成一个用来存储点顺序的矩阵
handle = 1:1:n;

for i = 1 : (n)                            %生成n个随机数
    x(i) = rand * 20 ;                     
    y(i) = rand * 20 ;
end

d = zeros(n) ;
for i = 1 : n 
    for j = 1 : n
        d(i,j) = sqrt( ( x(i) - x(j) ) ^ 2 + ( y(i) - y(j) ) ^ 2) ;         %距离矩阵
    end
end

best(1) = 1;                             %默认起点
num = 1; 
for a = 1:(n-2)                         %需要n-2次判断
    handle(:,1)=[];                     %上一次最优点的数据裁掉
    dis = zeros(1,(n-a));               %用来存剩下各个点的距离
    for b = 1:(n-a)                     %用来获取剩下各个点的距离
        dis(b) = d (num  , handle(b));      
    end
    num1 = find( dis == min(dis) );     %得到最优点所在检索
    
    t = handle(1);                      %将最优点与最前面的点位置进行交换  
    handle(1) = handle(num1);
    handle(num1) = t;
    
    num = handle(1);                    %获取下次进行操作的数
    best(a+1) = handle(1);              %将最优点存入best数组
end

best(n) = handle(num1);                 %补上最后一个点

plot(x(best),y(best),'-+') ;            %用'+'标出点并用实线连接得到最优路径
grid on
