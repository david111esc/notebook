function [x,t]=Gauss_Seidel(A,x,b,e)
    ll = length(A);
  %  x  = zeros(ll,1);
    xx = ones(ll,1);
    t = 0;
    while norm(x-xx)>=e
        xx=x;
        t=t+1;
        for i = 1:ll
            sigma = 0;
            for j = 1:ll
                if i~=j            
                   sigma = sigma + A(i,j)*x(j); 
                end
                x(i) = (1/A(i,i))*(b(i)-sigma);
            end
        end
    end
end