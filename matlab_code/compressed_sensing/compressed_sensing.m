%�Ҽ{��N�T�w�����A��x�T�����A�bn�����դ�����X�C
clear all
clc
profile on
%%
%��l�]�w
%options = optimoptions('linprog','Algorithm','dual-simplex','Display','off');
options = optimoptions('linprog','Algorithm','interior-point','Display','off');
%�]�wlinprog�ϥΤ��I�k�A�åB�������ܰT��
%N = �w���`�� n = ���զ��� x�T���� c�p�⦨�\��X��������
N =100; %column �j�p
I = ones(N,1);
O = zeros(N,1);

%�ѨM1-norm�u�ʳW�����D�ɡA�ؼШ�ƪ��Y��
f = [O;I];
%�ѨM1-norm�u�ʳW�����D�ɡA�Ұ����ഫ�x�}
PhIn2 = [eye(N),-eye(N);-eye(N),-eye(N)];   
%�ѨM1-norm�u�ʳW�����D�ɡA�Ұ����ഫ�Ӧ�������V�q
bn =zeros(2*N,1);
row_M = 40;       %row���̤j��
test_times = 1000;%�C�ر��p���̤j���禸��
%�x�s���յ��G(���v)
Data = zeros(5,row_M-4);

%�Q��rand�åB�@���Y�����A�H���o��[-1,1]���Ʀr�A��@�~�t���q
%Ew = (((rand(1,x)/2-1/4)*200)/100);
Ew = [-0.3 0.44 -0.33 0.2 -0.28]; 
%�Q��randperm�qN���H�N�ƦC�A���ex�ӷ�@����
%Ec = randperm(N);
Ec = [13 37 71 65 88 2];

%%���糡��

for coins = 1: 5             %�����Ӽ�
    for n=5:row_M            %row���Ӽ�(���զ���)
        success = 0;         %���\����
        for j =1:test_times
            %�إ�sparse matrix �`�A���G(0,1/n)
            PhI =randn(n,N)/n;
           % b = zeros(n,1);         
            b =  PhI(:, Ec(1:coins))*Ew(1:coins)' ;            
            %������󤣵������Y��
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
%�@��
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