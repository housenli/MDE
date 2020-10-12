function [ cube ] = pPartitionCube( sz, p )
%PPARTITIONCUBE Generate p-partition cube system
%   cube = pPartitionCube(sz, p)

% Housen Li @ MPIbpc
% 25.08.2015 create the code

% default input
if nargin < 2
    p = 2; % dyadic
end

m = sz(1);
n = sz(2);

maxTheta = ceil(log(max(sz)) / log(p));
nMaxCube    = (p^(2*(maxTheta+1)) - 1) / (p^2 - 1);

st = zeros(nMaxCube, 2);
ed = zeros(nMaxCube, 2);

cnt = 1; 
for theta = 0:maxTheta
    [str, edr] = partitionFixLen(m, p^theta);
    nr         = length(str);
    [stc, edc] = partitionFixLen(n, p^theta);
    nc         = length(stc);
    
    nCube      = nc * nr;
    
    st(cnt:(cnt+nCube-1), 1) = reshape(repmat(str(:)', [nc, 1]), [nCube, 1]);
    st(cnt:(cnt+nCube-1), 2) = repmat(stc(:), [nr, 1]);
    ed(cnt:(cnt+nCube-1), 1) = reshape(repmat(edr(:)', [nc, 1]), [nCube, 1]);
    ed(cnt:(cnt+nCube-1), 2) = repmat(edc(:), [nr, 1]);
    
    cnt = cnt + nCube;
end

cube.st = st(1:(cnt-1), :);
cube.ed = ed(1:(cnt-1), :);


