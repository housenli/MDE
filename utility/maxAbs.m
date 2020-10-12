function [ v ] = maxAbs( C )
%MAXABS Reture the maximum absolute value of a matrix or a cell
%   v = maxAbs(C)

% Housen Li
% 06.10.2017 created

level = 0;
aux   = C;
while isa(aux, 'cell')
    aux = aux{1};
    level = level + 1;
end
v = -Inf;

if level == 0
    v = max(abs(C(:)));
else
    for i = 1:length(C)
        v = max(v, maxAbs(C{i}));
    end
end

end

