function [ L, U, d, x ] = LU_decomp( A, r )
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
    L = eye(length(A));
    for i = 1 : length(A)
        for j = i+1 : length(A)
            L(j,i) = A(j,i) / A(i,i);
            A(j,:) = A(j,:) - L(j,i)*A(i,:);
            %r(j,:) = r(j,:) - L(j,i)*r(i,:);
        end
    end
    U = A;
    d = L\r;
    x = U\d;
end

