# MDE
This implements *Multiscale Dantzig Estimator (MDE)* in nonparametric regression (or denoising). MDE minimizes a general regularization term under certain multiscale constraints in terms of dictionaries. It is a collection of methods, includes 
-  del Alamo, M., Li, H., & Munk, A. (2020+). Frame-constrained total variation regularization for white noise regression. The Annals of Statistics, to appear (arXiv preprint [arXiv:1807.02038](https://arxiv.org/abs/1807.02038)).
-  Grasmair, M., Li, H., & Munk, A. (2018). Variational multiscale nonparametric regression: Smooth functions. In Annales de l'Institut Henri Poincaré, Probabilités et Statistiques ([Vol. 54, No. 2, pp. 1058-1097](https://projecteuclid.org/euclid.aihp/1524643240)). Institut Henri Poincaré.
- Frick, K., Marnitz, P., & Munk, A. (2013). Statistical multiresolution estimation for variational imaging: with an application in Poisson-biophotonics. Journal of Mathematical Imaging and Vision, [46(3), 370-387](https://link.springer.com/article/10.1007/s10851-012-0368-5).
- Frick, K., Marnitz, P., & Munk, A. (2012). Statistical multiresolution Dantzig estimation in imaging: Fundamental concepts and algorithmic framework. Electronic Journal of Statistics, [6, 231-268](https://projecteuclid.org/euclid.aihp/1524643240).

The implementation works exclusively for 2D grayscale images, and utilizes the [Chambolle-Pock algorithm](https://link.springer.com/article/10.1007/s10851-010-0251-1). For more details, please see 

\[1\] del Alamo, M., Li, H., Munk, A., & Werner, F. (2020+). Variational multiscale nonparametric regression: Algorithms. In submission.

## Installation
The codes require the following toolboxes:
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

and load toolboxes **ShearLab3D**, **CurveLab** and **Wavelab850**.

## Example

Examples, as well as experiments in our paper \[1\], can be run with the file [example.m](https://github.com/housenli/MDE/blob/main/example.m). 

## Acknowledgement

The codes for proximity operator of total variation seminorm are built from those by [Markus Grasmair](https://www.ntnu.edu/employees/markus.grasmair) (NTNU).
The encapsule of Wavelet class is from [Michael Lustig](https://www2.eecs.berkeley.edu/Faculty/Homepages/mlustig.html) (UC Berkeley). The codes for one approach of noise level estimation is from [Masayuki Tanaka](http://www.ok.sc.e.titech.ac.jp/~mtanaka/) (Tokyo Institute of Technology).
