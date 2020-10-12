function [ v ] = times( C, u )
%MTIMES Perform Curvelet transform without normalization
%   v = C .* u
%where
%   C: an object of Curvelet class
%   u: an image 

% Housen Li
% 06.10.2017

if isa(u, 'Curvelet')
    error('In  A .* B only A can be Curvelet object!');
end

if any(C.imSize ~= size(u)) && (C.adjoint == 0)
    error('Sizes of Curvelet object and image do NOT match!');
end

if C.adjoint
    v = ifdct_wrapping(u, C.isReal, C.imSize(1), C.imSize(2));
else
    v = fdct_wrapping(u, C.isReal, C.fLevel, C.nScale, C.nAngle);
end

end

