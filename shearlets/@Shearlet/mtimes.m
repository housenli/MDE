function [ v ] = mtimes( S, u )
%TIMES Perform normalized Shearlet transform and the adjoint
%   v = S * u;
%where
%   S: an object of Curvelet class
%   u: an image 

% Housen Li
% 22.06.2020 created

if isa(u, 'Shearlet')
    error('In  A * B only A can be Curvelet object!');
end

if (S.adjoint == 0) && any(S.imSize ~= size(u))
    error('Sizes of Shearlet object and image do NOT match!');
end

if S.adjoint
    for s = 1:S.shearletSystem.nShearlets
        u(:,:,s) = u(:,:,s) * S.normShe(s);
    end
    v = SLshearrec2D(u, S.shearletSystem);
else
    v = SLsheardec2D(u, S.shearletSystem);
    for s = 1:S.shearletSystem.nShearlets
        v(:,:,s) = v(:,:,s) / S.normShe(s);
    end
end

end

