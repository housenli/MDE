function [ C ] = times( A, B )
%TIMES Elementwise multiplication for two cells, or for a cell and a scalar
%   C = A .* B

% Housen Li
% 06.10.2017 created

if isa(B, 'numeric')
    C = times(B, A); 
else
    level = 1;
    aux   = B{1};
    while isa(aux, 'cell')
        aux = aux{1};
        level = level + 1;
    end
    C = cell(size(B));
    if level == 1
        if isa(A, 'numeric')
            for i = 1:length(B)
                C{i} = times(A, B{i});
            end
        else
            C = cellfun(@times, A, B, 'UniformOutput', 0);
        end
    else
        if isa(A, 'numeric')
            for i = 1:length(B)
                C{i} = times(A, B{i});
            end
        else
            for i = 1:length(B)
                C{i} = times(A{i}, B{i});
            end
        end
    end
end

end

