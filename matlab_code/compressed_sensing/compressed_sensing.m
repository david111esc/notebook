%考慮有N枚硬幣中，有x枚偽幣，在n次測試之中找出。
clear all
clc
profile on
%%
%初始設定
%options = optimoptions('linprog','Algorithm','dual-simplex','Display','off');
options = optimoptions('linprog','Algorithm','interior-point','Display','off');
%設定linprog使用內點法，並且關閉提示訊息
%N = 硬幣總數 n = 測試次數 x枚偽幣 c計算成功找出偽幣次數
N =100; %column 大小
I = ones(N,1);
O = zeros(N,1);

%解決1-norm線性規劃問題時，目標函數的係數
f = [O;I];
%解決1-norm線性規劃問題時，所做的轉換矩陣
PhIn2 = [eye(N),-eye(N);-eye(N),-eye(N)];   
%解決1-norm線性規劃問題時，所做的轉換而成的限制向量
bn =zeros(2*N,1);
row_M = 40;       %row的最大值
test_times = 1000;%每種情況的最大實驗次數
%儲存測試結果(機率)
Data = zeros(5,row_M-4);

%利用rand並且作伸縮平移，隨機得到[-1,1]的數字，當作誤差重量
%Ew = (((rand(1,x)/2-1/4)*200)/100);
Ew = [-0.3 0.44 -0.33 0.2 -0.28]; 
%利用randperm從N中隨意排列，取前x個當作偽幣
%Ec = randperm(N);
Ec = [13 37 71 65 88 2];

%%實驗部分

for coins = 1: 5             %偽幣個數
    for n=5:row_M            %row的個數(測試次數)
        success = 0;         %成功次數
        for j =1:test_times
            %建立sparse matrix 常態分佈(0,1/n)
            PhI =randn(n,N)/n;
           % b = zeros(n,1);         
            b =  PhI(:, Ec(1:coins))*Ew(1:coins)' ;            
            %限制條件不等式的係數
            PhIn = [PhI,zeros(n,N)];                    
            a = linprog(f',PhIn2,bn, PhIn,b,[],[],options);
            %length(find(a>0.0001));
            if(length(find(abs(a)>0.01))==2*coins)
                if norm(a(Ec(1:coins))-Ew(1:coins)')<=0.001
                success = success +1;
                end
            end
        end
      Data(coins,n-4) = success/test_times;
    end
end

%%
%作圖
hold on
X = 5:row_M;
plot(X,Data(1,:),'b--d')
plot(X,Data(2,:),'r--v')
plot(X,Data(3,:),'k--o')
plot(X,Data(4,:),'b--p')
plot(X,Data(5,:),'m--^')
axis([0,row_M,0,1])
legend('1 bad coin','2 bad coins','3 bad coins','4 bad coins','5 bad coins');
xlabel('Number of weighings'),ylabel('Probability of success')
profile report