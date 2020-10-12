function [ u ] = proxHk( v, lambda, k, verbose )
%PROXHK Proximal operator of Hk
%
%   minimize_{u} 1/2||u - v||_2^2  + lambda/2 ||D^ u||_2^2
%
%Usage:
%   u = proxHk(v, lambda, k, verbose)
%   u = proxHk(v, lambda, k)
%
%Input:
%   v:        data
%   lambda:   penalization coefficient
%   k:        Sobolev index
%   verbose:  level of screen print and plot (default 0)
%
%Output:
%   u:  solution (defined on [0, 1) and discretized on uniform grids)

% Housen Li
% 20.08.2020 built from function sobolevRegression2d in MOP

% level of screen print
if nargin < 4
    verbose = 0;
end

% initialization
[m, n] = size(v);
wr     = repmat(2*pi*circshift((-floor(m/2):1:(ceil(m/2)-1))', mod(m,2)), [1,n]);
wc     = repmat(2*pi*circshift(-floor(n/2):1:(ceil(n/2)-1), [0,mod(n,2)]), [m,1]);
w      = fftshift((wr.^2 + wc.^2).^k);

if verbose > 0
    fprintf('Sobolev inversion ...\n'); tic;
end

lambda = lambda/(m*n);
u = real(ifft2(fft2(v)./(1+lambda.*w)));

if verbose > 0
    fprintf('elapse %g s\n', toc);
end

end

