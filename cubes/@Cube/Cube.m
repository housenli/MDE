function [ ob ] = Cube( imSize, type, param )
%CUBE Encapsulate codes from package MOP available at 
%http://www.stochastik.math.uni-goettingen.de/mop
%   ob = Cube(imSize, type, param)

% Housen Li 
% 07.10.2017 created

if nargin < 2, type = 'partition'; end
switch type
    case 'partition'
        if nargin < 3 || isempty(param), param = 2; end
        cube = pPartitionCube(imSize, param);
    case 'scale'
        if nargin < 3|| isempty(param)
            param = 2.^(0:floor(log2(min(imSize))));
        end        
        cube = scale2cube(param, imSize);
    case 'manual'
        cube = param;
    otherwise
        error([sprintf('Unknown type ''%s'', ', type), ...
            'only support ''partition'', ''scale'' and ''manual''.']);
end        

ob.adjoint = 0;
ob.imSize  = imSize;
ob.type    = type;
ob.cube    = cube; 
% Estimate the norm via power method
fprintf('Estimate the norm (this might take some time) ...\n'); tic;
tol = 1e-6; nit = 1e3; seed = 123; 
rng('default'); rng(seed);
u = randn(imSize);
u = u / norm(u, 'fro');
for i = 1:nit
    v  = mrdualCube(imSize, mrcoefCube(u, cube), cube);
    en = sum(sum(v .* u));
    if norm(v - en * u, 'fro') < tol, break; end
    u  = v / norm(v, 'fro');
end
ob.norm = sqrt(en)*1.1; 

fprintf(['Time cost is %g s, # power iteration is %d,', ...
    ' and estimated norm is %g\n'], toc, i, ob.norm);

ob = class(ob, 'Cube');

end

