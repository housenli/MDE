function [ B ] = uminus( A )
%UMINUS Negative of a cell
%   B = -A;

% Housen Li
% 06.10.2017 created

level = 1;
aux   = A{1};
while isa(aux, 'cell')
    aux = aux{1};
    level = level + 1;
end
B = cell(size(A));
if level == 1
    B = cellfun(@uminus, A, 'UniformOutput', 0);
else
    for i = 1:length(B)
        B{i} = uminus(A{i});
    end
end

end

