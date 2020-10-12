function [ u ] = proxTV( v, lambda, ui, maxit, tol, verbose )
%PROXTV Proximal operator of TV
%
%   minimize_{u} 1/2||u - v||_2^2  + lambda||\nabla u||_1
%
%Usage:
%   u = proxTV(v, lambda, ui, maxit, tol, verbose)
%   u = proxTV(v, lambda)
%
%Input:
%   v:        data
%   lambda:   penalization coefficient
%   ui:       initial value (default v)
%   maxit:    maximal number of iterations (default 500)
%   tol:      tolerance for stopping rule (default 1e-3)
%   verbose:  level of screen print and plot (default 0)
%
%Output:
%   u:  the solution
%
%Algorithm: the projected gradient method
%
%Reference: Bect, J., Blanc-F\'{e}raud, L., Aubert, G., and Chambolle, A., 
%           A $l$1-unified variational framework for image restoration. 
%           Computer Vision - ECCV 2004 Volume 3024 of the series Lecture 
%           Notes in Computer Science pp 1-13
%
%Note: modified from Markus Grasmair's code

% Housen Li
% 10.10.2015 built from Markus Grasmair's code
% 29.09.2017 changed name "denoiseTV" --> "proxTV"

% step size for the projected gradient method
tau = 0.24;
% initial value
if (nargin < 3) || isempty(ui)
    ui = v;
end
% maximal number of steps for the denoising problem
if (nargin < 4) || isempty(maxit)
    maxit = 500;
end
% stopping criterion for the denoising problem
if (nargin < 5) || isempty(tol)
    tol = 10^(-3);
end
% level of screen print
if nargin < 6
    verbose = 0;
end

% initialisations - in the case of large regularisation parameter, it
% might make sense to improve the initialisation, else the number of
% iterations will be huge
w   = ui;
W_1 = zeros(size(ui));
W_2 = zeros(size(ui));
[v_x, v_y] = num_grad(v);
% the convergence flag for the denoising problem
not_converged = 1;
% the iteration number for the denoising problem
nit = 0;
while (not_converged)
    % perform a gradient step
    [w_x, w_y] = num_grad(w);
    W_1 = W_1 + tau*(w_x + v_x);
    W_2 = W_2 + tau*(w_y + v_y);
    % project W on the ball of radius lambda
    rescaling_factor = sqrt(W_1.^2+W_2.^2)/lambda;
    rescaling_factor = max(rescaling_factor, 1);
    W_1 = W_1./rescaling_factor;
    W_2 = W_2./rescaling_factor;
    % compute the next iterate
    w_new = num_divergence(W_1, W_2);
    % check for convergence
    if (nit >= maxit || max(abs(w_new(:)-w(:))) <= tol)
        not_converged = 0;
    end
    % overwrite the current iterate
    w = w_new;
    % increase the step number
    nit = nit+1;
end

if (verbose > 0)
    fprintf('          # iterations in ''proxTV'': %d\n', nit);
end

% update u
u = w+v;

end

