function [ cube ] = scale2cube(scl, sz)
%SCALE2CUBE Generate cube system by specified scales (scl)
%   cube = scale2cube(scl, sz)

% Housen Li @ MPIbpc
% 01.09.2015 create the code

m = sz(1);
n = sz(2);

scl = scl(scl <= min(m, n));

nMaxCube = sum((m - scl +1) .*  (n - scl +1));

cube.st = zeros(nMaxCube, 2);
cube.ed = zeros(nMaxCube, 2);

cnt = 1;
for s = scl(:)'
    str = 1:(m-s+1);
    edr = s:m;
    nr  = m-s+1;
    stc = 1:(n-s+1);
    edc = s:n;
    nc  = n-s+1;
    
    nCube = nc*nr;
    
    cube.st(cnt:(cnt+nCube-1), 1) = reshape(repmat(str(:)', [nc, 1]), [nCube, 1]);
    cube.st(cnt:(cnt+nCube-1), 2) = repmat(stc(:), [nr, 1]);
    cube.ed(cnt:(cnt+nCube-1), 1) = reshape(repmat(edr(:)', [nc, 1]), [nCube, 1]);
    cube.ed(cnt:(cnt+nCube-1), 2) = repmat(edc(:), [nr, 1]);
    
    cnt = cnt + nCube;
end