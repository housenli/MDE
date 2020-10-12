function [ u, stat ] = multiscale( v, th, iPar, mPar, rPar )
%MULTISCALE Regression via R minimization under multiscale constraints
%
%   minimize_u R(u) subject to || Phi (u - v) ||_inf <= th
%
%Usage:
%   u = multiscale(v, th)
%   [u, stat] = multiscale(v, th, iPar, mPar, rPar)
%
%Input:
%  v:    data matrix
%  th:   threshold in multiscale constraint
%  iPar: a structure array specifying parameters of iteration algorithm
%  mPar: a structure array specifying parameters of multiscale method,
%        maybe different structures for different types
%  rPar: a structure array specifying parameters of regularization term
%
%Output:
%   u:      solution matrix
%   stat:   details of each outer iteration
%     oVal: objective values R(u)
%     cGap: gaps of the constraint || Phi (u - v) ||_inf - th
%       tm: computation cost unitl each iteration
%
%Algorithm: Primal-Dual Hybrid Gradient (PDHG) algorithm by Chambolle &
%Pock (2011). In their notation, we use
%   F(x) := 1{|| x - Phi( v ) ||_inf <= th}
%   G(x) := R(x)
%   K    := Phi
%
%Reference:
%   Chambolle, A., & Pock, T. (2011). A First-Order Primal-Dual Algorithm 
%   for Convex Problems with Applications to Imaging. Journal of 
%   Mathematical Imaging and Vision, 40(1), 120-145.


% Housen Li
% 02.10.2017 created
% 22.06.2020 add shearlet
% 14.09.2020 add stopping criteria
% 12.10.2020 general R regularization 

sz = size(v); % image size
% Default input
if nargin < 3, iPar = []; end
if nargin < 4, mPar = []; end
if nargin < 5, rPar = []; end
%       parameters of iteration algorithm
if isfield(iPar,'maxIt'),  maxIt  = iPar.maxIt;  else, maxIt  = 500;     end
if isfield(iPar,'sigma'),  sigma  = iPar.sigma;  else, sigma  = max(sz); end
if isfield(iPar,'tau'),    tau    = iPar.tau;    else, tau    = 1/sigma; end
if isfield(iPar,'theta'),  theta  = iPar.theta;  else, theta  = 1;       end
if isfield(iPar,'toDisp'), toDisp = iPar.toDisp; else, toDisp = 2;       end
if isfield(iPar,'check'),  check  = iPar.check;  else, check  = 50;      end
if isfield(iPar,'tol'),    tol    = iPar.tol;    else, tol    = 1e-4;    end
if isfield(iPar,'ctol'),   ctol   = iPar.ctol;   else, ctol   = 1e-2;    end
%       parameters of multiscale method
if isfield(mPar,'type'), mType = mPar.type; else, mType = 'shearlet'; end
mPar.sz = sz;
mPar    = parMultiscaleMethod(mPar, mType);
switch mType
    case 'shearlet' 
        Phi = Shearlet(mPar.sz, mPar);
    case 'curvelet' % default values are the same as in 'fdct_wrapping'
        Phi = Curvelet(mPar.sz, mPar.isReal, mPar.fLevel, mPar.nScale, mPar.nAngle);
    case 'wavelet' % default Symmlet 6 wavelet
        Phi = Wavelet(mPar.filterType, mPar.filterSize, mPar.minScale);      
    case 'cube' % defaut dyadic partition system
        Phi = Cube(mPar.sz, mPar.cubeType, mPar.cubeParam);
    otherwise
        error([sprintf('Unknown type ''%s'', ', mType), ...
            'only support ''wavelet'', ''curvelet'', ''shearlet'' and ''cube''.']);
end
%       parameters of regularization term
if isfield(rPar,'type'), rType = rPar.type; else, rType = 'TV'; end
switch rType
    case 'TV'
        nitTV = 1e3;
        tolTV = 1e-3;
        if isfield(rPar,'maxIt'), nitTV = rPar.maxIt; end
        if isfield(rPar,'tol'),   tolTV = rPar.tol;   end 
    case 'Hk'
        k_sob = 1;
        if isfield(rPar,'k'), k_sob  = rPar.k; end
    otherwise
        error([sprintf('Unknown type ''%s'', ', mType), ...
            'only support ''TV'' and ''HK''.']);  
end


% Initialization
xo   = v;
xbar = xo;
Kv   = Phi * v;
y    = Kv; 
% Second output
if nargout > 1
    stat.oVal = zeros(maxIt, 1);
    stat.cGap = zeros(maxIt, 1);
    stat.tm   = zeros(maxIt, 1);
end
% Iteration
if toDisp > 1 
    hfig = figure; 
    subplot(131); 
    imshow(v, []); colorbar;
    title('data');
end
if toDisp > 0
    fprintf('Iteration starts ... (%d in total)\n', maxIt);
    tmAll = tic;
end
for iter = 1:maxIt
    if nargout > 1
        tmSt = tic;
    end
    if mod(iter, check) == 0 && toDisp > 0 
        fprintf('       #%d iteration\n', iter);
    end
    Kxbar = Phi * xbar; 
    y     = y + sigma .* (Kxbar - Kv);
    y     = proxl1(y, sigma*th);
    x     = xo - tau .* real(Phi' * y);
    switch rType
        case 'TV'
            x = proxTV(x, tau, x, nitTV, tolTV/iter, ...
                mod(iter,check) == 0 && toDisp > 0);
        case 'Hk'
            x  = proxHk(x, tau, k_sob, ...
                mod(iter,check) == 0 && toDisp > 0);
    end
    xbar = x + theta*(x - xo);
    xo   = x;
    
    % details about iteration
    if nargout > 1 
        stat.tm(iter) = toc(tmSt);
        switch rType
            case 'TV'
                [dx1, dx2] = num_grad(x);
                stat.oVal(iter) = sum(sqrt(dx1(:).^2+dx2(:).^2))/numel(v);
            case 'Hk'
                stat.oVal(iter) = 0.5*l2norm_der_ft(x, k);
        end
        Kx     = Phi * x; 
        maxVal = maxAbs(Kx - Kv); 
        if abs(th) > eps
            stat.cGap(iter) = (maxVal - th)/th;
        else
            stat.cGap(iter) = maxVal - th;
        end
    end
    if mod(iter,check) == 0
        % stopping criteria
        if ~(nargout > 1)
            Kx     = Phi * x;
            maxVal = maxAbs(Kx - Kv);
        end
        inc = norm(xbar-x, 'fro')/theta/sqrt(numel(x));
        gap = maxVal/th - 1;
        if toDisp > 1
            figure(hfig);
            subplot(132)
            imshow(x,[]); colorbar;
            title(sprintf('Iter %d', iter));
            subplot(133)
            imshow(x-v,[]); colorbar;
            title('residual')
            drawnow;
            fprintf(['          ',...
                'changes %g (tol %g), gap %g (ctol %g)\n'],...
                inc, tol, gap, ctol);
        end
        if (gap < ctol) && (inc < tol)
            break;
        end
    end
end
if toDisp > 0
    fprintf('Stop at %d iterations, and elapse %g sec!\n', ...
        iter, toc(tmAll)); 
end

if nargout > 1
    stat.oVal = stat.oVal(1:iter);
    stat.cGap = stat.cGap(1:iter);
    stat.tm   = stat.tm(1:iter);
end

% First output
u = x;

end

