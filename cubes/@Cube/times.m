function [ v ] = times( B, u )
%TIMES Compute multiscale coefficients w.r.t. cubes and the adjoint without
%normalization
%   v = B .* u;
%where
%   B: an object of Cube class
%   u: an image

% Housen Li
% 07.10.2017

if isa(u, 'Cube')
    error('In  A * B only A can be Cube object!');
end

if B.adjoint
    v = mrdualCube(B.imSize, u, B.cube);
else
    v = mrcoefCube(u, B.cube);
end

end

