function [ v ] = times( S, u )
%MTIMES Perform Shearlet transform without normalization
%   v = S .* u
%where
%   S: an object of Shearlet class
%   u: an image 

% Housen Li
% 22.06.2020 created

if isa(u, 'Shearlet')
    error('In  A .* B only A can be Curvelet object!');
end

if (S.adjoint == 0) && any(S.imSize ~= size(u)) 
    error('Sizes of Shearlet object and image do NOT match!');
end

if S.adjoint
    v = SLshearrec2D(u, S.shearletSystem);
else
    v = SLsheardec2D(u, S.shearletSystem);
end

end

