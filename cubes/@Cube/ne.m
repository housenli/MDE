function [ isNE ] = ne( obA, obB )
%NE not equal
%   isNE = (obA ~= obB);
%where
%   obA: an object of Cube class
%   obB: an object of Cube class

    isNE = ~eq(obA, obB);
    
end

