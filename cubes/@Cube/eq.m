function [ isEq ] = eq( obA, obB )
%EQ chcek whether cube system are the same
%   isEq = (obA == obB);
%where
%   obA: an object of Cube class
%   obB: an object of Cube class


if size(obA.cube.st,1) == size(obB.cube.st,1)
    isEq = (sum(all(obA.cube.st == obB.cube.st)...
        + all(obA.cube.ed == obB.cube.ed)) == 4);
else
    isEq = false;
end

end

