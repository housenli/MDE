function [ C ] = minus( A, B )
%MINUS Elementwise substraction for two cells, or for a cell and a scalar
%   C = A - B

% Housen Li
% 06.10.2017 created

C = plus(A, uminus(B));

end

