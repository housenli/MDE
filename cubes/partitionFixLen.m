function [ lnd, rnd ] = partitionFixLen( n, len )
%PARTITIONFIXLEN Partition intervals of a fixed length, this is a
%subroutine for 'pPartitionIntval' and 'pPartitionCube'
%   [lnd, rnd] = partitionFixLen(n, len)

% Housen Li @ MPIbpc
% 25.08.2015 create the code


lnd = ceil((0:(len-1)) / len * n) + 1;
rnd = [lnd(2:end) - 1, n];

ind = (lnd <= rnd);
lnd = lnd(ind);
rnd = rnd(ind);

end

