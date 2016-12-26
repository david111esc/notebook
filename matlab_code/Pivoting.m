function [ AA, rr ] = Pivoting ( A, r )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
    for i = 1 : length(A)
        [M, I] = max(abs(A(i:end, i)));
        temp = A(I+i-1,:); 
        A(I+i-1,:) = A(i,:) ;
        A(i,:)   = temp;
        temp = r(I+i-1,:); 
        r(I+i-1,:) = r(i,:) ;
        r(i,:)   = temp;
    end
    AA = A;
    rr = r;
end

