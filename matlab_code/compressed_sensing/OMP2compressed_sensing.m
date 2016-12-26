clc
clear all
profile on
%%
%��l�]�w

%�Q��orthogonal matching pursuit(OMP)�ѨM�������D
%N = �w���`�� n = ���զ��� x�T���� c�p�⦨�\��X��������
N =100;

%�Q��rand�åB�@���Y�����A�H���o��[-1,1]���Ʀr�A��@�~�t���q
%Ew = (((rand(1,x)/2-1/4)*200)/100);
Ew = [-0.3 0.44 -0.33 0.2 -0.28];
%�Q��randperm�qN���H�N�ƦC�A���ex�ӷ�@����
%Ec = randperm(N);
Ec = [13 37 71 65 88 2];

row_M = 80;             %row�̤j��(�]�N�O���ժ�����)
test_times = 1000;      %�C�ر��p���̤j���禸��
Data = zeros(5,row_M-4);%�Ψ��x�s�C�����ժ����G(���v)
err =0.0001;            %OMP�e�Ԫ��ݮt��

%%
%���糡��
for coins = 1: 5                                        %�����Ӽ�
    for n=5:row_M                                       %row�j�p(�]�N�O���ժ�����)
        success = 0;                                    %���\����
        ff = 0;
         for j =1:test_times                             %���禸��
            PhI =randn(n,N)/n;                          %�إ�sparse matrix �`�A���G(0,1/n)                     
            b =  PhI(:, Ec(1:coins))*Ew(1:coins)' ;     % b = zeros(n,1);     
            [a,index] = OMP_f(PhI,b,err);               %�Q��OMP���D��
            if(length(index)==coins) && norm(sort(index)-sort(Ec(1:coins)))<0.01
                %�P�_���� : index���׵��󰰹��Ӽ� && ��̩ҹ�����index�۲ŦX
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
%�@��
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