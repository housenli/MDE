function div_W = num_divergence(W_1,W_2)
% Numerical divergence
% this divergence is the adjoint of the gradient defined above
% see A. Chambolle, 2004
%
% Input: W_1, W_2 ... matrices of size m x n x k
% Output: div_W   ... matrix of size m x n x k
% 
% Codes from Markus Grasmair

% corrected by Housen Li
div_W = zeros(size(W_1));
div_W(2:end-1,:,:) = W_1(2:end-1,:,:) - W_1(1:end-2,:,:);
div_W(1,:,:) = W_1(1,:,:);
div_W(end,:,:) = -W_1(end-1,:,:);
div_W(:,2:end-1,:) = div_W(:,2:end-1,:) + W_2(:,2:end-1,:) - W_2(:,1:end-2,:);
div_W(:,1,:) = div_W(:,1,:) + W_2(:,1,:);
div_W(:,end,:) = div_W(:,end,:) - W_2(:,end-1,:);

% % back up of Markus Grasmair's codes
% div_W = zeros(size(W_1));
% div_W(2:end-1,:,:) = W_1(2:end-1,:,:) - W_1(1:end-2,:,:);
% div_W(1,:,:) = W_1(1,:,:);
% div_W(end,:,:) = W_1(end,:,:);
% div_W(:,2:end-1,:) = div_W(:,2:end-1,:) + W_2(:,2:end-1,:) - W_2(:,1:end-2,:);
% div_W(:,1,:) = div_W(:,1,:) + W_2(:,1,:);
% div_W(:,end,:) = div_W(:,end,:) + W_2(:,end,:);

end