function [ ob ] = Shearlet( imSize, shearletPar )
%SHEARLET A class encapsultes codes from ShearLab3D version 1.1 
%   (www.shearlab.org)
%
%Input:
%   imSize:      a vector specifying size of pre-image space [nrow, ncol]
%   shearletPar: a structure array specifying parameters for 
%                shearletSystem, including fields 'nScales', 'shearLevels',
%                'isFull' (a better name for 'full'), 'directionalFilter',
%                'quadratureMirrorFilter', 'quadratureMirrorFilter', see 
%                function parMultiscaleMethod for details
%                
%
%Output:
%   ob:          a shearlet operator
%
%Example:
%
%
%
%

% Housen Li
% 21.06.2020 created


% Default parameters
if (nargin < 1) || (length(imSize) ~= 2)
    error('Input imSize [nrow ncol] has to be provided!');
end
if (nargin < 2)
    shearletPar = [];
end

useGPU = 0;

shearletPar = parMultiscaleMethod(shearletPar, 'shearlet');

ob.imSize  = imSize;
ob.adjoint = 0;
ob.shearletSystem = SLgetShearletSystem2D(useGPU, imSize(1), imSize(2), ...
    shearletPar.nScales, shearletPar.shearLevels, shearletPar.isFull, ...
    shearletPar.directionalFilter, shearletPar.quadratureMirrorFilter);

deltaFun   = fftshift(ifft2(ones(imSize))) * sqrt(prod(imSize));
slcoef     = SLsheardec2D(deltaFun, ob.shearletSystem);
ob.normShe = zeros(ob.shearletSystem.nShearlets,1);
for s = 1:ob.shearletSystem.nShearlets
    ob.normShe(s) = norm(slcoef(:,:,s),'fro')/sqrt(numel(slcoef(:,:,s)));
end

ob = class(ob, 'Shearlet');

end

