# MDE
This implements *Multiscale Dantzig Estimator (MDE)* in nonparametric regression (or denoising). 


For more details about MDE please see 

% cite our paper here

## Installation
The codes rely on the following packages:
- **ShearLab3D** from http://shearlab.math.lmu.de
- **CurveLab** from http://www.curvelet.org
- **Wavelab850** from https://statweb.stanford.edu/~wavelab/

If a computer is MAC or Windows PC, then the complied mex files may probably work without re-compiling. Otherwise, one has to run first (assuming we are in the root folder of MDE)

> cd('./cubes') 
> mex -Dchar16_t=UINT16_T mrcoefCube_mex.c 
> mex -Dchar16_t=UINT16_T mrdualCube_mex.c 
> cd('..') 

Moreover, we need to run (assuming we are in the root folder of MDE)
> addpath(genpath('./'))

## Overview


