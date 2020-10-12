function [ q, mStat ] = msQuantile( sz, alpha, sPar, mPar )
%MSQUANTILE Simulate the lower alpha quantile of multiscale statistics 
%   
%   Prob{|| Phi (u) ||_inf <= q} = alpha    
%
%where u is a random matrix of size 'sz' 
%
%Usage:
%   q = msQuantile(sz)
%   [q, mStat] = msQuantile(sz, alpha, sPar, mPar)
%
%Input:
%   sz:    size of image
%   alpha: significance level (default: 0.9)
%   sPar:  a structure array specifying other simulation parameters
%   mPar:  a structure array specifying parameters of multiscale method
%
%Output:
%   q:     the simulated lower alpha quantile
%   mStat: the simulated values of multiscale statistics (a column vector 
%          of length sPar.nDraw)
 
% Housen Li
% 05.10.2017 created
 
% Default input
if nargin < 2 || isempty(alpha), alpha = 0.9; end
if nargin < 3, sPar  = []; end
if nargin < 4, mPar  = []; end   
%       parameters of other simulation parameters
base = [fileparts(mfilename('fullpath')), filesep, 'auxStorage'];
if isfield(sPar, 'nDraw'),  nDraw  = sPar.nDraw;  else, nDraw  = 5e3;  end
if isfield(sPar, 'seed'),   seed   = sPar.seed;   else, seed   = 100;  end
if isfield(sPar, 'loc'),    loc    = sPar.loc;    else, loc    = base; end
if isfield(sPar, 'toSave'), toSave = sPar.toSave; else, toSave = true; end
if isfield(sPar, 'check'),  check  = sPar.check;  else, check  = 500;  end
if isfield(sPar, 'toDisp'), toDisp = sPar.toDisp; else, toDisp = 1;    end
%       parameters of multiscale method
if isfield(mPar, 'type'),  type = mPar.type;  else, type = 'shearlet';  end
mPar.sz = sz;
mPar    = parMultiscaleMethod(mPar, type);
switch type
    case 'shearlet'
        Phi = Shearlet(mPar.sz, mPar);
    case 'curvelet' % default values are the same as in 'fdct_wrapping'
        Phi = Curvelet(mPar.sz, mPar.isReal, mPar.fLevel, mPar.nScale, mPar.nAngle);
    case 'wavelet'
        Phi = Wavelet(mPar.filterType, mPar.filterSize, mPar.minScale);      
    case 'cube' % defaut dyadic partition system
        Phi = Cube(mPar.sz, mPar.cubeType, mPar.cubeParam);
    otherwise
        error([sprintf('Unknown type ''%s'', ', type), ...
            'only support ''wavelet'', ''curvelet'', ''shearlet'' and ''cube''.']);
end


dataName = sprintf('simQ_%s_r_%d_sz_%d_%d.mat', type, nDraw, sz(1), sz(2));

toSim = true;
if exist([loc,filesep,dataName],'file') % Load
    data  = load([loc, filesep, dataName]);    
    if strcmp(type,'cube') 
       if data.Phi == Phi
           toSim = false;
       end
    else
        toSim = false;
    end
end
if toSim                                % Simulate   
    if toDisp > 0, fprintf('Simulate via %d draw ... \n', nDraw); tic; end
    mStat = zeros(nDraw, 1);
    rng('default'); rng(seed)
    for r = 1:nDraw
        if mod(r, check) == 0 && toDisp > 0
            fprintf('      # %d draws \n', r);
        end
        u = randn(sz);
        mStat(r) = maxAbs(Phi * u);
    end
    if toDisp > 0, fprintf('End of simulation: elapse %g sec!\n', toc); end
    if toSave                           % Save 
        if toDisp > 0, fprintf('Simulation result is stored!\n'); end
        if strcmp(type,'cube')
            save([loc,filesep,dataName], 'mStat', 'Phi');
        else
            save([loc,filesep,dataName], 'mStat');
        end
    end 
else
    if toDisp > 0, fprintf('Load from previous simulation results!\n'); end
    mStat = data.mStat;
end
 
% Compute quantile
q = quantile(mStat, alpha);
 
end
  

