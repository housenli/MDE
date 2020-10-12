function [ x ] = mrdualCube( sz, y, cube )
%MRDUALCUBE Dual multiresolution transform
%   x = mrdualCube(sz, y, cube)

x = mrdualCube_mex(sz(1), sz(2), y(:), cube.st-1, cube.ed-1);

end

