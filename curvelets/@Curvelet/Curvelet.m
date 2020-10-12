function [ ob ] = Curvelet( imSize, isReal, fLevel, nScale, nAngle )
%CURVELET A class encapsulates codes from CurveLab-2.1.3 by Candes 
%   
%   ob = Curvelet(imSize)
%   ob = Curvelet(imSize, isReal, fLevel, nScale, nAngle)
%   
%Input: 
%   imSize: size of pre-image space
%   isReal: type of the transform (default set to 0)
%                   0: complex-valued curvelets
%                   1: real-valued curvelets
%   fLevel: chooses one of two possibilities for the coefficients at the
%           finest level (default set to 2)
%                   1: curvelets
%                   2: wavelets
%   nScale: number of scales including the coarsest wavelet level (default 
%           set to ceil(log2(min(M,N)) - 3))
%   nAngle: number of angles at the 2nd coarsest level, minimum 8, must be 
%           a multiple of 4. (default set to 16)
%
%Output:
%   ob:     a curvelet operator
%
%Example:
%   sz = [128, 128];
%   u  = randn(sz);
%   C  = Curvelet(sz);
%   % Curvelet transform
%   v  = C * u;
%   % Inverse (also adjoint) Curvelet transform
%   ui = C' * v;

% Housen Li 
% 06.10.2017 created

if nargin < 2, isReal = 0; end;
if nargin < 3, fLevel = 2; end;
if nargin < 4, nScale = ceil(log2(min(imSize)) - 3); end;
if nargin < 5, nAngle = 16; end;

ob.imSize  = imSize;
ob.isReal  = isReal;
ob.fLevel  = fLevel;
ob.nScale  = nScale;
ob.nAngle  = nAngle;
ob.adjoint = 0;

deltaFun   = fftshift(ifft2(ones(imSize))) * sqrt(prod(imSize));
curvelet   = fdct_wrapping(deltaFun, isReal, fLevel, nScale, nAngle);
ob.normCur = cell(size(curvelet));
for s = 1:length(curvelet)
    ob.normCur{s} = cell(size(curvelet{s}));
    for w = 1:length(curvelet{s})
        aux = curvelet{s}{w};
        ob.normCur{s}{w} = norm(aux,'fro')/sqrt(numel(aux));
    end
end

ob = class(ob, 'Curvelet');

end

