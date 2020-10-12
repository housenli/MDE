function [ obo ] = ctranspose( obi )
%CTRANSPOSE Conjugate adjoint operator
%   obo = obi'

obi.adjoint = xor(obi.adjoint, 1);
obo         = obi;

end

