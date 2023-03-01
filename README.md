# alamode_CP2K_Toolbox
A port to make CP2K input files for fc calculation of alamode software and some useful postprocessing tools

Discription:

cat2fc.m  : creat fractinal coordinate data from cartesian coordinate of xyz files

alm2cp.m  : using  MATLAB to create CP2K input files and coordinate files from xyz files and configuration files

fc2alm.m  : using MATLAB to create alamode input DFSETs from force files exported from CP2K and configuration files

drawspec.m : using MATLAB to draw spectral heat conductivity in form of .kl.spec

drawmodes.m : using MATLAB to draw phonon eigenmodes of system 

Using:

1. enlarge the unit cell and fully optimize it using CP2K. 

2. grep the cartesian coordinates of the last optimization step from xyz files and cell parameters from cell files, then create another xyz file as input of cat2fc.

3. get fractional coordinates and then copy it to alamode input files, then suggest the displacement using alm, finally get the configuration files as input

4. run alm2cp.m then get CP2K inputs

5. run CP2K codes using circulation of bash scripts

6. run fc2alm.m then get DFSETs

7. run anphon then get force constants for other jobs
