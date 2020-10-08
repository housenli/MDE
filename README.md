# MDE
This implements *Multiscale Dantzig Estimator (MDE)* in nonparametric regression (or denoising). MDE minimizes a general regularization term under certain multiscale constraints in terms of dictionaries. It is a collection of methods, includes 
-  
- 
- 
- 


The implementation works exclusively for 2D case, and utilizes the [Chambolle-Pock algorithm](https://link.springer.com/article/10.1007/s10851-010-0251-1). For more details about the algorithm for computing MDE please see 

% cite our paper here

## Installation
The codes rely on the following packages:
- **ShearLab3D** from http://shearlab.math.lmu.de
- **CurveLab** from http://www.curvelet.org
- **Wavelab850** from https://statweb.stanford.edu/~wavelab/

Assume we are in the root folder of MDE. 

If a computer is MAC or Windows PC, then the complied mex files may probably work without re-compiling. Otherwise, one has to run first

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  cd('./cubes')   
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  mex -Dchar16_t=UINT16_T mrcoefCube_mex.c  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  mex -Dchar16_t=UINT16_T mrdualCube_mex.c  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;  cd('..')  


Moreover, we need to run 

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; addpath(genpath('./'))

## Overview


