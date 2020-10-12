function [g_x,g_y] = num_grad(g)
% Numerical gradient
% this definition of the gradient follows
% A. Chambolle, 'An algorithm for Total Variation Minimization and
% Applications', J. Math. Imaging Vision, 20(1-2):89-97, 2004.
%
% Codes from Markus Grasmair

g_x = zeros(size(g));
g_x(1:end-1,:,:) = (g(2:end,:,:)-g(1:end-1,:,:));
g_y = zeros(size(g));
g_y(:,1:end-1,:) = (g(:,2:end,:)-g(:,1:end-1,:));

end