%% Test installation
% Add path of 'MDE' and subfolders
% Import toolboxes 'ShearLab3D', 'CurveLab' and 'Wavelab850'
sz     = [256, 256];
X      = zeros(sz);
Xnoisy = X + randn(sz);
mTypes = {'cube', 'wavelet', 'curvelet', 'shearlet'};
rTypes = {'Hk', 'TV'};
sPar.nDraw  = 5;
iPar.maxIt  = 5; 
iPar.toDisp = 0;
for i = 1:length(mTypes)
    mPar.type = mTypes{i};
    th = msQuantile(sz, 0.5, sPar, mPar);
    for j = 1:length(rTypes)
        fprintf('%s + %s\n', mTypes{i}, rTypes{j});
        rPar.type = rTypes{j};
        Xrec = multiscale(Xnoisy, th, iPar, mPar, rPar);
    end
end

%% Experiments in the paper
%
%     del Alamo, M., Li, H., Munk, A., & Werner, F. (2020+). 
%       Variational multiscale nonparametric regression: Algorithms. 
%       In submission.
%
% All experiments are reproducible by modifying the following codes

% Add path of 'MDE' and subfolders
% Import toolboxes 'ShearLab3D', 'CurveLab' and 'Wavelab850'

% Images
imDir = './testImages/';
name  = 'cell'; % 'building', 'brain', 'BIRN'
X     = double(imread([imDir, name, '.png']));
X     = X/max(X(:));
sz    = size(X);


% Noisy image
snr   = 30;
sigma = 1/snr;
rng('default'); rng(123);
Xnoisy = X + sigma*randn(size(X));

% Regularization
rPar.type = 'TV'; % 'Hk'

% Significance level for threshold
alpha = 0.5;

% MDE: dyadic cubes
cube  = pPartitionCube(size(X), 2);
mPar.type      = 'cube';
mPar.cubeType  = 'manual';
mPar.cubeParam = cube;
th   = msQuantile(sz, alpha, [], mPar);
Xrec = multiscale(Xnoisy, sigma*th, [], mPar, rPar);

% MDE: small cubes
cube = scale2cube(1:30, sz);
mPar.cubeParam = cube;
mPar.type      = 'cube';
mPar.cubeType  = 'manual';
mPar.cubeParam = cube;
th   = msQuantile(sz, alpha, [], mPar);
Xrec = multiscale(Xnoisy, sigma*th, [], mPar, rPar);

% MDE: wavelet
mPar.type      = 'wavelet';
th   = msQuantile(sz, alpha, [], mPar);
Xrec = multiscale(Xnoisy, sigma*th, [], mPar, rPar);

% MDE: curvelet
mPar.type      = 'curvelet';
th   = msQuantile(sz, alpha, [], mPar);
Xrec = multiscale(Xnoisy, sigma*th, [], mPar, rPar);

% MDE: shearlet
mPar.type      = 'shearlet';
th   = msQuantile(sz, alpha, [], mPar);
Xrec = multiscale(Xnoisy, sigma*th, [], mPar, rPar);


