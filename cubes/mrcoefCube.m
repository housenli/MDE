function [ coef ] = mrcoefCube( u, cube )
%MRCOEFCUBE Multiresolution transformation - computing multiresolution
%coefficients
%   coef = mrcoefCube(u, cube)

coef = mrcoefCube_mex(u, cube.st-1, cube.ed-1);

end

