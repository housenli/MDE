function [ mPar ] = parMultiscaleMethod( mPar, type )
%PARMULTISCALEMETHOD Complete parameter choice for multiscale methods using 
%default values
%   omPar = parMultiscaleMethod(mPar, type)

% Housen Li
% 08.10.2017 created 
% 22.06.2020 add shearlet

switch type
    case 'shearlet'
        if ~isfield(mPar,'nScales'), mPar.nScales = 4; end
        if ~isfield(mPar,'shearLevels'), mPar.shearLevels = [1 1 2 2]; end
        if ~isfield(mPar,'isFull'), mPar.isFull = 0; end
        if ~isfield(mPar,'directionalFilter') 
            mPar.directionalFilter = ...
                modulate2(dfilters('dmaxflat4','d')./sqrt(2),'c'); 
        end
        if ~isfield(mPar,'quadratureMirrorFilter')
            mPar.quadratureMirrorFilter = ...
                [0.0104933261758410,-0.0263483047033631,-0.0517766952966370,...
                0.276348304703363,0.582566738241592,0.276348304703363,...
                -0.0517766952966369,-0.0263483047033631,0.0104933261758408];
        end
        
    case 'curvelet' % default values are the same as in 'fdct_wrapping'
        if ~isfield(mPar,'isReal'), mPar.isReal = 0; end
        if ~isfield(mPar,'fLevel'), mPar.fLevel = 2; end
        if ~isfield(mPar,'nScale'), mPar.nScale = ceil(log2(min(mPar.sz))-3); end
        if ~isfield(mPar,'nAngle'), mPar.nAngle = 16; end
        
    case 'wavelet'
        if ~isfield(mPar,'filterType'), mPar.filterType = 'Symmlet'; end
        if ~isfield(mPar,'filterSize'), mPar.filterSize = 6; end
        if ~isfield(mPar, 'minScale'),  mPar.minScale = 2; end
   
    case 'cube' % default dyadic partition system
        if ~isfield(mPar,'cubeType'),  mPar.cubeType = 'partition'; end
        if ~isfield(mPar,'cubeParam'), mPar.cubeParam = []; end

%     case 'cube' % default all small dyadic scales
%         if ~isfield(mPar,'cubeType'),  mPar.cubeType = 'scale'; end 
%         if ~isfield(mPar,'cubeParam'), mPar.cubeParam = 2.^(1:6); end
    otherwise
        error([sprintf('Unknown type ''%s'', ', type), ...
            'only support ''wavelet'', ''curvelet'', ''shearlet'' and ''cube''.']);
end

end

