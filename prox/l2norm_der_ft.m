function [ ndf ] = l2norm_der_ft(f, k)
%L2NORM_DER_FT Compute L2-norm of k-th derivative of f (vector) using
%Fourier transform
%   ndf = l2norm_der_ft(f, k)

% Housen Li @ MPIbpc 
% 18.01.2015 create the code


n  = numel(f);
w  = 2*pi*circshift((-floor(n/2):1:(ceil(n/2)-1))',mod(n,2));
w  = fftshift(w.^(2*k));

ndf = sqrt(sum(w.*abs(fft(f(:))/n).^2));

end

