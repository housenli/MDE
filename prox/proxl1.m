function [ u ] = proxl1( v, lambda )
%PROXL1 Proximal operator of l1 norm
%
%   minimize_{u} 1/2||u - v||_2^2  + lambda||u||_1
%
%Usage:
%   u = proxl1(v, lambda)
%
%Input:
%   v:        data (real or complex, matrix or cell)
%   lambda:   penalization coefficient
%
%Output:
%   u:  the solution
%
%Note: it is equivalent to soft-thresholding.

% Housen Li
% 01.10.2017 created

level = 0;
aux   = v;
while isa(aux, 'cell')
    aux = aux{1};
    level = level + 1;
end
if level == 0
    aux = abs(v) - lambda;
    aux = (aux + abs(aux))/2;
    u   = sign(v) .* aux;
else
    u = cell(size(v));
    for i = 1:length(v)
        u{i} = proxl1(v{i}, lambda);
    end
end

end

