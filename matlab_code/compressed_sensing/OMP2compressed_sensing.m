clc
clear all
profile on
%%
%初始設定

%利用orthogonal matching pursuit(OMP)解決偽幣問題
%N = 硬幣總數 n = 測試次數 x枚偽幣 c計算成功找出偽幣次數
N =100;

%利用rand並且作伸縮平移，隨機得到[-1,1]的數字，當作誤差重量
%Ew = (((rand(1,x)/2-1/4)*200)/100);
Ew = [-0.3 0.44 -0.33 0.2 -0.28];
%利用randperm從N中隨意排列，取前x個當作偽幣
%Ec = randperm(N);
Ec = [13 37 71 65 88 2];

row_M = 80;             %row最大值(也就是測試的次數)
test_times = 1000;      %每種情況的最大實驗次數
Data = zeros(5,row_M-4);%用來儲存每次測試的結果(機率)
err =0.0001;            %OMP容忍的殘差值

%%
%實驗部分
for coins = 1: 5                                        %偽幣個數
    for n=5:row_M                                       %row大小(也就是測試的次數)
        success = 0;                                    %成功次數
        ff = 0;
         for j =1:test_times                             %實驗次數
            PhI =randn(n,N)/n;                          %建立sparse matrix 常態分佈(0,1/n)                     
            b =  PhI(:, Ec(1:coins))*Ew(1:coins)' ;     % b = zeros(n,1);     
            [a,index] = OMP_f(PhI,b,err);               %利用OMP解題目
            if(length(index)==coins) && norm(sort(index)-sort(Ec(1:coins)))<0.01
                %判斷條件 : index長度等於偽幣個數 && 兩者所對應的index相符合
                success = success +1;
            else
                mu = m_A(PhI);
                if length(index)>0.5*(1+1/mu)                    
                    ff=ff+1;
                end
            
            end
            
        end
      Data(coins,n-4) = success/test_times;
      if ff>0
       [coins,n,ff]
      end
    end
end
%%
%作圖
hold on
X = 5:row_M ;
plot(X,Data(1,:),'b--d')
plot(X,Data(2,:),'r--v')
plot(X,Data(3,:),'k--o')
plot(X,Data(4,:),'b--p')
plot(X,Data(5,:),'m--^')
axis([0,row_M,0,1])
legend('1 bad coin','2 bad coins','3 bad coins','4 bad coins','5 bad coins');
xlabel('Number of weighings'),ylabel('Probability of success')
profile report