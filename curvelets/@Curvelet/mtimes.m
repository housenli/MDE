function [ v ] = mtimes( C, u )
%TIMES Perform normalized Curvelet transform and the adjoint
%   v = C * u;
%where
%   C: an object of Curvelet class
%   u: an image 

% Housen Li
% 06.10.2017

if isa(u, 'Curvelet')
    error('In  A * B only A can be Curvelet object!');
end

if any(C.imSize ~= size(u)) && (C.adjoint == 0)
    error('Sizes of Curvelet object and image do NOT match!');
end

if C.adjoint
    for s = 1:length(u)
        for w = 1:length(u{s})
            u{s}{w} = u{s}{w} * C.normCur{s}{w};
        end
    end
    v = ifdct_wrapping(u, C.isReal, C.imSize(1), C.imSize(2));
else
    v = fdct_wrapping(u, C.isReal, C.fLevel, C.nScale, C.nAngle);
    for s = 1:length(v)
        for w = 1:length(v{s})
            v{s}{w} = v{s}{w} / C.normCur{s}{w};
        end
    end
end

end

